import 'package:flutter/material.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';

class MetodoPago {
  final int idformapago;
  final String nombreformapago;
  final String? mensaje;

  MetodoPago({
      required this.idformapago,
      required this.nombreformapago,
      required this.mensaje,
  });

  factory MetodoPago.fromJson(Map<String, dynamic> json) => MetodoPago(
      idformapago: json["idformapago"],
      nombreformapago: json["nombreformapago"],
      mensaje: json["mensaje"],
  );

  Map<String, dynamic> toJson() => {
      "idformapago": idformapago,
      "nombreformapago": nombreformapago,
      "mensaje": mensaje,
  };

  /// Convierte un JSON String que contiene un arreglo en List MetodoPago
  static List<MetodoPago> listFromJson(List<dynamic> jsonData) {
  return jsonData
      .map((item) => MetodoPago.fromJson(item as Map<String, dynamic>))
      .toList();
  }

  /// Convierte una lista de rutas a JSON String
  static List<MetodoPago> listToJson(List<MetodoPago> jsonList) {
      return jsonList
    .map((json) => MetodoPago.fromJson(json as Map<String, dynamic>))
    .toList();
  }

  IconData get icono {
    switch (nombreformapago.toLowerCase()) {
      case 'efectivo':
        return Icons.payments;

      case 'tarjeta credito':
        return Icons.credit_card;

      case 'tarjeta débito':
        return Symbols.payment_card;

      case 'transferencia banco':
        return Icons.account_balance;

      case 'nequi':
        return Icons.phone_android;

      case 'daviplata':
        return Icons.account_balance_wallet;

      default:
        return Icons.payment;
    }
  }

  Color color(BuildContext context) {
    switch (nombreformapago.toLowerCase()) {
      case 'efectivo':
        return Colors.green;

      case 'tarjeta credito':
        return Colors.indigo;

      case 'tarjeta débito':
        return Colors.blue;

      default:
        return Theme.of(context).colorScheme.primary;
    }
  }
}
