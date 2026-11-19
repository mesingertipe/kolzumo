import 'package:flutter/material.dart';
import 'package:kolzumo_app/core/network/result.dart';
import 'package:kolzumo_app/data/repositories/cliente_repo.dart';

import '../infrastructure/models/cliente_model.dart';

class ClienteProvider extends ChangeNotifier {
  Cliente? _clienteSeleccionado;
  ClientesRepository? _repository;

  List<Cliente> _clientes = [];
  bool _loading = false;
  String? _errorMessage;

  Cliente? get clienteSeleccionado => _clienteSeleccionado;
  List<Cliente> get clientes => _clientes;
  bool get loading => _loading;
  String? get errorMessage => _errorMessage;

  void setRepository(ClientesRepository repository) {
    _repository = repository;
  }

  void seleccionarCliente(Cliente? cliente) {
    _clienteSeleccionado = cliente;
    notifyListeners();
  }

  void limpiar() {
    _clienteSeleccionado = null;
    notifyListeners();
  }

  Future<void> cargarClientes(
    String ruta, {
    int? rutaId,
    bool forceRefresh = false,
  }) async {
    _loading = true;
    _errorMessage = null;
    notifyListeners();

    if (_repository != null) {
      final Result<List<Cliente>> result = await _repository!.getClientesPorRuta(
        rutaId: rutaId,
        nombreRuta: ruta,
        forceRemoteRefresh: forceRefresh,
      );

      result.when(
        success: (data) {
          _clientes = data;
          _errorMessage = null;
        },
        failure: (fail) {
          _errorMessage = fail.message;
        },
      );
    }

    _loading = false;
    notifyListeners();
  }
}