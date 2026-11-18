import 'package:flutter/material.dart';
import 'package:kolzumo_app/infrastructure/helpers/promocion_helper.dart';
import 'package:kolzumo_app/infrastructure/models/cliente_model.dart';
import 'package:kolzumo_app/infrastructure/models/promocion_model.dart';
import 'package:kolzumo_app/providers/checkout_provider.dart';
import 'package:kolzumo_app/providers/precio_provider.dart';
import 'package:provider/provider.dart';

import '../../../infrastructure/formatters/currency_formatter.dart';
import '../../../providers/cart_provider.dart';
import '../../../providers/inventario_provider.dart';
import 'badge_promocion.dart';

class CheckoutProducts extends StatelessWidget {

  const CheckoutProducts({
    super.key,
    required this.items,
    required this.inventario,
    required this.precio,
    required this.cliente,
  });

  final List<MapEntry<int,int>> items;
  final InventarioProvider inventario;
  final PreciosProvider precio;
  final Cliente? cliente;

  @override
  Widget build(BuildContext context) {

    // * Providers 
    final cart = context.watch<CartProvider>();
    final checkout = context.watch<CheckoutProvider>();

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(

          children: [

            Row(
              children: [
                Icon(Icons.shopping_cart),
                SizedBox(width:8),
                Text(
                  "Productos",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
              ],
            ),

            const SizedBox(height:20),

            ...items.map((entry){

              final producto = inventario.getById(entry.key);

              final precioItem = precio.getByIds(entry.key, cliente!.idcategoriaCliente,);

              final subtotal = precioItem!.valor * entry.value;

              final cantidadProm = PromocionHelper.calcularBonificacion(producto?.promocion, entry.value);

              final aplicaProm = producto!.promocion?.aplicaPara(cliente!);

              return ListTile(

                contentPadding: EdgeInsets.zero,

                leading: Column(
                  
                  children: [
                    Text('Unidades'),
                    CircleAvatar(
                      child: Text(entry.value.toString()),
                    ),
                  ],
                ),

                title: Text(producto.nombreproducto),

                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text('Precio: ${CurrencyFormatter.toCOP(precioItem.valor,)}',),
                        SizedBox(width: 10,),
                        // Badge promoción si aplica
                        if (producto.promocion != null) 
                          if (aplicaProm!)
                            if ((entry.value >= producto.promocion!.cantidadventa && producto.promocion!.promocionde != 'Descuento') || !(producto.promocion!.promocionde != 'Descuento'))
                              BadgePromocion(itemStock: producto, cantidadPromocion: cantidadProm,)

                      ],
                    ),
                    Text(
                      'Subtotal: ${CurrencyFormatter.toCOP(subtotal)}',
                      style: TextStyle(
                        color: Theme.of(context)
                            .colorScheme
                            .primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),

                trailing: IconButton(
                            icon: const Icon(Icons.delete),
                            color: Colors.red,
                            onPressed: () {
                              
                              cart.remove(producto.idproducto);

                              if (cart.items.isEmpty) {

                                checkout.clearTipoPago();
                                Navigator.pop(context, '/stock');
                              }
                            } 
                              
                )
              );
            })
          ],
        ),
      ),
    );
  }
}