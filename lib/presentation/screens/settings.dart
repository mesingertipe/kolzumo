import 'package:flutter/material.dart';
import 'package:kolzumo_app/config/app_theme.dart';
import 'package:kolzumo_app/controllers/thermal_printer_controller.dart';
import 'package:kolzumo_app/core/config/app_config.dart';
import 'package:kolzumo_app/core/services/biometric_service.dart';
import 'package:kolzumo_app/core/services/telemetry_service.dart';
import 'package:kolzumo_app/logic/auth_logic.dart';
import 'package:kolzumo_app/presentation/utils/items_ui/menu_burguer.dart';
import 'package:kolzumo_app/services/session_sync_service.dart';
import 'package:provider/provider.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _isSyncing = false;

  Future<void> _forceSync() async {
    final user = context.read<Auth>().userAccount;
    if (user == null || _isSyncing) return;

    setState(() => _isSyncing = true);
    try {
      await context.read<SessionSyncService>().syncAll(user.idvendedor);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Catálogos, clientes y precios actualizados con éxito'),
          backgroundColor: AppTheme.primaryColor,
        ),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('No se pudo sincronizar: $e'),
          backgroundColor: AppTheme.dangerColor,
        ),
      );
    } finally {
      if (mounted) setState(() => _isSyncing = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = context.watch<Auth>().userAccount;
    final bioService = context.watch<BiometricService>();
    final printer = context.watch<ThermalPrinterController>();
    final config = context.watch<AppConfig>();
    final telemetry = context.watch<TelemetryService>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Seguridad y Ajustes'),
      ),
      drawer: const AppDrawer(currentRoute: '/settings'),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // 1. Apartado de Seguridad y Biometría
          Card(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.fromLTRB(16, 8, 16, 4),
                    child: Row(
                      children: [
                        Icon(
                          Icons.security_rounded,
                          color: AppTheme.primaryColor,
                          size: 20,
                        ),
                        SizedBox(width: 8),
                        Text(
                          'SEGURIDAD Y ACCESO BIOMÉTRICO',
                          style: TextStyle(
                            fontSize: 12.5,
                            fontWeight: FontWeight.bold,
                            color: AppTheme.forestDark,
                            letterSpacing: 0.4,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SwitchListTile(
                    title: const Text(
                      'Ingreso con Huella Digital / Face ID',
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                    subtitle: Text(
                      bioService.isHardwareAvailable
                          ? (bioService.isEnabled
                              ? 'Activado para el usuario "${bioService.savedUsername}".'
                              : 'Permite iniciar sesión rápidamente usando el lector biométrico de tu teléfono.')
                          : 'Este dispositivo no tiene sensor biométrico configurado.',
                    ),
                    value: bioService.isEnabled,
                    onChanged: (!bioService.isHardwareAvailable || user == null)
                        ? null
                        : (val) async {
                            if (val) {
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
                                        ? 'Biometría activada correctamente'
                                        : 'No se completó la validación biométrica',
                                  ),
                                ),
                              );
                            } else {
                              await bioService.disableBiometrics();
                              if (!context.mounted) return;
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Biometría desactivada'),
                                ),
                              );
                            }
                          },
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // 2. Apartado de Impresión
          Card(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.fromLTRB(16, 8, 16, 4),
                    child: Row(
                      children: [
                        Icon(
                          Icons.print_rounded,
                          color: AppTheme.primaryColor,
                          size: 20,
                        ),
                        SizedBox(width: 8),
                        Text(
                          'PREFERENCIAS DE IMPRESIÓN',
                          style: TextStyle(
                            fontSize: 12.5,
                            fontWeight: FontWeight.bold,
                            color: AppTheme.forestDark,
                            letterSpacing: 0.4,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SwitchListTile(
                    title: const Text(
                      'Modo Impresora Virtual (En Pantalla)',
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                    subtitle: const Text(
                      'Muestra las tirillas de venta y cuadre de caja en pantalla si no hay impresora Bluetooth conectada.',
                    ),
                    value: printer.virtualPrinterEnabled,
                    onChanged: (v) => printer.setVirtualPrinterEnabled(v),
                  ),
                  const Divider(height: 1),
                  ListTile(
                    title: const Text(
                      'Ancho de papel térmico',
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                    subtitle: Text('Seleccionado: ${printer.paperSizeMm} mm'),
                    trailing: SegmentedButton<int>(
                      segments: const [
                        ButtonSegment(value: 58, label: Text('58 mm')),
                        ButtonSegment(value: 80, label: Text('80 mm')),
                      ],
                      selected: {printer.paperSizeMm},
                      onSelectionChanged: (s) {
                        if (s.isNotEmpty) printer.setPaperSizeMm(s.first);
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // 3. Sincronización, Servidor y Diagnóstico Firebase (Cero Hardcoding)
          Card(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.fromLTRB(16, 8, 16, 4),
                    child: Row(
                      children: [
                        Icon(
                          Icons.cloud_sync_rounded,
                          color: AppTheme.primaryColor,
                          size: 20,
                        ),
                        SizedBox(width: 8),
                        Text(
                          'SINCRONIZACIÓN, VERSIONAMIENTO Y FIREBASE',
                          style: TextStyle(
                            fontSize: 12.5,
                            fontWeight: FontWeight.bold,
                            color: AppTheme.forestDark,
                            letterSpacing: 0.4,
                          ),
                        ),
                      ],
                    ),
                  ),
                  ListTile(
                    leading: const Icon(Icons.info_outline_rounded),
                    title: const Text('Versión y Build Instalado'),
                    subtitle: Text(
                      '${config.appName} ${config.fullVersionLabel} (${config.packageName})',
                    ),
                  ),
                  const Divider(height: 1),
                  ListTile(
                    leading: const Icon(Icons.dns_outlined),
                    title: const Text('Servidor Backend Activo'),
                    subtitle: Text(
                      config.apiBaseUrl,
                      style: const TextStyle(fontSize: 12),
                    ),
                  ),
                  const Divider(height: 1),
                  ListTile(
                    leading: Icon(
                      telemetry.isInitialized
                          ? Icons.verified_rounded
                          : Icons.cloud_off_rounded,
                      color: telemetry.isInitialized
                          ? AppTheme.primaryColor
                          : Colors.grey,
                    ),
                    title: const Text(
                      'Estado Firebase (Crashlytics / Push / Remote Config)',
                    ),
                    subtitle: Text(
                      telemetry.isInitialized
                          ? 'Conectado • Build mínimo requerido: ${config.minRequiredBuild}'
                          : 'Operando en modo local resiliente',
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                    child: SizedBox(
                      width: double.infinity,
                      child: OutlinedButton.icon(
                        onPressed: _isSyncing ? null : _forceSync,
                        icon: _isSyncing
                            ? const SizedBox(
                                width: 16,
                                height: 16,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                ),
                              )
                            : const Icon(Icons.sync_rounded),
                        label: Text(
                          _isSyncing
                              ? 'Sincronizando catálogos...'
                              : 'Forzar Sincronización de Catálogos y Precios',
                        ),
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
