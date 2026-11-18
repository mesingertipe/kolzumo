import 'package:drift/drift.dart';
import 'package:kolzumo_app/services/rutas_service.dart';

import '../../infrastructure/helpers/resultado_sincronizacion_helper.dart';
import '../database/database.dart';

class RutaRepositoryDB {
  final AppDatabase _db;
  final RutaService _api;

  RutaRepositoryDB(this._db, this._api);

  Future<ResultadoSincronizacion> insertRutas() async {
    try {
      final json = await _api.findRutas('');

      await _db.batch((batch) {
        batch.insertAllOnConflictUpdate(
          _db.rutas,
          json.map((item) {
            return RutasCompanion.insert(
              idRuta: Value(item.idruta),
              nombre: item.nombreruta,
              idZona: item.idzona,
              nombrezona: item.nombrezona,
              estado: item.estado == 0 ? false : true,
              nombreEstado: item.nombreestado

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