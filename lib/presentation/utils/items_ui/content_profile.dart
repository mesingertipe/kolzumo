import 'package:flutter/material.dart';
import 'package:kolzumo_app/config/app_theme.dart';
import 'package:kolzumo_app/controllers/thermal_printer_controller.dart';
import 'package:kolzumo_app/core/config/app_config.dart';
import 'package:kolzumo_app/core/services/biometric_service.dart';
import 'package:kolzumo_app/infrastructure/models/seller_stats.dart';
import 'package:kolzumo_app/infrastructure/models/userauth.dart';
import 'package:kolzumo_app/presentation/utils/items_ui/ticket_preview_dialog.dart';
import 'package:provider/provider.dart';
import 'package:rxdart/rxdart.dart';

import '../../../controllers/day_closing_controller.dart';
import '../../../data/database/database.dart';
import '../../../logic/auth_logic.dart';
import 'daily_summary_sheet.dart';
import 'legal_policy_dialog.dart';
import 'seller_stats_card.dart';

class ContentProfile extends StatelessWidget {
  const ContentProfile({super.key});

  String _displayValue(dynamic raw, {String fallback = 'No registrado'}) {
    if (raw == null) return fallback;
    final str = raw.toString().trim();
    return str.isEmpty ? fallback : str;
  }

  @override
  Widget build(BuildContext context) {
    final database = context.read<AppDatabase>();
    final UserAuth? user = context.watch<Auth>().userAccount;
    final bioService = context.watch<BiometricService>();
    final config = context.watch<AppConfig>();

    final streamCombinado = Rx.combineLatest2(
      database.ventasDao.watchVentasCount(),
      database.ventasDao.watchTotalEfectivoRecibido(),
      (int ventas, double efectivo) {
        return SellerStats(
          ventasRealizadas: ventas,
          clientesVisitados: ventas,
          efectivoRecibido: efectivo,
        );
      },
    );

    return StreamBuilder<SellerStats>(
      stream: streamCombinado,
      builder: (context, snapshot) {
        final stats = snapshot.data ??
            const SellerStats(
              ventasRealizadas: 0,
              clientesVisitados: 0,
              efectivoRecibido: 0.0,
            );

        if (user == null) {
          return const Center(child: Text('No hay datos de usuario activos.'));
        }

        return SingleChildScrollView(
          padding: const EdgeInsets.all(18.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Tarjeta de identidad real del vendedor (Cero Hardcoding)
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [AppTheme.forestDark, AppTheme.primaryColor],
                  ),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 34,
                      backgroundColor: Colors.white.withValues(alpha: 0.2),
                      child: const Icon(
                        Icons.person_rounded,
                        size: 38,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            user.nombre,
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '${user.nombreperfil} • ID Vendedor: ${user.idvendedor}',
                            style: const TextStyle(
                              fontSize: 13,
                              color: Colors.white70,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 3,
                            ),
                            decoration: BoxDecoration(
                              color: AppTheme.accentLime.withValues(alpha: 0.25),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              user.nombreestado.isNotEmpty
                                  ? user.nombreestado
                                  : (user.estado == 1 ? 'Activo' : 'Inactivo'),
                              style: const TextStyle(
                                fontSize: 11.5,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Tarjeta de estadísticas y botón de Cierre de Día / Cuadre de Caja
              SellerStatsCard(stats: stats),
              const SizedBox(height: 12),

              SizedBox(
                width: double.infinity,
                height: 52,
                child: FilledButton.icon(
                  onPressed: () => _abrirFlujoFinalizarDia(context, stats),
                  icon: const Icon(Icons.assignment_turned_in_rounded),
                  label: const Text('Terminar Día y Generar Cuadre de Caja'),
                  style: FilledButton.styleFrom(
                    backgroundColor: AppTheme.dangerColor,
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Datos reales del vendedor registrados en el backend
              Card(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Padding(
                      padding: EdgeInsets.fromLTRB(16, 16, 16, 4),
                      child: Text(
                        'Información del Vendedor',
                        style: TextStyle(
                          fontSize: 15.5,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.forestDark,
                        ),
                      ),
                    ),
                    ListTile(
                      leading: const Icon(
                        Icons.badge_outlined,
                        color: AppTheme.primaryColor,
                      ),
                      title: const Text('Documento / Identificación'),
                      subtitle: Text(_displayValue(user.documento)),
                    ),
                    const Divider(height: 1),
                    ListTile(
                      leading: const Icon(
                        Icons.email_outlined,
                        color: AppTheme.primaryColor,
                      ),
                      title: const Text('Correo electrónico'),
                      subtitle: Text(_displayValue(user.email)),
                    ),
                    const Divider(height: 1),
                    ListTile(
                      leading: const Icon(
                        Icons.phone_outlined,
                        color: AppTheme.primaryColor,
                      ),
                      title: const Text('Teléfono'),
                      subtitle: Text(_displayValue(user.telefono)),
                    ),
                    const Divider(height: 1),
                    ListTile(
                      leading: const Icon(
                        Icons.location_on_outlined,
                        color: AppTheme.primaryColor,
                      ),
                      title: const Text('Dirección registrada'),
                      subtitle: Text(_displayValue(user.direccion)),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Tarjeta rápida de Seguridad Biométrica
              Card(
                child: Column(
                  children: [
                    SwitchListTile(
                      secondary: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: const BoxDecoration(
                          color: AppTheme.secondColor,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.fingerprint_rounded,
                          color: AppTheme.primaryColor,
                        ),
                      ),
                      title: const Text(
                        'Acceso con Biometría (Huella / Face ID)',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14.5,
                        ),
                      ),
                      subtitle: Text(
                        bioService.isHardwareAvailable
                            ? (bioService.isEnabled
                                ? 'Activo para ${bioService.savedUsername}'
                                : 'Toca para activar el inicio de sesión rápido con biometría.')
                            : 'Este dispositivo no reporta sensor biométrico disponible.',
                        style: const TextStyle(fontSize: 12.5),
                      ),
                      value: bioService.isEnabled,
                      onChanged: !bioService.isHardwareAvailable
                          ? null
                          : (enable) async {
                              if (enable) {
                                final ok = await bioService.enableBiometrics(
                                  username: user.nombre,
                                  password: user.clave,
                                );
                                if (!context.mounted) return;
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    backgroundColor: ok
                                        ? AppTheme.primaryColor
                                        : AppTheme.dangerColor,
                                    content: Text(
                                      ok
                                          ? 'Acceso biométrico activado'
                                          : 'No se pudo verificar la huella/Face ID',
                                    ),
                                  ),
                                );
                              } else {
                                await bioService.disableBiometrics();
                                if (!context.mounted) return;
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content:
                                        Text('Acceso biométrico desactivado'),
                                  ),
                                );
                              }
                            },
                    ),
                    const Divider(height: 1),
                    ListTile(
                      leading: const Icon(
                        Icons.settings_outlined,
                        color: AppTheme.primaryColor,
                      ),
                      title: const Text('Más ajustes de Seguridad e Impresión'),
                      trailing: const Icon(Icons.chevron_right_rounded),
                      onTap: () => Navigator.of(context).pushNamed('/settings'),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Tarjeta Legal y Privacidad (Requisito Google Play Store)
              Card(
                child: Column(
                  children: [
                    ListTile(
                      leading: const Icon(
                        Icons.privacy_tip_outlined,
                        color: AppTheme.primaryColor,
                      ),
                      title: const Text(
                        'Política de Privacidad',
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),
                      subtitle: const Text(
                        'Protección de datos, GPS, Bluetooth y biometría',
                        style: TextStyle(fontSize: 12),
                      ),
                      trailing: const Icon(Icons.chevron_right_rounded),
                      onTap: () => LegalPolicyHelper.openPrivacyPolicy(
                        context,
                        config.privacyPolicyUrl,
                      ),
                    ),
                    const Divider(height: 1),
                    ListTile(
                      leading: const Icon(
                        Icons.description_outlined,
                        color: AppTheme.primaryColor,
                      ),
                      title: const Text(
                        'Términos y Condiciones',
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),
                      subtitle: const Text(
                        'Condiciones de uso de la app y liquidación de ventas',
                        style: TextStyle(fontSize: 12),
                      ),
                      trailing: const Icon(Icons.chevron_right_rounded),
                      onTap: () => LegalPolicyHelper.openTermsOfService(
                        context,
                        config.termsOfServiceUrl,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Center(
                child: Text(
                  '${config.brandName} • ${config.fullVersionLabel}',
                  style: TextStyle(fontSize: 12, color: Colors.grey.shade500),
                ),
              ),
              const SizedBox(height: 12),
            ],
          ),
        );
      },
    );
  }
}

Future<void> _abrirFlujoFinalizarDia(
  BuildContext context,
  SellerStats stats,
) async {
  final printer = context.read<ThermalPrinterController>();

  // Regla de negocio: Para cerrar el día e imprimir el reporte de cierre debe
  // estar conectada la impresora o activo el Modo Impresora Virtual.
  if (!printer.canOperate) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: AppTheme.dangerColor,
        content: const Text(
          'Debe conectar la impresora (o activar Impresora Virtual) para generar el reporte de cierre de día.',
        ),
        action: SnackBarAction(
          label: 'Conectar',
          textColor: Colors.white,
          onPressed: () => Navigator.of(context).pushNamed('/printers'),
        ),
      ),
    );
    return;
  }

  final cerrado = await showDailySummarySheet(context, stats: stats);

  if (!context.mounted) return;

  if (cerrado) {
    final mensaje = context.read<DayClosingController>().mensajeBackend;
    final lastTicket = printer.lastTicketPreview;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(mensaje ?? 'Cargue resumen del vendedor OK'),
        backgroundColor: AppTheme.primaryColor,
      ),
    );

    if (lastTicket != null && lastTicket.isNotEmpty) {
      await showTicketPreviewDialog(
        context,
        ticketText: lastTicket,
        title: 'Resumen del Día / Cuadre Caja',
      );
    }
  }
}
