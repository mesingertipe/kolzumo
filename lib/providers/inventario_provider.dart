import 'package:flutter/material.dart';
import '../infrastructure/models/inventario_model.dart';

class InventarioProvider extends ChangeNotifier {
  List<Inventario> _inventarios = [];

  List<Inventario> get inventarios => _inventarios;

  void setInventarios(List<Inventario> data) {
    _inventarios = data;
    notifyListeners();
  }

  Inventario? getById(int id) {
    try {
      return _inventarios.firstWhere(
        (p) => p.idproducto == id,
      );
    } catch (_) {
      return null;
    }
  }

   void upsertInventario(List<Inventario> nuevosInventarios) {
    for (final nuevo in nuevosInventarios) {
      final index = _inventarios.indexWhere(
        (p) => p.idproducto == nuevo.idproducto,
      );

      if (index != -1) {
        // Ya existe -> sumar cantidad
        final existente = _inventarios[index];
        _inventarios[index] = existente.copyWith(
          cantidad: existente.cantidad + nuevo.cantidad,
        );
      } else {
        // No existe -> agregarlo tal cual
        _inventarios.add(nuevo);
      }
    }

    notifyListeners();
  }
}