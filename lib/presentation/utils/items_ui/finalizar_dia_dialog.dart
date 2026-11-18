import 'package:flutter/material.dart';
import 'package:kolzumo_app/infrastructure/helpers/get_location.dart';
import 'package:kolzumo_app/infrastructure/models/resumen_dia_model.dart';
import 'package:kolzumo_app/logic/auth_logic.dart';
import 'package:provider/provider.dart';
import '../../../controllers/day_closing_controller.dart';
import '../../../data/repositories/resumen_dia_repo.dart';
import '../../../infrastructure/helpers/inline_error_banner.dart';
import '../../../infrastructure/models/seller_stats.dart';

Future<bool> showFinalizarDiaDialog(
  BuildContext context, {
  required SellerStats stats,
}) async {

  final vendedor = context.read<Auth>().userAccount!;
  final resumenRepo = context.read<ResumenDiaRepository>();
  final gps = await obtenerUbicacion();
 
  final resumenDia = await resumenRepo.obtenerResumenDia(
    idvendedor: vendedor.idvendedor,
    nombrevendedor: vendedor.nombre,
    gps: '${gps!.latitude}, ${gps.longitude}', 
  );
 
  if (!context.mounted) return false;

  final result = await showDialog<bool>(
    context: context,
    barrierDismissible: false,
    builder: (_) => FinalizarDiaDialog(stats: stats, resumenDia: resumenDia),
  );
  return result ?? false;
}

class FinalizarDiaDialog extends StatelessWidget {
  const FinalizarDiaDialog({super.key, required this.stats, required this.resumenDia});
  // * vars
  final SellerStats stats;
  final ResumenDia resumenDia;

  @override
  Widget build(BuildContext context) {
    // *Providers
    final controller = context.watch<DayClosingController>();

    // * vars
    final colors = Theme.of(context).colorScheme;


    return PopScope(
      canPop: !controller.isProcessing,
      child: AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        icon: Icon(Icons.event_available, color: colors.primary, size: 32),
        title: const Text('¿Finalizar el día?'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Esta acción cierra la jornada actual. Verifica el resumen '
              'antes de continuar:',
            ),
            const SizedBox(height: 16),
            _SummaryLine(label: 'Ventas realizadas', value: '${stats.ventasRealizadas}'),
            const SizedBox(height: 6),
            _SummaryLine(label: 'Clientes visitados', value: '${stats.clientesVisitados}'),
            const SizedBox(height: 6),
            _SummaryLine(
              label: 'Efectivo recibido',
              value: '\$${stats.efectivoRecibido.toStringAsFixed(0)}',
            ),
            const SizedBox(height: 6),
            _SummaryLine(
              label: 'Productos en inventario',
              value: '${resumenDia.listainventario.length}',
            ),
            if (controller.errorMessage != null) ...[
              const SizedBox(height: 16),
              InlineErrorBanner(message: controller.errorMessage),
              
            ],
          ],
        ),
        actions: [
          TextButton(
            onPressed: controller.isProcessing
                ? null
                : () => Navigator.of(context).pop(false),
            child: const Text('Cancelar'),
          ),
          FilledButton(
            onPressed: controller.isProcessing
                ? null
                : () async {
                    final ok = await controller.finalizarDia(resumenDia);
                    if (!context.mounted) return;

                    if (ok) Navigator.of(context).pop(true);
                    
                  },
            child: controller.isProcessing
                ? const SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.white,
                    ),
                  )
                : const Text('Finalizar día'),
          ),
        ],
      ),
    );
  }
}

class _SummaryLine extends StatelessWidget {
  const _SummaryLine({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: const TextStyle(color: Colors.grey, fontSize: 13)),
        Text(value, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
      ],
    );
  }
}