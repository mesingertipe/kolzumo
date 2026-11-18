import 'package:drift/drift.dart';

import '../database.dart';
import '../tables/clientes.dart';

part 'clientes_dao.g.dart';

@DriftAccessor(tables: [Clientes])
class ClientesDao extends DatabaseAccessor<AppDatabase>
    with _$ClientesDaoMixin {
  ClientesDao(super.db);

  Future<List<Cliente>> obtenerTodos() => select(clientes).get();

  Stream<List<Cliente>> watchActivos() =>
      (select(clientes)..where((c) => c.activo.equals(true))).watch();

  Future<Cliente?> obtenerPorId(int id) =>
      (select(clientes)..where((c) => c.id.equals(id))).getSingleOrNull();

  Future<int> upsert(ClientesCompanion cliente) => into(clientes).insertOnConflictUpdate(cliente);

  static ClientesCompanion desdeJsonBackend(Map<String, dynamic> json) {
    final gps = json['gps'] as Map<String, dynamic>?;

    return ClientesCompanion.insert(
      id: Value(json['idcliente'] as int),
      tipoDocumentoId: json['idtipodocumento'] as int,
      documento: json['documento'] as String,
      nombreEstablecimiento: json['nombreestablecimiento'] as String,
      direccion: json['direccion'] as String,
      telefono: Value(json['telefono'] as String?),
      email: Value(json['email'] as String?),
      administrador: Value(json['administrador'] as String?),
      barrio: Value(json['barrio'] as String?),
      gpsLat: Value((gps?['lat'] as num?)?.toDouble()),
      gpsLng: Value((gps?['lng'] as num?)?.toDouble()),
      consecutivoEntrega: Value(json['consecutivoentrega'] as int? ?? 0),
      ivaDiscrimina: Value(json['ivadiscrimina'] == 1),
      pagoCredito: Value(json['pagocredito'] == 1),
      cupo: Value((json['cupo'] as num).toDouble()),
      plazo: Value(json['plazo'] as int?),
      activo: Value(json['estado'] == 1),
      categoriaClienteId: json['idcategoriaCliente'] as int,
      rutaId: json['idruta'] as int,
      ciudadId: json['idciudad'] as int,
      horarioDesde: Value(json['horariodesde'] as String?),
      horarioHasta: Value(json['horariohasta'] as String?),
    );
  }
}