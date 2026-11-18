import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:kolzumo_app/data/database/database.dart';
import 'package:provider/provider.dart';

import '../../../infrastructure/models/ruta_model.dart' as model;
import '../../../providers/cliente_provider.dart';
import '../../../providers/ruta_provider.dart';

class DropdownItems extends StatefulWidget {
  const DropdownItems({super.key});

  @override
  State<DropdownItems> createState() => _DropdownItemsState();
}

class _DropdownItemsState extends State<DropdownItems> {

  @override
  Widget build(BuildContext context) {

    //* Providers 
    final database = context.watch<AppDatabase>();
    final rutaProvider = context.watch<RutaProvider>();
    
    return DropdownSearch<model.Ruta>(
      selectedItem: rutaProvider.rutaSeleccionada,

      compareFn: (item, selectedItem) => item.idruta == selectedItem.idruta,

      itemAsString: (ruta) => '${ruta.nombreruta} - ${ruta.nombrezona}',

      items: (filter, loadProps) async {
        final rutasLocales = await database.catalogosDao.obtenerRutas();
 
        final filtradas = filter.isEmpty
            ? rutasLocales
            : rutasLocales
                .where((r) =>
                    r.nombre.toLowerCase().contains(filter.toLowerCase()))
                .toList();
 
        return filtradas.map((r) {
          return model.Ruta(
            idruta: r.idRuta,
            nombreruta: r.nombre,
            idzona: r.idZona,
            nombrezona: r.nombrezona,
            estado: r.estado ? 1 : 0,
            nombreestado: r.estado ? 'Activo' : 'Inactivo',
            diasvisita: const [],
            mensaje: null,
          );
        }).toList();
      },

      popupProps: PopupProps.modalBottomSheet(
        showSearchBox: true,

        searchFieldProps: TextFieldProps(
          decoration: InputDecoration(
            hintText: 'Buscar ruta...',
            prefixIcon: Icon(Icons.route_outlined),
            border: OutlineInputBorder(),
          ),
        ),

        itemBuilder: (context, ruta, isDisabled, isSelected) {
          return ListTile(
            leading: const Icon(Icons.route_outlined),
            title: Text(ruta.nombreruta),
            subtitle: Text(ruta.nombrezona),
          );
        },
      ),

      decoratorProps: const DropDownDecoratorProps(
        decoration: InputDecoration(
          labelText: 'Ruta',
          hintText: 'Seleccione una ruta',
          border: OutlineInputBorder(),
          prefixIcon: Icon(Icons.route),
        ),
      ),

      onSelected: (model.Ruta? ruta) async {
        context.read<RutaProvider>().seleccionarRuta(ruta);
        await context.read<ClienteProvider>().cargarClientes(ruta!.nombreruta);
      },

      validator: (ruta) {
        if (ruta == null) {
          return 'Debe seleccionar una ruta';
        }
        return null;
      },
    );
  }
}