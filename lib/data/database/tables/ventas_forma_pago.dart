import 'package:drift/drift.dart';

import 'ventas.dart';
import 'formas_pago.dart';

@DataClassName('VentaFormaPago')
class VentasFormasPago extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get ventaId => integer().references(Ventas, #id)();
  IntColumn get formaPagoId => integer().references(FormasPago, #idformapago)();
  RealColumn get monto => real()();

  @override
  String get tableName => 'ventas_formas_pago';
}