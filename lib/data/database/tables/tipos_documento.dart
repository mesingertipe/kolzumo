import 'package:drift/drift.dart';

@DataClassName('TipoDocumento')
class TiposDocumento extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get nombre => text()(); // "Cédula", "NIT", etc.

  @override
  String get tableName => 'tipos_documento';
}