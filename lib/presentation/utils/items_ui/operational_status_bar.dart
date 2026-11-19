import 'package:flutter/material.dart';
import 'package:kolzumo_app/config/app_theme.dart';
import 'package:kolzumo_app/controllers/thermal_printer_controller.dart';
import 'package:kolzumo_app/core/services/auto_sync_service.dart';
import 'package:kolzumo_app/providers/ruta_provider.dart';
import 'package:kolzumo_app/providers/vehiculo_provider.dart';
import 'package:provider/provider.dart';

/// Barra superior persistente que muestra de un vistazo:
/// 1. Ruta y Vehículo activos (al tocarla abre el selector de Ruta/Vehículo).
/// 2. Estado de la Impresora (Conectada Bluetooth, Modo Virtual o Desconectada).
/// 3. Estado de Sincronización en línea / offline y cola de ventas pendientes.
class OperationalStatusBar extends StatelessWidget {
  final VoidCallback? onTapRoute;
  final VoidCallback? onTapPrinter;
  final VoidCallback? onTapSync;

  const OperationalStatusBar({
    super.key,
    this.onTapRoute,
    this.onTapPrinter,
    this.onTapSync,
  });

  @override
  Widget build(BuildContext context) {
    final rutaProv = context.watch<RutaProvider>();
    final vehiculoProv = context.watch<VehiculoProvider>();
    final printer = context.watch<ThermalPrinterController>();
    final syncService = context.watch<AutoSyncQueueService?>();

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
            ? 'Virtual'
            : 'Sin Impresora';

    final Color printerColor = printer.isConnected
        ? const Color(0xFF16A34A)
        : isVirtual
            ? AppTheme.infoBlue
            : AppTheme.dangerColor;

    // Métricas del servicio de sincronización automática
    final bool isSyncing = syncService?.isSyncing ?? false;
    final bool isOnline = syncService?.isOnline ?? false;
    final int pendingCount = syncService?.pendingCount ?? 0;

    final Color syncColor = isSyncing
        ? AppTheme.accentLime
        : (isOnline
            ? (pendingCount > 0 ? AppTheme.orangeBadge : const Color(0xFF16A34A))
            : Colors.grey.shade400);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
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
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
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
                      size: 15,
                      color: hasRoute ? AppTheme.accentLime : AppTheme.orangeBadge,
                    ),
                    const SizedBox(width: 5),
                    Expanded(
                      child: Text(
                        routeLabel,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 11.5,
                          fontWeight: FontWeight.w600,
                          color: hasRoute ? Colors.white : AppTheme.orangeBadge,
                        ),
                      ),
                    ),
                    const Icon(
                      Icons.expand_more_rounded,
                      size: 15,
                      color: Colors.white70,
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(width: 6),
          // Chip de Sincronización Automática
          InkWell(
            onTap: onTapSync ??
                () {
                  if (syncService != null && !syncService.isSyncing) {
                    syncService.checkConnectivityAndSync();
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        duration: const Duration(seconds: 2),
                        content: Text(
                          isOnline
                              ? (pendingCount > 0
                                  ? 'Sincronizando $pendingCount ventas pendientes...'
                                  : 'En línea. Todas las ventas sincronizadas.')
                              : 'Sin conexión a internet. Las ventas se enviarán solas cuando vuelva.',
                        ),
                        backgroundColor: isOnline
                            ? AppTheme.primaryColor
                            : Colors.grey.shade800,
                      ),
                    );
                  }
                },
            borderRadius: BorderRadius.circular(10),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
              decoration: BoxDecoration(
                color: syncColor.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: syncColor.withValues(alpha: 0.7)),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (isSyncing)
                    const SizedBox(
                      width: 13,
                      height: 13,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  else
                    Icon(
                      isOnline
                          ? (pendingCount > 0
                              ? Icons.cloud_upload_rounded
                              : Icons.cloud_done_rounded)
                          : Icons.cloud_off_rounded,
                      size: 15,
                      color: Colors.white,
                    ),
                  const SizedBox(width: 4),
                  Text(
                    isSyncing
                        ? 'Sync...'
                        : (pendingCount > 0
                            ? '$pendingCount pend'
                            : (isOnline ? 'Online' : 'Offline')),
                    style: const TextStyle(
                      fontSize: 11.5,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 6),
          // Chip de Impresora
          InkWell(
            onTap: onTapPrinter ??
                () => Navigator.of(context).pushNamed('/printers'),
            borderRadius: BorderRadius.circular(10),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
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
                  const SizedBox(width: 4),
                  ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 85),
                    child: Text(
                      printerLabel,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 11.5,
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

