import 'package:drift/drift.dart';
import 'package:kolzumo_app/data/database/tables/categorias_cliente.dart';
import 'package:kolzumo_app/data/database/tables/productos.dart';

import 'rutas.dart';

@DataClassName('Promocion')
class Promociones extends Table {
  IntColumn get idpromocion => integer()();
  TextColumn get promocionpara => text()();
  TextColumn get promocionde => text()();
  IntColumn get cantidadventa => integer().withDefault(const Constant(0))();
  IntColumn get cantidadsobreventa => integer().nullable()();
  IntColumn get porcentajesobreventa => integer().nullable()();
  DateTimeColumn get fechadesde => dateTime()();
  DateTimeColumn get fechahasta => dateTime()();
  IntColumn get rutaId => integer().nullable().references(Rutas, #id)();
  IntColumn get productoId => integer().references(Productos, #id)();
  IntColumn get categoriaClienteId => integer().nullable().references(CategoriasCliente, #id)();


  @override
  Set<Column> get primaryKey => {idpromocion};

  @override
  String get tableName => 'promociones';
}