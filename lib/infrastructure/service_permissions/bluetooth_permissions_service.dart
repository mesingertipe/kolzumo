import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter_classic_bluetooth/flutter_classic_bluetooth.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:location/location.dart' as loc;
import 'package:print_bluetooth_thermal/print_bluetooth_thermal.dart';

class BluetoothPermissionsService {
  BluetoothPermissionsService({FlutterClassicBluetooth? classicBluetooth})
      : _classicBluetooth = classicBluetooth ?? FlutterClassicBluetooth();

  final FlutterClassicBluetooth _classicBluetooth;

  bool get _isIOS => !kIsWeb && Platform.isIOS;

  Future<bool> requestPermissionsAndEnableHardware({
    void Function(String message)? onWarning,
  }) async {
    if (_isIOS) {
      return _ensureIOSBluetoothReady(onWarning: onWarning);
    }

    final statuses = await [
      Permission.bluetooth,
      Permission.bluetoothScan,
      Permission.bluetoothConnect,
      Permission.locationWhenInUse,
    ].request();

    final granted = statuses.values.every(
      (status) => status.isGranted || status.isLimited,
    );

    if (!granted) return false;

    await _ensureBluetoothOn(onWarning: onWarning);
    await _ensureLocationServiceOn(onWarning: onWarning);

    return true;
  }

  /// En iOS, CoreBluetooth solicita el permiso nativo al inicializar
  /// CBCentralManager dentro de PrintBluetoothThermal. Esperamos brevemente
  /// a que el estado pase de unknown a poweredOn.
  Future<bool> _ensureIOSBluetoothReady({
    void Function(String message)? onWarning,
  }) async {
    try {
      for (var i = 0; i < 8; i++) {
        final enabled = await PrintBluetoothThermal.bluetoothEnabled;
        if (enabled) return true;
        await Future.delayed(const Duration(milliseconds: 300));
      }

      final granted =
          await PrintBluetoothThermal.isPermissionBluetoothGranted;
      if (!granted) {
        onWarning?.call(
          'Permite el acceso a Bluetooth en Ajustes > KolZumo > Bluetooth.',
        );
        return false;
      }

      final enabled = await PrintBluetoothThermal.bluetoothEnabled;
      if (!enabled) {
        onWarning?.call(
          'Activa Bluetooth en tu iPhone para buscar impresoras térmicas.',
        );
      }
      return true;
    } catch (e) {
      onWarning?.call('No se pudo verificar Bluetooth en iOS: $e');
      return true;
    }
  }

  Future<void> _ensureBluetoothOn({
    void Function(String message)? onWarning,
  }) async {
    try {
      final enabled = await _classicBluetooth.isEnabled();
      if (!enabled) {
        await _classicBluetooth.enableBluetooth();
      }
    } catch (e) {
      onWarning?.call('No se pudo encender Bluetooth automáticamente: $e');
    }
  }

  Future<void> _ensureLocationServiceOn({
    void Function(String message)? onWarning,
  }) async {
    final location = loc.Location();
    try {
      var serviceEnabled = await location.serviceEnabled();
      if (!serviceEnabled) {
        serviceEnabled = await location.requestService();
      }
      if (!serviceEnabled) {
        onWarning?.call(
          'La ubicación sigue apagada; el escaneo Bluetooth podría '
          'no encontrar dispositivos.',
        );
      }
    } catch (e) {
      onWarning?.call('No se pudo encender la ubicación automáticamente: $e');
    }
  }
}