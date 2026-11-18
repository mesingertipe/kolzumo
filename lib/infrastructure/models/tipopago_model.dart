import 'package:flutter/material.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';

enum TipoPago {
  completo,
  mixto,
  creditoparcial,
  credito,
}

extension TipoPagoExtension on TipoPago {
  String get titulo {
    switch (this) {
      case TipoPago.completo:
        return 'Pago completo';
      case TipoPago.mixto:
        return 'Pago Mixto';
      case TipoPago.credito:
        return 'A crédito';
      case TipoPago.creditoparcial:
        return 'Crédito parcial';
    }
  }

  String get descripcion {
    switch (this) {
      case TipoPago.completo:
        return 'Cancela el valor total de la compra.';
      case TipoPago.mixto:
        return 'Realiza el pago total con diferentes métodos de pago.';
      case TipoPago.credito:
        return 'Genera una venta a crédito.';
      case TipoPago.creditoparcial:
        return 'Realiza un abono y deja un saldo pendiente.';
    }
  }

  IconData get icono {
    switch (this) {
      case TipoPago.completo:
        return Icons.payments;
      case TipoPago.mixto:
        return Symbols.playing_cards;
      case TipoPago.credito:
        return Icons.credit_score;
      case TipoPago.creditoparcial:
        return Icons.account_balance_wallet;
    }
  }
}