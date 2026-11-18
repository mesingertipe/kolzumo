import 'package:drift/drift.dart';

import '../database.dart';
import '../tables/precios.dart';
import '../tables/productos.dart';
import '../tables/categorias_cliente.dart';
import '../tables/clientes.dart';

part 'precios_dao.g.dart';

@DriftAccessor(tables: [Precios, Productos, CategoriasCliente, Clientes])
class PreciosDao extends DatabaseAccessor<AppDatabase> with _$PreciosDaoMixin {
  PreciosDao(super.db);

  Future<int> upsert(PreciosCompanion precio) => into(precios).insertOnConflictUpdate(precio);

  Stream<List<PrecioDetallado>> watchPreciosDelDia(DateTime dia) {
    final inicio = DateTime(dia.year, dia.month, dia.day);
    final fin = inicio.add(const Duration(days: 1));

    final query = select(precios).join([
      innerJoin(productos, productos.id.equalsExp(precios.productoId)),
      innerJoin(categoriasCliente,
          categoriasCliente.id.equalsExp(precios.categoriaClienteId)),
    ])
    ..where(precios.fecha.isBetweenValues(inicio, fin))
    ..orderBy([OrderingTerm.asc(precios.fecha)]);

    return query.watch().map((rows) => rows.map((row) {
      return PrecioDetallado(
        precio: row.readTable(precios),
        producto: row.readTable(productos),
        categoriaCliente: row.readTable(categoriasCliente),
      );
    }).toList());
  }

  /// Precio vigente hoy para un producto en una categoría de cliente.
  Future<double?> precioActual(
    int productoId,
    int categoriaClienteId,
    DateTime dia,
  ) async {
    final inicio = DateTime(dia.year, dia.month, dia.day);
    final fin = inicio.add(const Duration(days: 1));

    final row = await (select(precios)
          ..where((p) =>
              p.productoId.equals(productoId) &
              p.categoriaClienteId.equals(categoriaClienteId) &
              p.fecha.isBetweenValues(inicio, fin)))
        .getSingleOrNull();

    return row?.valor;
  }

  /// Resuelve el precio de un producto para un CLIENTE específico,
  /// usando la categoría de cliente asociada a ese cliente.
  Future<double?> precioParaCliente(
    int clienteId,
    int productoId,
    DateTime dia,
  ) async {
    final cliente =
        await (select(clientes)..where((c) => c.id.equals(clienteId)))
            .getSingleOrNull();
    if (cliente == null) return null;

    return precioActual(productoId, cliente.categoriaClienteId, dia);
  }

  /// Histórico de precios de un producto entre dos fechas (para gráficas).
  Future<List<Precio>> historico(
    int productoId,
    DateTime desde,
    DateTime hasta,
  ) {
    return (select(precios)
          ..where((p) =>
              p.productoId.equals(productoId) &
              p.fecha.isBetweenValues(desde, hasta))
          ..orderBy([(p) => OrderingTerm.asc(p.fecha)]))
        .get();
  }
}

/// Clase auxiliar para representar un precio con sus relaciones resueltas.
class PrecioDetallado {
  final Precio precio;
  final Producto producto;
  final CategoriaCliente categoriaCliente;

  PrecioDetallado({
    required this.precio,
    required this.producto,
    required this.categoriaCliente,
  });
}