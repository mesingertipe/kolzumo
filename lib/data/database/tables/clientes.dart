import 'package:drift/drift.dart';

import 'tipos_documento.dart';
import 'categorias_cliente.dart';
import 'rutas.dart';
import 'ciudades.dart';

@DataClassName('Cliente')
class Clientes extends Table {
  IntColumn get id => integer()();

  IntColumn get tipoDocumentoId => integer().references(TiposDocumento, #id)();
  TextColumn get documento => text()();

  TextColumn get nombreEstablecimiento => text()();
  TextColumn get direccion => text()();
  TextColumn get telefono => text().nullable()();
  TextColumn get email => text().nullable()();
  TextColumn get administrador => text().nullable()();
  TextColumn get barrio => text().nullable()();

  RealColumn get gpsLat => real().nullable()();
  RealColumn get gpsLng => real().nullable()();

  IntColumn get consecutivoEntrega => integer().withDefault(const Constant(0))();

  BoolColumn get ivaDiscrimina => boolean().withDefault(const Constant(false))();
  BoolColumn get pagoCredito => boolean().withDefault(const Constant(false))();
  RealColumn get cupo => real().withDefault(const Constant(0))();
  IntColumn get plazo => integer().nullable()();

  BoolColumn get activo => boolean().withDefault(const Constant(true))();

  IntColumn get categoriaClienteId => integer().references(CategoriasCliente, #id)();
  IntColumn get rutaId => integer().references(Rutas, #id)();
  IntColumn get ciudadId => integer().references(Ciudades, #id)();

  TextColumn get horarioDesde => text().nullable()(); 
  TextColumn get horarioHasta => text().nullable()();

  @override
  Set<Column> get primaryKey => {id};

  @override
  String get tableName => 'clientes';
}