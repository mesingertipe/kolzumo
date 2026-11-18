// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'catalogos_dao.dart';

// ignore_for_file: type=lint
mixin _$CatalogosDaoMixin on DatabaseAccessor<AppDatabase> {
  $ProductosTable get productos => attachedDatabase.productos;
  $CategoriasClienteTable get categoriasCliente =>
      attachedDatabase.categoriasCliente;
  $FormasPagoTable get formasPago => attachedDatabase.formasPago;
  $TiposDocumentoTable get tiposDocumento => attachedDatabase.tiposDocumento;
  $RutasTable get rutas => attachedDatabase.rutas;
  $CiudadesTable get ciudades => attachedDatabase.ciudades;
  $SyncInventarioTable get syncInventario => attachedDatabase.syncInventario;
  CatalogosDaoManager get managers => CatalogosDaoManager(this);
}

class CatalogosDaoManager {
  final _$CatalogosDaoMixin _db;
  CatalogosDaoManager(this._db);
  $$ProductosTableTableManager get productos =>
      $$ProductosTableTableManager(_db.attachedDatabase, _db.productos);
  $$CategoriasClienteTableTableManager get categoriasCliente =>
      $$CategoriasClienteTableTableManager(
        _db.attachedDatabase,
        _db.categoriasCliente,
      );
  $$FormasPagoTableTableManager get formasPago =>
      $$FormasPagoTableTableManager(_db.attachedDatabase, _db.formasPago);
  $$TiposDocumentoTableTableManager get tiposDocumento =>
      $$TiposDocumentoTableTableManager(
        _db.attachedDatabase,
        _db.tiposDocumento,
      );
  $$RutasTableTableManager get rutas =>
      $$RutasTableTableManager(_db.attachedDatabase, _db.rutas);
  $$CiudadesTableTableManager get ciudades =>
      $$CiudadesTableTableManager(_db.attachedDatabase, _db.ciudades);
  $$SyncInventarioTableTableManager get syncInventario =>
      $$SyncInventarioTableTableManager(
        _db.attachedDatabase,
        _db.syncInventario,
      );
}
