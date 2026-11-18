import 'package:drift/drift.dart';
import 'package:kolzumo_app/infrastructure/helpers/lista_venta_extension.dart';

import '../database.dart';
import '../tables/ventas.dart';
import '../tables/ventas_detalle.dart';
import '../tables/ventas_forma_pago.dart';

part 'ventas_dao.g.dart';

class LineaVentaInput {
  final int productoId;
  final int cantidad;
  final double precioUnitario;
  final int porcentajeIva;
  final int? promocionId;

  LineaVentaInput({
    required this.productoId,
    required this.cantidad,
    required this.precioUnitario,
    required this.porcentajeIva,
    this.promocionId,
  });

  double get subtotal => cantidad * precioUnitario;
}

class PagoVentaInput {
  final int formaPagoId;
  final double monto;

  PagoVentaInput({required this.formaPagoId, required this.monto});
}

class VentaCompleta {
  final Venta venta;
  final List<VentaDetalle> detalle;
  final List<VentaFormaPago> pagos;
  final String? nombrecliente;
  final String nombrevendedor;
  final String gps;
  final Map<int, String>? nombresProductos; 
  final Map<int, String>? nombresFormasPago;
  final Map<int, Promocion>? promocionesPorId;

  VentaCompleta({
    required this.venta, 
    required this.detalle, 
    required this.pagos,
    this.nombrecliente,
    required this.nombrevendedor,
    required this.gps,
    this.nombresProductos,
    this.nombresFormasPago,
    this.promocionesPorId,
  });

  Map<String, dynamic> toJson() {
    return {
      ...venta.toBackendJson(nombrecliente: nombrecliente, nombrevendedor: nombrevendedor, gps: gps),
      'detalleventa': detalle.map((d) => d.toBackendJson(
        nombreproducto: nombresProductos![d.productoId], 
        promocion: promocionesPorId?[d.promocionId],
      )).toList(),
      'detallepagoventa': pagos.map((p) => p.toBackendJson(nombreformapago: nombresFormasPago![p.formaPagoId], fechapagoventa: '2026-08-19')).toList(),
    };
  }
}

@DriftAccessor(tables: [Ventas, VentasDetalle, VentasFormasPago])
class VentasDao extends DatabaseAccessor<AppDatabase> with _$VentasDaoMixin {
  VentasDao(super.db);

  Future<int> registrarVenta({
    required int clienteId,
    required int vendedorId,
    required int consecutivo,
    int? rutaId,
    required List<LineaVentaInput> lineas,
    required List<PagoVentaInput> pagos,
  }) async {
    return transaction(() async {
      final total = lineas.fold<double>(0, (acc, l) => acc + l.subtotal);

      final ventaId = await into(ventas).insert(
        VentasCompanion.insert(
          consecutivo: consecutivo,
          clienteId: clienteId,
          vendedorId: vendedorId,
          rutaId: Value(rutaId),
          total: total,
          fecha: Value(DateTime.now()),
        ),
      );

      await batch((b) {
        b.insertAll(
          ventasDetalle,
          lineas.map((l) {
            return VentasDetalleCompanion.insert(
              ventaId: ventaId,
              productoId: l.productoId,
              cantidad: l.cantidad,
              precioUnitario: l.precioUnitario,
              porcentajeIva: Value(l.porcentajeIva),
              promocionId: Value(l.promocionId),
              subtotal: l.subtotal,
            );
          }).toList(),
        );

        b.insertAll(
          ventasFormasPago,
          pagos.map((p) {
            return VentasFormasPagoCompanion.insert(
              ventaId: ventaId,
              formaPagoId: p.formaPagoId,
              monto: p.monto,
            );
          }).toList(),
        );
      });

      return ventaId;
    });
  }

  // Count ventas
  Stream<int> watchVentasCount(){
    final countExp = countAll();

    final query = selectOnly(ventas)
      ..addColumns([countExp]);
    
    return query.map((row) => row.read(countExp) ?? 0).watchSingle();
  }

  /// Ventas registradas en un día específico (por defecto, hoy).
  Future<List<Venta>> ventasDelDia({DateTime? dia}) {
    final fecha = dia ?? DateTime.now();
    final inicio = DateTime(fecha.year, fecha.month, fecha.day);
    final fin = inicio.add(const Duration(days: 1));

    return (select(ventas)
          ..where((v) => v.fecha.isBetweenValues(inicio, fin))
          ..orderBy([(v) => OrderingTerm.desc(v.fecha)]))
        .get();
  }

  /// Ventas que todavía no se han enviado al backend.
  Future<List<Venta>> ventasPendientesDeSincronizar() {
    return (select(ventas)..where((v) => v.sincronizado.equals(false))).get();
  }

  /// Marca una venta como sincronizada, guardando el ID real
  /// asignado por el backend.
  Future<void> marcarComoSincronizada(int ventaLocalId, int idBackend) {
    return (update(ventas)..where((v) => v.id.equals(ventaLocalId))).write(
      VentasCompanion(
        idBackend: Value(idBackend),
        sincronizado: const Value(true),
        fechaSincronizacion: Value(DateTime.now()),
      ),
    );
  }

  Future<int?> getConsecutivoDB() async {
    final query = selectOnly(ventas)
      ..addColumns([ventas.consecutivo])
      ..orderBy([OrderingTerm.desc(ventas.consecutivo)])
      ..limit(1);
 
    final row = await query.getSingleOrNull();
    return row?.read(ventas.consecutivo);
  }
  
  /// Trae una venta completa (cabecera + detalle + pagos) para
  /// mostrarla en un recibo o pantalla de detalle.
  Future<VentaCompleta?> obtenerVentaCompleta(int ventaId) async {
    final venta =
        await (select(ventas)..where((v) => v.id.equals(ventaId)))
            .getSingleOrNull();
    if (venta == null) return null;

    final detalle = await (select(ventasDetalle)
          ..where((d) => d.ventaId.equals(ventaId)))
        .get();

    final pagos = await (select(ventasFormasPago)
          ..where((p) => p.ventaId.equals(ventaId)))
        .get();

    return VentaCompleta(
      venta: venta, 
      detalle: detalle, 
      pagos: pagos, 
      nombrevendedor: '', 
      gps: '',
    );
  }

  /// Total vendido en un rango de fechas (para reportes/resúmenes).
  Future<double> totalVendido({required DateTime desde, required DateTime hasta}) async {
    final query = selectOnly(ventas)
      ..addColumns([ventas.total.sum()])
      ..where(ventas.fecha.isBetweenValues(desde, hasta));

    final row = await query.getSingleOrNull();
    return row?.read(ventas.total.sum()) ?? 0.0;
  }

  // * Suma monto de ventas en efectivo (id = 1)
  Stream<double> watchTotalEfectivoRecibido() {
    final montoSum = ventasFormasPago.monto.sum();

    final query = selectOnly(ventasFormasPago)
      .join([

        innerJoin(ventas, ventas.id.equalsExp(ventasFormasPago.ventaId)),
      ])
      ..addColumns([montoSum])

      ..where(ventasFormasPago.formaPagoId.equals(1));
      
    return query
        .map((row) => row.read(montoSum) ?? 0.0)
        .watchSingleOrNull()
        .map((valor) => valor ?? 0.0);
  }
}