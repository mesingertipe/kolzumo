import 'package:flutter/material.dart';
import 'package:kolzumo_app/controllers/thermal_printer_controller.dart';
import 'package:kolzumo_app/core/services/demo_api_interceptor.dart';
import 'package:kolzumo_app/services/storage_service.dart';
import 'package:provider/provider.dart';

import '../../data/database/database.dart';
import '../../infrastructure/models/ruta_model.dart' as model;
import '../../logic/auth_logic.dart';
import '../../providers/cliente_provider.dart';
import '../../providers/ruta_provider.dart';
import '../../providers/vehiculo_provider.dart';
import '../../services/session_sync_service.dart';
import '../../services/vehiculos_service.dart';

class SessionSyncGate extends StatefulWidget {
  final Widget child;
  const SessionSyncGate({super.key, required this.child});

  @override
  State<SessionSyncGate> createState() => _SessionSyncGateState();
}

class _SessionSyncGateState extends State<SessionSyncGate> {
  late Future<void> _syncFuture;
  final _syncInventarioService = StorageService();

  @override
  void initState() {
    super.initState();
    _syncFuture = _sincronizar();
  }

  Future<void> _sincronizar() async {
    final auth = context.read<Auth>();
    final idVendedor = auth.userAccount!.idvendedor;

    // Si es la sesión del usuario demo (idVendedor == 999), activa el interceptor demo
    // y habilita por defecto el Modo Impresora Virtual para que pueda probar ventas de inmediato.
    if (idVendedor == DemoApiInterceptor.demoVendedorId) {
      DemoApiInterceptor.instance.activateDemoMode();
      final printer = context.read<ThermalPrinterController>();
      if (!printer.isConnected && !printer.virtualPrinterEnabled) {
        await printer.setVirtualPrinterEnabled(true);
      }
    }

    final sincronizado =
        await _syncInventarioService.yaSincronizado(idVendedor);

    if (!sincronizado || idVendedor == DemoApiInterceptor.demoVendedorId) {
      if (!mounted) return;
      await context.read<SessionSyncService>().syncAll(idVendedor);

      if (!mounted) return;
      await _syncInventarioService.marcarSincronizado(idVendedor);
    }

    if (!mounted) return;

    final database = context.read<AppDatabase>();
    final vehiculoService = VehiculoService();
    final vehiculoProv = context.read<VehiculoProvider>();
    final rutaProv = context.read<RutaProvider>();

    await vehiculoProv.cargarSeleccionVehiculo(vehiculoService);
    if (!mounted) return;

    await rutaProv.cargarRutaSeleccionada(database);
    if (!mounted) return;

    // En modo demo, si aún no ha elegido ruta o vehículo, preselecciona "Codito" y "VOX 234"
    if (idVendedor == DemoApiInterceptor.demoVendedorId) {
      if (vehiculoProv.vehiculoSeleccionado == null) {
        final vehiculos = await vehiculoService.findVehiculos('');
        if (vehiculos.isNotEmpty) {
          vehiculoProv.seleccionarVehiculo(vehiculos.first);
        }
      }
      if (rutaProv.rutaSeleccionada == null && mounted) {
        final rutasLocales = await database.catalogosDao.obtenerRutas();
        if (rutasLocales.isNotEmpty) {
          final r = rutasLocales.first;
          rutaProv.seleccionarRuta(
            model.Ruta(
              idruta: r.idRuta,
              nombreruta: r.nombre,
              idzona: r.idZona,
              nombrezona: r.nombrezona,
              estado: r.estado ? 1 : 0,
              nombreestado: r.estado ? 'Activo' : 'Inactivo',
              diasvisita: const [],
              mensaje: null,
            ),
          );
        }
      }
    }

    if (!mounted) return;
    final ruta = rutaProv.rutaSeleccionada;
    if (ruta != null) {
      await context.read<ClienteProvider>().cargarClientes(ruta.nombreruta);
    }
  }

  void _retry() {
    setState(() {
      _syncFuture = _sincronizar();
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<void>(
      future: _syncFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 16),
                  Text(
                    'Sincronizando catálogos, rutas e inventario...',
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                ],
              ),
            ),
          );
        }
        if (snapshot.hasError) {
          return Scaffold(
            body: Center(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.cloud_off_rounded,
                      size: 56,
                      color: Colors.grey,
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'No se pudo sincronizar la información.',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '${snapshot.error}',
                      style: const TextStyle(fontSize: 12, color: Colors.grey),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    FilledButton.icon(
                      onPressed: _retry,
                      icon: const Icon(Icons.refresh),
                      label: const Text('Reintentar'),
                    ),
                  ],
                ),
              ),
            ),
          );
        }
        return widget.child;
      },
    );
  }
}
