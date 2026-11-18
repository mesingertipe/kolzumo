import 'package:flutter/material.dart';
import 'package:kolzumo_app/data/database/database.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../infrastructure/models/ruta_model.dart' as model;

class RutaProvider extends ChangeNotifier {
  static const _rutaChoosed = 'ruta_seleccionada_id';

  model.Ruta? _rutaSeleccionada;

  model.Ruta? get rutaSeleccionada => _rutaSeleccionada;

  void seleccionarRuta(model.Ruta? ruta) {
    _rutaSeleccionada = ruta;
    notifyListeners();
    _guardarSeleccionRuta(ruta);
  }

  void limpiar() {
    _rutaSeleccionada = null;
    notifyListeners();
    _borrarSeleccionRuta();
  }

  Future<void> _guardarSeleccionRuta(model.Ruta? ruta) async {
    final prefs = await SharedPreferences.getInstance();
    if (ruta != null) {
      await prefs.setInt(_rutaChoosed, ruta.idruta);
    } else {
      await prefs.remove(_rutaChoosed);
    }
  }

  Future<void> _borrarSeleccionRuta() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_rutaChoosed);
  }

  Future<void> cargarRutaSeleccionada(AppDatabase database) async {
    final prefs = await SharedPreferences.getInstance();
    final id = prefs.getInt(_rutaChoosed);

    if (id == null) return;
    
     final rutasLocales = await database.catalogosDao.obtenerRutas();

    try {
      final r = rutasLocales.firstWhere((r) => r.idRuta == id);

      _rutaSeleccionada = model.Ruta(
        idruta: r.idRuta,
        nombreruta: r.nombre,
        idzona: r.idZona,
        nombrezona: r.nombrezona,
        estado: r.estado ? 1 : 0,
        nombreestado: r.estado ? 'Activo' : 'Inactivo',
        diasvisita: const [],
        mensaje: null,
      );

      notifyListeners();
    } catch (e) {
      debugPrint('Error seteando ruta: ${e.toString()}');
    }
  }
}