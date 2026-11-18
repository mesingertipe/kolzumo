import 'package:dio/dio.dart';
import 'package:kolzumo_app/core/network/api_client.dart';
import '../infrastructure/models/categoriacliente_model.dart';

class CategoriaClienteService {
  final Dio _dio = ApiClient.instance.dio;

  Future<List<CategoriaCliente>> getCategoriaClientes() async {
    try {
      final Response response = await _dio.get('/tbasicas/vercategoriascliente');

      if (response.statusCode == 200) {
        return CategoriaCliente.listFromJson(response.data);
      } else {
        throw Exception(
          'Error al cargar categorías de cliente (${response.statusCode})',
        );
      }
    } catch (e) {
      throw Exception('No se pudieron obtener las categorías de cliente: $e');
    }
  }
}
