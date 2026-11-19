import 'package:flutter/material.dart';
import 'package:kolzumo_app/infrastructure/formatters/currency_formatter.dart';
import 'package:kolzumo_app/infrastructure/models/cliente_model.dart';
import 'package:kolzumo_app/infrastructure/models/inventario_model.dart';
import 'package:kolzumo_app/presentation/utils/items_ui/badge_promocion.dart';
import 'package:kolzumo_app/presentation/utils/items_ui/contador_widget.dart';
import 'package:kolzumo_app/providers/precio_provider.dart';
import 'package:provider/provider.dart';

import '../../../config/app_theme.dart';
import '../../../infrastructure/helpers/promocion_helper.dart';
import '../../../providers/cart_provider.dart';

/// Tarjeta de Producto optimizada para alta velocidad de venta.
/// Incluye Chips de un solo toque (+1, +6, +24) para cargar canastillas al instante.
class CartItemWidget extends StatelessWidget {
  final Inventario stockItem;
  final Cliente cliente;

  const CartItemWidget({
    super.key,
    required this.stockItem,
    required this.cliente,
  });

  void _addQuick(BuildContext context, int increment) {
    final cart = context.read<CartProvider>();
    final currentQty = cart.quantityOf(stockItem.idproducto);
    final newQty = currentQty + increment;

    // Calcula consumo considerando promociones/bonificaciones
    int consumo = newQty;
    if (stockItem.promocion != null &&
        stockItem.promocion!.cantidadventa > 0 &&
        newQty >= stockItem.promocion!.cantidadventa) {
      consumo = PromocionHelper.calcularConsumoStock(
        stockItem.promocion,
        newQty,
      );
    }

    if (consumo <= stockItem.cantidad) {
      cart.setQuantity(stockItem.idproducto, newQty);
      if (!cart.inCart(stockItem.idproducto)) {
        cart.addItem(stockItem.idproducto);
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Stock insuficiente para agregar +$increment. Disponible: ${stockItem.cantidad}',
          ),
          backgroundColor: AppTheme.dangerColor,
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final cart = context.read<CartProvider>();
    final precio = context.read<PreciosProvider>();

    final quantity = context.select<CartProvider, int>(
      (cart) => cart.quantityOf(stockItem.idproducto),
    );

    final consumoStock = PromocionHelper.calcularConsumoStock(
      stockItem.promocion,
      quantity,
    );

    final stockDisponible = stockItem.cantidad - consumoStock;
    final cantidadProm = PromocionHelper.calcularBonificacion(stockItem.promocion, quantity);
    final hasQuantity = quantity > 0;

    final inCart = context.select<CartProvider, bool>(
      (cart) => cart.inCart(stockItem.idproducto),
    );

    final precioItem = precio.getByIds(stockItem.idproducto, cliente.idcategoriaCliente);
    final valorUnitario = precioItem?.valor ?? 0.0;

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: hasQuantity ? AppTheme.secondColor.withValues(alpha: 0.15) : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: hasQuantity
              ? AppTheme.primaryColor.withValues(alpha: 0.45)
              : Colors.grey.shade300,
          width: hasQuantity ? 1.5 : 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Icono / Miniatura
              Column(
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: AppTheme.secondColor,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.local_drink_rounded,
                      color: AppTheme.primaryColor,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: stockDisponible > 0
                          ? Colors.grey.shade100
                          : Colors.red.shade50,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      'Disp: $stockDisponible',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: stockDisponible > 0
                            ? Colors.grey.shade700
                            : AppTheme.dangerColor,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 12),

              // Información del producto
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      stockItem.nombreproducto,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14.5,
                      ),
                    ),
                    const SizedBox(height: 4),
                    if (stockItem.promocion != null)
                      BadgePromocion(
                        itemStock: stockItem,
                        cantidadPromocion: cantidadProm,
                      ),
                    Text(
                      CurrencyFormatter.toCOP(valorUnitario),
                      style: const TextStyle(
                        color: AppTheme.primaryColor,
                        fontWeight: FontWeight.w800,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),

              // Contador numérico y botón eliminar
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.grey.shade300),
                    ),
                    child: ContadorWidget(
                      stockItem: stockItem,
                      cart: cart,
                      quantity: quantity,
                      inCart: inCart,
                      hasQuantity: hasQuantity,
                    ),
                  ),
                  IconButton(
                    tooltip: 'Limpiar cantidad',
                    onPressed: hasQuantity
                        ? () => cart.remove(stockItem.idproducto)
                        : null,
                    icon: Icon(
                      Icons.delete_outline_rounded,
                      size: 20,
                      color: hasQuantity ? AppTheme.dangerColor : Colors.grey.shade400,
                    ),
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 10),
          const Divider(height: 1),
          const SizedBox(height: 8),

          // CHIPS DE CARGA RÁPIDA (+1, +6, +24 CANASTILLA)
          Row(
            children: [
              Text(
                'Carga Rápida:',
                style: TextStyle(
                  fontSize: 11.5,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey.shade600,
                ),
              ),
              const SizedBox(width: 8),
              _buildQuickChip(
                context: context,
                label: '+1',
                tooltip: 'Sumar 1 unidad',
                onTap: () => _addQuick(context, 1),
              ),
              const SizedBox(width: 6),
              _buildQuickChip(
                context: context,
                label: '+6 Pack',
                tooltip: 'Sumar six-pack (+6)',
                onTap: () => _addQuick(context, 6),
              ),
              const SizedBox(width: 6),
              _buildQuickChip(
                context: context,
                label: '+24 Canastilla',
                isHighlighted: true,
                tooltip: 'Sumar 1 canastilla completa (+24)',
                onTap: () => _addQuick(context, 24),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildQuickChip({
    required BuildContext context,
    required String label,
    required VoidCallback onTap,
    String? tooltip,
    bool isHighlighted = false,
  }) {
    return Tooltip(
      message: tooltip ?? label,
      child: InkWell(
        borderRadius: BorderRadius.circular(8),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          decoration: BoxDecoration(
            color: isHighlighted
                ? AppTheme.primaryColor
                : AppTheme.secondColor.withValues(alpha: 0.6),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: isHighlighted
                  ? AppTheme.primaryColor
                  : AppTheme.primaryColor.withValues(alpha: 0.25),
            ),
          ),
          child: Text(
            label,
            style: TextStyle(
              fontSize: 11.5,
              fontWeight: FontWeight.bold,
              color: isHighlighted ? Colors.white : AppTheme.forestDark,
            ),
          ),
        ),
      ),
    );
  }
}
