import 'package:drift/drift.dart';
import 'package:kolzumo_app/data/database/tables/productos.dart';

import '../database.dart';
import '../tables/promociones.dart';
import '../tables/promociones_clientes.dart';
import '../../../infrastructure/models/promocion_model.dart' as model;

part 'promociones_dao.g.dart';

class ProductoConPromocion {
  final Producto producto;
  final Promocion? promocion;

  ProductoConPromocion({required this.producto, this.promocion});
}

@DriftAccessor(tables: [Promociones, PromocionesClientes, Productos])
class PromocionesDao extends DatabaseAccessor<AppDatabase> with _$PromocionesDaoMixin {
  PromocionesDao(super.db);

  Future<void> guardarPromocionesDesdeJson(List<model.Promocion> json) async {
    await transaction(() async {
      for (final item in json) {
        final promocionId = item.idpromocion;

        await into(promociones).insertOnConflictUpdate(
          PromocionesCompanion.insert(
            idpromocion: Value(promocionId),
            promocionpara: item.promocionpara,
            promocionde: item.promocionde,
            productoId: item.idproducto,
            cantidadventa: Value(item.cantidadventa),
            cantidadsobreventa: Value(item.cantidadsobreventa),
            porcentajesobreventa: Value(item.porcentajesobreventa),
            fechadesde: item.fechadesde,
            fechahasta: item.fechahasta,
            rutaId: Value(item.idpromocionruta),
            categoriaClienteId: Value(item.idpromocioncatcli),
          ),
        );

       
        await (delete(promocionesClientes)
              ..where((t) => t.promocionId.equals(promocionId)))
            .go();

        final listaClientes = (item.listaclientespromocion);

        if (listaClientes.isNotEmpty) {
          await batch((b) {
            b.insertAll(
              promocionesClientes,
              listaClientes.map((clienteId) {
                return PromocionesClientesCompanion.insert(
                  promocionId: promocionId,
                  clienteId: clienteId as int,
                );
              }).toList(),
            );
          });
        }
      }
    });
  }

  Future<List<Promocion>> promocionesVigentes({DateTime? fecha}) {
    final dia = fecha ?? DateTime.now();
    final soloFecha = DateTime(dia.year, dia.month, dia.day);

    return (select(promociones)
          ..where((p) =>
              p.fechadesde.isSmallerOrEqualValue(soloFecha) &
              p.fechahasta.isBiggerOrEqualValue(soloFecha)))
        .get();
  }

  Future<List<Promocion>> promocionesParaCliente({
    required int productoId,
    required int clienteId,
    required int rutaId,
    required int categoriaClienteId,
    DateTime? fecha,
  }) async {
    final vigentes = await promocionesVigentes(fecha: fecha);
    final delProducto = vigentes.where((p) => p.productoId == productoId).toList();

    final idsClienteEspecifico = await (select(promocionesClientes)
      ..where((t) => t.clienteId.equals(clienteId)))
    .map((row) => row.promocionId)
    .get();

    return delProducto.where((p) {
      switch (p.promocionpara) {
        case 'Ruta':
          return p.rutaId == rutaId;
        case 'Categoria Cliente':
          return p.categoriaClienteId == categoriaClienteId;
        case 'Cliente':
          return idsClienteEspecifico.contains(p.idpromocion);
        default:
          return false;
      }
    }).toList();
  }

  Future<List<ProductoConPromocion>> productosConPromocionVigente({
    required int clienteId,
    required int rutaId,
    required int categoriaClienteId,
    DateTime? fecha,
  }) async {
    final todosLosProductos = await select(productos).get();
    final vigentes = await promocionesVigentes(fecha: fecha);
 
    final idsClienteEspecifico = await (select(promocionesClientes)
          ..where((t) => t.clienteId.equals(clienteId)))
        .map((row) => row.promocionId)
        .get();
 
    final promocionPorProducto = <int, Promocion>{};
    for (final promo in vigentes) {
      final aplica = switch (promo.promocionpara) {
        'Ruta' => promo.rutaId == rutaId,
        'Categoria Cliente' => promo.categoriaClienteId == categoriaClienteId,
        'Cliente' => idsClienteEspecifico.contains(promo.idpromocion),
        _ => false,
      };
      if (aplica) {
        promocionPorProducto[promo.productoId] = promo;
      }
    }
 
    return todosLosProductos.map((producto) {
      return ProductoConPromocion(
        producto: producto,
        promocion: promocionPorProducto[producto.id],
      );
    }).toList();
  }
}