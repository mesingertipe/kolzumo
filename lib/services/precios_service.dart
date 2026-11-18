import 'package:dio/dio.dart';

import '../infrastructure/models/precios_model.dart';


class PreciosService {

  Future<List<Precios>> getPrecios() async {
    try {
      Response response = await Dio().get('http://vps.easesoft.com.co:8080/BackRutaVenta-0.0.1-SNAPSHOT/tbasicas/verprecios');

      if (response.statusCode == 200) {
      
        final precios = Precios.listFromJson(response.data);
        return precios;

      } else {
        throw Exception('Failed to load data');
      }
    } catch (e) {
      throw Exception('Failed to fetch data: $e');
    }
  }
}