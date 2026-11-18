import 'package:flutter/material.dart';
import 'package:kolzumo_app/presentation/utils/items_ui/menu_burguer.dart';
import 'package:kolzumo_app/presentation/utils/items_ui/operational_status_bar.dart';

import '../utils/items_ui/list_customers.dart';

class CustomersScreen extends StatelessWidget {
  const CustomersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Clientes Activos'),
      ),
      drawer: const AppDrawer(currentRoute: '/customers'),
      body: const Column(
        children: [
          OperationalStatusBar(),
          Expanded(child: ListCustomers()),
        ],
      ),
    );
  }
}
