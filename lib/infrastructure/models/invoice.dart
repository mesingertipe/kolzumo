import 'package:kolzumo_app/core/config/app_config.dart';
import 'package:kolzumo_app/infrastructure/models/metodopago_model.dart';
import 'package:kolzumo_app/infrastructure/models/pago_model.dart';

class InvoiceItem {
  final String productName;
  final int quantity;
  final double unitPrice;

  const InvoiceItem({
    required this.productName,
    required this.unitPrice,
    this.quantity = 1,
  });

  double get total => unitPrice * quantity;
}

class PaymentEntry {
  final String method;
  final double amount;

  const PaymentEntry({required this.method, required this.amount});
}

class InvoiceSummary {
  final double subtotal;
  final double discount;
  final double tax; // IVA
  final double totalPaid;

  const InvoiceSummary({
    required this.subtotal,
    required this.totalPaid,
    this.discount = 0,
    this.tax = 0,
  });
}

class Invoice {
  final String brandName;

  final DateTime date;
  final String storeName;
  final String customerName;
  final String customerTaxId;
  final String customerAddress;
  final String sellerName;

  final List<InvoiceItem> items;
  final InvoiceSummary summary;
  final List<PagoVenta> payments;

  final double debtToDate;

  final String footerMessage;

  Invoice({
    String? brandName,
    required this.date,
    required this.storeName,
    required this.customerName,
    required this.customerTaxId,
    required this.customerAddress,
    required this.sellerName,
    required this.items,
    required this.summary,
    this.payments = const [],
    this.debtToDate = 0,
    String? footerMessage,
  })  : brandName = (brandName != null && brandName.isNotEmpty)
            ? brandName
            : AppConfig.instance.brandName,
        footerMessage = (footerMessage != null && footerMessage.isNotEmpty)
            ? footerMessage
            : AppConfig.instance.ticketFooter;

  int get totalItems => items.fold(0, (sum, item) => sum + item.quantity);

  /// Comprobante de venta de prueba para validar la impresora térmica.
  factory Invoice.sample({String? sellerName}) {
    return Invoice(
      date: DateTime.now(),
      storeName: 'Comercializadora de Prueba',
      customerName: 'Cliente de Prueba',
      customerTaxId: '900123456-7',
      customerAddress: 'Ruta de Prueba',
      sellerName: sellerName ?? 'Vendedor KolZumo',
      items: const [
        InvoiceItem(
          productName: 'Concentrado de Limón 375 ml',
          quantity: 4,
          unitPrice: 2100,
        ),
        InvoiceItem(
          productName: 'Concentrado de Coco 375 ml',
          quantity: 2,
          unitPrice: 2000,
        ),
      ],
      summary: const InvoiceSummary(
        subtotal: 12400,
        discount: 0,
        tax: 0,
        totalPaid: 12400,
      ),
      payments: [
        PagoVenta(
          metodoPago: MetodoPago(
            idformapago: 1,
            nombreformapago: 'Efectivo',
            mensaje: null,
          ),
          valor: 12400,
        ),
      ],
      debtToDate: 0,
    );
  }
}
