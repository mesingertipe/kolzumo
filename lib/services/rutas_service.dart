import 'package:dio/dio.dart';

import '../infrastructure/models/ruta_model.dart';

class RutaService {

  Future<List<Ruta>> findRutas(String filter) async {
    try {
      Response response = await Dio().get('http://vps.easesoft.com.co:8080/BackRutaVenta-0.0.1-SNAPSHOT/tbasicas/verrutas');

      if (response.statusCode == 200) {
      
        final itemsRuta = Ruta.listFromJson(response.data);

        if (filter.isEmpty) {
          return itemsRuta;
        }

        return itemsRuta.where((ruta) {
          return ruta.nombreruta
            .toLowerCase()
            .contains(filter.toLowerCase());
        }).toList();

      } else {
        throw Exception('Failed to load data');
      }
    } catch (e) {
      throw Exception('Failed to fetch data: $e');
    }
  }
}