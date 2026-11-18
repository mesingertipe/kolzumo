import 'package:drift/drift.dart';
import 'package:kolzumo_app/services/inventario_service.dart';

import '../../data/database/database.dart';
import '../helpers/resultado_sincronizacion_helper.dart';

class InventarioRepositoryDB {
  final AppDatabase _db;
  final InventarioService _api;
  final int _idVendedor;

  InventarioRepositoryDB(this._db, this._api, this._idVendedor);

  Future<ResultadoSincronizacion> sincronizarProductos() async {
    try {
      final json = await _api.getInventarioParcial(_idVendedor);

      await _db.batch((batch) {
        batch.insertAllOnConflictUpdate(
          _db.productos,
          json.map((item) {
            return ProductosCompanion.insert(
              id: Value(item.idproducto),
              nombre: item.nombreproducto,
              cantidad: item.cantidad,
              porcentajeiva: item.porcentajeiva
            );
          }).toList(),
        );
      });

      return ResultadoSincronizacion.ok(json.length);
    } catch (e) {
      return ResultadoSincronizacion.fallo(e.toString());
    }
  }

  Future<List<Producto>> obtenerProductosLocales() {
    return _db.select(_db.productos).get();
  }
}