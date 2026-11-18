import 'package:flutter/material.dart';
import 'package:kolzumo_app/infrastructure/models/cliente_model.dart';

import '../infrastructure/models/metodopago_model.dart';
import '../infrastructure/models/motivo_noventamodel.dart';
import '../infrastructure/models/pago_model.dart';
import '../infrastructure/models/tipopago_model.dart';

class CheckoutProvider extends ChangeNotifier {

  // * Variables
  Cliente? _cliente;
  TipoPago? _tipoPago;
  MotivoNoVenta? _motivoNoVenta;
  final List<PagoVenta> _pagos = [];
  double total = 0;


  // * Metodo pago
  List<MetodoPago> _metodopago = [];
  MetodoPago? metodoSeleccionado;

  // * Getters
  Cliente? get cliente => _cliente;
  List<MetodoPago> get metodopago => _metodopago;
  TipoPago? get tipoPago => _tipoPago;

  // * Getters pagos
  List<PagoVenta> get pagos => List.unmodifiable(_pagos);
  double get totalPagado => _pagos.fold(0, (sum, pago) => sum + pago.valor);
  double get saldoPendiente => total - totalPagado;
  bool get ventaCompletada => saldoPendiente <= 0;
  MotivoNoVenta? get motivoNoVenta => _motivoNoVenta;

  // * Limpiar objeto
  void reset() {
    metodoSeleccionado = null;
    _tipoPago = null;
    _pagos.clear();
    notifyListeners();
  }

  void clearTipoPago(){
    _tipoPago = null;
  }

  // * Actualizar cliente
  void actualizarCliente(Cliente? cliente) {
    if (_cliente == cliente) return;

    _cliente = cliente;
    notifyListeners();
  }


  // * Carga métodos de pago
  void loadMetodosPago(List<MetodoPago> data) {
    _metodopago = data;
    notifyListeners();
  }

  // * Selección de tipo pago
  void seleccionarTipoPago(TipoPago tipo) {
    _tipoPago = tipo;
    metodoSeleccionado = null;

    if (_tipoPago == TipoPago.credito) {
      _pagos.clear();

      _pagos.add(
        PagoVenta(
          metodoPago: MetodoPago(
            idformapago: 0, 
            nombreformapago: 'Crédito', 
            mensaje: 'Pago a crédito'
          ),
          valor: 0,
        ),
      );
    }else{
      _pagos.clear();
    }

    notifyListeners();
  }
  
  // * Selección método de pago
  void seleccionarMetodo(MetodoPago metodo) {
    metodoSeleccionado = metodo;
    notifyListeners();
  }

  // * Pagos disponibles según cliente
  List<TipoPago> get tiposPagoDisponibles {

    final tipos = <TipoPago>[];

    final clientePago = cliente;

    if (clientePago?.credito == 'Si') {
      tipos.add(TipoPago.creditoparcial);
      tipos.add(TipoPago.credito);
    }

    return tipos;
  }

  // * Agregar método de pago
  void agregarPago(
    MetodoPago metodo,
    double valor,
  ) {

    _pagos.add(
      PagoVenta(
        metodoPago: metodo,
        valor: valor,
      ),
    );

    notifyListeners();
  }

  // * Eliminar método pago
  void eliminarPago(PagoVenta pago) {
    _pagos.remove(pago);
    notifyListeners();
  }

  // * Actualizar valor
  void actualizarValor(
    PagoVenta pagoActualizado,
    double valor,
  ) {

    final index = _pagos.indexWhere(
      (p) => p.metodoPago.idformapago == pagoActualizado.metodoPago.idformapago,
    );

    if (index != -1) {
      _pagos[index] = pagoActualizado;
      notifyListeners();
    }

    notifyListeners();
  }

  // * Finalización venta
  bool get puedeFinalizar {

    if(tipoPago != TipoPago.credito){

      if (_pagos.isEmpty) {
        _motivoNoVenta = MotivoNoVenta.pagoVacio;
        return false;
      }

      if (tipoPago != TipoPago.creditoparcial) {
        
        if (!ventaCompletada) {
          _motivoNoVenta = MotivoNoVenta.pagosIncompletos;
          return false;
        }
      }
    }


    return true;
  }

  // * Calcula cambio a devolver
  double get cambio {

    final efectivo = _pagos
      .where((e) => e.metodoPago.nombreformapago == 'efectivo')
      .fold(0.0, (s, e) => s + e.valor);

    final otros = _pagos
      .where((e) => e.metodoPago.nombreformapago != "efectivo")
      .fold(0.0, (s, e) => s + e.valor);

    final restante = total - otros;

    if (efectivo > restante) {
      return efectivo - restante;
    }

    return 0;
  }

}