import 'package:kolzumo_app/services/precios_service.dart';

import '../../infrastructure/helpers/resultado_sincronizacion_helper.dart';
import '../database/database.dart';
import '../database/daos/precios_dao.dart';

class PreciosRepository {
  final AppDatabase _db;

  PreciosRepository(this._db);

  Future<ResultadoSincronizacion> insertPrecios() async {
    final PreciosService precioServ = PreciosService();
    
    try {
      final json = await precioServ.getPrecios();

      await _db.batch((batch) {
        batch.insertAllOnConflictUpdate(
          _db.precios,
          json.map((item) {
            return PreciosCompanion.insert(
              productoId: item.idproducto, 
              categoriaClienteId: item.idcategoriacliente, 
              valor: item.valor, 
              fecha: DateTime.now()
            );
          }).toList(),
        );
      });

      return ResultadoSincronizacion.ok(json.length);
    } catch (e) {
      return ResultadoSincronizacion.fallo(e.toString());
    }
  }

  Stream<List<PrecioDetallado>> preciosDelDia(DateTime dia) {
    return _db.preciosDao.watchPreciosDelDia(dia);
  }

  Future<double?> precioParaClienteHoy(int clienteId, int productoId) {
    return _db.preciosDao.precioParaCliente(
      clienteId,
      productoId,
      DateTime.now(),
    );
  }
}