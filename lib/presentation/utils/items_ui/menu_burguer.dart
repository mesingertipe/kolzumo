import 'package:flutter/material.dart';
import 'package:kolzumo_app/core/config/app_config.dart';
import 'package:kolzumo_app/providers/orders_provider.dart';
import 'package:provider/provider.dart';
import '../../../config/app_theme.dart';
import '../../../infrastructure/models/userauth.dart';
import '../../../logic/auth_logic.dart';

class AppDrawer extends StatelessWidget {
  final String currentRoute;

  const AppDrawer({super.key, required this.currentRoute});

  void _navigate(BuildContext context, String route) {
    Navigator.of(context).pop();
    if (route != currentRoute) {
      Navigator.of(context).pushReplacementNamed(route);
    }
  }

  @override
  Widget build(BuildContext context) {
    final UserAuth? user = context.watch<Auth>().userAccount;
    final PedidosPendientesProvider pedidosProvider =
        context.watch<PedidosPendientesProvider>();
    final config = context.watch<AppConfig>();

    final String nombre = user?.nombre ?? 'Vendedor';
    final String perfil = user?.nombreperfil ?? 'Ruta';

    return Drawer(
      backgroundColor: Colors.white,
      child: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(20, 52, 20, 20),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [AppTheme.forestDark, AppTheme.primaryColor],
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      radius: 26,
                      backgroundColor: Colors.white.withValues(alpha: 0.2),
                      child: const Icon(
                        Icons.person_rounded,
                        size: 30,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            nombre,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            perfil,
                            style: const TextStyle(
                              fontSize: 12.5,
                              color: Colors.white70,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(vertical: 8),
              children: [
                ListTile(
                  leading: Badge(
                    isLabelVisible: pedidosProvider.pedidos.isNotEmpty,
                    label: Text('${pedidosProvider.pedidos.length}'),
                    child: const Icon(Icons.dashboard_rounded),
                  ),
                  title: const Text('Jornada y Pedidos'),
                  selected: currentRoute == '/home',
                  onTap: () => _navigate(context, '/home'),
                ),
                ListTile(
                  leading: const Icon(Icons.route_rounded),
                  title: const Text('Iniciar Día / Ruta'),
                  selected: currentRoute == '/ruta',
                  onTap: () => _navigate(context, '/ruta'),
                ),
                ListTile(
                  leading: const Icon(Icons.storefront_rounded),
                  title: const Text('Clientes Activos'),
                  selected: currentRoute == '/customers',
                  onTap: () => _navigate(context, '/customers'),
                ),
                ListTile(
                  leading: const Icon(Icons.print_rounded),
                  title: const Text('Impresora Térmica'),
                  selected: currentRoute == '/printers',
                  onTap: () => _navigate(context, '/printers'),
                ),
                ListTile(
                  leading: const Icon(Icons.person_rounded),
                  title: const Text('Mi Perfil y Cierre de Día'),
                  selected: currentRoute == '/profile',
                  onTap: () => _navigate(context, '/profile'),
                ),
                ListTile(
                  leading: const Icon(Icons.security_rounded),
                  title: const Text('Seguridad y Ajustes'),
                  selected: currentRoute == '/settings',
                  onTap: () => _navigate(context, '/settings'),
                ),
              ],
            ),
          ),
          const Divider(height: 1),
          ListTile(
            leading: const Icon(Icons.logout_rounded, color: AppTheme.dangerColor),
            title: const Text(
              'Cerrar sesión',
              style: TextStyle(
                color: AppTheme.dangerColor,
                fontWeight: FontWeight.w600,
              ),
            ),
            onTap: () {
              _navigate(context, '/');
              Future.delayed(const Duration(milliseconds: 250), () {
                if (context.mounted) {
                  context.read<Auth>().logout();
                }
              });
            },
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 16, top: 4),
            child: Text(
              '${config.brandName} ${config.fullVersionLabel}',
              style: TextStyle(fontSize: 11.5, color: Colors.grey.shade500),
            ),
          ),
        ],
      ),
    );
  }
}
