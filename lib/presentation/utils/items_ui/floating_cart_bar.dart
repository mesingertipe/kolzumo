import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kolzumo_app/config/app_theme.dart';
import 'package:kolzumo_app/infrastructure/formatters/currency_formatter.dart';
import 'package:kolzumo_app/providers/cart_provider.dart';

import '../../../infrastructure/models/cliente_model.dart';

/// Barra Flotante de Carrito Moderna (Floating Cart Bar)
/// Muestra dinámicamente el total acumulado, las unidades seleccionadas
/// y una microinteracción háptica al avanzar al Checkout.
class FloatingCartBar extends StatelessWidget {
  final double total;
  final CartProvider cart;
  final Cliente cliente;

  const FloatingCartBar({
    super.key,
    required this.total,
    required this.cart,
    required this.cliente,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final totalUnits = cart.items.values.fold<int>(0, (sum, qty) => sum + qty);
    final hasItems = cart.items.isNotEmpty;

    return SafeArea(
      child: Container(
        margin: const EdgeInsets.fromLTRB(14, 0, 14, 12),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: isDark ? AppTheme.darkCard : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isDark ? AppTheme.darkBorder : Colors.grey.shade300,
            width: 1.2,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: isDark ? 0.35 : 0.12),
              blurRadius: 18,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Row(
          children: [
            // Resumen de unidades y monto
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: isDark
                    ? AppTheme.darkBorder
                    : AppTheme.secondColor,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Badge(
                isLabelVisible: totalUnits > 0,
                label: Text(
                  '$totalUnits',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                child: Icon(
                  Icons.shopping_bag_rounded,
                  color: isDark ? AppTheme.accentLime : AppTheme.primaryColor,
                  size: 24,
                ),
              ),
            ),
            const SizedBox(width: 14),

            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    hasItems
                        ? '$totalUnits ${totalUnits == 1 ? "unidad" : "unidades"} en pedido'
                        : 'Carrito vacío',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: isDark ? Colors.grey.shade400 : Colors.grey.shade600,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    CurrencyFormatter.toCOP(total),
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w800,
                      color: isDark ? AppTheme.accentLime : AppTheme.forestDark,
                      letterSpacing: -0.2,
                    ),
                  ),
                ],
              ),
            ),

            // Botón de acción con Haptic Feedback
            FilledButton.icon(
              style: FilledButton.styleFrom(
                backgroundColor: hasItems
                    ? (isDark ? AppTheme.accentLime : AppTheme.primaryColor)
                    : Colors.grey.shade400,
                foregroundColor: hasItems
                    ? (isDark ? AppTheme.forestDark : Colors.white)
                    : Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              onPressed: () {
                if (hasItems) {
                  HapticFeedback.mediumImpact();
                  Navigator.of(context).pushNamed('/cart');
                } else {
                  HapticFeedback.heavyImpact();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Agrega al menos un producto al pedido'),
                      duration: Duration(seconds: 2),
                    ),
                  );
                }
              },
              icon: const Icon(Icons.arrow_forward_rounded, size: 18),
              label: const Text(
                'Cobrar',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14.5),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

