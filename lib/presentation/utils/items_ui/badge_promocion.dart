import 'package:flutter/material.dart';
import 'package:kolzumo_app/infrastructure/models/inventario_model.dart';

class BadgePromocion extends StatelessWidget {
  final Inventario itemStock;
  final int? cantidadPromocion;

  const BadgePromocion({super.key, required this.itemStock, this.cantidadPromocion = 0});

  @override
  Widget build(BuildContext context) {
  return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 6,
      ),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.deepOrange.shade400,
            Colors.orange.shade400,
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.orange.withValues(alpha: 0.3),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.local_fire_department,
            color: Colors.white,
            size: 14,
          ),
          const SizedBox(width: 4),
          Text(
            cantidadPromocion != 0 
            ? '${itemStock.promocion!.promocionde}: $cantidadPromocion' 
            : itemStock.promocion!.promocionde,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

}