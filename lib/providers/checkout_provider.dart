import 'package:flutter/material.dart';
import 'package:kolzumo_app/infrastructure/models/cliente_model.dart';

import '../infrastructure/models/metodopago_model.dart';
import '../infrastructure/models/motivo_noventamodel.dart';
import '../infrastructure/models/pago_model.dart';
import '../infrastructure/models/tipopago_model.dart';

class CheckoutProvider extends ChangeNotifier {
  Cliente? _cliente;
  TipoPago? _tipoPago;
  MotivoNoVenta? _motivoNoVenta;
  final List<PagoVenta> _pagos = [];
  double total = 0;

  List<MetodoPago> _metodopago = [];
  MetodoPago? metodoSeleccionado;

  Cliente? get cliente => _cliente;
  List<MetodoPago> get metodopago => _metodopago;
  TipoPago? get tipoPago => _tipoPago;

  List<PagoVenta> get pagos => List.unmodifiable(_pagos);
  double get totalPagado => _pagos.fold(0, (sum, pago) => sum + pago.valor);
  double get saldoPendiente => total - totalPagado;
  bool get ventaCompletada => saldoPendiente <= 0.01;
  MotivoNoVenta? get motivoNoVenta => _motivoNoVenta;

  bool get clienteTieneCredito =>
      _cliente?.credito.toLowerCase() == 'si' || _cliente?.pagocredito == 1;

  void reset() {
    metodoSeleccionado = null;
    _tipoPago = clienteTieneCredito ? null : TipoPago.mixto;
    _pagos.clear();
    notifyListeners();
  }

  void clearTipoPago() {
    _tipoPago = clienteTieneCredito ? null : TipoPago.mixto;
  }

  void actualizarCliente(Cliente? cliente) {
    if (_cliente == cliente) return;
    _cliente = cliente;
    _pagos.clear();
    // Si el cliente no tiene crédito, se fija automáticamente pago de contado/mixto
    _tipoPago = clienteTieneCredito ? null : TipoPago.mixto;
    notifyListeners();
  }

  void loadMetodosPago(List<MetodoPago> data) {
    _metodopago = data;
    notifyListeners();
  }

  void seleccionarTipoPago(TipoPago tipo) {
    _tipoPago = tipo;
    metodoSeleccionado = null;

    if (_tipoPago == TipoPago.credito) {
      _pagos.clear();
      // Busca si en la tabla sincronizada existe la forma de pago "Crédito"
      final metodoCredito = _metodopago.cast<MetodoPago?>().firstWhere(
            (m) =>
                m != null &&
                (m.nombreformapago.toLowerCase().contains('cred') ||
                    m.nombreformapago.toLowerCase().contains('créd')),
            orElse: () => MetodoPago(
              idformapago: 0,
              nombreformapago: 'Crédito',
              mensaje: 'Pago a crédito',
            ),
          )!;

      _pagos.add(
        PagoVenta(
          metodoPago: metodoCredito,
          valor: 0,
        ),
      );
    } else {
      _pagos.clear();
    }

    notifyListeners();
  }

  void seleccionarMetodo(MetodoPago metodo) {
    metodoSeleccionado = metodo;
    notifyListeners();
  }

  /// Opciones de tipo de pago según si el cliente tiene crédito aprobado o no.
  List<TipoPago> get tiposPagoDisponibles {
    if (clienteTieneCredito) {
      return const [
        TipoPago.mixto, // No usar crédito (Pagar todo hoy)
        TipoPago.creditoparcial, // Usar crédito parcialmente
        TipoPago.credito, // Usar crédito total
      ];
    }
    return const [
      TipoPago.mixto,
    ];
  }

  void agregarPago(MetodoPago metodo, double valor) {
    final existingIdx = _pagos.indexWhere(
      (p) => p.metodoPago.idformapago == metodo.idformapago,
    );
    if (existingIdx != -1) {
      _pagos[existingIdx] = PagoVenta(
        metodoPago: metodo,
        valor: _pagos[existingIdx].valor + valor,
      );
    } else {
      _pagos.add(
        PagoVenta(
          metodoPago: metodo,
          valor: valor,
        ),
      );
    }
    notifyListeners();
  }

  void eliminarPago(PagoVenta pago) {
    _pagos.remove(pago);
    notifyListeners();
  }

  void actualizarValor(PagoVenta pagoActualizado, double valor) {
    final index = _pagos.indexWhere(
      (p) =>
          p.metodoPago.idformapago == pagoActualizado.metodoPago.idformapago,
    );

    if (index != -1) {
      _pagos[index] = PagoVenta(
        metodoPago: pagoActualizado.metodoPago,
        valor: valor,
      );
    }
    notifyListeners();
  }

  bool get puedeFinalizar {
    final effectiveTipo = _tipoPago ?? (clienteTieneCredito ? null : TipoPago.mixto);
    if (effectiveTipo == null) {
      _motivoNoVenta = MotivoNoVenta.pagoVacio;
      return false;
    }

    if (effectiveTipo != TipoPago.credito) {
      if (_pagos.isEmpty || totalPagado <= 0) {
        _motivoNoVenta = MotivoNoVenta.pagoVacio;
        return false;
      }

      if (effectiveTipo != TipoPago.creditoparcial) {
        if (!ventaCompletada) {
          _motivoNoVenta = MotivoNoVenta.pagosIncompletos;
          return false;
        }
      }
    }

    return true;
  }

  /// Calcula el cambio a devolver comparando de forma insensible a mayúsculas.
  double get cambio {
    final efectivo = _pagos
        .where((e) => e.metodoPago.nombreformapago
            .toLowerCase()
            .contains('efectivo'))
        .fold(0.0, (s, e) => s + e.valor);

    final otros = _pagos
        .where((e) => !e.metodoPago.nombreformapago
            .toLowerCase()
            .contains('efectivo'))
        .fold(0.0, (s, e) => s + e.valor);

    final restante = total - otros;

    if (efectivo > restante && restante >= 0) {
      return efectivo - restante;
    }

    return 0;
  }
}
