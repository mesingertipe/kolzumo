import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter_classic_bluetooth/flutter_classic_bluetooth.dart';
import 'package:print_bluetooth_thermal/print_bluetooth_thermal.dart';

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
    final granted = await _permissionsService.requestPermissionsAndEnableHardware(
      onWarning: _notifyMessage,
    );
    if (!granted) {
      _notifyMessage('Se necesitan permisos de Bluetooth y ubicación');
      return;
    }
    await loadPairedDevices();
    _pollConnectionState();
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

  Future<void> loadPairedDevices() async {
    isLoading = true;
    notifyListeners();
    try {
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

    // La búsqueda clásica de Android dura ~12 segundos.
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
      }
      notifyListeners();
    } catch (e) {
      isConnecting = false;
      selectedDevice = null;
      _notifyMessage('No se pudo conectar: $e');
      notifyListeners();
    }
  }

  Future<void> disconnect() async {
    await _printerService.disconnect();
    isConnected = false;
    selectedDevice = null;
    notifyListeners();
  }

  Future<void> printInvoice(Invoice invoice, String consecutivo) async {
    if (!isConnected) return;
    try {
      final bytes = await _ticketBuilder.build(invoice, consecutivo);
      final result = await _printerService.printBytes(bytes);
      if (!result) {
        _notifyMessage('No se pudo enviar la impresión');
        notifyListeners();
      }
    } catch (e) {
      _notifyMessage('Error al imprimir: $e');
      notifyListeners();
    }
  }

  @override
  void dispose() {
    _connectionPoll?.cancel();
    _discoverySub?.cancel();
    _printerService.dispose();
    super.dispose();
  }
}