import 'package:flutter/material.dart';
import 'package:kolzumo_app/providers/checkout_provider.dart';
import 'package:provider/provider.dart';

import '../../../infrastructure/formatters/currency_formatter.dart';
import '../../../infrastructure/models/pago_model.dart';
import '../../../infrastructure/models/tipopago_model.dart';

class PagosSeleccionadosWidget extends StatelessWidget {
  final List<PagoVenta> pagos;
  final ValueChanged<PagoVenta>? onEliminar;
  final ValueChanged<PagoVenta>? onEditar;

  const PagosSeleccionadosWidget({
    super.key,
    required this.pagos,
    this.onEliminar,
    this.onEditar,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final checkout = context.watch<CheckoutProvider>();
    final tipoPagoSel = checkout.tipoPago;

    if (pagos.isEmpty) {
      return Card(
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(
            color: theme.colorScheme.outlineVariant,
          ),
        ),
        child: const Padding(
          padding: EdgeInsets.all(24),
          child: Column(
            children: [
              Icon(
                Icons.account_balance_wallet_outlined,
                size: 48,
              ),
              SizedBox(height: 12),
              Text(
                'No se han agregado métodos de pago.',
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Pagos registrados',
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),

        const SizedBox(height: 12),

        ...pagos.map((pago) {
          return Card(
            margin: const EdgeInsets.only(bottom: 10),
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
              side: BorderSide(
                color: theme.colorScheme.outlineVariant,
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(14),
              child: Row(
                children: [

                  CircleAvatar(
                    radius: 22,
                    backgroundColor:
                        theme.colorScheme.primaryContainer,
                    child: Icon(
                      pago.metodoPago.icono,
                      color: theme.colorScheme.primary,
                    ),
                  ),

                  const SizedBox(width: 14),

                  Expanded(
                    child: Column(
                      crossAxisAlignment:
                          CrossAxisAlignment.start,
                      children: [

                        Text(
                          pago.metodoPago.nombreformapago,
                          style: theme.textTheme.titleSmall
                              ?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),

                        const SizedBox(height: 4),

                        Row(
                          children: [
                            Text(
                              'Monto:'
                            ),

                            const SizedBox(width: 5,),
                            
                            Text(
                              CurrencyFormatter.toCOP(
                                pago.valor,
                              ),
                              style: theme.textTheme.bodyLarge?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: theme.colorScheme.primary,
                              ),
                            ),
                              
                            

                            const SizedBox(width: 8),
                          ],
                        ),
                      ],
                    ),
                  ),

                  PopupMenuButton<String>(
                    onSelected: (value) {
                      switch (value) {
                        case 'editar':
                          onEditar?.call(pago);
                          break;

                        case 'eliminar':
                          onEliminar?.call(pago);
                          break;
                      }
                    },
                    
                    itemBuilder: (_) {
                      final items = <PopupMenuEntry<String>>[];

                      if (tipoPagoSel != TipoPago.completo) {
                        items.add(
                          const PopupMenuItem<String>(
                            value: 'editar',
                            child: ListTile(
                              leading: Icon(Icons.edit),
                              title: Text('Editar'),
                            ),
                          ),
                        );
                      }

                      items.add(
                        const PopupMenuItem<String>(
                          value: 'eliminar',
                          child: ListTile(
                            leading: Icon(Icons.delete),
                            title: Text('Eliminar'),
                          ),
                        ),
                      );

                      return items;
                    },
                  ),
                  
                ],
              ),
            ),
          );
        }),
      ],
    );
  }
}