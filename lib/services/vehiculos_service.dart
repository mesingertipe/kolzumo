import 'package:dio/dio.dart';
import 'package:kolzumo_app/core/network/api_client.dart';
import '../infrastructure/models/vehiculo_model.dart';

class VehiculoService {
  final Dio _dio = ApiClient.instance.dio;

  Future<List<Vehiculo>> findVehiculos(String filter) async {
    try {
      final Response response = await _dio.get('/tbasicas/vervehiculos');

      if (response.statusCode == 200) {
        final itemsVehiculo = Vehiculo.listFromJson(response.data);

        if (filter.isEmpty) {
          return itemsVehiculo;
        }

        return itemsVehiculo.where((vehiculo) {
          return vehiculo.placa.toLowerCase().contains(filter.toLowerCase());
        }).toList();
      } else {
        throw Exception('Error al cargar vehículos (${response.statusCode})');
      }
    } catch (e) {
      throw Exception('No se pudieron obtener los vehículos: $e');
    }
  }

  Future<Vehiculo> findVehiculoPorId(int id) async {
    final vehiculos = await findVehiculos('');
    return vehiculos.firstWhere((v) => v.idvehiculo == id);
  }
}
