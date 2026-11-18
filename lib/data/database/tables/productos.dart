import 'package:drift/drift.dart';

@DataClassName('Producto')
class Productos extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get nombre => text()();
  IntColumn get cantidad => integer()();
  IntColumn get porcentajeiva => integer()();

  @override
  String get tableName => 'productos';
}