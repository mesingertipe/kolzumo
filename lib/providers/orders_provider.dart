import 'package:flutter/material.dart';

import '../infrastructure/models/pedido_pendiente_model.dart';
import '../services/pedidos_pendientes_service.dart';

class PedidosPendientesProvider extends ChangeNotifier {
  
  // * Services
  final PedidosPendientesService _servicePedidos = PedidosPendientesService();

  List<PedidosPendientes> _pedidos = [];

  List<PedidosPendientes> get pedidos => _pedidos;

  bool _loading = false;
  bool get loading => _loading;

  Future<void> cargarPedidos(int idVendedor) async {
    if(_pedidos.isNotEmpty) return;

    _loading = true;
    notifyListeners();

    try {
      _pedidos = await _servicePedidos.getPedidosPendientes(idVendedor);
    } catch (e) {
      _pedidos = [];
      rethrow;
    }  finally {
      _loading = false;
      notifyListeners();
    }
  }

  int getIdPedido (){
    return _pedidos.first.idpedidovendedor;
  }

  Future <void> aprobarPedido(int idPedido) async {
    try {
      await _servicePedidos.aprobarPedido(idPedido);
    } catch (e) {
      debugPrint('Error en aprobar pedido');
    }
  }

  void clear() {
    _pedidos.clear();
    _loading = false;
    notifyListeners();
  }
  
}