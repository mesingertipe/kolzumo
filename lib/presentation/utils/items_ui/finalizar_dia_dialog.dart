import 'package:flutter/material.dart';
import 'package:kolzumo_app/config/app_theme.dart';
import 'package:kolzumo_app/controllers/thermal_printer_controller.dart';
import 'package:kolzumo_app/infrastructure/helpers/get_location.dart';
import 'package:kolzumo_app/infrastructure/models/resumen_dia_model.dart';
import 'package:kolzumo_app/logic/auth_logic.dart';
import 'package:kolzumo_app/services/storage_service.dart';
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

  String coords = '0.0, 0.0';
  try {
    final gps = await obtenerUbicacion();
    if (gps != null && gps.latitude != null && gps.longitude != null) {
      coords = '${gps.latitude}, ${gps.longitude}';
    }
  } catch (_) {}

  final resumenDia = await resumenRepo.obtenerResumenDia(
    idvendedor: vendedor.idvendedor,
    nombrevendedor: vendedor.nombre,
    gps: coords,
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
  const FinalizarDiaDialog({
    super.key,
    required this.stats,
    required this.resumenDia,
  });

  final SellerStats stats;
  final ResumenDia resumenDia;

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<DayClosingController>();
    final printer = context.read<ThermalPrinterController>();

    return PopScope(
      canPop: !controller.isProcessing,
      child: AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        icon: Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: AppTheme.dangerColor.withValues(alpha: 0.1),
            shape: BoxShape.circle,
          ),
          child: const Icon(
            Icons.receipt_long_rounded,
            color: AppTheme.dangerColor,
            size: 34,
          ),
        ),
        title: const Text(
          '¿Estás seguro de que deseas cerrar el día?',
          textAlign: TextAlign.center,
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Esta acción finalizará todas las ventas del día actual, enviará el cargue al servidor e imprimirá el reporte de Cuadre de Caja:',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 13.5),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: AppTheme.surfaceBg,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Column(
                children: [
                  _SummaryLine(
                    label: 'No. Facturas',
                    value: '${stats.ventasRealizadas}',
                  ),
                  const SizedBox(height: 6),
                  _SummaryLine(
                    label: 'Clientes visitados',
                    value: '${stats.clientesVisitados}',
                  ),
                  const SizedBox(height: 6),
                  _SummaryLine(
                    label: 'Recaudo de contado',
                    value: '\$${stats.efectivoRecibido.toStringAsFixed(0)}',
                  ),
                  const SizedBox(height: 6),
                  _SummaryLine(
                    label: 'Referencias en inventario',
                    value: '${resumenDia.listainventario.length}',
                  ),
                ],
              ),
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
          FilledButton.icon(
            style: FilledButton.styleFrom(
              backgroundColor: AppTheme.dangerColor,
            ),
            onPressed: controller.isProcessing
                ? null
                : () async {
                    final ok = await controller.finalizarDia(resumenDia);
                    if (!context.mounted) return;

                    if (ok) {
                      // Imprime el tiraje físico y digital de RESUMEN DEL DÍA / CUADRE DE CAJA
                      await printer.printDayClosing(
                        resumen: resumenDia,
                        stats: stats,
                      );
                      await StorageService().resetear(resumenDia.idvendedor);
                      if (context.mounted) {
                        Navigator.of(context).pop(true);
                      }
                    }
                  },
            icon: controller.isProcessing
                ? const SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.white,
                    ),
                  )
                : const Icon(Icons.print_rounded, size: 18),
            label: Text(
              controller.isProcessing ? 'Cerrando día...' : 'CERRAR DÍA',
            ),
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
        Text(
          label,
          style: TextStyle(color: Colors.grey.shade700, fontSize: 13),
        ),
        Text(
          value,
          style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13.5),
        ),
      ],
    );
  }
}
