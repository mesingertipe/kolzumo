import 'package:dio/dio.dart';
import 'package:kolzumo_app/core/network/api_client.dart';
import '../infrastructure/models/promocion_model.dart';

class PromocionService {
  final Dio _dio = ApiClient.instance.dio;

  Future<List<Promocion>> getPromociones() async {
    try {
      final Response response = await _dio.get('/tbasicas/verpromocioneshoy');

      if (response.statusCode == 200) {
        return Promocion.listFromJson(response.data);
      } else {
        throw Exception('Error al cargar promociones (${response.statusCode})');
      }
    } catch (e) {
      throw Exception('No se pudieron obtener las promociones: $e');
    }
  }
}
