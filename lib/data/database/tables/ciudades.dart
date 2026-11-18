import 'package:drift/drift.dart';

@DataClassName('Ciudad')
class Ciudades extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get nombre => text()();

  @override
  String get tableName => 'ciudades';
}