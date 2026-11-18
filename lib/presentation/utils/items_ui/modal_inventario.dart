import 'package:flutter/material.dart';
import 'package:kolzumo_app/infrastructure/models/inventario_model.dart';
import 'package:kolzumo_app/presentation/utils/items_ui/listview_inventario.dart';
import 'package:provider/provider.dart';

import '../../../providers/orders_provider.dart';

class ModalInventario extends StatelessWidget{
  final List<Inventario> inventarios;
  final String? origen;

  const ModalInventario({super.key, required this.inventarios, this.origen});
  
  @override
  Widget build(BuildContext context) {

    // * Providers
    final ordersPending = context.watch<PedidosPendientesProvider>();

    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: 600,
          maxHeight: MediaQuery.of(context).size.height * 0.75,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [

            // Encabezado
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor.withValues(alpha: 0.8),
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(16),
                ),
              ),
              child: Row(
                children: [
                  const Icon(Icons.inventory_2_outlined, color: Colors.white,),
                  const SizedBox(width: 5),
                  origen == 'home'?
                  const Text(
                    'Detalle Pedido',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  )
                  :const Text(
                    'Inventario Asignado',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ) 
            ),

            // Contenido
            Expanded(
              child: inventarios.isEmpty
                  ? const Center(
                      child: Text(
                        'No hay inventario disponible',
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      itemCount: inventarios.length,
                      itemBuilder: (context, index) {
                        return ListviewInventario(
                          index: index,
                          item: inventarios[index],
                        );
                      },
                    ),
            ),

            const Divider(height: 1),

            // Botones
            Padding(
              padding: const EdgeInsets.all(12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  OutlinedButton(
                    style: ButtonStyle(backgroundColor: WidgetStateProperty.all(Colors.brown[50])),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text('Cancelar'),
                  ),

                  const SizedBox(width: 8),

                  ElevatedButton(
                    onPressed: () async {
                      if (origen != null && origen == 'home') {
                        
                        // * aprobar pedido
                        final idPedido = ordersPending.getIdPedido();
                        ordersPending.aprobarPedido(idPedido);

                        // * Limpieza de pedidos pendientes
                        ordersPending.clear();
                      }

                      if (context.mounted) {
                        Navigator.pop(context);
                      }
                      
                    },
                    child: const Text('Aceptar'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}