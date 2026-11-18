import 'package:flutter/material.dart';
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

    // * Providers
    UserAuth? user = context.watch<Auth>().userAccount;
    PedidosPendientesProvider pedidosProvider = context.watch<PedidosPendientesProvider>();

    // * Vars
    final String nombre, perfil;

    if (user == null) {
      nombre = 'Jhon Doe';
      perfil = 'Desconocido';
    }else{
      nombre = user.nombre;
      perfil = user.nombreperfil;
    }


    return Drawer(
      child: Column(
        children: [
          Expanded(
            child:  ListView(
              padding: EdgeInsets.zero,
              children: [
                DrawerHeader(
                  decoration: const BoxDecoration(
                    color: AppTheme.thirdColor,
                  ),
                  child: Align(
                    alignment: Alignment.bottomLeft,
                    child: ListTile(
                      titleTextStyle: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
                      leading: CircleAvatar(
                        radius: 30,
                        backgroundColor: Theme.of(context).colorScheme.secondaryContainer,
                        child: Icon(
                          Icons.person,
                          size: 40,
                          color: Colors.black,
                        ),
                      ),
                      title: Text(nombre),
                      subtitle: Text(perfil),
                    )
                  )
                ),
                ListTile(
                  leading: const Icon(Icons.pending_actions_rounded),
                  title: const Text('Pedidos Pendientes'),
                  selected: currentRoute == '/home',
                  onTap: () => _navigate(context, '/home'),
                ),
                ListTile(
                  leading: const Icon(Icons.person),
                  title: const Text('Perfil'),
                  selected: currentRoute == '/profile',
                  onTap: () => _navigate(context, '/profile'),
                ),
                if (pedidosProvider.pedidos.isEmpty)...[
                  ListTile(
                    leading: const Icon(Icons.route_rounded),
                    title: const Text('Ruta'),
                    selected: currentRoute == '/ruta',
                    onTap: () => _navigate(context, '/ruta'),
                  ),
                  ListTile(
                    leading: const Icon(Icons.people_alt_sharp),
                    title: const Text('Clientes'),
                    selected: currentRoute == '/customers',
                    onTap: () => _navigate(context, '/customers'),
                  ),
                ],
                ListTile(
                  leading: const Icon(Icons.print_rounded),
                  title: const Text('Dispositivos'),
                  selected: currentRoute == '/printers',
                  onTap: () => _navigate(context, '/printers'),
                ),
                ListTile(
                  leading: const Icon(Icons.settings),
                  title: const Text('Configuraciones'),
                  selected: currentRoute == '/settings',
                  onTap: () => _navigate(context, '/settings'),
                ),
              ],
            ),
          ),
          const Divider(height: 1),
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text('Salir'),
            onTap: () {
              _navigate(context, '/');

              Future.delayed(const Duration(milliseconds: 300), (){
                if (context.mounted) {
                  context.read<Auth>().logout();
                }
              });
            }
          ),
          const SizedBox(height: 16),
        ],
      )
    );
  }
}
