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

  const Invoice({
    this.brandName = 'DistKol',
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
    this.footerMessage = 'Software DistKol',
  });

  int get totalItems => items.fold(0, (sum, item) => sum + item.quantity);

  /// Comprobante de venta de prueba.
  factory Invoice.sample() {
    return Invoice(
      date: DateTime.now(),
      storeName: 'Mercast',
      customerName: 'José Alberto Perez',
      customerTaxId: '56789321',
      customerAddress: 'Calle 8 79 40',
      sellerName: 'Pepito Perez',
      items: const [
        InvoiceItem(productName: 'Concentrado de Mango 375ML Kolzumo', quantity: 12, unitPrice: 2500),
        InvoiceItem(productName: 'Concentrado de Coco 375ML Kolzumo', quantity: 3, unitPrice: 2500),
      ],
      summary: const InvoiceSummary(
        subtotal: 37500,
        discount: 0,
        tax: 0,
        totalPaid: 37500,
      ),
      payments: [
        PagoVenta(
          metodoPago: MetodoPago(
            idformapago: 1, 
            nombreformapago: 'Efectivo', 
            mensaje: null
          ), 
          valor: 35000)
      ],
      debtToDate: 0,
    );
  }
}