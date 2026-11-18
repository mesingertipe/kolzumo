// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'precios_dao.dart';

// ignore_for_file: type=lint
mixin _$PreciosDaoMixin on DatabaseAccessor<AppDatabase> {
  $ProductosTable get productos => attachedDatabase.productos;
  $CategoriasClienteTable get categoriasCliente =>
      attachedDatabase.categoriasCliente;
  $PreciosTable get precios => attachedDatabase.precios;
  $TiposDocumentoTable get tiposDocumento => attachedDatabase.tiposDocumento;
  $RutasTable get rutas => attachedDatabase.rutas;
  $CiudadesTable get ciudades => attachedDatabase.ciudades;
  $ClientesTable get clientes => attachedDatabase.clientes;
  PreciosDaoManager get managers => PreciosDaoManager(this);
}

class PreciosDaoManager {
  final _$PreciosDaoMixin _db;
  PreciosDaoManager(this._db);
  $$ProductosTableTableManager get productos =>
      $$ProductosTableTableManager(_db.attachedDatabase, _db.productos);
  $$CategoriasClienteTableTableManager get categoriasCliente =>
      $$CategoriasClienteTableTableManager(
        _db.attachedDatabase,
        _db.categoriasCliente,
      );
  $$PreciosTableTableManager get precios =>
      $$PreciosTableTableManager(_db.attachedDatabase, _db.precios);
  $$TiposDocumentoTableTableManager get tiposDocumento =>
      $$TiposDocumentoTableTableManager(
        _db.attachedDatabase,
        _db.tiposDocumento,
      );
  $$RutasTableTableManager get rutas =>
      $$RutasTableTableManager(_db.attachedDatabase, _db.rutas);
  $$CiudadesTableTableManager get ciudades =>
      $$CiudadesTableTableManager(_db.attachedDatabase, _db.ciudades);
  $$ClientesTableTableManager get clientes =>
      $$ClientesTableTableManager(_db.attachedDatabase, _db.clientes);
}
