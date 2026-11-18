import 'package:esc_pos_utils_plus/esc_pos_utils_plus.dart';
import 'package:kolzumo_app/core/config/app_config.dart';
import 'package:kolzumo_app/infrastructure/models/resumen_dia_model.dart';
import 'package:kolzumo_app/infrastructure/models/seller_stats.dart';
import '../models/invoice.dart';

class InvoiceTicketBuilder {
  Future<List<int>> build(
    Invoice invoice,
    String consecutivo, {
    PaperSize paperSize = PaperSize.mm58,
    String codeTable = 'CP1252',
  }) async {
    final profile = await CapabilityProfile.load();
    final generator = Generator(paperSize, profile);
    final boxWidth = _boxWidth(paperSize);
    var bytes = <int>[];

    // 1. Encabezado de marca
    bytes += generator.text(
      invoice.brandName,
      styles: const PosStyles(
        align: PosAlign.center,
        bold: true,
        height: PosTextSize.size2,
        width: PosTextSize.size2,
      ),
    );
    bytes += generator.hr(ch: '-');

    // Sección factura consecutivo
    bytes += generator.text(
      'COMPROBANTE DE VENTA',
      styles: const PosStyles(align: PosAlign.center, bold: true),
    );

    bytes += generator.text(
      'Pedido # $consecutivo',
      styles: const PosStyles(align: PosAlign.center, bold: true),
    );

    bytes += generator.hr(ch: '-');

    // 2. Datos del ticket
    bytes += generator.text('Fecha...: ${_formatDate(invoice.date)}');
    bytes += generator.text('Almacen.: ${invoice.storeName}');
    bytes += generator.text('Cliente.: ${invoice.customerName}');
    bytes += generator.text('NIT.....: ${invoice.customerTaxId}');
    bytes += generator.text('Direcc..: ${invoice.customerAddress}');
    bytes += generator.text('Vendedor: ${invoice.sellerName}');
    bytes += generator.hr(ch: '-');

    // 3. Productos
    bytes += generator.row([
      PosColumn(text: 'Cant', width: 3),
      PosColumn(
        text: 'Precio',
        width: 4,
        styles: const PosStyles(align: PosAlign.right),
      ),
      PosColumn(
        text: 'Total',
        width: 5,
        styles: const PosStyles(align: PosAlign.right),
      ),
    ]);

    for (final item in invoice.items) {
      bytes += generator.text(
        item.productName,
        styles: const PosStyles(bold: true),
      );
      bytes += generator.row([
        PosColumn(text: '${item.quantity}', width: 3),
        PosColumn(
          text: _formatCurrency(item.unitPrice),
          width: 4,
          styles: const PosStyles(align: PosAlign.right),
        ),
        PosColumn(
          text: _formatCurrency(item.total),
          width: 5,
          styles: const PosStyles(align: PosAlign.right),
        ),
      ]);
    }
    bytes += generator.hr(ch: '-');

    // 4. Resumen de venta
    bytes += generator.row([
      PosColumn(text: 'Subtotal', width: 6),
      PosColumn(
        text: _formatCurrency(invoice.summary.subtotal),
        width: 6,
        styles: const PosStyles(align: PosAlign.right),
      ),
    ]);
    bytes += generator.row([
      PosColumn(text: 'Descuentos', width: 6),
      PosColumn(
        text: _formatCurrency(invoice.summary.discount),
        width: 6,
        styles: const PosStyles(align: PosAlign.right),
      ),
    ]);
    bytes += generator.row([
      PosColumn(text: 'IVA', width: 6),
      PosColumn(
        text: _formatCurrency(invoice.summary.tax),
        width: 6,
        styles: const PosStyles(align: PosAlign.right),
      ),
    ]);
    bytes += generator.row([
      PosColumn(
        text: 'TOTAL PAGADO',
        width: 6,
        styles: const PosStyles(bold: true),
      ),
      PosColumn(
        text: _formatCurrency(invoice.summary.totalPaid),
        width: 6,
        styles: const PosStyles(align: PosAlign.right, bold: true),
      ),
    ]);
    bytes += generator.hr(ch: '-');

    // 5. Total de artículos y forma de pago
    bytes += generator.row([
      PosColumn(text: 'Total articulos', width: 6),
      PosColumn(
        text: '${invoice.totalItems}',
        width: 6,
        styles: const PosStyles(align: PosAlign.right),
      ),
    ]);
    bytes += generator.text('Medios de pago:');
    for (final payment in invoice.payments) {
      bytes += generator.row([
        PosColumn(text: payment.metodoPago.nombreformapago, width: 6),
        PosColumn(
          text: _formatCurrency(payment.valor),
          width: 6,
          styles: const PosStyles(align: PosAlign.right),
        ),
      ]);
    }
    bytes += generator.hr(ch: '-');

    // 6. Recuadro de firmas y saldo / deuda
    bytes += generator.feed(1);
    bytes += generator.text(_signatureBoxLine(boxWidth, filled: false));
    bytes += generator.text(_signatureBoxLine(boxWidth, filled: false));
    bytes += generator.text(_signatureBoxLine(boxWidth, filled: true));
    bytes += generator.text(
      'Firma_del_cliente',
      styles: const PosStyles(align: PosAlign.center),
    );
    bytes += generator.feed(1);
    bytes += generator.row([
      PosColumn(
        text: 'Saldo',
        width: 6,
        styles: const PosStyles(bold: true),
      ),
      PosColumn(
        text: _formatCurrency(invoice.debtToDate),
        width: 6,
        styles: const PosStyles(align: PosAlign.right, bold: true),
      ),
    ]);
    bytes += generator.hr(ch: '-');

    // 7. Pie de página
    bytes += generator.feed(1);
    for (final line in invoice.footerMessage.split('\n')) {
      bytes += generator.text(
        line.trim(),
        styles: const PosStyles(align: PosAlign.center),
      );
    }
    bytes += generator.cut();

    return bytes;
  }

  /// Genera el texto plano formateado de la tirilla de venta para el Visor de
  /// Impresora Virtual en pantalla.
  String formatInvoicePlainText(Invoice invoice, String consecutivo) {
    final sb = StringBuffer();
    sb.writeln('================================');
    sb.writeln('          ${invoice.brandName.toUpperCase()}');
    sb.writeln('      COMPROBANTE DE VENTA');
    sb.writeln('        Pedido # $consecutivo');
    sb.writeln('--------------------------------');
    sb.writeln('Fecha...: ${_formatDate(invoice.date)}');
    sb.writeln('Almacen.: ${invoice.storeName}');
    sb.writeln('Cliente.: ${invoice.customerName}');
    sb.writeln('NIT.....: ${invoice.customerTaxId}');
    sb.writeln('Direcc..: ${invoice.customerAddress}');
    sb.writeln('Vendedor: ${invoice.sellerName}');
    sb.writeln('--------------------------------');
    sb.writeln('Producto');
    sb.writeln('Cant         Precio        Total');
    sb.writeln('--------------------------------');
    for (final item in invoice.items) {
      sb.writeln(item.productName);
      final q = item.quantity.toString().padRight(8);
      final u = _formatCurrency(item.unitPrice).padLeft(10);
      final t = _formatCurrency(item.total).padLeft(12);
      sb.writeln('$q$u$t');
    }
    sb.writeln('--------------------------------');
    sb.writeln('Subtotal      : ${_formatCurrency(invoice.summary.subtotal).padLeft(14)}');
    sb.writeln('Descuentos    : ${_formatCurrency(invoice.summary.discount).padLeft(14)}');
    sb.writeln('IVA           : ${_formatCurrency(invoice.summary.tax).padLeft(14)}');
    sb.writeln('TOTAL PAGADO  : ${_formatCurrency(invoice.summary.totalPaid).padLeft(14)}');
    sb.writeln('Tot. Articulos: ${invoice.totalItems.toString().padLeft(14)}');
    sb.writeln('--------------------------------');
    sb.writeln('Medios de Pago:');
    for (final p in invoice.payments) {
      sb.writeln(
        '${p.metodoPago.nombreformapago.padRight(14)}: ${_formatCurrency(p.valor).padLeft(14)}',
      );
    }
    sb.writeln('Saldo         : ${_formatCurrency(invoice.debtToDate).padLeft(14)}');
    sb.writeln('--------------------------------');
    sb.writeln('|                              |');
    sb.writeln('|______________________________|');
    sb.writeln('       Firma_del_cliente        ');
    sb.writeln('--------------------------------');
    for (final line in invoice.footerMessage.split('\n')) {
      sb.writeln('  ${line.trim()}');
    }
    sb.writeln('================================');
    return sb.toString();
  }

  /// Construye los bytes ESC/POS para la tirilla de RESUMEN DEL DÍA / CUADRE DE CAJA
  /// como se especifica en el flujo de cierre de jornada.
  Future<List<int>> buildDayClosingTicket({
    required ResumenDia resumen,
    required SellerStats stats,
    PaperSize paperSize = PaperSize.mm58,
  }) async {
    final profile = await CapabilityProfile.load();
    final generator = Generator(paperSize, profile);
    var bytes = <int>[];

    final metrics = _calculateDayClosingMetrics(resumen, stats);

    bytes += generator.text(
      AppConfig.instance.brandName,
      styles: const PosStyles(
        align: PosAlign.center,
        bold: true,
        height: PosTextSize.size2,
        width: PosTextSize.size2,
      ),
    );
    bytes += generator.text(
      'RESUMEN DEL DIA',
      styles: const PosStyles(align: PosAlign.center, bold: true),
    );
    bytes += generator.text('fecha: ${_formatDate(DateTime.now())}');
    bytes += generator.text('vendedor: ${resumen.nombrevendedor}');
    bytes += generator.hr(ch: '-');
    bytes += generator.text(
      'CUADRE CAJA',
      styles: const PosStyles(align: PosAlign.center, bold: true),
    );
    bytes += generator.hr(ch: '-');

    bytes += generator.row([
      PosColumn(text: 'VENTAS_TOTALES :', width: 7),
      PosColumn(
        text: metrics.ventasTotales.toStringAsFixed(1),
        width: 5,
        styles: const PosStyles(align: PosAlign.right, bold: true),
      ),
    ]);
    bytes += generator.row([
      PosColumn(text: 'VENTAS_A_CREDITO :', width: 7),
      PosColumn(
        text: metrics.ventasCredito.toStringAsFixed(1),
        width: 5,
        styles: const PosStyles(align: PosAlign.right),
      ),
    ]);
    bytes += generator.row([
      PosColumn(text: 'VENTAS_DE_CONTADO :', width: 7),
      PosColumn(
        text: metrics.ventasContado.toStringAsFixed(1),
        width: 5,
        styles: const PosStyles(align: PosAlign.right),
      ),
    ]);
    bytes += generator.row([
      PosColumn(text: 'DESCUENTOS :', width: 7),
      PosColumn(
        text: '0',
        width: 5,
        styles: const PosStyles(align: PosAlign.right),
      ),
    ]);
    bytes += generator.row([
      PosColumn(text: 'CLIENTES_VISITADOS :', width: 8),
      PosColumn(
        text: '${stats.clientesVisitados}',
        width: 4,
        styles: const PosStyles(align: PosAlign.right),
      ),
    ]);
    bytes += generator.row([
      PosColumn(text: 'NO_FACTURAS :', width: 8),
      PosColumn(
        text: '${stats.ventasRealizadas}',
        width: 4,
        styles: const PosStyles(align: PosAlign.right),
      ),
    ]);
    bytes += generator.hr(ch: '-');
    bytes += generator.feed(2);
    bytes += generator.cut();
    return bytes;
  }

  /// Texto plano para visualizar en pantalla el tiraje de RESUMEN DEL DÍA / CUADRE DE CAJA.
  String formatDayClosingPlainText({
    required ResumenDia resumen,
    required SellerStats stats,
  }) {
    final metrics = _calculateDayClosingMetrics(resumen, stats);
    final sb = StringBuffer();
    sb.writeln('================================');
    sb.writeln('        RESUMEN DEL DIA');
    sb.writeln('fecha: ${_formatDate(DateTime.now())}');
    sb.writeln('vendedor: ${resumen.nombrevendedor}');
    sb.writeln('--------------------------------');
    sb.writeln('          CUADRE CAJA');
    sb.writeln('--------------------------------');
    sb.writeln('VENTAS_TOTALES     : ${metrics.ventasTotales.toStringAsFixed(1).padLeft(10)}');
    sb.writeln('VENTAS_A_CREDITO   : ${metrics.ventasCredito.toStringAsFixed(1).padLeft(10)}');
    sb.writeln('VENTAS_DE_CONTADO  : ${metrics.ventasContado.toStringAsFixed(1).padLeft(10)}');
    sb.writeln('DESCUENTOS         : ${"0".padLeft(10)}');
    sb.writeln('CLIENTES_VISITADOS : ${stats.clientesVisitados.toString().padLeft(10)}');
    sb.writeln('NO_FACTURAS        : ${stats.ventasRealizadas.toString().padLeft(10)}');
    sb.writeln('================================');
    return sb.toString();
  }

  ({double ventasTotales, double ventasCredito, double ventasContado})
      _calculateDayClosingMetrics(ResumenDia resumen, SellerStats stats) {
    double totalProductos = 0;
    double totalPagosContado = 0;
    double totalPagosCredito = 0;

    for (final v in resumen.listaventas) {
      totalProductos += v.venta.total;
      for (final fp in v.pagos) {
        final nombre =
            (v.nombresFormasPago?[fp.formaPagoId] ?? '').toLowerCase();
        if (fp.formaPagoId == 0 ||
            nombre.contains('cred') ||
            nombre.contains('créd')) {
          totalPagosCredito += fp.monto;
        } else {
          totalPagosContado += fp.monto;
        }
      }
    }

    if (totalProductos == 0 && stats.efectivoRecibido > 0) {
      totalProductos = stats.efectivoRecibido;
      totalPagosContado = stats.efectivoRecibido;
    }

    final double saldoCredito =
        (totalProductos - totalPagosContado) > totalPagosCredito
            ? (totalProductos - totalPagosContado)
            : totalPagosCredito;

    return (
      ventasTotales: totalProductos,
      ventasCredito: saldoCredito < 0 ? 0 : saldoCredito,
      ventasContado: totalPagosContado,
    );
  }

  int _boxWidth(PaperSize paperSize) {
    return paperSize == PaperSize.mm80 ? 46 : 30;
  }

  String _signatureBoxLine(int width, {required bool filled}) {
    final inner = width - 2;
    final middle = filled ? '_' * inner : ' ' * inner;
    return '|$middle|';
  }

  String _formatCurrency(double value) {
    return '\$${value.toStringAsFixed(0)}';
  }

  String _formatDate(DateTime date) {
    String two(int n) => n.toString().padLeft(2, '0');
    return '${two(date.day)}/${two(date.month)}/${date.year} '
        '${two(date.hour)}:${two(date.minute)}:${two(date.second)}';
  }
}
