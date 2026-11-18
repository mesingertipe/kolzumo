import 'metodopago_model.dart';

class PagoVenta {
  final MetodoPago metodoPago;
  double valor;

  PagoVenta({
    required this.metodoPago,
    required this.valor,
  });

  PagoVenta copyWith({
    MetodoPago? metodoPago,
    double? valor,
  }) {
    return PagoVenta(
      metodoPago: metodoPago ?? this.metodoPago,
      valor: valor ?? this.valor,
    );
  }
}