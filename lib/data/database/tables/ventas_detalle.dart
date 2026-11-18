import 'package:drift/drift.dart';

import 'ventas.dart';
import 'productos.dart';
import 'promociones.dart';

@DataClassName('VentaDetalle')
class VentasDetalle extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get ventaId => integer().references(Ventas, #id)();
  IntColumn get productoId => integer().references(Productos, #id)();

  IntColumn get cantidad => integer()();
  RealColumn get precioUnitario => real()();
  IntColumn get porcentajeIva => integer().withDefault(const Constant(0))();

  IntColumn get promocionId => integer().nullable().references(Promociones, #idpromocion)();

  RealColumn get subtotal => real()();

  @override
  String get tableName => 'ventas_detalle';
}