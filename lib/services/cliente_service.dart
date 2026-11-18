import 'package:dio/dio.dart';
import 'package:kolzumo_app/core/network/api_client.dart';
import 'package:kolzumo_app/infrastructure/models/cliente_model.dart';

class ClienteService {
  final Dio _dio = ApiClient.instance.dio;

  Future<List<Cliente>> getClientes(String rutafilter) async {
    try {
      final Response response = await _dio.get('/tbasicas/verclientes');

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
        throw Exception('Error al cargar clientes (${response.statusCode})');
      }
    } catch (e) {
      throw Exception('No se pudieron obtener los clientes: $e');
    }
  }
}
