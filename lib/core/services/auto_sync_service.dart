import 'dart:async';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:kolzumo_app/core/network/api_client.dart';
import 'package:kolzumo_app/core/services/telemetry_service.dart';
import 'package:kolzumo_app/data/database/database.dart';
import 'package:kolzumo_app/data/repositories/resumen_dia_repo.dart';
import 'package:kolzumo_app/infrastructure/models/userauth.dart';

enum SyncConnectionState { online, offline, checking }

/// Servicio autónomo en segundo plano para sincronización automática
/// cuando hay conexión a internet disponible, sin intervención humana.
class AutoSyncQueueService extends ChangeNotifier {
  final AppDatabase database;
  final ResumenDiaRepository resumenDiaRepository;
  final UserAuth? Function() getCurrentUser;

  Timer? _periodicTimer;
  StreamSubscription<int>? _pendingSubscription;

  bool _isSyncing = false;
  bool _isOnline = false;
  int _pendingCount = 0;
  DateTime? _lastSyncTime;
  String? _lastError;

  bool get isSyncing => _isSyncing;
  bool get isOnline => _isOnline;
  int get pendingCount => _pendingCount;
  DateTime? get lastSyncTime => _lastSyncTime;
  String? get lastError => _lastError;

  AutoSyncQueueService({
    required this.database,
    required this.resumenDiaRepository,
    required this.getCurrentUser,
  });

  /// Inicia la vigilancia continua de red y la cola de ventas pendientes.
  void start() {
    _pendingSubscription?.cancel();
    _pendingSubscription = database.ventasDao
        .watchVentasPendientesCount()
        .listen((count) {
      final prev = _pendingCount;
      _pendingCount = count;
      notifyListeners();

      // Si entraron ventas nuevas y creemos que hay red, dispara intento inmediato
      if (count > 0 && count != prev) {
        syncNow();
      }
    });

    _periodicTimer?.cancel();
    // Revisa la conectividad periódicamente (cada 30 segundos)
    _periodicTimer = Timer.periodic(const Duration(seconds: 30), (_) {
      checkConnectivityAndSync();
    });

    // Verificación inicial inmediata
    checkConnectivityAndSync();
  }

  /// Verifica activamente la salida a internet realizando un lookup DNS a google.com
  Future<bool> checkInternetAccess() async {
    try {
      final lookup = await InternetAddress.lookup('google.com')
          .timeout(const Duration(seconds: 4));
      return lookup.isNotEmpty && lookup[0].rawAddress.isNotEmpty;
    } catch (_) {
      return false;
    }
  }

  /// Chequea red y si hay conectividad y ventas pendientes, las despacha.
  Future<void> checkConnectivityAndSync() async {
    final online = await checkInternetAccess();
    if (_isOnline != online) {
      _isOnline = online;
      notifyListeners();
    }

    if (_isOnline && _pendingCount > 0 && !_isSyncing) {
      await syncNow();
    }
  }

  /// Fuerza el despacho de las ventas pendientes en segundo plano.
  Future<bool> syncNow() async {
    if (_isSyncing) return false;

    final user = getCurrentUser();
    if (user == null) return false;

    // Obtener ventas pendientes reales
    final pendientes = await database.ventasDao.ventasPendientesDeSincronizar();
    _pendingCount = pendientes.length;
    notifyListeners();

    if (pendientes.isEmpty) return true;

    // Confirmar que haya internet antes de enviar
    final online = await checkInternetAccess();
    _isOnline = online;
    if (!online) {
      notifyListeners();
      return false;
    }

    _isSyncing = true;
    _lastError = null;
    notifyListeners();

    try {
      // Ensamblar el payload del día para el vendedor
      final resumenDia = await resumenDiaRepository.obtenerResumenDia(
        idvendedor: user.idvendedor,
        nombrevendedor: user.nombre,
        gps: '0.0, 0.0',
      );

      final dio = ApiClient.instance.dio;
      final response = await dio.post(
        '/tbasicas/cargaresumendiavendedor',
        data: {
          'idresumenvendedordia': resumenDia.idresumenvendedordia,
          'idvendedor': resumenDia.idvendedor,
          'nombrevendedor': resumenDia.nombrevendedor,
          'fecha': DateTime.now().toIso8601String(),
          'listaventas': resumenDia.listaventas.map((v) => v.toJson()).toList(),
          'listainventario':
              resumenDia.listainventario.map((i) => i.toJson()).toList(),
        },
      ).timeout(const Duration(seconds: 15));

      if (response.statusCode == 200) {
        // Marcar todas las ventas enviadas exitosamente
        final idsSincronizados = pendientes.map((v) => v.id).toList();
        await database.ventasDao.marcarVentasComoSincronizadas(idsSincronizados);

        _lastSyncTime = DateTime.now();
        _pendingCount = 0;
        _isOnline = true;

        await TelemetryService.instance.logEvent('auto_sync_success', {
          'ventas_sincronizadas': idsSincronizados.length,
          'idvendedor': user.idvendedor,
        });

        if (kDebugMode) {
          debugPrint(
            'AutoSyncQueueService: Sincronizadas ${idsSincronizados.length} ventas con éxito.',
          );
        }

        _isSyncing = false;
        notifyListeners();
        return true;
      } else {
        _lastError = 'Servidor respondió con código ${response.statusCode}';
      }
    } catch (e, stack) {
      _lastError = e.toString();
      if (kDebugMode) {
        debugPrint('AutoSyncQueueService error al sincronizar: $e');
      }
      await TelemetryService.instance.recordError(
        e,
        stack,
        reason: 'AutoSyncQueueService.syncNow failed',
      );
    } finally {
      _isSyncing = false;
      notifyListeners();
    }

    return false;
  }

  @override
  void dispose() {
    _periodicTimer?.cancel();
    _pendingSubscription?.cancel();
    super.dispose();
  }
}
