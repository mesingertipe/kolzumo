import 'package:dio/dio.dart';
import 'package:kolzumo_app/core/network/api_client.dart';
import '../infrastructure/models/vendedor_model.dart';

class VendedorService {
  final Dio _dio = ApiClient.instance.dio;

  Future<Vendedor> getConsecutivo(int idVendedor) async {
    try {
      final Response response = await _dio.get(
        '/tbasicas/vervendedor',
        queryParameters: {'idvendedor': idVendedor},
      );

      if (response.statusCode == 200) {
        return Vendedor.fromJson(response.data);
      } else {
        throw Exception('Error al cargar vendedor (${response.statusCode})');
      }
    } catch (e) {
      throw Exception('No se pudo obtener el consecutivo del vendedor: $e');
    }
  }
}
