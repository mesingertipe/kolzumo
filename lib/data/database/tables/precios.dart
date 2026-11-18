import 'package:drift/drift.dart';

import 'productos.dart';
import 'categorias_cliente.dart';

@DataClassName('Precio')
class Precios extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get productoId => integer().references(Productos, #id)();
  IntColumn get categoriaClienteId =>
      integer().references(CategoriasCliente, #id)();
  RealColumn get valor => real()();
  DateTimeColumn get fecha => dateTime()();

  @override
  String get tableName => 'precios';

  @override
  List<Set<Column>> get uniqueKeys => [
        {productoId, categoriaClienteId, fecha},
      ];
}