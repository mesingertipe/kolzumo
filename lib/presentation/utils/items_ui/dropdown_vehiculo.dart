import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../infrastructure/models/vehiculo_model.dart';
import '../../../providers/vehiculo_provider.dart';
import '../../../services/vehiculos_service.dart';

class DropdownVehiculo extends StatefulWidget {
  const DropdownVehiculo({super.key});

  @override
  State<DropdownVehiculo> createState() => _DropdownVehiculoState();
}

class _DropdownVehiculoState extends State<DropdownVehiculo> {

  final VehiculoService _vehiculoService = VehiculoService();

  @override
  Widget build(BuildContext context) {
     
    final vehiculoProvider = context.watch<VehiculoProvider>();
    
    return DropdownSearch<Vehiculo>(
      selectedItem: vehiculoProvider.vehiculoSeleccionado,

      compareFn: (item, selectedItem) =>
          item.idvehiculo == selectedItem.idvehiculo,

      items: (filter, loadProps) async {
        return await _vehiculoService.findVehiculos(filter);
      },

      itemAsString: (vehiculo) => '${vehiculo.placa} - ${vehiculo.tipovehiculo}',

      popupProps: PopupProps.modalBottomSheet(
        showSearchBox: true,

        searchFieldProps: TextFieldProps(
          decoration: InputDecoration(
            hintText: 'Buscar vehículo...',
            prefixIcon: Icon(Icons.search),
            border: OutlineInputBorder(),
          ),
        ),

        itemBuilder: (context, vehiculo, isDisabled, isSelected) {
          return ListTile(
            leading: const Icon(Icons.directions_car),
            title: Text(vehiculo.tipovehiculo),
            subtitle: Text(vehiculo.placa),
          );
        },
      ),

      decoratorProps: const DropDownDecoratorProps(
        decoration: InputDecoration(
          labelText: 'Vehiculo',
          hintText: 'Seleccione un vehiculo',
          border: OutlineInputBorder(),
          prefixIcon: Icon(Icons.directions_car),
        ),
      ),

      onSelected: (Vehiculo? vehiculo) {
        context.read<VehiculoProvider>().seleccionarVehiculo(vehiculo);
      },

      validator: (vehiculo) {
        if (vehiculo == null) {
          return 'Debe seleccionar un vehiculo';
        }
        return null;
      },
    );
  }
}