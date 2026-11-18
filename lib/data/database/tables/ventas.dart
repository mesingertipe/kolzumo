import 'package:drift/drift.dart';

import 'clientes.dart';
import 'rutas.dart';

@DataClassName('Venta')
class Ventas extends Table {
  IntColumn get id => integer().autoIncrement()(); 

  IntColumn get idBackend => integer().nullable()();

  IntColumn get consecutivo => integer()();

  IntColumn get clienteId => integer().references(Clientes, #id)();
  IntColumn get vendedorId => integer()();
  IntColumn get rutaId => integer().nullable().references(Rutas, #idRuta)();

  DateTimeColumn get fecha => dateTime().withDefault(currentDateAndTime)();

  RealColumn get total => real()();

  BoolColumn get sincronizado => boolean().withDefault(const Constant(false))();
  DateTimeColumn get fechaSincronizacion => dateTime().nullable()();

  @override
  String get tableName => 'ventas';
}