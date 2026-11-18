import 'package:dio/dio.dart';
import 'package:kolzumo_app/core/network/api_client.dart';
import 'package:kolzumo_app/infrastructure/models/inventario_model.dart';

class InventarioService {
  final Dio _dio = ApiClient.instance.dio;

  Future<List<Inventario>> getInventarioParcial(int idVendedor) async {
    try {
      final Response response = await _dio.get(
        '/app/verinventariovendedor',
        queryParameters: {'idvendedor': idVendedor},
      );

      if (response.statusCode == 200) {
        return Inventario.listFromJson(response.data);
      } else {
        throw Exception('Error al cargar inventario (${response.statusCode})');
      }
    } catch (e) {
      throw Exception('No se pudo obtener el inventario del vendedor: $e');
    }
  }
}
