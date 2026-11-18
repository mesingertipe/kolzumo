// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ventas_dao.dart';

// ignore_for_file: type=lint
mixin _$VentasDaoMixin on DatabaseAccessor<AppDatabase> {
  $TiposDocumentoTable get tiposDocumento => attachedDatabase.tiposDocumento;
  $CategoriasClienteTable get categoriasCliente =>
      attachedDatabase.categoriasCliente;
  $RutasTable get rutas => attachedDatabase.rutas;
  $CiudadesTable get ciudades => attachedDatabase.ciudades;
  $ClientesTable get clientes => attachedDatabase.clientes;
  $VentasTable get ventas => attachedDatabase.ventas;
  $ProductosTable get productos => attachedDatabase.productos;
  $PromocionesTable get promociones => attachedDatabase.promociones;
  $VentasDetalleTable get ventasDetalle => attachedDatabase.ventasDetalle;
  $FormasPagoTable get formasPago => attachedDatabase.formasPago;
  $VentasFormasPagoTable get ventasFormasPago =>
      attachedDatabase.ventasFormasPago;
  VentasDaoManager get managers => VentasDaoManager(this);
}

class VentasDaoManager {
  final _$VentasDaoMixin _db;
  VentasDaoManager(this._db);
  $$TiposDocumentoTableTableManager get tiposDocumento =>
      $$TiposDocumentoTableTableManager(
        _db.attachedDatabase,
        _db.tiposDocumento,
      );
  $$CategoriasClienteTableTableManager get categoriasCliente =>
      $$CategoriasClienteTableTableManager(
        _db.attachedDatabase,
        _db.categoriasCliente,
      );
  $$RutasTableTableManager get rutas =>
      $$RutasTableTableManager(_db.attachedDatabase, _db.rutas);
  $$CiudadesTableTableManager get ciudades =>
      $$CiudadesTableTableManager(_db.attachedDatabase, _db.ciudades);
  $$ClientesTableTableManager get clientes =>
      $$ClientesTableTableManager(_db.attachedDatabase, _db.clientes);
  $$VentasTableTableManager get ventas =>
      $$VentasTableTableManager(_db.attachedDatabase, _db.ventas);
  $$ProductosTableTableManager get productos =>
      $$ProductosTableTableManager(_db.attachedDatabase, _db.productos);
  $$PromocionesTableTableManager get promociones =>
      $$PromocionesTableTableManager(_db.attachedDatabase, _db.promociones);
  $$VentasDetalleTableTableManager get ventasDetalle =>
      $$VentasDetalleTableTableManager(_db.attachedDatabase, _db.ventasDetalle);
  $$FormasPagoTableTableManager get formasPago =>
      $$FormasPagoTableTableManager(_db.attachedDatabase, _db.formasPago);
  $$VentasFormasPagoTableTableManager get ventasFormasPago =>
      $$VentasFormasPagoTableTableManager(
        _db.attachedDatabase,
        _db.ventasFormasPago,
      );
}
