import 'package:flutter/material.dart';
import 'package:kolzumo_app/config/app_theme.dart';
import 'package:kolzumo_app/infrastructure/models/inventario_model.dart';

import '../../../infrastructure/models/pedido_pendiente_model.dart';
import 'modal_inventario.dart';

class OrderItem {
  final String id;
  final String title;
  final String description;
  final IconData icon;
  final DateTime date;

  OrderItem({
    required this.id,
    required this.title,
    required this.description,
    required this.icon,
    required this.date,
  });
}

/// A reusable widget that shows a list of orders as cards with icons, shadow and
/// a small description. Use ListOrders() in your UI.
class ListOrders extends StatelessWidget {
  final List<PedidosPendientes> orders;

  const ListOrders({super.key, required this.orders});

  @override
  Widget build(BuildContext context) {
    final items = orders.isNotEmpty ? orders : [];
    final theme = Theme.of(context);

    if (items.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.inbox, size: 100, color: theme.colorScheme.onSurfaceVariant),
            const Text('No hay pedidos pendientes por aprobar'),
          ],
        )
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.all(12),
      itemCount: items.length,
      separatorBuilder: (_, _) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        PedidosPendientes order = items[index];
        return Card(
          elevation: 4,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          shadowColor: Colors.black26,
          child: ListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            leading: Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: AppTheme.secondColor,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: AppTheme.secondColor,
                    blurRadius: 6,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              child: Icon(Icons.room_service, color: theme.colorScheme.primary),
            ),
            title: Row(
              children: [
                Text('Pedido # ${index + 1}',
                  style: const TextStyle(fontWeight: FontWeight.w600)
                ),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: AppTheme.orangeBadge,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.pending_actions,
                        size: 20,
                      ),
                      const SizedBox(width: 5,),
                      Text(
                        order.nombreestado,
                        style: TextStyle(
                          color: theme.colorScheme.inverseSurface,
                          fontWeight: FontWeight.w600,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  )
                )
              ],
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 6),
                Row(
                  children: [
                    Icon(Icons.house_siding_sharp),
                    Text('Bodega: ${order.idbodega.toString()}', 
                      maxLines: 2, 
                      overflow: TextOverflow.ellipsis
                    ),
                  ]
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    Icon(Icons.calendar_month_outlined),
                    Text(
                      'Fecha pedido: ${_formatDate(order.fechapedido)}',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                )
              ],
            ),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {

              // Mostrar modal
              showDialog(context: context, builder: (_) {
                final inventarios = order.detallepedidovendedor
                  .map(Inventario.fromDetallePedido)
                  .toList();
                return ModalInventario(inventarios:inventarios, origen: 'home');
              });
            },
          ),
        );
      },
    );
  }

  static String _formatDate(DateTime d) {
    return '${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';
  }
}
