import 'package:flutter/material.dart';
import 'package:kolzumo_app/presentation/utils/items_ui/list_orders.dart';
import 'package:kolzumo_app/presentation/utils/items_ui/menu_burguer.dart';
import 'package:provider/provider.dart';

import '../../logic/auth_logic.dart';
import '../../providers/orders_provider.dart';

class HomeApp extends StatefulWidget {
  
  const HomeApp({super.key});

  @override
  State<HomeApp> createState() => _HomeAppState();

}

class _HomeAppState extends State<HomeApp>{

  @override
  void initState(){
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_){
      final user = context.read<Auth>().userAccount;

      if (user != null) {

        context.read<PedidosPendientesProvider>().cargarPedidos(user.idvendedor);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final pedidosPendientesProv = context.watch<PedidosPendientesProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Pedidos Pendientes'),
      ),
      drawer: const AppDrawer(currentRoute: '/home'),
      body: pedidosPendientesProv.loading 
        ? const Center(child: CircularProgressIndicator())
        : Center(child: ListOrders(orders: pedidosPendientesProv.pedidos),)
    );
  }
}
