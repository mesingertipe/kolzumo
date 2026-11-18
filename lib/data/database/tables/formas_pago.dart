import 'package:drift/drift.dart';

@DataClassName('FormaPago')
class FormasPago extends Table {
  IntColumn get idformapago => integer()();
  TextColumn get nombreformapago => text()();

  @override
  Set<Column> get primaryKey => {idformapago};

  @override
  String get tableName => 'forma_pago';
}