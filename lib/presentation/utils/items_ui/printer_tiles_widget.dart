import 'package:flutter/material.dart';
import 'package:flutter_classic_bluetooth/flutter_classic_bluetooth.dart';
import 'package:print_bluetooth_thermal/print_bluetooth_thermal.dart';

class SectionHeader extends StatelessWidget {
  const SectionHeader({super.key, required this.title, this.trailing});

  final String title;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 8, 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.bold,
              color: Colors.grey,
              letterSpacing: 0.5,
            ),
          ),
          ?trailing,
        ],
      ),
    );
  }
}

class EmptyPairedHint extends StatelessWidget {
  const EmptyPairedHint({super.key});

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Text(
        'No hay impresoras vinculadas todavía. Búscalas abajo en '
        '"Disponibles".',
        style: TextStyle(fontSize: 13, color: Colors.grey),
      ),
    );
  }
}

class ConnectedBanner extends StatelessWidget {
  const ConnectedBanner({
    super.key,
    required this.deviceName,
    required this.onDisconnect,
  });

  final String deviceName;
  final VoidCallback onDisconnect;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: Colors.green.withValues(alpha: 0.1),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Row(
        children: [
          const Icon(Icons.check_circle, color: Colors.green, size: 18),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              'Conectado a $deviceName',
              style: const TextStyle(
                color: Colors.green,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          TextButton(onPressed: onDisconnect, child: const Text('Desconectar')),
        ],
      ),
    );
  }
}

class PairedDeviceTile extends StatelessWidget {
  const PairedDeviceTile({
    super.key,
    required this.device,
    required this.isConnected,
    required this.isConnecting,
    required this.onConnect,
    required this.onDisconnect,
  });

  final BluetoothInfo device;
  final bool isConnected;
  final bool isConnecting;
  final VoidCallback onConnect;
  final VoidCallback onDisconnect;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor:
            isConnected ? Colors.green.withValues(alpha: 0.1) : Colors.blue.withValues(alpha: .1),
        child: Icon(
          Icons.print,
          color: isConnected ? Colors.green : Colors.blue,
        ),
      ),
      title: Text(
        device.name.isNotEmpty ? device.name : 'Dispositivo desconocido',
        style: const TextStyle(fontWeight: FontWeight.w600),
      ),
      subtitle: Text(device.macAdress, style: const TextStyle(fontSize: 12)),
      trailing: isConnecting
          ? const SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(strokeWidth: 2),
            )
          : ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: isConnected ? Colors.grey.shade300 : null,
                padding: const EdgeInsets.symmetric(horizontal: 12),
                minimumSize: const Size(0, 32),
              ),
              onPressed: isConnected ? onDisconnect : onConnect,
              child: Text(
                isConnected ? 'Desconectar' : 'Conectar',
                style: TextStyle(color: isConnected ? Colors.black87 : null),
              ),
            ),
    );
  }
}

class DiscoveredDeviceTile extends StatelessWidget {
  const DiscoveredDeviceTile({
    super.key,
    required this.device,
    required this.isBonding,
    required this.onPair,
  });

  final BtcDevice device;
  final bool isBonding;
  final VoidCallback onPair;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: Colors.grey.withValues(alpha: .15),
        child: const Icon(Icons.bluetooth, color: Colors.grey),
      ),
      title: Text(
        device.displayName.isNotEmpty ? device.displayName : 'Dispositivo desconocido',
        style: const TextStyle(fontWeight: FontWeight.w600),
      ),
      subtitle: Text(device.address, style: const TextStyle(fontSize: 12)),
      trailing: isBonding
          ? const SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(strokeWidth: 2),
            )
          : OutlinedButton(
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                minimumSize: const Size(0, 32),
              ),
              onPressed: onPair,
              child: const Text('Vincular'),
            ),
    );
  }
}