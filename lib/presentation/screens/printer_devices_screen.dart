import 'package:flutter/material.dart';
import 'package:kolzumo_app/config/app_theme.dart';
import 'package:kolzumo_app/logic/auth_logic.dart';
import 'package:kolzumo_app/presentation/utils/items_ui/menu_burguer.dart';
import 'package:kolzumo_app/presentation/utils/items_ui/ticket_preview_dialog.dart';
import 'package:provider/provider.dart';

import '../../controllers/thermal_printer_controller.dart';
import '../utils/items_ui/printer_tiles_widget.dart';

class ThermalPrinterScreen extends StatefulWidget {
  final bool embedded;
  const ThermalPrinterScreen({super.key, this.embedded = false});

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

  Future<void> _handlePrintTest(ThermalPrinterController c) async {
    final sellerName = context.read<Auth>().userAccount?.nombre;
    final preview = await c.printTestTicket(sellerName: sellerName);
    if (!mounted) return;
    await showTicketPreviewDialog(
      context,
      ticketText: preview,
      title: c.isConnected
          ? 'Recibo Enviado a ${c.selectedDevice?.name ?? "Impresora"}'
          : 'Recibo de Prueba (Impresora Virtual)',
    );
  }

  @override
  Widget build(BuildContext context) {
    final c = context.watch<ThermalPrinterController>();

    final content = Column(
      children: [
        if (c.isConnected)
          ConnectedBanner(
            deviceName: c.selectedDevice?.name.isNotEmpty == true
                ? c.selectedDevice!.name
                : 'Impresora Bluetooth',
            onDisconnect: c.disconnect,
          ),
        Expanded(
          child: c.isLoading
              ? const Center(child: CircularProgressIndicator())
              : RefreshIndicator(
                  onRefresh: c.loadPairedDevices,
                  child: ListView(
                    padding: const EdgeInsets.fromLTRB(16, 16, 16, 96),
                    children: [
                      // Tarjeta de Modo Impresora Virtual y Ancho de Papel
                      Card(
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                      color: c.virtualPrinterEnabled
                                          ? AppTheme.infoBlue
                                              .withValues(alpha: 0.12)
                                          : Colors.grey.shade100,
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Icon(
                                      Icons.receipt_long_rounded,
                                      color: c.virtualPrinterEnabled
                                          ? AppTheme.infoBlue
                                          : Colors.grey.shade700,
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const Text(
                                          'Modo Impresora Virtual',
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 15,
                                          ),
                                        ),
                                        Text(
                                          'Permite registrar ventas y ver la tirilla en pantalla cuando no tienes la impresora física conectada.',
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: Colors.grey.shade600,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Switch(
                                    value: c.virtualPrinterEnabled,
                                    activeThumbColor: AppTheme.primaryColor,
                                    onChanged: (val) =>
                                        c.setVirtualPrinterEnabled(val),
                                  ),
                                ],
                              ),
                              const Divider(height: 24),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text(
                                    'Ancho de papel térmico:',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 13.5,
                                    ),
                                  ),
                                  SegmentedButton<int>(
                                    segments: const [
                                      ButtonSegment(
                                        value: 58,
                                        label: Text('58 mm'),
                                        icon: Icon(Icons.straighten, size: 16),
                                      ),
                                      ButtonSegment(
                                        value: 80,
                                        label: Text('80 mm'),
                                        icon: Icon(Icons.straighten, size: 16),
                                      ),
                                    ],
                                    selected: {c.paperSizeMm},
                                    onSelectionChanged: (sel) {
                                      if (sel.isNotEmpty) {
                                        c.setPaperSizeMm(sel.first);
                                      }
                                    },
                                  ),
                                ],
                              ),
                              if (c.lastTicketPreview != null) ...[
                                const SizedBox(height: 12),
                                SizedBox(
                                  width: double.infinity,
                                  child: OutlinedButton.icon(
                                    onPressed: () => showTicketPreviewDialog(
                                      context,
                                      ticketText: c.lastTicketPreview!,
                                      title: 'Última Tirilla Generada',
                                    ),
                                    icon: const Icon(Icons.visibility_outlined),
                                    label: const Text(
                                      'Ver última tirilla generada',
                                    ),
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Dispositivos Bluetooth Vinculados (Android) / BLE (iOS)
                      Card(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SectionHeader(
                              title: c.isIOS
                                  ? 'IMPRESORAS BLUETOOTH (BLE)'
                                  : 'IMPRESORAS VINCULADAS',
                              trailing: c.isIOS
                                  ? (c.isDiscovering
                                      ? const Padding(
                                          padding: EdgeInsets.all(8.0),
                                          child: SizedBox(
                                            width: 18,
                                            height: 18,
                                            child: CircularProgressIndicator(
                                              strokeWidth: 2,
                                            ),
                                          ),
                                        )
                                      : TextButton.icon(
                                          onPressed: c.startDiscovery,
                                          icon: const Icon(
                                            Icons.bluetooth_searching,
                                            size: 18,
                                          ),
                                          label: const Text('Buscar'),
                                        ))
                                  : IconButton(
                                      icon: const Icon(Icons.refresh, size: 20),
                                      onPressed: c.isLoading
                                          ? null
                                          : c.loadPairedDevices,
                                      tooltip: 'Actualizar vinculados',
                                    ),
                            ),
                            if (c.pairedDevices.isEmpty)
                              Padding(
                                padding: EdgeInsets.fromLTRB(
                                  16,
                                  c.isIOS ? 4 : 0,
                                  16,
                                  16,
                                ),
                                child: c.isIOS
                                    ? Text(
                                        c.isDiscovering
                                            ? 'Escaneando impresoras Bluetooth BLE cercanas...'
                                            : 'Enciende tu impresora térmica compatible con Bluetooth BLE y presiona "Buscar". Nota: iOS no permite descubrir impresoras Bluetooth clásico antiguas que no soporten BLE.',
                                        style: const TextStyle(
                                          fontSize: 13,
                                          color: Colors.grey,
                                        ),
                                      )
                                    : const EmptyPairedHint(),
                              )
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
                          ],
                        ),
                      ),
                      if (!c.isIOS) ...[
                        const SizedBox(height: 16),

                        // Escaneo de nuevas impresoras Bluetooth (solo Android)
                        Card(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SectionHeader(
                                title: 'DISPOSITIVOS CERCANOS',
                                trailing: c.isDiscovering
                                    ? const Padding(
                                        padding: EdgeInsets.all(8.0),
                                        child: SizedBox(
                                          width: 18,
                                          height: 18,
                                          child: CircularProgressIndicator(
                                            strokeWidth: 2,
                                          ),
                                        ),
                                      )
                                    : TextButton.icon(
                                        onPressed: c.startDiscovery,
                                        icon: const Icon(
                                            Icons.bluetooth_searching,
                                            size: 18),
                                        label: const Text('Buscar Impresoras'),
                                      ),
                              ),
                              if (c.discoveredDevices.isEmpty)
                                Padding(
                                  padding: const EdgeInsets.fromLTRB(
                                    16,
                                    4,
                                    16,
                                    16,
                                  ),
                                  child: Text(
                                    c.isDiscovering
                                        ? 'Escaneando impresoras Bluetooth cercanas...'
                                        : 'Enciende tu impresora portátil (ej. MP210) y presiona "Buscar Impresoras".',
                                    style: const TextStyle(
                                      fontSize: 13,
                                      color: Colors.grey,
                                    ),
                                  ),
                                )
                              else
                                ...c.discoveredDevices.map(
                                  (device) => DiscoveredDeviceTile(
                                    device: device,
                                    isBonding:
                                        c.bondingAddress == device.address,
                                    onPair: () => c.pairDevice(device),
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
        ),
      ],
    );

    if (widget.embedded) {
      return Scaffold(
        backgroundColor: AppTheme.surfaceBg,
        body: content,
        floatingActionButton: c.canOperate
            ? FloatingActionButton.extended(
                onPressed: () => _handlePrintTest(c),
                backgroundColor: AppTheme.primaryColor,
                foregroundColor: Colors.white,
                icon: const Icon(Icons.print_rounded),
                label: const Text('Imprimir Recibo de Prueba'),
              )
            : null,
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Configuración de Impresora'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: c.isLoading ? null : c.loadPairedDevices,
            tooltip: 'Actualizar vinculados',
          ),
        ],
      ),
      drawer: const AppDrawer(currentRoute: '/printers'),
      body: content,
      floatingActionButton: c.canOperate
          ? FloatingActionButton.extended(
              onPressed: () => _handlePrintTest(c),
              backgroundColor: AppTheme.primaryColor,
              foregroundColor: Colors.white,
              icon: const Icon(Icons.print_rounded),
              label: const Text('Imprimir Recibo de Prueba'),
            )
          : null,
    );
  }
}
