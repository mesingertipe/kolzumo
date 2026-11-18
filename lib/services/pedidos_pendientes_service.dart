import 'package:dio/dio.dart';
import 'package:flutter/rendering.dart';
import 'package:kolzumo_app/infrastructure/models/pedido_pendiente_model.dart';

class PedidosPendientesService {

  Future<List<PedidosPendientes>> getPedidosPendientes(int idVendedor) async {
    try {
      Response response = await Dio().get('http://vps.easesoft.com.co:8080/BackRutaVenta-0.0.1-SNAPSHOT/app/verpedidosvendedor', 
        queryParameters: {
          'idvendedor': idVendedor
        }
      );

      if (response.statusCode == 200) {
      
        final listPedidos = PedidosPendientes.listFromJson(response.data);
        return listPedidos;

      } else {
        throw Exception('Failed to load data');
      }
    } catch (e) {
      throw Exception('Failed to fetch data: $e');
    }
  }

  Future<void> aprobarPedido(int idPedido) async {
    try {
      Response response = await Dio().post('http://vps.easesoft.com.co:8080/BackRutaVenta-0.0.1-SNAPSHOT/app/aprobarpedido', 
        queryParameters: {
          'idpedido': idPedido
        }
      );

      if (response.statusCode == 200) {
        debugPrint('pedido aprobado');
      }

    } catch (e) {
      throw Exception('Failed data');
    }
  }
}