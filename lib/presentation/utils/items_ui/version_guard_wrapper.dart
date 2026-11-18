import 'package:flutter/material.dart';
import 'package:kolzumo_app/config/app_theme.dart';
import 'package:kolzumo_app/core/config/app_config.dart';
import 'package:kolzumo_app/core/services/telemetry_service.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

/// Envuelve la aplicación para:
/// 1. Validar el Build actual contra Firebase Remote Config (bloqueo si requiere actualización obligatoria).
/// 2. Mostrar banner de actualización opcional si hay un build nuevo recomendado.
/// 3. Mostrar notificaciones Push (FCM) recibidas mientras la app está abierta.
class VersionGuardWrapper extends StatefulWidget {
  final Widget child;
  const VersionGuardWrapper({super.key, required this.child});

  @override
  State<VersionGuardWrapper> createState() => _VersionGuardWrapperState();
}

class _VersionGuardWrapperState extends State<VersionGuardWrapper> {
  bool _dismissedOptionalUpdate = false;

  Future<void> _openStoreUrl(String url) async {
    final uri = Uri.tryParse(url);
    if (uri != null) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    final config = context.watch<AppConfig>();
    final telemetry = context.watch<TelemetryService>();

    final pushEvent = telemetry.consumeLatestNotification();
    if (pushEvent != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: AppTheme.forestDark,
            duration: const Duration(seconds: 5),
            content: Row(
              children: [
                const Icon(Icons.notifications_active, color: AppTheme.accentLime),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        pushEvent.title,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      if (pushEvent.body.isNotEmpty)
                        Text(
                          pushEvent.body,
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.white70,
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      });
    }

    if (config.isForceUpdateRequired) {
      return Scaffold(
        backgroundColor: AppTheme.forestDark,
        body: SafeArea(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: const BoxDecoration(
                          color: AppTheme.secondColor,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.system_update_rounded,
                          size: 48,
                          color: AppTheme.primaryColor,
                        ),
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'Actualización Obligatoria',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.forestDark,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 12),
                      Text(
                        config.forceUpdateMessage,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey.shade700,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 16),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade100,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          'Tu versión: ${config.fullVersionLabel}  •  Requerida: Build ${config.minRequiredBuild}+',
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),
                      SizedBox(
                        width: double.infinity,
                        child: FilledButton.icon(
                          onPressed: () => _openStoreUrl(config.storeUrl),
                          icon: const Icon(Icons.open_in_new),
                          label: const Text('Actualizar ahora en la Tienda'),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      );
    }

    return Column(
      children: [
        if (config.isOptionalUpdateAvailable && !_dismissedOptionalUpdate)
          Material(
            color: AppTheme.orangeBadge,
            child: SafeArea(
              bottom: false,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                child: Row(
                  children: [
                    const Icon(Icons.new_releases, size: 18, color: Colors.black87),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Nueva versión disponible (Build ${config.latestRecommendedBuild}).',
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: Colors.black87,
                        ),
                      ),
                    ),
                    TextButton(
                      onPressed: () => _openStoreUrl(config.storeUrl),
                      child: const Text(
                        'Actualizar',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close, size: 16, color: Colors.black87),
                      onPressed: () =>
                          setState(() => _dismissedOptionalUpdate = true),
                    ),
                  ],
                ),
              ),
            ),
          ),
        Expanded(child: widget.child),
      ],
    );
  }
}

