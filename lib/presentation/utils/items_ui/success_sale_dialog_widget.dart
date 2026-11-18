import 'package:flutter/material.dart';
import 'package:kolzumo_app/infrastructure/models/motivo_noventamodel.dart';

import '../../../infrastructure/formatters/currency_formatter.dart';
import '../../../infrastructure/models/pago_model.dart';

class VentaFinalizadaDialog extends StatelessWidget {
  final bool exitosa;
  final MotivoNoVenta? motivo;

  final String? consecutivo;
  final double totalVenta;
  final double totalPagado;
  final double saldoPendiente;
  final int cantidadProductos;
  final List<PagoVenta> pagos;

  final VoidCallback? onNuevaVenta;
  final VoidCallback? onImprimir;

  const VentaFinalizadaDialog({
    super.key,
    required this.exitosa,
    this.motivo,
    this.consecutivo,
    required this.totalVenta,
    required this.totalPagado,
    required this.saldoPendiente,
    required this.cantidadProductos,
    required this.pagos,
    this.onNuevaVenta,
    this.onImprimir,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final Color estadoColor = exitosa ? Colors.green : Colors.red;

    final IconData estadoIcono = exitosa
      ? Icons.task_alt_rounded
      : Icons.cancel_rounded;

    final String titulo = exitosa
      ? '¡Venta realizada!'
      : 'No fue posible finalizar la venta';

    final String descripcion = exitosa
      ? 'La venta fue registrada exitosamente.'
      : (motivo?.titulo ?? 'Ocurrió un problema al finalizar la venta.');

    return Dialog(
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: Container(
        constraints: const BoxConstraints(maxWidth: 430),
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(28),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [

            /// Icono principal
            Container(
              width: 90,
              height: 90,
              decoration: BoxDecoration(
                color: estadoColor.withValues(alpha: .12),
                shape: BoxShape.circle,
              ),
              child: Icon(
                estadoIcono,
                size: 60,
                color: estadoColor,
              ),
            ),

            const SizedBox(height: 18),

            if(exitosa)...[
              Text(
                consecutivo!,
                textAlign: TextAlign.center,
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],

            Text(
              titulo,
              textAlign: TextAlign.center,
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 6),

            if(!exitosa)
              Text(
                descripcion,
                textAlign: TextAlign.center,
                style: theme.textTheme.bodyMedium,
              ),

            if(exitosa) ...[

              Text(
                descripcion,
                textAlign: TextAlign.center,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),

              const SizedBox(height: 24),
            ],

            // Motivo no venta
            if (!exitosa && motivo != null) ...[

              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: theme.colorScheme.errorContainer,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    Icon(
                      Icons.info_outline,
                      color: theme.colorScheme.onErrorContainer,
                    ),

                    const SizedBox(width: 10),

                    Expanded(
                      child: Text(
                        motivo!.detalle,
                        style: TextStyle(
                          color: theme.colorScheme.onErrorContainer,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],

            /// Resumen
            if(exitosa) ...[

              Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: theme.colorScheme.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Column(
                  children: [

                    _row(
                      context,
                      Icons.receipt_long,
                      "Total venta",
                      CurrencyFormatter.toCOP(totalVenta),
                    ),

                    const Divider(),

                    _row(
                      context,
                      Icons.payments,
                      "Total pagado",
                      CurrencyFormatter.toCOP(totalPagado),
                    ),

                    if (saldoPendiente > 0) ...[
                      const Divider(),
                      _row(
                        context,
                        Icons.account_balance_wallet,
                        "Saldo pendiente",
                        CurrencyFormatter.toCOP(saldoPendiente),
                        valueColor: Colors.orange,
                      ),
                    ],

                    const Divider(),

                    _row(
                      context,
                      Icons.shopping_cart_checkout,
                      "Productos",
                      "$cantidadProductos",
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Métodos de pago",
                  style: theme.textTheme.titleMedium,
                ),
              ),

              const SizedBox(height: 10),

              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: pagos.map((pago) {
                  return Chip(
                    avatar: Icon(
                      pago.metodoPago.icono,
                      size: 18,
                    ),
                    label: Text(
                      pago.metodoPago.nombreformapago,
                    ),
                  );
                }).toList(),
              ),

              const SizedBox(height: 28),
            ],

            // Botones
            if(exitosa)
              Row(
                children: [
                  
                  Expanded(
                    child: FilledButton.icon(
                      icon: const Icon(Icons.add_shopping_cart),
                      label: const Text("Nueva"),
                      onPressed: () {
                        // TODO: Nueva venta
                        Navigator.pop(context);

                        onNuevaVenta?.call();
                      },
                    ),
                  ),
                ],
              )
              else
                SizedBox(
                  width: double.infinity,
                  child: FilledButton.icon(
                    icon: const Icon(Icons.arrow_back),
                    label: const Text("Volver"),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                ),
          ],
        ),
      ),
    );
  }

  Widget _row(
    BuildContext context,
    IconData icon,
    String label,
    String value, {
    Color? valueColor,
  }) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [

          Icon(
            icon,
            size: 20,
            color: theme.colorScheme.primary,
          ),

          const SizedBox(width: 10),

          Expanded(
            child: Text(label),
          ),

          Text(
            value,
            style: theme.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: valueColor,
            ),
          ),
        ],
      ),
    );
  }
}