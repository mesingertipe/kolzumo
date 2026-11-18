import 'package:esc_pos_utils_plus/esc_pos_utils_plus.dart';
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

    // 1. Encabezado: solo el nombre de la marca, sin más datos.
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
    bytes += generator.text('COMPROBANTE DE VENTA',
      styles: const PosStyles(
        align: PosAlign.center,
        bold: true
      ));

    bytes += generator.text('Pedido No. $consecutivo',
      styles: const PosStyles(
        align: PosAlign.center,
      ));

    bytes += generator.hr(ch: '-');

    // 2. Datos del ticket.
    bytes += generator.text('Fecha...: ${_formatDate(invoice.date)}');
    bytes += generator.text('Almacen.: ${invoice.storeName}');
    bytes += generator.text('Cliente.: ${invoice.customerName}');
    bytes += generator.text('NIT.....: ${invoice.customerTaxId}');
    bytes += generator.text('Direcc..: ${invoice.customerAddress}');
    bytes += generator.text('Vendedor: ${invoice.sellerName}');
    bytes += generator.hr(ch: '-');

    // 3. Productos: encabezado de columnas para cantidad/precio/total.
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

    // 4. Resumen de venta.
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

    // 5. Total de artículos y forma de pago.
    bytes += generator.row([
      PosColumn(text: 'Total articulos', width: 6),
      PosColumn(
        text: '${invoice.totalItems}',
        width: 6,
        styles: const PosStyles(align: PosAlign.right),
      ),
    ]);
    bytes += generator.text('Forma de pago:');
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

    // 6. Recuadro de firmas y deuda a la fecha.
    bytes += generator.feed(1);
    bytes += generator.text(_signatureBoxLine(boxWidth, filled: false));
    bytes += generator.text(_signatureBoxLine(boxWidth, filled: false));
    bytes += generator.text(_signatureBoxLine(boxWidth, filled: true));
    bytes += generator.text(
      'Firma Cliente',
      styles: const PosStyles(align: PosAlign.center),
    );
    bytes += generator.feed(1);
    bytes += generator.row([
      PosColumn(
        text: 'Deuda a la fecha',
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

    // 7. Pie de página.
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

  /// Ancho aproximado en caracteres según el tamaño de papel, usado para
  /// dibujar el recuadro de firmas.
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
        '${two(date.hour)}:${two(date.minute)}';
  }
}