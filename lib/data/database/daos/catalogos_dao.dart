import 'package:drift/drift.dart';
import 'package:kolzumo_app/data/database/tables/formas_pago.dart';
import '../../../infrastructure/models/inventario_model.dart';
import '../../../infrastructure/models/metodopago_model.dart';
import '../database.dart';
import '../tables/inventario_sincronizacion.dart';
import '../tables/productos.dart';
import '../tables/categorias_cliente.dart';
import '../tables/tipos_documento.dart';
import '../tables/rutas.dart';
import '../tables/ciudades.dart';

part 'catalogos_dao.g.dart';

@DriftAccessor(tables: [
  Productos,
  CategoriasCliente,
  FormasPago,
  TiposDocumento,
  Rutas,
  Ciudades,
  SyncInventario,
])
class CatalogosDao extends DatabaseAccessor<AppDatabase> with _$CatalogosDaoMixin {
  CatalogosDao(super.db);

  // ---- Productos ----
  Future<List<Producto>> obtenerProductos() => select(productos).get();

  Stream<List<Producto>> watchProductos() => select(productos).watch();

  Future<int> upsertProducto(ProductosCompanion producto) =>
      into(productos).insertOnConflictUpdate(producto);

  Future<void> descontarCantidadesVendidas(
    List<MapEntry<int, int>> cantidadesPorProductoId,
  ) async {
    await transaction(() async {
      for (final entry in cantidadesPorProductoId) {
        final productoId = entry.key;
        final cantidadComprada = entry.value;
 
        await customStatement(
          'UPDATE productos SET cantidad = MAX(0, cantidad - ?) WHERE id = ?',
          [cantidadComprada, productoId],
        );
      }
    });
  }

  Future<void> actualizarCantidad(
    List<Inventario> pedidos,
  ) async {
    await transaction(() async{
      for (final producto in pedidos) {
        final productoId = producto.idproducto;
        final nuevaCantidad = producto.cantidad;

        await customStatement(
          'UPDATE productos SET cantidad = MAX(0, cantidad + ?) WHERE id = ?',
          [nuevaCantidad, productoId],
        );
      }
    });
  }

  // ---- Formas Pago ----
  Future<List<FormaPago>> obtenerFormasPago() => select(formasPago).get();

  Future<int> upsertFormasPago(FormasPagoCompanion formapago) => into(formasPago).insertOnConflictUpdate(formapago);
  
  Future<void> insertFormasPago(
    List<MetodoPago> formasPagoBackend,
  ) async {
    await batch((b) {
      b.insertAllOnConflictUpdate(
        formasPago,
        formasPagoBackend.map((m) {
          return FormasPagoCompanion.insert(
            idformapago: Value(m.idformapago),
            nombreformapago: m.nombreformapago,
          );
        }).toList(),
      );
    });
  }

  // --- Sincronizacion Inventario ---
  Future<bool?> getEstadoSincronizacion() async {
    final row = await (select(syncInventario)
          ..where((t) => t.sincronizado.equals(true)))
        .getSingleOrNull();

    if (row == null) return null;
    return row.sincronizado;
  }

  Future<void> saveSincronizacion() async {
    await into(syncInventario).insertOnConflictUpdate(
      SyncInventarioCompanion.insert(
        sincronizado: Value(true)
      ),
    );
  }

  // ---- Categorías de cliente ----
  Future<List<CategoriaCliente>> obtenerCategoriasCliente() => select(categoriasCliente).get();

  Future<int> upsertCategoriaCliente(CategoriasClienteCompanion categoria) =>
      into(categoriasCliente).insertOnConflictUpdate(categoria);

  // ---- Tipos de documento ----
  Future<List<TipoDocumento>> obtenerTiposDocumento() =>
      select(tiposDocumento).get();

  Future<int> upsertTipoDocumento(TiposDocumentoCompanion tipo) =>
      into(tiposDocumento).insertOnConflictUpdate(tipo);

  // ---- Rutas ----
  Future<List<Ruta>> obtenerRutas() => select(rutas).get();

  Future<int> upsertRuta(RutasCompanion ruta) =>
      into(rutas).insertOnConflictUpdate(ruta);

  // ---- Ciudades ----
  Future<List<Ciudad>> obtenerCiudades() => select(ciudades).get();

  Future<int> upsertCiudad(CiudadesCompanion ciudad) =>
      into(ciudades).insertOnConflictUpdate(ciudad);
}