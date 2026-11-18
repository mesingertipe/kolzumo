import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:kolzumo_app/core/network/api_client.dart';
import 'package:kolzumo_app/infrastructure/models/pedido_pendiente_model.dart';

class PedidosPendientesService {
  final Dio _dio = ApiClient.instance.dio;

  Future<List<PedidosPendientes>> getPedidosPendientes(int idVendedor) async {
    try {
      final Response response = await _dio.get(
        '/app/verpedidosvendedor',
        queryParameters: {'idvendedor': idVendedor},
      );

      if (response.statusCode == 200) {
        return PedidosPendientes.listFromJson(response.data);
      } else {
        throw Exception('Error al cargar pedidos (${response.statusCode})');
      }
    } catch (e) {
      throw Exception('No se pudieron obtener los pedidos pendientes: $e');
    }
  }

  Future<void> aprobarPedido(int idPedido) async {
    try {
      final Response response = await _dio.post(
        '/app/aprobarpedido',
        queryParameters: {'idpedido': idPedido},
      );

      if (response.statusCode == 200) {
        debugPrint('Pedido #$idPedido aprobado');
      }
    } catch (e) {
      throw Exception('Error al aprobar el pedido #$idPedido: $e');
    }
  }
}
