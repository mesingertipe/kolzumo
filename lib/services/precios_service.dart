import 'package:dio/dio.dart';
import 'package:kolzumo_app/core/network/api_client.dart';
import '../infrastructure/models/precios_model.dart';

class PreciosService {
  final Dio _dio = ApiClient.instance.dio;

  Future<List<Precios>> getPrecios() async {
    try {
      final Response response = await _dio.get('/tbasicas/verprecios');

      if (response.statusCode == 200) {
        return Precios.listFromJson(response.data);
      } else {
        throw Exception('Error al cargar precios (${response.statusCode})');
      }
    } catch (e) {
      throw Exception('No se pudieron obtener los precios: $e');
    }
  }
}
