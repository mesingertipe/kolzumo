import 'package:dio/dio.dart';
import 'package:kolzumo_app/core/network/api_client.dart';
import 'package:kolzumo_app/infrastructure/models/metodopago_model.dart';

class MetodopagoService {
  final Dio _dio = ApiClient.instance.dio;

  Future<List<MetodoPago>> getMetodosPago() async {
    try {
      final Response response = await _dio.get('/tbasicas/verformaspago');

      if (response.statusCode == 200) {
        return MetodoPago.listFromJson(response.data);
      } else {
        throw Exception(
          'Error al cargar formas de pago (${response.statusCode})',
        );
      }
    } catch (e) {
      throw Exception('No se pudieron obtener las formas de pago: $e');
    }
  }
}
