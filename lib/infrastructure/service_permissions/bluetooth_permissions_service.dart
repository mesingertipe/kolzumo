import 'package:flutter_classic_bluetooth/flutter_classic_bluetooth.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:location/location.dart' as loc;

class BluetoothPermissionsService {
  BluetoothPermissionsService({FlutterClassicBluetooth? classicBluetooth})
      : _classicBluetooth = classicBluetooth ?? FlutterClassicBluetooth();

  final FlutterClassicBluetooth _classicBluetooth;

  Future<bool> requestPermissionsAndEnableHardware({
    void Function(String message)? onWarning,
  }) async {
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