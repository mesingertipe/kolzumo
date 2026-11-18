import 'package:flutter/material.dart';
import 'package:kolzumo_app/services/storage_service.dart';
import 'package:provider/provider.dart';

import '../../data/database/database.dart';
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

    final sincronizado = await _syncInventarioService.yaSincronizado(idVendedor);

    if (!sincronizado) {
      if (!mounted) return;

      await context.read<SessionSyncService>().syncAll(idVendedor);

      if (!mounted) return;

      await _syncInventarioService.marcarSincronizado(idVendedor);
  }


    if (!mounted) return;

    // * Cargar selección de ruta y vehículo guardadas (si existen)
    final database = context.read<AppDatabase>();
    final vehiculoService = VehiculoService();

    await context.read<VehiculoProvider>().cargarSeleccionVehiculo(vehiculoService);
    if (!mounted) return;
    
    await context.read<RutaProvider>().cargarRutaSeleccionada(database);

    if (!mounted) return;

    // * Si había una ruta guardada, cargar también sus clientes
    final ruta = context.read<RutaProvider>().rutaSeleccionada;
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
          return const Scaffold(body: Center(child: CircularProgressIndicator()));
        }
        if (snapshot.hasError) {
          return Scaffold(
            body: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text('No se pudo sincronizar la información.'),
                  const SizedBox(height: 8),
                  Text(
                    '${snapshot.error}',
                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 12),
                  ElevatedButton(onPressed: _retry, child: const Text('Reintentar')),
                ],
              ),
            ),
          );
        }
        return widget.child;
      },
    );
  }
}