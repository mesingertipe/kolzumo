import 'package:flutter/material.dart';
import 'package:kolzumo_app/infrastructure/repositories/inventario_repository.dart';
import 'package:kolzumo_app/presentation/utils/items_ui/button_form.dart';
import 'package:kolzumo_app/presentation/utils/items_ui/dropdown_ruta.dart';
import 'package:kolzumo_app/presentation/utils/items_ui/dropdown_vehiculo.dart';
import 'package:provider/provider.dart';

import '../../config/app_theme.dart';
import '../../infrastructure/models/userauth.dart';
import '../../logic/auth_logic.dart';
import '../utils/items_ui/menu_burguer.dart';
import '../utils/items_ui/modal_inventario.dart';


class FormRuta extends StatelessWidget {
  const FormRuta({super.key});

  @override
  Widget build(BuildContext context) {

    UserAuth? user = context.watch<Auth>().userAccount;
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Formulario de Ruta'),
      ),
      drawer: const AppDrawer(currentRoute: '/ruta'),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
              child: DropdownVehiculo(),
            ),
            
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
              child: DropdownItems(),
            ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
              child: ButtonForm(
                textButton: 'Iniciar Día',
                colorButton: AppTheme.primaryColor,
                onPressed: () async {
                  final inventarios = await InventarioRepository().getInventario(user!.idvendedor);
                  
                  if(!context.mounted) return;

                  // Mostrar modal
                  showDialog(context: context, builder: (_) {
                    return ModalInventario(inventarios: inventarios);
                  });
                }
              ),
            ),
          ],
        )
      ),
    );
  }
}