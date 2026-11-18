import 'package:dio/dio.dart';

import '../infrastructure/models/categoriacliente_model.dart';

class CategoriaClienteService {

  Future<List<CategoriaCliente>> getCategoriaClientes() async {
    try {
      Response response = await Dio()
        .get('http://vps.easesoft.com.co:8080/BackRutaVenta-0.0.1-SNAPSHOT/tbasicas/vercategoriascliente');

      if (response.statusCode == 200) {
      
        final catClientes = CategoriaCliente.listFromJson(response.data);

        return catClientes;
        
      } else {
        throw Exception('Failed to load data');
      }
    } catch (e) {
      throw Exception('Failed to fetch data: $e');
    }
  }
}