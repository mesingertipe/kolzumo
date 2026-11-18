import 'package:drift/drift.dart';

class SyncInventario extends Table {
  IntColumn get id => integer().autoIncrement()();
  BoolColumn get sincronizado => boolean().withDefault(const Constant(false))();
  
  @override
  Set<Column> get primaryKey => {id};

  @override
  String get tableName => 'syncInventario';
}