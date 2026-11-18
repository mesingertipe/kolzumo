import 'package:flutter/material.dart';
import 'package:kolzumo_app/core/services/telemetry_service.dart';
import 'package:kolzumo_app/infrastructure/repositories/inventario_repository.dart';
import 'package:kolzumo_app/presentation/utils/items_ui/dropdown_ruta.dart';
import 'package:kolzumo_app/presentation/utils/items_ui/dropdown_vehiculo.dart';
import 'package:kolzumo_app/providers/ruta_provider.dart';
import 'package:kolzumo_app/providers/vehiculo_provider.dart';
import 'package:provider/provider.dart';

import '../../config/app_theme.dart';
import '../../infrastructure/models/userauth.dart';
import '../../logic/auth_logic.dart';
import '../utils/items_ui/menu_burguer.dart';
import '../utils/items_ui/modal_inventario.dart';

class FormRuta extends StatefulWidget {
  const FormRuta({super.key});

  @override
  State<FormRuta> createState() => _FormRutaState();
}

class _FormRutaState extends State<FormRuta> {
  bool _loadingInventario = false;

  Future<void> _handleIniciarDia(UserAuth user) async {
    final ruta = context.read<RutaProvider>().rutaSeleccionada;
    final vehiculo = context.read<VehiculoProvider>().vehiculoSeleccionado;

    if (ruta == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Selecciona una ruta antes de iniciar el día.'),
          backgroundColor: AppTheme.dangerColor,
        ),
      );
      return;
    }

    setState(() => _loadingInventario = true);
    try {
      await TelemetryService.instance.setUserContext(
        idVendedor: user.idvendedor,
        nombreVendedor: user.nombre,
        rutaActiva: ruta.nombreruta,
        placaVehiculo: vehiculo?.placa,
      );

      final inventarios =
          await InventarioRepository().getInventario(user.idvendedor);

      if (!mounted) return;
      showDialog(
        context: context,
        builder: (_) => ModalInventario(
          inventarios: inventarios,
          onApproved: () {
            if (mounted && Navigator.of(context).canPop()) {
              Navigator.of(context).pop();
            }
          },
        ),
      );
    } finally {
      if (mounted) setState(() => _loadingInventario = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final UserAuth? user = context.watch<Auth>().userAccount;
    final ruta = context.watch<RutaProvider>().rutaSeleccionada;
    final vehiculo = context.watch<VehiculoProvider>().vehiculoSeleccionado;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Iniciar Día / Configurar Ruta'),
      ),
      drawer: const AppDrawer(currentRoute: '/ruta'),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: AppTheme.secondColor,
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: const Icon(
                            Icons.local_shipping_rounded,
                            color: AppTheme.primaryColor,
                            size: 28,
                          ),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Configuración de Jornada',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: AppTheme.forestDark,
                                ),
                              ),
                              Text(
                                'Selecciona el vehículo y la ruta para cargar sus clientes o confirmar el inventario asignado.',
                                style: TextStyle(
                                  fontSize: 13,
                                  color: Colors.grey.shade600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    const Text(
                      '1. Placa del Vehículo',
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 13.5,
                        color: AppTheme.forestDark,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const DropdownVehiculo(),
                    const SizedBox(height: 20),
                    const Text(
                      '2. Ruta de Venta',
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 13.5,
                        color: AppTheme.forestDark,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const DropdownItems(),
                    const SizedBox(height: 28),
                    SizedBox(
                      width: double.infinity,
                      height: 52,
                      child: FilledButton.icon(
                        onPressed: (_loadingInventario || user == null)
                            ? null
                            : () => _handleIniciarDia(user),
                        icon: _loadingInventario
                            ? const SizedBox(
                                width: 18,
                                height: 18,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.white,
                                ),
                              )
                            : const Icon(Icons.play_circle_fill_rounded),
                        label: const Text(
                          'Iniciar Día y Confirmar Inventario',
                        ),
                      ),
                    ),
                    if (ruta != null) ...[
                      const SizedBox(height: 12),
                      SizedBox(
                        width: double.infinity,
                        height: 48,
                        child: OutlinedButton.icon(
                          onPressed: () {
                            if (user != null) {
                              TelemetryService.instance.setUserContext(
                                idVendedor: user.idvendedor,
                                nombreVendedor: user.nombre,
                                rutaActiva: ruta.nombreruta,
                                placaVehiculo: vehiculo?.placa,
                              );
                            }
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  'Ruta activa cambiada a ${ruta.nombreruta}',
                                ),
                                backgroundColor: AppTheme.primaryColor,
                              ),
                            );
                            if (Navigator.of(context).canPop()) {
                              Navigator.of(context).pop();
                            } else {
                              Navigator.of(context)
                                  .pushReplacementNamed('/customers');
                            }
                          },
                          icon: const Icon(Icons.swap_horiz_rounded),
                          label: Text(
                            'Usar ruta "${ruta.nombreruta}" e ir a Clientes',
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
