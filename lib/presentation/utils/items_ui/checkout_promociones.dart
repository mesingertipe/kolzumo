import 'package:flutter/material.dart';

import '../../../infrastructure/models/promocion_model.dart';

class CheckoutPromotions extends StatelessWidget {
  final List<Promocion> promociones;

  const CheckoutPromotions({super.key, required this.promociones});

  @override
  Widget build(BuildContext context) {

    return Card(

      color: Colors.orange.shade50,

      child: Padding(

        padding: const EdgeInsets.all(16),

        child: Column(

          crossAxisAlignment:
              CrossAxisAlignment.start,

          children: [

            Row(

              children: const [

                Icon(
                  Icons.local_offer,
                  color: Colors.orange,
                ),

                SizedBox(width:8),

                Text(
                  "Promociones aplicadas",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                )

              ],
            ),

            const SizedBox(height:16),

            ...promociones.map((itemProm) {
              
              return ListTile(
            
                leading: const Icon(
                  Icons.check_circle,
                  color: Colors.green,
                ),
              
                title: Text(
                  itemProm.promocionde,
                ),
              
                trailing: itemProm.promocionde == 'Cantidad'
                ? Text('${itemProm.cantidadventa} x ${itemProm.cantidadsobreventa}')
                : itemProm.promocionde == 'Encime'
                ? Text('${itemProm.cantidadventa} x ${itemProm.porcentajesobreventa}%')            
                : Text(
                  '${itemProm.porcentajesobreventa}%',
                  style: TextStyle(
                    color: Colors.green,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              );
            
            })
          ],
        ),
      ),
    );
  }
}