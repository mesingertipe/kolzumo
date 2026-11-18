// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'clientes_dao.dart';

// ignore_for_file: type=lint
mixin _$ClientesDaoMixin on DatabaseAccessor<AppDatabase> {
  $TiposDocumentoTable get tiposDocumento => attachedDatabase.tiposDocumento;
  $CategoriasClienteTable get categoriasCliente =>
      attachedDatabase.categoriasCliente;
  $RutasTable get rutas => attachedDatabase.rutas;
  $CiudadesTable get ciudades => attachedDatabase.ciudades;
  $ClientesTable get clientes => attachedDatabase.clientes;
  ClientesDaoManager get managers => ClientesDaoManager(this);
}

class ClientesDaoManager {
  final _$ClientesDaoMixin _db;
  ClientesDaoManager(this._db);
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
}
