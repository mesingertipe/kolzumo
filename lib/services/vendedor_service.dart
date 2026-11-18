import 'package:dio/dio.dart';

import '../infrastructure/models/vendedor_model.dart';

class VendedorService {

  Future<Vendedor> getConsecutivo(int idVendedor) async {
    try {
      Response response = await Dio()
        .get('http://vps.easesoft.com.co:8080/BackRutaVenta-0.0.1-SNAPSHOT/tbasicas/vervendedor',
        queryParameters: {
          'idvendedor': idVendedor
        });

      if (response.statusCode == 200) {
      
        final vendedor = Vendedor.fromJson(response.data);
        return vendedor;

      } else {
        throw Exception('Failed to load data');
      }
    } catch (e) {
      throw Exception('Failed to fetch data: $e');
    }
  }
}