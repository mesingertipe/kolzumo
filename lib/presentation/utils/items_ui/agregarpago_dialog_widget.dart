import 'package:flutter/material.dart';
import 'package:kolzumo_app/infrastructure/formatters/currency_formatter.dart';

import '../../../infrastructure/models/metodopago_model.dart';
import '../../../infrastructure/models/pago_model.dart';
import '../../../infrastructure/models/tipopago_model.dart';

class AgregarPagoDialog extends StatefulWidget {
  
  // * Pago agregar
  final MetodoPago metodo;
  final TipoPago? tipoPago;
  final double saldoPendiente;

  // * Pago editar
  final PagoVenta? pago;
  bool get isEditing => pago != null;

  const AgregarPagoDialog({
    super.key,
    required this.metodo,
    required this.tipoPago,
    required this.saldoPendiente,
  }) : pago = null;

  AgregarPagoDialog.editar({
    super.key,
    required this.tipoPago,
    required this.saldoPendiente,
    required this.pago,
  })  : metodo = pago!.metodoPago;

  @override
  State<AgregarPagoDialog> createState() => _AgregarPagoDialogState();
}

class _AgregarPagoDialogState extends State<AgregarPagoDialog> {
  late MetodoPago _metodoPago;
  TipoPago? _tipoPago;
  final TextEditingController _valorController = TextEditingController();


  @override
  void initState(){
    super.initState();
    _tipoPago = widget.tipoPago;
    _metodoPago = widget.metodo;

    if (widget.isEditing) {
      _valorController.text = widget.pago!.valor.toStringAsFixed(0);
    }
  }

  @override
  void dispose() {
    _valorController.dispose();
    super.dispose();
  }

  bool get _requiereValor {
    return _tipoPago == TipoPago.mixto || _tipoPago == TipoPago.creditoparcial;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AlertDialog(
      title: Row(
        children: [
          Icon(
            widget.metodo.icono,
            color: theme.colorScheme.primary,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(widget.metodo.nombreformapago),
          ),
        ],
      ),

      content: SizedBox(
        width: 420,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [

              const SizedBox(height: 20),

              if (_requiereValor)
                TextFormField(
                  controller: _valorController,
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  decoration: InputDecoration(
                    labelText: _tipoPago == TipoPago.creditoparcial
                        ? 'Abono inicial'
                        : 'Valor',
                    border: const OutlineInputBorder(),
                    prefixIcon: const Icon(Icons.attach_money),
                  ),
                ),

              if (_tipoPago == TipoPago.completo)
                Card(
                  color: theme.colorScheme.primaryContainer,
                  child: ListTile(
                    leading: const Icon(Icons.check_circle),
                    title: const Text("Pago completo"),
                    subtitle: Text(
                      "Se registrará un pago por ${CurrencyFormatter.toCOP(widget.saldoPendiente)}",
                    ),
                  ),
                ),

              if (_tipoPago == TipoPago.creditoparcial)
                const Padding(
                  padding: EdgeInsets.only(top: 12),
                  child: Text(
                    "El saldo restante quedará como cuenta por cobrar.",
                    style: TextStyle(fontSize: 13),
                  ),
                ),
            ],
          ),
        ),
      ),

      actions: [

        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text("Cancelar"),
        ),

        FilledButton(
          onPressed: () {

            if (_tipoPago == null) {
              return;
            }

            double valor;

            if (_tipoPago == TipoPago.completo) {
              valor = widget.saldoPendiente;
            } else {
              valor = double.tryParse(_valorController.text) ?? 0;
            }

            final pago = PagoVenta(
              metodoPago: widget.metodo,
              valor: valor,
            );
          
            Navigator.pop(
              context, 
              widget.isEditing
              ? widget.pago!.copyWith(metodoPago: _metodoPago,valor: valor)
              : pago
            );
          },
          child: Text(
            widget.isEditing
            ? "Editar"
            : "Agregar"
          ),
        ),
      ],
    );
  }
}