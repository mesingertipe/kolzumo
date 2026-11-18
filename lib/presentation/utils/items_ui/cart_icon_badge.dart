import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../providers/cart_provider.dart';

class CartIconBadge extends StatelessWidget {
  const CartIconBadge({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<CartProvider>(
      builder: (context, cart, _) {
        final totalItems = cart.items.length;
        

        return Badge(
          isLabelVisible: totalItems > 0,
          label: Text('$totalItems'),
          offset: const Offset(-7, 5),
          child: IconButton(
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
            icon: Icon(Icons.shopping_cart_outlined, color: Theme.of(context).primaryColor,),
            tooltip: 'Carrito',
            onPressed: () {
              if (cart.items.isNotEmpty) {
                
                Navigator.of(context).pushNamed('/cart');
              }else{
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: const Text('El carrito no tiene ningún producto'),
                    backgroundColor: Theme.of(context).colorScheme.error,
                    behavior: SnackBarBehavior.floating,
                    duration: const Duration(seconds: 3), // se oculta solo
                  ),
                );
              }
            },
          ),
        );
      },
    );
  }
}