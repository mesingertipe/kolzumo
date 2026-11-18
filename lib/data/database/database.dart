import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:kolzumo_app/data/database/tables/promociones_clientes.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import 'daos/ventas_dao.dart';
import 'tables/inventario_sincronizacion.dart';
import 'tables/productos.dart';
import 'tables/categorias_cliente.dart';
import 'tables/tipos_documento.dart';
import 'tables/formas_pago.dart';
import 'tables/rutas.dart';
import 'tables/ciudades.dart';
import 'tables/clientes.dart';
import 'tables/precios.dart';
import 'tables/promociones.dart';

import 'daos/catalogos_dao.dart';
import 'daos/clientes_dao.dart';
import 'daos/precios_dao.dart';
import 'daos/promociones_dao.dart';
import 'tables/ventas.dart';
import 'tables/ventas_detalle.dart';
import 'tables/ventas_forma_pago.dart';

part 'database.g.dart';

@DriftDatabase(
  tables: [
    Productos,
    CategoriasCliente,
    TiposDocumento,
    FormasPago,
    Rutas,
    Ciudades,
    Clientes,
    Precios,
    Promociones,
    PromocionesClientes,
    Ventas,
    VentasDetalle,
    VentasFormasPago,
    SyncInventario,
  ],
  daos: [
    CatalogosDao,
    ClientesDao,
    PreciosDao,
    PromocionesDao,
    VentasDao,
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  // Usa un constructor separado para tests (base de datos en memoria)
  AppDatabase.forTesting(super.executor);

  @override
  int get schemaVersion => 5;

  @override
  MigrationStrategy get migration {
    return MigrationStrategy(
      onCreate: (Migrator m) async {
        await m.createAll();
      },
      onUpgrade: (Migrator m, int from, int to) async {
        if (from == 1) {
          await m.addColumn(productos, productos.cantidad);
          await m.addColumn(productos, productos.porcentajeiva);
        }

        if (from == 2) {
          await m.addColumn(rutas, rutas.idRuta);
          await m.addColumn(rutas, rutas.idZona);
          await m.addColumn(rutas, rutas.nombrezona);
          await m.addColumn(rutas, rutas.estado);
          await m.addColumn(rutas, rutas.nombreEstado);
        }

        if (from == 3) {
          await m.createTable(formasPago);
        }

        if (from == 4) {
          await m.createTable(promociones);
          await m.createTable(promocionesClientes);
        }
        if (from == 5) {
          await m.createTable(ventas);
          await m.createTable(ventasDetalle);
          await m.createTable(ventasFormasPago);
        }
      },
    );
  }
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'app_db.sqlite'));
    return NativeDatabase.createInBackground(file);
  });
}