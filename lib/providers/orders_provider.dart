import 'package:flutter/material.dart';

import '../infrastructure/models/pedido_pendiente_model.dart';
import '../services/pedidos_pendientes_service.dart';

class PedidosPendientesProvider extends ChangeNotifier {
  final PedidosPendientesService _servicePedidos = PedidosPendientesService();

  List<PedidosPendientes> _pedidos = [];
  List<PedidosPendientes> get pedidos => _pedidos;

  bool _loading = false;
  bool get loading => _loading;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  Future<void> cargarPedidos(int idVendedor, {bool forceRefresh = false}) async {
    if (_pedidos.isNotEmpty && !forceRefresh) return;

    _loading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _pedidos = await _servicePedidos.getPedidosPendientes(idVendedor);
    } catch (e) {
      _pedidos = [];
      _errorMessage = 'No se pudieron consultar los pedidos pendientes.';
      debugPrint('Error cargando pedidos pendientes: $e');
    } finally {
      _loading = false;
      notifyListeners();
    }
  }

  int getIdPedido() {
    if (_pedidos.isEmpty) return 0;
    return _pedidos.first.idpedidovendedor;
  }

  Future<bool> aprobarPedido(int idPedido) async {
    try {
      await _servicePedidos.aprobarPedido(idPedido);
      _pedidos.removeWhere((p) => p.idpedidovendedor == idPedido);
      notifyListeners();
      return true;
    } catch (e) {
      debugPrint('Error en aprobar pedido #$idPedido: $e');
      return false;
    }
  }

  void clear() {
    _pedidos.clear();
    _loading = false;
    _errorMessage = null;
    notifyListeners();
  }
}
