import 'package:drift/drift.dart';

@DataClassName('CategoriaCliente')
class CategoriasCliente extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get nombre => text()();

  @override
  String get tableName => 'categorias_cliente';
}