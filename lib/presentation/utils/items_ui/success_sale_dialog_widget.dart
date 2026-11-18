import 'package:flutter/material.dart';
import 'package:kolzumo_app/config/app_theme.dart';
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
  final VoidCallback? onVerTirilla;

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
    this.onVerTirilla,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final Color estadoColor =
        exitosa ? AppTheme.primaryColor : AppTheme.dangerColor;
    final IconData estadoIcono =
        exitosa ? Icons.task_alt_rounded : Icons.cancel_rounded;

    final String titulo = exitosa
        ? '¡Venta registrada con éxito!'
        : 'Total a pagar y Medios de pago no coinciden';

    final String descripcion = exitosa
        ? 'El comprobante ha sido generado e impreso.'
        : (motivo?.titulo ?? 'Verifica los medios de pago antes de registrar.');

    return Dialog(
      elevation: 0,
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      child: Container(
        constraints: const BoxConstraints(maxWidth: 430),
        padding: const EdgeInsets.all(22),
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(24),
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 72,
                height: 72,
                decoration: BoxDecoration(
                  color: estadoColor.withValues(alpha: .12),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  estadoIcono,
                  size: 46,
                  color: estadoColor,
                ),
              ),
              const SizedBox(height: 14),
              if (exitosa && consecutivo != null) ...[
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: AppTheme.secondColor,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    'Pedido # $consecutivo',
                    style: const TextStyle(
                      fontWeight: FontWeight.w800,
                      color: AppTheme.forestDark,
                      fontSize: 15,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
              ],
              Text(
                titulo,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 19,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.forestDark,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                descripcion,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 13.5,
                  color: Colors.grey.shade600,
                ),
              ),
              const SizedBox(height: 18),
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
                const SizedBox(height: 18),
              ],
              if (exitosa) ...[
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppTheme.surfaceBg,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    children: [
                      _row(
                        context,
                        Icons.receipt_long,
                        'Total venta',
                        CurrencyFormatter.toCOP(totalVenta),
                      ),
                      const Divider(),
                      _row(
                        context,
                        Icons.payments,
                        'Pagado hoy',
                        CurrencyFormatter.toCOP(totalPagado),
                      ),
                      if (saldoPendiente > 0) ...[
                        const Divider(),
                        _row(
                          context,
                          Icons.account_balance_wallet,
                          'Saldo a crédito',
                          CurrencyFormatter.toCOP(saldoPendiente),
                          valueColor: AppTheme.orangeBadge,
                        ),
                      ],
                      const Divider(),
                      _row(
                        context,
                        Icons.shopping_cart_checkout,
                        'Total unidades',
                        '$cantidadProductos',
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 14),
                if (pagos.isNotEmpty) ...[
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: pagos.map((pago) {
                      return Chip(
                        avatar: Icon(
                          pago.metodoPago.icono,
                          size: 16,
                          color: AppTheme.primaryColor,
                        ),
                        label: Text(
                          '${pago.metodoPago.nombreformapago}: ${CurrencyFormatter.toCOP(pago.valor)}',
                          style: const TextStyle(fontSize: 12),
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 16),
                ],
                Row(
                  children: [
                    if (onVerTirilla != null)
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: onVerTirilla,
                          icon: const Icon(Icons.receipt_outlined, size: 18),
                          label: const Text('Ver Tirilla'),
                        ),
                      ),
                    if (onVerTirilla != null && onImprimir != null)
                      const SizedBox(width: 8),
                    if (onImprimir != null)
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: onImprimir,
                          icon: const Icon(Icons.print_outlined, size: 18),
                          label: const Text('Reimprimir'),
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 10),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton.icon(
                    icon: const Icon(Icons.check_circle_outline),
                    label: const Text('Continuar en Ruta'),
                    onPressed: () {
                      Navigator.pop(context);
                      onNuevaVenta?.call();
                    },
                  ),
                ),
              ] else
                SizedBox(
                  width: double.infinity,
                  child: FilledButton.icon(
                    icon: const Icon(Icons.arrow_back),
                    label: const Text('Corregir Medios de Pago'),
                    onPressed: () => Navigator.pop(context),
                  ),
                ),
            ],
          ),
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
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(
            icon,
            size: 19,
            color: theme.colorScheme.primary,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(label, style: const TextStyle(fontSize: 13.5)),
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
