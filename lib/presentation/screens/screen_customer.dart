import 'package:flutter/material.dart';
import 'package:kolzumo_app/presentation/utils/items_ui/menu_burguer.dart';

import '../utils/items_ui/list_customers.dart';

class CustomersScreen extends StatefulWidget {
  const CustomersScreen({super.key});

  @override
  State<StatefulWidget> createState() => _CustomersWidgetState();
  
}

class _CustomersWidgetState extends State<CustomersScreen> {
  
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Clientes'),
        centerTitle: true,
      ),
      drawer: const AppDrawer(currentRoute: '/customers'),
      body: const ListCustomers(),
    );
  }

}