import 'dart:async';
import 'package:esc_pos_utils_plus/esc_pos_utils_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_classic_bluetooth/flutter_classic_bluetooth.dart';
import 'package:kolzumo_app/core/services/telemetry_service.dart';
import 'package:kolzumo_app/infrastructure/models/resumen_dia_model.dart';
import 'package:kolzumo_app/infrastructure/models/seller_stats.dart';
import 'package:print_bluetooth_thermal/print_bluetooth_thermal.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../infrastructure/models/invoice.dart';
import '../infrastructure/service_permissions/bluetooth_permissions_service.dart';
import '../infrastructure/service_permissions/invoice_ticket_builder.dart';
import '../infrastructure/service_permissions/thermal_printer_service.dart';

class ThermalPrinterController extends ChangeNotifier {
  ThermalPrinterController({
    ThermalPrinterService? printerService,
    BluetoothPermissionsService? permissionsService,
    InvoiceTicketBuilder? ticketBuilder,
  })  : _printerService = printerService ?? ThermalPrinterService(),
        _permissionsService =
            permissionsService ?? BluetoothPermissionsService(),
        _ticketBuilder = ticketBuilder ?? InvoiceTicketBuilder();

  static const String _keyVirtualPrinter = 'virtual_printer_enabled';
  static const String _keyPaperSizeMm = 'printer_paper_size_mm';

  final ThermalPrinterService _printerService;
  final BluetoothPermissionsService _permissionsService;
  final InvoiceTicketBuilder _ticketBuilder;

  List<BluetoothInfo> pairedDevices = [];
  final List<BtcDevice> discoveredDevices = [];
  BluetoothInfo? selectedDevice;

  bool isConnected = false;
  bool isLoading = false;
  bool isConnecting = false;
  bool isDiscovering = false;
  String? bondingAddress;

  // Modo Impresora Virtual (para pruebas sin impresora física y aprobación en tiendas)
  bool _virtualPrinterEnabled = false;
  int _paperSizeMm = 58;
  String? _lastTicketPreview;

  bool get virtualPrinterEnabled => _virtualPrinterEnabled;
  int get paperSizeMm => _paperSizeMm;
  PaperSize get paperSize =>
      _paperSizeMm == 80 ? PaperSize.mm80 : PaperSize.mm58;
  String? get lastTicketPreview => _lastTicketPreview;

  /// Determina si el vendedor puede ejecutar ventas y cerrar el día
  /// (ya sea con impresora Bluetooth conectada o con Modo Impresora Virtual activo).
  bool get canOperate => isConnected || _virtualPrinterEnabled;

  Timer? _connectionPoll;
  StreamSubscription<BtcDevice>? _discoverySub;

  String? consumeMessage() {
    final m = _pendingMessage;
    _pendingMessage = null;
    return m;
  }

  String? _pendingMessage;

  void _notifyMessage(String message) {
    _pendingMessage = message;
    notifyListeners();
  }

  Future<void> init() async {
    final prefs = await SharedPreferences.getInstance();
    _virtualPrinterEnabled = prefs.getBool(_keyVirtualPrinter) ?? false;
    _paperSizeMm = prefs.getInt(_keyPaperSizeMm) ?? 58;
    notifyListeners();

    final granted =
        await _permissionsService.requestPermissionsAndEnableHardware(
      onWarning: _notifyMessage,
    );
    if (!granted) {
      _notifyMessage('Se necesitan permisos de Bluetooth y ubicación');
      return;
    }
    await loadPairedDevices();
    _pollConnectionState();
  }

  Future<void> setVirtualPrinterEnabled(bool enabled) async {
    _virtualPrinterEnabled = enabled;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyVirtualPrinter, enabled);
    notifyListeners();
  }

  Future<void> setPaperSizeMm(int mm) async {
    _paperSizeMm = (mm == 80) ? 80 : 58;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_keyPaperSizeMm, _paperSizeMm);
    notifyListeners();
  }

  void _pollConnectionState() {
    _connectionPoll = Timer.periodic(const Duration(seconds: 3), (_) async {
      final connected = await _printerService.isConnected;
      if (connected != isConnected) {
        isConnected = connected;
        if (!connected) selectedDevice = null;
        notifyListeners();
      }
    });
  }

  bool get isIOS => _printerService.isIOS;

  Future<void> loadPairedDevices() async {
    isLoading = true;
    notifyListeners();
    try {
      if (isIOS) {
        final ready = await _printerService.ensureBluetoothReady();
        if (!ready) {
          pairedDevices = [];
          _notifyMessage(
            'Verifica que Bluetooth esté encendido y con permiso para KolZumo en Ajustes.',
          );
          return;
        }
      }
      final devices = await _printerService.getPairedDevices();
      final alreadyConnected = await _printerService.isConnected;
      pairedDevices = devices;
      isConnected = alreadyConnected;
      discoveredDevices.removeWhere(
        (d) => devices.any((p) => p.macAdress == d.address),
      );
    } catch (e) {
      _notifyMessage('Error al obtener dispositivos: $e');
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> startDiscovery() async {
    if (isIOS) {
      isDiscovering = true;
      notifyListeners();
      try {
        final ready = await _printerService.ensureBluetoothReady();
        if (!ready) {
          _notifyMessage(
            'Enciende Bluetooth y otorga el permiso en Ajustes > KolZumo > Bluetooth.',
          );
          return;
        }
        final devices = await _printerService.getPairedDevices();
        final alreadyConnected = await _printerService.isConnected;
        pairedDevices = devices;
        isConnected = alreadyConnected;
        if (devices.isEmpty) {
          _notifyMessage(
            'No se encontraron impresoras BLE cercanas. Verifica que la impresora esté encendida y sea compatible con Bluetooth BLE.',
          );
        }
      } catch (e) {
        _notifyMessage('No se pudo buscar impresoras BLE: $e');
      } finally {
        isDiscovering = false;
        notifyListeners();
      }
      return;
    }

    discoveredDevices.clear();
    isDiscovering = true;
    notifyListeners();

    await _discoverySub?.cancel();
    _discoverySub = _printerService.discoveryResults.listen((device) {
      final alreadyPaired =
          pairedDevices.any((p) => p.macAdress == device.address);
      final alreadyListed =
          discoveredDevices.any((d) => d.address == device.address);
      if (!alreadyPaired && !alreadyListed) {
        discoveredDevices.add(device);
        notifyListeners();
      }
    });

    try {
      await _printerService.startDiscovery();
    } catch (e) {
      _notifyMessage('No se pudo iniciar la búsqueda: $e');
    }

    Future.delayed(const Duration(seconds: 13), () async {
      await _printerService.stopDiscovery();
      isDiscovering = false;
      notifyListeners();
    });
  }

  Future<void> pairDevice(BtcDevice device) async {
    bondingAddress = device.address;
    notifyListeners();
    try {
      final ok = await _printerService.pairDevice(device.address);
      if (ok) {
        discoveredDevices.removeWhere((d) => d.address == device.address);
        await loadPairedDevices();
        _notifyMessage('${device.displayName} vinculado');
      } else {
        _notifyMessage('No se pudo vincular el dispositivo');
      }
    } catch (e) {
      _notifyMessage('Error al vincular: $e');
    } finally {
      bondingAddress = null;
      notifyListeners();
    }
  }

  Future<void> connect(BluetoothInfo device) async {
    isConnecting = true;
    selectedDevice = device;
    notifyListeners();
    try {
      final result = await _printerService.connect(device.macAdress);
      isConnected = result;
      isConnecting = false;
      if (!result) {
        selectedDevice = null;
        _notifyMessage('No se pudo conectar a la impresora');
      } else {
        await TelemetryService.instance.logEvent('printer_connected', {
          'device_name': device.name,
          'mac': device.macAdress,
        });
      }
      notifyListeners();
    } catch (e, stack) {
      isConnecting = false;
      selectedDevice = null;
      _notifyMessage('No se pudo conectar: $e');
      await TelemetryService.instance.recordError(
        e,
        stack,
        reason: 'Bluetooth printer connect failed',
      );
      notifyListeners();
    }
  }

  Future<void> disconnect() async {
    await _printerService.disconnect();
    isConnected = false;
    selectedDevice = null;
    notifyListeners();
  }

  /// Imprime la factura en la impresora física (si está conectada) y genera
  /// siempre la tirilla digital de texto para vista previa / reimpresión.
  Future<String> printInvoice(Invoice invoice, String consecutivo) async {
    final plainText = _ticketBuilder.formatInvoicePlainText(invoice, consecutivo);
    _lastTicketPreview = plainText;
    notifyListeners();

    if (isConnected) {
      try {
        final bytes = await _ticketBuilder.build(
          invoice,
          consecutivo,
          paperSize: paperSize,
        );
        final result = await _printerService.printBytes(bytes);
        if (!result) {
          _notifyMessage('No se pudo enviar la impresión a la impresora Bluetooth');
          notifyListeners();
        }
      } catch (e, stack) {
        _notifyMessage('Error al imprimir: $e');
        await TelemetryService.instance.recordError(
          e,
          stack,
          reason: 'printInvoice failed',
        );
        notifyListeners();
      }
    }
    return plainText;
  }

  /// Imprime el tiraje de RESUMEN DEL DÍA / CUADRE DE CAJA al cerrar el día.
  Future<String> printDayClosing({
    required ResumenDia resumen,
    required SellerStats stats,
  }) async {
    final plainText = _ticketBuilder.formatDayClosingPlainText(
      resumen: resumen,
      stats: stats,
    );
    _lastTicketPreview = plainText;
    notifyListeners();

    if (isConnected) {
      try {
        final bytes = await _ticketBuilder.buildDayClosingTicket(
          resumen: resumen,
          stats: stats,
          paperSize: paperSize,
        );
        final result = await _printerService.printBytes(bytes);
        if (!result) {
          _notifyMessage('No se pudo imprimir el reporte de cierre de día');
          notifyListeners();
        }
      } catch (e, stack) {
        _notifyMessage('Error al imprimir cierre de día: $e');
        await TelemetryService.instance.recordError(
          e,
          stack,
          reason: 'printDayClosing failed',
        );
        notifyListeners();
      }
    }
    return plainText;
  }

  /// Imprime un recibo de prueba (físico y/o digital).
  Future<String> printTestTicket({String? sellerName}) async {
    final sample = Invoice.sample(sellerName: sellerName);
    return printInvoice(sample, 'PRUEBA-001');
  }

  @override
  void dispose() {
    _connectionPoll?.cancel();
    _discoverySub?.cancel();
    _printerService.dispose();
    super.dispose();
  }
}
