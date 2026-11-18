import 'package:dio/dio.dart';
import 'package:kolzumo_app/infrastructure/models/inventario_model.dart';

class InventarioService {

  Future<List<Inventario>> getInventarioParcial(int idVendedor) async {
    try {
      Response response = await Dio()
        .get('http://vps.easesoft.com.co:8080/BackRutaVenta-0.0.1-SNAPSHOT/app/verinventariovendedor',
        queryParameters: {
          'idvendedor': idVendedor
        });

      if (response.statusCode == 200) {
      
        final inventario = Inventario.listFromJson(response.data);
        return inventario;

      } else {
        throw Exception('Failed to load data');
      }
    } catch (e) {
      throw Exception('Failed to fetch data: $e');
    }
  }
}