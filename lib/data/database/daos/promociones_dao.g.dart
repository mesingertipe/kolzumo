// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'promociones_dao.dart';

// ignore_for_file: type=lint
mixin _$PromocionesDaoMixin on DatabaseAccessor<AppDatabase> {
  $RutasTable get rutas => attachedDatabase.rutas;
  $ProductosTable get productos => attachedDatabase.productos;
  $CategoriasClienteTable get categoriasCliente =>
      attachedDatabase.categoriasCliente;
  $PromocionesTable get promociones => attachedDatabase.promociones;
  $TiposDocumentoTable get tiposDocumento => attachedDatabase.tiposDocumento;
  $CiudadesTable get ciudades => attachedDatabase.ciudades;
  $ClientesTable get clientes => attachedDatabase.clientes;
  $PromocionesClientesTable get promocionesClientes =>
      attachedDatabase.promocionesClientes;
  PromocionesDaoManager get managers => PromocionesDaoManager(this);
}

class PromocionesDaoManager {
  final _$PromocionesDaoMixin _db;
  PromocionesDaoManager(this._db);
  $$RutasTableTableManager get rutas =>
      $$RutasTableTableManager(_db.attachedDatabase, _db.rutas);
  $$ProductosTableTableManager get productos =>
      $$ProductosTableTableManager(_db.attachedDatabase, _db.productos);
  $$CategoriasClienteTableTableManager get categoriasCliente =>
      $$CategoriasClienteTableTableManager(
        _db.attachedDatabase,
        _db.categoriasCliente,
      );
  $$PromocionesTableTableManager get promociones =>
      $$PromocionesTableTableManager(_db.attachedDatabase, _db.promociones);
  $$TiposDocumentoTableTableManager get tiposDocumento =>
      $$TiposDocumentoTableTableManager(
        _db.attachedDatabase,
        _db.tiposDocumento,
      );
  $$CiudadesTableTableManager get ciudades =>
      $$CiudadesTableTableManager(_db.attachedDatabase, _db.ciudades);
  $$ClientesTableTableManager get clientes =>
      $$ClientesTableTableManager(_db.attachedDatabase, _db.clientes);
  $$PromocionesClientesTableTableManager get promocionesClientes =>
      $$PromocionesClientesTableTableManager(
        _db.attachedDatabase,
        _db.promocionesClientes,
      );
}
