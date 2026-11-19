import 'package:flutter/foundation.dart';
import 'package:kolzumo_app/services/metodopago_service.dart';

import '../data/database/daos/promociones_dao.dart';
import '../data/database/database.dart';
import '../data/repositories/categoria_cliente_repo.dart';
import '../data/repositories/cliente_repo.dart';
import '../data/repositories/precios_repo.dart';
import '../data/repositories/ruta_repo.dart';
import '../infrastructure/repositories/inventario_repo_db.dart';
import 'cliente_service.dart';
import 'inventario_service.dart';
import 'promocion_service.dart';
import 'rutas_service.dart';

class SessionSyncService {
  final AppDatabase database;
  final PreciosRepository preciosRepository;

  SessionSyncService(this.database, this.preciosRepository);

  Future<void> syncAll(int idVendedor) async {
    final catClienteRepoDB = CategoriaClienteRepo(database);
    final inventarioServi = InventarioService();
    final inventarioRepoDB = InventarioRepositoryDB(database, inventarioServi, idVendedor);
    final rutaServ = RutaService();
    final rutaRepoDB = RutaRepositoryDB(database, rutaServ);
    final clienteServ = ClienteService();
    final clienteRepoDB = ClientesRepository(database, clienteServ);
    final promocionesDao = PromocionesDao(database);
    final formaPagoServ = await MetodopagoService().getMetodosPago();
    final promService = await PromocionService().getPromociones();

    final tasks = <String, Future<void> Function()>{
      'categorias_cliente': catClienteRepoDB.insertCategoriasCliente,
      'inventario': inventarioRepoDB.sincronizarProductos,
      'rutas': rutaRepoDB.insertRutas,
      'clientes': () async {
        final remotos = await clienteServ.getClientes('');
        await clienteRepoDB.sincronizarEnDb(remotos);
      },
      'precios': preciosRepository.insertPrecios,
    };

    final results = await Future.wait(
      tasks.entries.map((e) async {
        try {
          await e.value();
          return null;
        } catch (err, stack) {
          if (kDebugMode) debugPrint('Sync falló en "${e.key}": $err\n$stack');
          return e.key;
        }
      }),
    );

    await database.catalogosDao.insertFormasPago(formaPagoServ);

    await promocionesDao.guardarPromocionesDesdeJson(promService);

    final failed = results.whereType<String>().toList();
    if (failed.isNotEmpty) {
      throw SessionSyncException('Fallaron: ${failed.join(', ')}');
    }
  }
}

class SessionSyncException implements Exception {
  final String message;
  SessionSyncException(this.message);
  @override
  String toString() => 'SessionSyncException: $message';
}