import 'package:dio/dio.dart';
import 'package:kolzumo_app/infrastructure/models/cliente_model.dart';

class ClienteService {

  Future<List<Cliente>> getClientes(String rutafilter) async {
    try {
      Response response = await Dio()
        .get('http://vps.easesoft.com.co:8080/BackRutaVenta-0.0.1-SNAPSHOT/tbasicas/verclientes');

      if (response.statusCode == 200) {
      
        final clientes = Cliente.listFromJson(response.data);

        if (rutafilter.isEmpty) {
          return clientes;
        }

        return clientes.where((cliente) {
          return cliente.nombreruta
            .toLowerCase()
            .contains(rutafilter.toLowerCase());
        }).toList();

      } else {
        throw Exception('Failed to load data');
      }
    } catch (e) {
      throw Exception('Failed to fetch data: $e');
    }
  }
}