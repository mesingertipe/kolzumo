import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kolzumo_app/infrastructure/models/inventario_model.dart';

import '../../../infrastructure/helpers/promocion_helper.dart';
import '../../../providers/cart_provider.dart';

class ContadorWidget extends StatefulWidget {
  final Inventario stockItem;
  final CartProvider cart;
  final int quantity;
  final bool inCart;
  final bool hasQuantity;

  const ContadorWidget({
    super.key, 
    required this.stockItem,
    required this.cart,
    required this.quantity,
    required this.inCart,
    required this.hasQuantity,
  });

  @override
  State<ContadorWidget> createState() => ContadorWidgetState();
}


class ContadorWidgetState extends State<ContadorWidget> {
  late final TextEditingController _controller;
  final FocusNode _focusNode = FocusNode();
  bool _hasError = false;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.quantity.toString());
  }

  @override
  void didUpdateWidget(covariant ContadorWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Sincroniza si la cantidad cambió desde afuera (botones u otra parte)
    final quantityText = widget.quantity.toString();
    if (!_focusNode.hasFocus && _controller.text != quantityText) {
      _controller.text = quantityText;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  int _consumoParaCantidad(int nuevaCantidad) {
    int consumo = nuevaCantidad;
    if (widget.stockItem.promocion != null &&
        widget.stockItem.promocion!.cantidadventa > 0 &&
        nuevaCantidad >= widget.stockItem.promocion!.cantidadventa) {
      consumo = PromocionHelper.calcularConsumoStock(
        widget.stockItem.promocion,
        nuevaCantidad,
      );
    }
    return consumo;
  }

  void _aplicarCantidad(String value) {
    final nuevaCantidad = int.tryParse(value);

    if (nuevaCantidad == null || nuevaCantidad <= 0) {
      setState(() {
        _hasError = false;
        _controller.text = widget.quantity.toString();
      });
      return;
    }

    final consumo = _consumoParaCantidad(nuevaCantidad);

    if (consumo <= widget.stockItem.cantidad) {
      widget.cart.setQuantity(widget.stockItem.idproducto, nuevaCantidad);
      setState(() {
        _hasError = false;
        _controller.text = nuevaCantidad.toString();
      });

      // Auto-add item in Cart
      if (!widget.inCart) {
        widget.cart.addItem(widget.stockItem.idproducto);
      }

    } else {
      setState(() {
        _hasError = true;
        _controller.text = widget.quantity.toString();
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Stock insuficiente. Disponible: ${widget.stockItem.cantidad}',
          ),
          backgroundColor: Theme.of(context).colorScheme.error,
          duration: const Duration(seconds: 2),
        ),
      );

      // Quita el borde rojo después de un momento
      Future.delayed(const Duration(seconds: 2), () {
        if (mounted) setState(() => _hasError = false);
      });

    }

    _controller.selection = TextSelection.fromPosition(
      TextPosition(offset: _controller.text.length),
    );
  }

  @override
  Widget build(BuildContext context) {
    final canEdit = !widget.inCart;

    return Row(
      children: [

        SizedBox(
          width: 50,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            decoration: BoxDecoration(
              border: Border.all(
                color: _hasError ? Colors.red : Colors.transparent,
                width: 1.5,
              ),
              borderRadius: BorderRadius.circular(4),
            ),
            child: TextField(
              controller: _controller,
              focusNode: _focusNode,
              enabled: canEdit,
              textAlign: TextAlign.center,
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              style: const TextStyle(fontWeight: FontWeight.bold),
              decoration: const InputDecoration(
                isDense: true,
                contentPadding: EdgeInsets.zero,
                border: InputBorder.none,
              ),
              onSubmitted: _aplicarCantidad,
              onEditingComplete: () => _aplicarCantidad(_controller.text),
              onTapOutside: (_) {
                _focusNode.unfocus();
                _aplicarCantidad(_controller.text);
              },
            ),
          ),
        ),

        
      ],
    );
  }
}