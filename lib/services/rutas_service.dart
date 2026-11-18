import 'package:dio/dio.dart';
import 'package:kolzumo_app/core/network/api_client.dart';
import '../infrastructure/models/ruta_model.dart';

class RutaService {
  final Dio _dio = ApiClient.instance.dio;

  Future<List<Ruta>> findRutas(String filter) async {
    try {
      final Response response = await _dio.get('/tbasicas/verrutas');

      if (response.statusCode == 200) {
        final itemsRuta = Ruta.listFromJson(response.data);

        if (filter.isEmpty) {
          return itemsRuta;
        }

        return itemsRuta.where((ruta) {
          return ruta.nombreruta.toLowerCase().contains(filter.toLowerCase());
        }).toList();
      } else {
        throw Exception('Error al cargar rutas (${response.statusCode})');
      }
    } catch (e) {
      throw Exception('No se pudieron obtener las rutas: $e');
    }
  }
}
