import 'package:flutter/material.dart';
import 'package:kolzumo_app/config/app_theme.dart';

import '../../../infrastructure/models/inventario_model.dart';

class ListviewInventario extends StatelessWidget {

  final int index;
  final Inventario item;

  const ListviewInventario({
    super.key,
    required this.index,
    required this.item,
  });
  
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 6,
      ),
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.all(12),

        leading: CircleAvatar(
          backgroundColor: Theme.of(context).colorScheme.secondaryContainer,
          radius: 22,
          child: Text(
            '${index + 1}',
            style: const TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
        ),

        title: Text(
          item.nombreproducto,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),

        subtitle: Padding(
          padding: const EdgeInsets.only(top: 4),
          child: Row(
            children: [
              const SizedBox(width: 4),
              Chip(
                color: WidgetStateProperty.all(AppTheme.secondColor),
                avatar: const Icon(
                  Icons.inventory_2_outlined,
                  size: 16,
                ),
                label: Text('Cantidad: ${item.cantidad}'),
              )
            ],
          ),
        ),
      ),
    );
  }
}