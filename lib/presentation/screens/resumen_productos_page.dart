import 'package:flutter/material.dart';
import 'package:kolzumo_app/infrastructure/models/cliente_model.dart';
import 'package:kolzumo_app/infrastructure/models/promocion_model.dart';
import 'package:kolzumo_app/providers/inventario_provider.dart';
import 'package:kolzumo_app/providers/precio_provider.dart';

import '../utils/items_ui/checkout_products.dart';
import '../utils/items_ui/checkout_promociones.dart';

class CheckoutResumenPage extends StatelessWidget {
  
  final List<MapEntry<int, int>> items;
  final InventarioProvider inventario;
  final PreciosProvider precio;
  final Cliente cliente;
  final List<Promocion> promociones;
  final bool mostrarPromociones;

  const CheckoutResumenPage({
    super.key,
    required this.items,
    required this.inventario,
    required this.precio,
    required this.cliente,
    required this.promociones,
    required this.mostrarPromociones,
  });

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        CheckoutProducts(
          items: items,
          inventario: inventario,
          precio: precio,
          cliente: cliente,
        ),
        const SizedBox(height: 20),
        if (mostrarPromociones) CheckoutPromotions(promociones: promociones),
      ],
    );
  }
}