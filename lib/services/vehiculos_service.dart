import 'package:dio/dio.dart';

import '../infrastructure/models/vehiculo_model.dart';

class VehiculoService {

  Future<List<Vehiculo>> findVehiculos(String filter) async {
    try {
      Response response = await Dio().get('http://vps.easesoft.com.co:8080/BackRutaVenta-0.0.1-SNAPSHOT/tbasicas/vervehiculos');

      if (response.statusCode == 200) {
      
        final itemsVehiculo = Vehiculo.listFromJson(response.data);

        if (filter.isEmpty) {
          return itemsVehiculo;
        }

        return itemsVehiculo.where((vehiculo) {
          return vehiculo.placa
            .toLowerCase()
            .contains(filter.toLowerCase());
        }).toList();

      } else {
        throw Exception('Failed to load data');
      }
    } catch (e) {
      throw Exception('Failed to fetch data: $e');
    }
  }

  Future<Vehiculo> findVehiculoPorId(int id) async {
    final vehiculos = await findVehiculos('');
    
    return vehiculos.firstWhere((v) => v.idvehiculo == id);
    
  }
}