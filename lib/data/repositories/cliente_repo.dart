import 'package:drift/drift.dart';
import 'package:kolzumo_app/services/cliente_service.dart';

import '../../infrastructure/helpers/resultado_sincronizacion_helper.dart';
import '../database/database.dart';

class ClienteRepositoryDB {
  final AppDatabase _db;
  final ClienteService _api;

  ClienteRepositoryDB(this._db, this._api);

  Future<ResultadoSincronizacion> insertClientes() async {
    try {
      final json = await _api.getClientes('');

      await _db.batch((batch) {
        batch.insertAllOnConflictUpdate(
          _db.clientes,
          json.map((item) {
            return ClientesCompanion.insert(
              id: Value(item.idcliente),
              tipoDocumentoId: item.idtipodocumento, 
              documento: item.documento, 
              nombreEstablecimiento: item.nombreestablecimiento, 
              direccion: item.direccion,
              telefono: Value(item.telefono),
              email: Value(item.email),
              administrador: Value(item.administrador),
              barrio: Value(item.barrio),
              ivaDiscrimina: Value(item.ivadiscrimina == 0 ? false : true),
              pagoCredito: Value(item.pagocredito == 0 ? false : true),
              cupo: Value(item.cupo),
              plazo: Value(item.plazo),
              activo: Value(item.estado == 0 ? false : true),
              categoriaClienteId: item.idcategoriaCliente, 
              rutaId: item.idruta, 
              ciudadId: item.idciudad
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