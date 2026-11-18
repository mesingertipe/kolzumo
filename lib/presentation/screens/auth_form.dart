import 'package:flutter/material.dart';
import 'package:kolzumo_app/config/app_theme.dart';
import 'package:kolzumo_app/core/config/app_config.dart';
import 'package:kolzumo_app/presentation/utils/items_ui/form_validation.dart';
import 'package:provider/provider.dart';

class AuthForm extends StatelessWidget {
  const AuthForm({super.key});

  @override
  Widget build(BuildContext context) {
    final config = context.watch<AppConfig>();

    return Scaffold(
      backgroundColor: AppTheme.surfaceBg,
      body: Stack(
        children: [
          // Fondo superior curvo con degradado corporativo KolZumo
          Container(
            height: 310,
            width: double.infinity,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  AppTheme.forestDark,
                  AppTheme.primaryColor,
                ],
              ),
              borderRadius: BorderRadius.vertical(
                bottom: Radius.circular(36),
              ),
            ),
          ),
          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Contenedor del Logo Oficial KolZumo
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 16,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(24),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.14),
                            blurRadius: 20,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),
                      child: Image.asset(
                        'assets/images/logo-kolzumo-1.png',
                        height: 76,
                        fit: BoxFit.contain,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      '${config.brandName} • Venta en Ruta',
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                        letterSpacing: 0.4,
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Tarjeta principal de autenticación
                    Container(
                      width: double.infinity,
                      constraints: const BoxConstraints(maxWidth: 420),
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(24),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.08),
                            blurRadius: 24,
                            offset: const Offset(0, 10),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Bienvenido de nuevo',
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.w800,
                              color: AppTheme.forestDark,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Ingresa tus credenciales de vendedor para iniciar tu jornada.',
                            style: TextStyle(
                              fontSize: 13.5,
                              color: Colors.grey.shade600,
                            ),
                          ),
                          const SizedBox(height: 22),
                          const FormValidation(),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Pie de página con versión y build reales (Cero Hardcoding)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.verified_user_outlined,
                          size: 15,
                          color: Colors.grey.shade600,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          '${config.brandName} ${config.fullVersionLabel}',
                          style: TextStyle(
                            fontSize: 12.5,
                            fontWeight: FontWeight.w600,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
