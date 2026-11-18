import 'package:flutter_test/flutter_test.dart';
import 'package:kolzumo_app/core/config/app_config.dart';
import 'package:kolzumo_app/infrastructure/models/invoice.dart';
import 'package:kolzumo_app/infrastructure/models/vendedor_model.dart';
import 'package:kolzumo_app/infrastructure/service_permissions/invoice_ticket_builder.dart';

void main() {
  test('Vendedor.parseConsecutivo extracts dynamic prefix and number', () {
    final vendedor = Vendedor(
      idvendedor: 1,
      nombre: 'Pepito Perez',
      consecutivoremision: 'PPP30002',
      idusuario: 10,
      nombreusuario: 'pepito',
      fechaultimaventa: null,
      mensaje: null,
    );

    final parsed = vendedor.parseConsecutivo();
    expect(parsed.prefix, 'PPP');
    expect(parsed.number, 30002);
    expect(parsed.padWidth, 5);
  });

  test('InvoiceTicketBuilder formats plain text receipt with AppConfig brand', () {
    final sample = Invoice.sample(sellerName: 'Pepito Perez');
    final text = InvoiceTicketBuilder().formatInvoicePlainText(sample, 'PPP30002');
    expect(text.contains('PPP30002'), isTrue);
    expect(text.contains(AppConfig.instance.brandName.toUpperCase()), isTrue);
  });
}
