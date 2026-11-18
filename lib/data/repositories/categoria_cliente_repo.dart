import 'package:drift/drift.dart';
import 'package:kolzumo_app/services/categoria_cliente_service.dart';

import '../../infrastructure/helpers/resultado_sincronizacion_helper.dart';
import '../database/database.dart';

class CategoriaClienteRepo {
  final AppDatabase _db;

  CategoriaClienteRepo(this._db);

  Future<ResultadoSincronizacion> insertCategoriasCliente() async {
    final CategoriaClienteService categoriaClienteService = CategoriaClienteService();
    
    try {
      final json = await categoriaClienteService.getCategoriaClientes();

      await _db.batch((batch) {
        batch.insertAllOnConflictUpdate(
          _db.categoriasCliente,
          json.map((item) {
            return CategoriasClienteCompanion.insert(
              id: Value(item.idcategoriaCliente),
              nombre: item.nombre
            );
          }).toList(),
        );
      });

      return ResultadoSincronizacion.ok(json.length);
    } catch (e) {
      return ResultadoSincronizacion.fallo(e.toString());
    }
  }
}