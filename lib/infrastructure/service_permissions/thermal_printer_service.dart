import 'dart:async';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter_classic_bluetooth/flutter_classic_bluetooth.dart';
import 'package:print_bluetooth_thermal/print_bluetooth_thermal.dart';

class ThermalPrinterService {
  ThermalPrinterService({FlutterClassicBluetooth? classicBluetooth})
      : _classicBluetooth = classicBluetooth ?? FlutterClassicBluetooth();

  final FlutterClassicBluetooth _classicBluetooth;

  bool get isIOS => !kIsWeb && Platform.isIOS;

  /// En iOS, inicializa CBCentralManager y espera a que esté encendido
  /// antes de lanzar el escaneo BLE en pairedBluetooths.
  Future<bool> ensureBluetoothReady() async {
    if (!isIOS) return true;
    for (var i = 0; i < 8; i++) {
      final enabled = await PrintBluetoothThermal.bluetoothEnabled;
      if (enabled) return true;
      await Future.delayed(const Duration(milliseconds: 300));
    }
    return await PrintBluetoothThermal.bluetoothEnabled;
  }

  /// Dispositivos ya vinculados (Android) o escaneados vía BLE (iOS),
  /// listos para conectar e imprimir.
  Future<List<BluetoothInfo>> getPairedDevices() {
    return PrintBluetoothThermal.pairedBluetooths;
  }

  /// Estado actual de conexión con la impresora.
  Future<bool> get isConnected => PrintBluetoothThermal.connectionStatus;

  Stream<BtcDevice> get discoveryResults => _classicBluetooth.discoveryResults;

  Future<void> startDiscovery() => _classicBluetooth.startDiscovery();

  Future<void> stopDiscovery() async {
    if (isIOS) return;
    await _classicBluetooth.stopDiscovery();
  }

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
    if (!isIOS) {
      await _classicBluetooth.stopDiscovery();
    }
  }
}