import 'package:flutter/material.dart';
import 'package:kolzumo_app/config/app_theme.dart';
import 'package:kolzumo_app/controllers/thermal_printer_controller.dart';
import 'package:kolzumo_app/providers/ruta_provider.dart';
import 'package:kolzumo_app/providers/vehiculo_provider.dart';
import 'package:provider/provider.dart';

/// Barra superior persistente que muestra de un vistazo:
/// 1. Ruta y Vehículo activos (al tocarla abre el selector de Ruta/Vehículo).
/// 2. Estado de la Impresora (Conectada Bluetooth, Modo Virtual o Desconectada).
class OperationalStatusBar extends StatelessWidget {
  final VoidCallback? onTapRoute;
  final VoidCallback? onTapPrinter;

  const OperationalStatusBar({
    super.key,
    this.onTapRoute,
    this.onTapPrinter,
  });

  @override
  Widget build(BuildContext context) {
    final rutaProv = context.watch<RutaProvider>();
    final vehiculoProv = context.watch<VehiculoProvider>();
    final printer = context.watch<ThermalPrinterController>();

    final rutaName = rutaProv.rutaSeleccionada?.nombreruta;
    final placa = vehiculoProv.vehiculoSeleccionado?.placa;
    final hasRoute = rutaName != null && rutaName.isNotEmpty;

    final String routeLabel = hasRoute
        ? (placa != null && placa.isNotEmpty ? '$rutaName • $placa' : rutaName)
        : 'Elegir Ruta / Vehículo';

    final bool printerReady = printer.canOperate;
    final bool isVirtual = printer.virtualPrinterEnabled && !printer.isConnected;
    final String printerLabel = printer.isConnected
        ? (printer.selectedDevice?.name ?? 'Impresora OK')
        : isVirtual
            ? 'Impresora Virtual'
            : 'Sin Impresora';

    final Color printerColor = printer.isConnected
        ? const Color(0xFF16A34A)
        : isVirtual
            ? AppTheme.infoBlue
            : AppTheme.dangerColor;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: const BoxDecoration(
        color: AppTheme.forestDark,
        border: Border(
          bottom: BorderSide(color: Colors.white12, width: 1),
        ),
      ),
      child: Row(
        children: [
          // Chip de Ruta y Vehículo
          Expanded(
            child: InkWell(
              onTap: onTapRoute ??
                  () => Navigator.of(context).pushNamed('/ruta'),
              borderRadius: BorderRadius.circular(10),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
                decoration: BoxDecoration(
                  color: hasRoute
                      ? Colors.white.withValues(alpha: 0.12)
                      : AppTheme.orangeBadge.withValues(alpha: 0.22),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: hasRoute
                        ? Colors.white24
                        : AppTheme.orangeBadge.withValues(alpha: 0.7),
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.local_shipping_rounded,
                      size: 16,
                      color: hasRoute ? AppTheme.accentLime : AppTheme.orangeBadge,
                    ),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        routeLabel,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: hasRoute ? Colors.white : AppTheme.orangeBadge,
                        ),
                      ),
                    ),
                    const Icon(
                      Icons.expand_more_rounded,
                      size: 16,
                      color: Colors.white70,
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
          // Chip de Impresora
          InkWell(
            onTap: onTapPrinter ??
                () => Navigator.of(context).pushNamed('/printers'),
            borderRadius: BorderRadius.circular(10),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
              decoration: BoxDecoration(
                color: printerColor.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: printerColor.withValues(alpha: 0.7)),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    printerReady
                        ? (isVirtual
                            ? Icons.receipt_long_rounded
                            : Icons.print_rounded)
                        : Icons.print_disabled_rounded,
                    size: 15,
                    color: Colors.white,
                  ),
                  const SizedBox(width: 6),
                  ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 115),
                    child: Text(
                      printerLabel,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

