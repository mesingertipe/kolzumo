import 'package:flutter/material.dart';
import 'package:kolzumo_app/config/app_theme.dart';
import 'package:kolzumo_app/infrastructure/formatters/currency_formatter.dart';

import '../../../infrastructure/models/metodopago_model.dart';
import '../../../infrastructure/models/pago_model.dart';
import '../../../infrastructure/models/tipopago_model.dart';

class AgregarPagoDialog extends StatefulWidget {
  final MetodoPago metodo;
  final TipoPago? tipoPago;
  final double saldoPendiente;
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
  }) : metodo = pago!.metodoPago;

  @override
  State<AgregarPagoDialog> createState() => _AgregarPagoDialogState();
}

class _AgregarPagoDialogState extends State<AgregarPagoDialog> {
  late MetodoPago _metodoPago;
  TipoPago? _tipoPago;
  final TextEditingController _valorController = TextEditingController();
  String? _errorText;

  double get _maxAssignable {
    if (widget.isEditing) {
      return widget.saldoPendiente + widget.pago!.valor;
    }
    return widget.saldoPendiente > 0 ? widget.saldoPendiente : 0;
  }

  bool get _isCash =>
      _metodoPago.nombreformapago.toLowerCase().contains('efectivo');

  @override
  void initState() {
    super.initState();
    _tipoPago = widget.tipoPago ?? TipoPago.mixto;
    _metodoPago = widget.metodo;

    if (widget.isEditing) {
      _valorController.text = widget.pago!.valor.toStringAsFixed(0);
    } else if (_maxAssignable > 0 && _tipoPago != TipoPago.creditoparcial) {
      _valorController.text = _maxAssignable.toStringAsFixed(0);
    }
  }

  @override
  void dispose() {
    _valorController.dispose();
    super.dispose();
  }

  void _setAmount(double amount) {
    setState(() {
      _errorText = null;
      _valorController.text = amount.toStringAsFixed(0);
    });
  }

  void _confirm() {
    final double valor = double.tryParse(
          _valorController.text.replaceAll(RegExp(r'[^0-9.]'), ''),
        ) ??
        0;

    if (valor <= 0) {
      setState(() => _errorText = 'Ingresa un monto mayor a \$0');
      return;
    }

    // Validación de monto excedido para medios digitales (Nequi, Bancolombia, Daviplata)
    if (!_isCash && _maxAssignable > 0 && valor > _maxAssignable) {
      setState(
        () => _errorText =
            'El monto no puede superar el saldo pendiente (${CurrencyFormatter.toCOP(_maxAssignable)})',
      );
      return;
    }

    final pago = PagoVenta(
      metodoPago: _metodoPago,
      valor: valor,
    );

    Navigator.pop(
      context,
      widget.isEditing
          ? widget.pago!.copyWith(metodoPago: _metodoPago, valor: valor)
          : pago,
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AlertDialog(
      title: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: const BoxDecoration(
              color: AppTheme.secondColor,
              shape: BoxShape.circle,
            ),
            child: Icon(
              widget.metodo.icono,
              color: AppTheme.primaryColor,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.metodo.nombreformapago,
                  style: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'Faltante por pagar: ${CurrencyFormatter.toCOP(_maxAssignable)}',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey.shade600,
                    fontWeight: FontWeight.normal,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      content: SizedBox(
        width: 420,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 8),
              TextFormField(
                controller: _valorController,
                autofocus: true,
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: false,
                ),
                onChanged: (_) {
                  if (_errorText != null) setState(() => _errorText = null);
                },
                decoration: InputDecoration(
                  labelText: _tipoPago == TipoPago.creditoparcial
                      ? 'Valor a abonar hoy'
                      : 'Monto a pagar',
                  prefixIcon: const Icon(Icons.attach_money),
                  errorText: _errorText,
                ),
              ),
              const SizedBox(height: 12),
              if (_maxAssignable > 0) ...[
                Text(
                  'Accesos rápidos:',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey.shade700,
                  ),
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    ActionChip(
                      avatar: const Icon(
                        Icons.done_all_rounded,
                        size: 16,
                        color: AppTheme.primaryColor,
                      ),
                      backgroundColor: AppTheme.secondColor,
                      label: Text(
                        'Completar (${CurrencyFormatter.toCOP(_maxAssignable)})',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: AppTheme.forestDark,
                          fontSize: 12,
                        ),
                      ),
                      onPressed: () => _setAmount(_maxAssignable),
                    ),
                    if (_maxAssignable >= 10000)
                      ActionChip(
                        label: const Text('\$10.000', style: TextStyle(fontSize: 12)),
                        onPressed: () => _setAmount(10000),
                      ),
                    if (_maxAssignable >= 15000)
                      ActionChip(
                        label: const Text('\$15.000', style: TextStyle(fontSize: 12)),
                        onPressed: () => _setAmount(15000),
                      ),
                    if (_maxAssignable >= 20000)
                      ActionChip(
                        label: const Text('\$20.000', style: TextStyle(fontSize: 12)),
                        onPressed: () => _setAmount(20000),
                      ),
                  ],
                ),
              ],
              if (_tipoPago == TipoPago.creditoparcial)
                Padding(
                  padding: const EdgeInsets.only(top: 12),
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.primaryContainer
                          .withValues(alpha: 0.5),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Text(
                      'El saldo restante quedará cargado automáticamente a crédito del cliente.',
                      style: TextStyle(fontSize: 12.5),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancelar'),
        ),
        FilledButton.icon(
          onPressed: _confirm,
          icon: const Icon(Icons.check, size: 18),
          label: Text(widget.isEditing ? 'Guardar cambio' : 'Agregar pago'),
        ),
      ],
    );
  }
}
