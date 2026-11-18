import 'package:drift/drift.dart';

import 'promociones.dart';
import 'clientes.dart';

@DataClassName('PromocionCliente')
class PromocionesClientes extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get promocionId => integer().references(Promociones, #idpromocion)();
  IntColumn get clienteId => integer().references(Clientes, #id)();

  @override
  String get tableName => 'promociones_clientes';

  @override
  List<Set<Column>> get uniqueKeys => [{promocionId, clienteId},];
}