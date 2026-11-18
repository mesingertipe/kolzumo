import 'package:dio/dio.dart';
import 'package:kolzumo_app/infrastructure/models/metodopago_model.dart';

class MetodopagoService {

  Future<List<MetodoPago>> getMetodosPago() async {
    try {
      Response response = await Dio().get('http://vps.easesoft.com.co:8080/BackRutaVenta-0.0.1-SNAPSHOT/tbasicas/verformaspago');

      if (response.statusCode == 200) {
      
        final metodosPago = MetodoPago.listFromJson(response.data);
        return metodosPago;

      } else {
        throw Exception('Failed to load data');
      }
    } catch (e) {
      throw Exception('Failed to fetch data: $e');
    }
  }
}