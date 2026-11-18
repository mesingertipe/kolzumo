import 'package:intl/intl.dart';

class CurrencyFormatter {
  
  static String toCOP(dynamic value) {
  
    final num number = value is String ? (num.tryParse(value) ?? 0) : (value ?? 0);

  
    final formatCurrency = NumberFormat.currency(
      locale: 'es_CO',
      symbol: '\$',
      decimalDigits: 0,
      customPattern: '¤ #,###',
    );

  
    return formatCurrency.format(number).trim();
  }
}