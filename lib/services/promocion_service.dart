import 'package:dio/dio.dart';

import '../infrastructure/models/promocion_model.dart';

class PromocionService {

  Future<List<Promocion>> getPromociones() async {
    try {
      Response response = await Dio()
        .get('http://vps.easesoft.com.co:8080/BackRutaVenta-0.0.1-SNAPSHOT/tbasicas/verpromocioneshoy');

      if (response.statusCode == 200) {
      
        final promociones = Promocion.listFromJson(response.data);

        return promociones;

      } else {
        throw Exception('Failed to load data');
      }
    } catch (e) {
      throw Exception('Failed to fetch data: $e');
    }
  }
}