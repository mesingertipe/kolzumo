import 'package:flutter/material.dart';
import 'package:kolzumo_app/presentation/utils/items_ui/finalizar_dia_dialog.dart';
import '../../../infrastructure/models/seller_stats.dart';

Future<bool> showDailySummarySheet(
  BuildContext context, {
  required SellerStats stats,
}) async {
  final result = await showModalBottomSheet<bool>(
    context: context,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (context) => DailySummarySheet(stats: stats),
  );
  return result ?? false;
}

class DailySummarySheet extends StatelessWidget {
  const DailySummarySheet({super.key, required this.stats});

  final SellerStats stats;

  Future<void> _abrirDialogYCerrarSiExito(BuildContext context) async {
    final resultado = await showFinalizarDiaDialog(context, stats: stats);

    if (!context.mounted) return;

    if (resultado) {
      Navigator.of(context).pop(true);
    }
    
  }

  @override
  Widget build(BuildContext context) {

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(24, 12, 24, 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const Text(
              'Resumen del día',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            _SummaryRow(
              icon: Icons.point_of_sale,
              label: 'Ventas realizadas',
              value: '${stats.ventasRealizadas}',
            ),
            const Divider(height: 28),
            _SummaryRow(
              icon: Icons.groups,
              label: 'Clientes visitados',
              value: '${stats.clientesVisitados}',
            ),
            const Divider(height: 28),
            _SummaryRow(
              icon: Icons.payments,
              label: 'Efectivo recibido',
              value: '\$${stats.efectivoRecibido.toStringAsFixed(0)}',
            ),
            
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: () => _abrirDialogYCerrarSiExito(context),
                icon: const Icon(Icons.event_available),
                label: const Text('Cerrar día'),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Cerrar'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SummaryRow extends StatelessWidget {
  const _SummaryRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).colorScheme.primary;
    return Row(
      children: [
        Icon(icon, color: primary),
        const SizedBox(width: 12),
        Expanded(
          child: Text(label, style: const TextStyle(fontSize: 15)),
        ),
        Text(
          value,
          style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}