import 'package:flutter/material.dart';
import 'package:kolzumo_app/providers/cliente_provider.dart';
import 'package:kolzumo_app/providers/ruta_provider.dart';
import 'package:provider/provider.dart';

import '../../../config/app_theme.dart';

class ListCustomers extends StatelessWidget {
  const ListCustomers({super.key});

  @override
  Widget build(BuildContext context) {
    final clientesProvider = context.watch<ClienteProvider>();
    final rutaSeleccionada = context.watch<RutaProvider>().rutaSeleccionada;
    
    if (clientesProvider.loading) {
      return Center(child: CircularProgressIndicator());
    }

    if (clientesProvider.clientes.isEmpty) {
      if(rutaSeleccionada?.nombreruta != null){
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.group_off_rounded, 
                size: 100, 
                color: Theme.of(context).colorScheme.onSurfaceVariant
              ),
              Text('No existen clientes para la ruta ${rutaSeleccionada!.nombreruta}.'),
            ],
          )
        );
      }else{
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.wrong_location_rounded, 
                size: 100, 
                color: Theme.of(context).colorScheme.onSurfaceVariant
              ),
              Text('No se ha seleccionado una ruta.'),
            ],
          )
        );
      }
    }

    return ListView.separated(
      padding: const EdgeInsets.all(12),
      itemCount: clientesProvider.clientes.length,
      separatorBuilder: (_, _) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final customerItem = clientesProvider.clientes[index];
        return Card(
          elevation: 4,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          shadowColor: Colors.black26,
          child: ListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            leading: Container(
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
              child: Icon(Icons.shop, color: Theme.of(context).colorScheme.primary),
            ),
            title: Text(
              '${customerItem.nombreestablecimiento} - ${customerItem.documento}', 
              style: const TextStyle(fontWeight: FontWeight.w600)
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 6),
                Text(customerItem.nombrecategoriaCliente, maxLines: 2, overflow: TextOverflow.ellipsis),
                const SizedBox(height: 6),
                Text(
                  '${customerItem.direccion} - ${customerItem.nombreruta}',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
            onTap: () {
              context.read<ClienteProvider>().seleccionarCliente(customerItem);
              Navigator.pushNamed(context, '/stock');
            },
          ),
        );
      },
    );
  }

}