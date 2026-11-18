import 'package:drift/drift.dart';

@DataClassName('Ruta')
class Rutas extends Table {
  IntColumn get idRuta => integer()();
  TextColumn get nombre => text()();
  IntColumn get idZona => integer()();
  TextColumn get nombrezona => text()();
  BoolColumn get estado => boolean()();
  TextColumn get nombreEstado => text()();

  @override
  Set<Column> get primaryKey => {idRuta};

  @override
  String get tableName => 'rutas';
}