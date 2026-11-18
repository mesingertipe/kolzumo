import 'package:flutter/material.dart';

import '../infrastructure/models/precios_model.dart';

class PreciosProvider extends ChangeNotifier {
  List<Precios> _precios = [];

  List<Precios> get precios => _precios;

  void setPrecios(List<Precios> data) {
    _precios = data;
    notifyListeners();
  }

  Precios? getByIds(int idproducto, int idcategoriacliente) {
    try {
      return _precios.firstWhere(
        (p) => p.idcategoriacliente == idcategoriacliente && p.idproducto == idproducto,
      );
    } catch (_) {
      return null;
    }
  }
}