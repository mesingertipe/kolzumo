
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

class CartItemWidget extends StatelessWidget {
  final Inventario stockItem;
  final Cliente cliente;

  const CartItemWidget({
    super.key,
    required this.stockItem,
    required this.cliente,
  });

  @override
  Widget build(BuildContext context) {

    // * Providers
    final cart = context.read<CartProvider>();
    final precio = context.read<PreciosProvider>();

    // * Variables
    final quantity = context.select<CartProvider, int>(
      (cart) =>  cart.quantityOf(stockItem.idproducto),
    ); 

    // * Calcular promocion
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

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            children: [
              /// Imagen
              Container(
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
                child: Icon(Icons.local_drink_rounded, color: Theme.of(context).colorScheme.primary),
                
              ),
              
              const SizedBox(height: 5,),

              Text(
                'Stock: $stockDisponible',
                style: const TextStyle(
                  fontSize: 12,
                  color: Colors.grey,
                ),
              ),
            ],
          ),

          const SizedBox(width: 12),

          /// INFO
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
                  ),
                ),

                const SizedBox(height: 6),

                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    // Badge promoción si aplica
                    if (stockItem.promocion != null) 
                      if ((stockItem.promocion?.nombrepromocionruta != null && stockItem.promocion?.nombrepromocionruta == cliente.nombreruta) || (stockItem.promocion?.idpromocioncatcli != null && stockItem.promocion?.idpromocioncatcli == cliente.idcategoriaCliente) || (stockItem.promocion?.listaclientespromocion != null && stockItem.promocion!.listaclientespromocion.any((prom) => prom.nombrecliente == cliente.nombreestablecimiento)))
                        BadgePromocion(itemStock: stockItem, cantidadPromocion: cantidadProm),
                  ],
                ),

                Text(
                  CurrencyFormatter.toCOP(precioItem!.valor),
                  style: TextStyle(
                    color: Theme.of(context).primaryColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),

          /// CONTROLES
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              /// Contador
              ContadorWidget(
                stockItem: stockItem, 
                cart: cart, 
                quantity: quantity, 
                inCart: inCart, 
                hasQuantity: hasQuantity
              ),

              /// acciones
              Row(
                children: [
                  IconButton(
                    onPressed: hasQuantity
                        ? () => cart.remove(stockItem.idproducto)
                        : null,
                    icon: Icon(
                      Icons.delete_outline_rounded,
                      color: hasQuantity
                          ? Theme.of(context).colorScheme.error
                          : Colors.grey,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}