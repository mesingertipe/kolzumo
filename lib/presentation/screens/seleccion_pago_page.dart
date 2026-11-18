import 'package:flutter/material.dart';
import 'package:kolzumo_app/infrastructure/models/metodopago_model.dart';
import 'package:kolzumo_app/infrastructure/models/pago_model.dart';
import 'package:kolzumo_app/infrastructure/models/tipopago_model.dart';
import 'package:kolzumo_app/presentation/utils/items_ui/agregarpago_dialog_widget.dart';
import 'package:kolzumo_app/presentation/utils/items_ui/button_agregar_metodo_widget.dart';
import 'package:kolzumo_app/presentation/utils/items_ui/pagos_seleccionados_widget.dart';
import 'package:kolzumo_app/presentation/utils/items_ui/tipo_pago.dart';
import 'package:kolzumo_app/providers/checkout_provider.dart';

class CheckoutPagoPage extends StatelessWidget {
  final CheckoutProvider checkout;
  final List<MetodoPago> metodos;

  const CheckoutPagoPage({
    super.key,
    required this.checkout,
    required this.metodos,
  });

  Future<void> _agregarPago(BuildContext context, MetodoPago metodo) async {
    final pago = await showDialog(
      context: context,
      builder: (_) => AgregarPagoDialog(
        metodo: metodo,
        tipoPago: checkout.cliente?.pagocredito == 0 ? TipoPago.mixto : checkout.tipoPago,
        saldoPendiente: checkout.saldoPendiente,
      ),
    );

    if (pago != null) {
      checkout.agregarPago(metodo, pago.valor);
    }
  }

  Future<void> _editarPago(BuildContext context, PagoVenta pago) async {
    final pagoEditado = await showDialog<PagoVenta>(
      context: context,
      builder: (_) => AgregarPagoDialog.editar(
        pago: pago,
        tipoPago: checkout.tipoPago,
        saldoPendiente: checkout.saldoPendiente,
      ),
    );

    if (pagoEditado != null) {
      checkout.actualizarValor(pagoEditado, pagoEditado.valor);
    }
  }

  @override
  Widget build(BuildContext context) {
    final noCredit = checkout.cliente?.pagocredito == 0;
    final mostrarMetodos = (checkout.tipoPago != TipoPago.credito && checkout.tipoPago != null) || noCredit;

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        TipoPagoSelector(
          opciones: checkout.tiposPagoDisponibles,
          seleccionado: checkout.tipoPago,
          onSelected: checkout.seleccionarTipoPago,
        ),

        const SizedBox(height: 20),

        if (mostrarMetodos) ...[
          AgregarMetodoPagoButton(
            metodos: metodos,
            onAgregar: (metodo) => _agregarPago(context, metodo),
          ),

          const SizedBox(height: 20),

          PagosSeleccionadosWidget(
            pagos: checkout.pagos,
            onEliminar: checkout.eliminarPago,
            onEditar: (pago) => _editarPago(context, pago),
          ),
        ],
      ],
    );
  }
}