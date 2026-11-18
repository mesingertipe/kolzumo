import 'dart:async';
import 'package:flutter_classic_bluetooth/flutter_classic_bluetooth.dart';
import 'package:print_bluetooth_thermal/print_bluetooth_thermal.dart';

class ThermalPrinterService {
  ThermalPrinterService({FlutterClassicBluetooth? classicBluetooth})
      : _classicBluetooth = classicBluetooth ?? FlutterClassicBluetooth();

  final FlutterClassicBluetooth _classicBluetooth;

  /// Dispositivos ya vinculados, listos para conectar e imprimir.
  Future<List<BluetoothInfo>> getPairedDevices() {
    return PrintBluetoothThermal.pairedBluetooths;
  }

  /// Estado actual de conexión con la impresora.
  Future<bool> get isConnected => PrintBluetoothThermal.connectionStatus;

  Stream<BtcDevice> get discoveryResults => _classicBluetooth.discoveryResults;

  Future<void> startDiscovery() => _classicBluetooth.startDiscovery();

  Future<void> stopDiscovery() => _classicBluetooth.stopDiscovery();

  Future<bool> pairDevice(String address) {
    return _classicBluetooth.bondDevice(address);
  }

  Future<bool> connect(String macAddress) {
    return PrintBluetoothThermal.connect(macPrinterAddress: macAddress);
  }

  Future<void> disconnect() => PrintBluetoothThermal.disconnect;

  Future<bool> printBytes(List<int> bytes) {
    return PrintBluetoothThermal.writeBytes(bytes);
  }

  Future<void> dispose() async {
    await _classicBluetooth.stopDiscovery();
  }
}