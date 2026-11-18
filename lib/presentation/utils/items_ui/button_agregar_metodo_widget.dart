import 'package:flutter/material.dart';
import 'package:kolzumo_app/presentation/utils/items_ui/metodopago_selector_widget.dart';

import '../../../infrastructure/models/metodopago_model.dart';

class AgregarMetodoPagoButton extends StatelessWidget {
  final List<MetodoPago> metodos;
  final ValueChanged<MetodoPago> onAgregar;

  const AgregarMetodoPagoButton({
    super.key,
    required this.metodos,
    required this.onAgregar,
  });

  Future<void> _abrirModal(BuildContext context) async {
    final metodo = await showModalBottomSheet<MetodoPago>(
      context: context,
      isScrollControlled: true, // permite que el modal crezca y respete el teclado/notch
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        // DraggableScrollableSheet para que, si la lista de métodos crece,
        // el modal sea deslizable en vez de desbordar la pantalla.
        return DraggableScrollableSheet(
          expand: false,
          initialChildSize: 0.6,
          minChildSize: 0.3,
          maxChildSize: 0.9,
          builder: (context, scrollController) {
            return MetodoPagoSelector(
              metodos: metodos,
              scrollController: scrollController,
            );
          },
        );
      },
    );

    if (metodo != null) {
      onAgregar(metodo);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return OutlinedButton.icon(
      onPressed: metodos.isEmpty ? null : () => _abrirModal(context),
      icon: const Icon(Icons.add),
      label: const Text('Agregar método de pago'),
      style: OutlinedButton.styleFrom(
        minimumSize: const Size.fromHeight(48), // 48dp: objetivo táctil accesible
        foregroundColor: theme.colorScheme.primary,
        side: BorderSide(color: theme.colorScheme.outlineVariant),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
        ),
      ),
    );
  }
}