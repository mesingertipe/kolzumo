import 'package:flutter/material.dart';

import '../infrastructure/models/cliente_model.dart';
import '../services/cliente_service.dart';


class ClienteProvider extends ChangeNotifier {
  Cliente? _clienteSeleccionado;

  final ClienteService _service = ClienteService();
  List<Cliente> _clientes = [];
  bool _loading = false;

  Cliente? get clienteSeleccionado => _clienteSeleccionado;

  void seleccionarCliente(Cliente? cliente) {
    _clienteSeleccionado = cliente;
    notifyListeners();
  }

  void limpiar() {
    _clienteSeleccionado = null;
    notifyListeners();
  }

  List<Cliente> get clientes => _clientes;
  bool get loading => _loading;

  Future<void> cargarClientes(String ruta) async {
    _loading = true;
    notifyListeners();

    try {
      _clientes = await _service.getClientes(ruta);
    } catch (e) {
      _clientes = [];
    }

    _loading = false;
    notifyListeners();
  }
}