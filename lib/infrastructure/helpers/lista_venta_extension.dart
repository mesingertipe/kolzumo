import 'package:drift/drift.dart';
import 'package:kolzumo_app/infrastructure/helpers/iva_calcular.dart';

import '../../data/database/daos/ventas_dao.dart';
import '../../data/database/database.dart';

extension VentasDaoBatch on AppDatabase {
  /// Trae TODAS las ventas completas del día en un lote optimizado,
  /// evitando el patrón N+1 (una query por venta).
  Future<List<VentaCompleta>> obtenerVentasCompletasDelDia(DateTime dia, String nombrevendedor, String gps) async {
    // 1. Ventas del día (ya lo tenías)
    final ventasDelDia = await ventasDao.ventasDelDia(dia: dia);
    if (ventasDelDia.isEmpty) return [];

    final ventaIds = ventasDelDia.map((v) => v.id).toList();
    final clienteIds = ventasDelDia.map((v) => v.clienteId).toSet().toList();

    // 2. Clientes y vendedores involucrados (una sola query cada uno)
    final clientesRows = await (select(clientes)
          ..where((c) => c.id.isIn(clienteIds)))
        .get();
    final clientesPorId = {for (final c in clientesRows) c.id: c.nombreEstablecimiento};

    // 3. Todos los detalles de TODAS las ventas del día, con JOIN a productos
    final detalleQuery = select(ventasDetalle).join([
      innerJoin(productos, productos.id.equalsExp(ventasDetalle.productoId)),
    ])..where(ventasDetalle.ventaId.isIn(ventaIds));

    final detalleRows = await detalleQuery.get();

    final promocionIds = detalleRows
      .map((r) => r.readTable(ventasDetalle).promocionId)
      .whereType<int>()
      .toSet()
      .toList();

    final promocionesPorId = <int, Promocion>{};
    if (promocionIds.isNotEmpty) {
      final promos = await (select(promociones)
            ..where((p) => p.idpromocion.isIn(promocionIds)))
          .get();
      for (final p in promos) {
        promocionesPorId[p.idpromocion] = p;
      }
    }

    // Agrupar detalles por ventaId
    final detallesPorVenta = <int, List<VentaDetalle>>{};
    final nombresProductosPorVenta = <int, Map<int, String>>{};

    for (final row in detalleRows) {
      final detalle = row.readTable(ventasDetalle);
      final producto = row.readTable(productos);

      detallesPorVenta.putIfAbsent(detalle.ventaId, () => []).add(detalle);
      nombresProductosPorVenta
          .putIfAbsent(detalle.ventaId, () => {})[detalle.productoId] = producto.nombre;
    }

    // 4. Todos los pagos de TODAS las ventas del día, con JOIN a formas de pago
    final pagosQuery = select(ventasFormasPago).join([
      innerJoin(formasPago, formasPago.idformapago.equalsExp(ventasFormasPago.formaPagoId)),
    ])..where(ventasFormasPago.ventaId.isIn(ventaIds));

    final pagosRows = await pagosQuery.get();

    // Agrupar pagos por ventaId
    final pagosPorVenta = <int, List<VentaFormaPago>>{};
    final nombresFormasPagoPorVenta = <int, Map<int, String>>{};

    for (final row in pagosRows) {
      final pago = row.readTable(ventasFormasPago);
      final formaPago = row.readTable(formasPago);

      pagosPorVenta.putIfAbsent(pago.ventaId, () => []).add(pago);
      nombresFormasPagoPorVenta.putIfAbsent(pago.ventaId, () => {})[pago.formaPagoId] = formaPago.nombreformapago;
    }

    // 5. Ensamblar VentaCompleta por cada venta, todo en memoria (sin más queries)
    return ventasDelDia.map((venta) {
      return VentaCompleta(
        venta: venta,
        detalle: detallesPorVenta[venta.id] ?? [],
        pagos: pagosPorVenta[venta.id] ?? [],
        nombrecliente: clientesPorId[venta.clienteId] ?? '',
        nombrevendedor: nombrevendedor, 
        gps: gps,
        nombresProductos: nombresProductosPorVenta[venta.id] ?? {},
        nombresFormasPago: nombresFormasPagoPorVenta[venta.id] ?? {}, 
        promocionesPorId: promocionesPorId,
      );
    }).toList();
  }
}

extension VentaJson on Venta {
  Map<String, dynamic> toBackendJson({
    required String? nombrecliente,
    required String nombrevendedor,
    required String gps,
    double saldo = 0,
    int estado = 1,
  }) {
    return {
      'idventa': id,
      'fechaventa': fecha.toIso8601String(),
      'valor': total,
      'observacion': '',
      'numeroRemision': 'VPP-${consecutivo.toString().padLeft(4, '0')}',
      'saldo': saldo,
      'nombrecliente': nombrecliente,
      'nombrevendedor': nombrevendedor,
      'estado': estado,
      'gps': gps,
      'idcliente': clienteId,
      'idvendedor': vendedorId,
    };
  }
}

extension VentaDetalleJson on VentaDetalle {
  Map<String, dynamic> toBackendJson({
    required String? nombreproducto,
    Promocion? promocion, 
  }) {
    
    final valoriva = IvaCalculator.calcular(
      subtotal: subtotal,
      porcentajeIva: porcentajeIva,
    );

    // Descuento: aplica solo si la promo es de tipo "Descuento"
    final valordescuento = (promocion?.promocionde == 'Descuento')
      ? subtotal * ((promocion!.porcentajesobreventa ?? 0) / 100)
      : 0.0;

    // Cantidad extra: aplica para "Encime" y "Cantidad"
    final cantidadpromocion = (promocion?.promocionde == 'Encime' || promocion?.promocionde == 'Cantidad')
      ? (promocion!.cantidadsobreventa ?? 0)
      : 0;
  
    return {
      'iddetalleventa': id,
      'cantidad': cantidad,
      'valorunidad': precioUnitario,
      'valortotal': subtotal,
      'valordescuento': valordescuento,
      'valoriva': valoriva,
      'cantidadpromocion': cantidadpromocion,
      'observacion': 'NA',
      'idproducto': productoId,
      'nombreproducto': nombreproducto,
      'idventa': ventaId,
    };
  }
}

extension VentaFormaPagoJson on VentaFormaPago {
  Map<String, dynamic> toBackendJson({
    required String? nombreformapago,
    required String fechapagoventa,
  }) {
    return {
      'iddetallefpagovta': id,
      'fechapagoventa': fechapagoventa,
      'valor': monto,
      'idformapago': formaPagoId,
      'nombreformapago': nombreformapago,
      'idventa': ventaId,
    };
  }
}