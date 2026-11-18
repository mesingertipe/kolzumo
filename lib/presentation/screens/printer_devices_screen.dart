
import 'package:flutter/material.dart';
import 'package:kolzumo_app/presentation/utils/items_ui/menu_burguer.dart';
import 'package:provider/provider.dart';

import '../../controllers/thermal_printer_controller.dart';
import '../../infrastructure/models/invoice.dart';
import '../utils/items_ui/printer_tiles_widget.dart';

class ThermalPrinterScreen extends StatefulWidget {
  const ThermalPrinterScreen({super.key});

  @override
  State<ThermalPrinterScreen> createState() => _ThermalPrinterScreenState();
}

class _ThermalPrinterScreenState extends State<ThermalPrinterScreen> {
  ThermalPrinterController? _controller;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final controller = context.read<ThermalPrinterController>();
    if (_controller != controller) {
      _controller?.removeListener(_onControllerChanged);
      _controller = controller;
      _controller!.addListener(_onControllerChanged);
    }
  }

  void _onControllerChanged() {
    final message = _controller?.consumeMessage();
    if (message != null && mounted) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(message)));
    }
  }

  @override
  void dispose() {
    _controller?.removeListener(_onControllerChanged);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final c = context.watch<ThermalPrinterController>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Impresoras térmicas'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: c.isLoading ? null : c.loadPairedDevices,
            tooltip: 'Actualizar vinculados',
          ),
        ],
      ),
      drawer: AppDrawer(currentRoute: '/printers'),
      body: Column(
        children: [
          if (c.isConnected)
            ConnectedBanner(
              deviceName: c.selectedDevice?.name.isNotEmpty == true
                  ? c.selectedDevice!.name
                  : 'impresora',
              onDisconnect: c.disconnect,
            ),
          Expanded(
            child: c.isLoading
                ? const Center(child: CircularProgressIndicator())
                : RefreshIndicator(
                    onRefresh: c.loadPairedDevices,
                    child: ListView(
                      padding: const EdgeInsets.only(bottom: 80),
                      children: [
                        const SectionHeader(title: 'Vinculados'),
                        if (c.pairedDevices.isEmpty)
                          const EmptyPairedHint()
                        else
                          ...c.pairedDevices.map(
                            (device) => PairedDeviceTile(
                              device: device,
                              isConnected: c.isConnected &&
                                  c.selectedDevice?.macAdress ==
                                      device.macAdress,
                              isConnecting: c.isConnecting &&
                                  c.selectedDevice?.macAdress ==
                                      device.macAdress,
                              onConnect: () => c.connect(device),
                              onDisconnect: c.disconnect,
                            ),
                          ),
                        const Divider(height: 24),
                        SectionHeader(
                          title: 'Disponibles',
                          trailing: c.isDiscovering
                              ? const SizedBox(
                                  width: 16,
                                  height: 16,
                                  child:
                                      CircularProgressIndicator(strokeWidth: 2),
                                )
                              : TextButton.icon(
                                  onPressed: c.startDiscovery,
                                  icon: const Icon(Icons.search, size: 18),
                                  label: const Text('Buscar'),
                                ),
                        ),
                        if (c.discoveredDevices.isEmpty)
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 12,
                            ),
                            child: Text(
                              c.isDiscovering
                                  ? 'Buscando dispositivos cercanos...'
                                  : 'Presiona "Buscar" para detectar impresoras nuevas',
                              style: const TextStyle(
                                  fontSize: 13, color: Colors.grey),
                            ),
                          )
                        else
                          ...c.discoveredDevices.map(
                            (device) => DiscoveredDeviceTile(
                              device: device,
                              isBonding: c.bondingAddress == device.address,
                              onPair: () => c.pairDevice(device),
                            ),
                          ),
                      ],
                    ),
                  ),
          ),
        ],
      ),
      floatingActionButton: c.isConnected
          ? FloatingActionButton.extended(
              onPressed: () => c.printInvoice(Invoice.sample(), 'VPP-0001'),
              icon: const Icon(Icons.print),
              label: const Text('Imprimir prueba'),
            )
          : null,
    );
  }
}