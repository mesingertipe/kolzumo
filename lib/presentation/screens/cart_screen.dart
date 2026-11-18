import 'package:flutter/material.dart';
import 'package:kolzumo_app/infrastructure/formatters/currency_formatter.dart';
import 'package:kolzumo_app/providers/cliente_provider.dart';
import 'package:kolzumo_app/providers/precio_provider.dart';
import 'package:provider/provider.dart';
import '../../providers/cart_provider.dart';
import '../../providers/inventario_provider.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {

    final cart = context.watch<CartProvider>();
    final inventario = context.watch<InventarioProvider>();
    final customer = context.read<ClienteProvider>();
    final precio = context.read<PreciosProvider>();

    final items = cart.items.entries.toList();

    final customerSel = customer.clienteSeleccionado;

    final total = cart.calcularTotal(items, inventario, precio, customerSel!);

    return Scaffold(
      appBar: AppBar(
        title: Text('Mi Carrito: ${customerSel.nombreestablecimiento}'),
        actions: [
          TextButton(
            onPressed: items.isEmpty
                ? null
                : () => cart.clear(),
            child: Text(
              'Vaciar',
              style: TextStyle(color: Theme.of(context).colorScheme.onTertiary),
            ),
          ),
        ],
      ),

      body: items.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.wrong_location_rounded, size: 100, color: Theme.of(context).colorScheme.onSurfaceVariant),
                  Text('El carrito está vacío.'),
                ],
              ),
            )
          : Column(
              children: [
                /// LISTA DE PRODUCTOS
                Expanded(
                  child: ListView.separated(
                    padding: const EdgeInsets.all(12),
                    itemCount: items.length,
                    separatorBuilder: (_, _) =>
                      const SizedBox(height: 10),
                    itemBuilder: (context, index) {
                      final entry = items[index];
                      final product = inventario.getById(entry.key);
                      final precioItem = precio.getByIds(entry.key, customerSel.idcategoriaCliente);

                      final subtotal = precioItem!.valor * entry.value;

                      return Card(
                        elevation: 2,
                        shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(12),
                        ),
                        child: ListTile(
                          title: Text(product!.nombreproducto),
                          subtitle: Column(
                            crossAxisAlignment:
                                CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 4),
                              Text('Precio: ${CurrencyFormatter.toCOP(precioItem.valor)}, Unidades ${entry.value}'),
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
                              
                            },
                          ),
                        ),
                      );
                    },
                  ),
                ),

                /// TOTAL Y ACCIÓN FINAL
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Theme.of(context)
                        .colorScheme
                        .surface,
                    boxShadow: const [
                      BoxShadow(
                        blurRadius: 10,
                        color: Colors.black12,
                      )
                    ],
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment:
                            MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Total',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            CurrencyFormatter.toCOP(total),
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context)
                                  .colorScheme
                                  .primary,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 12),

                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            // checkout
                          },
                          child: const Text('Pagar'),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }
}