import 'package:flutter/material.dart';
import 'package:kolzumo_app/infrastructure/models/vehiculo_model.dart';
import 'package:kolzumo_app/services/vehiculos_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class VehiculoProvider extends ChangeNotifier {
  static const _vehiculoChoosed = 'vehiculo_seleccionado_id';

  Vehiculo? _vehiculoSeleccionado;

  Vehiculo? get vehiculoSeleccionado => _vehiculoSeleccionado;

  void seleccionarVehiculo(Vehiculo? vehiculo) {
    _vehiculoSeleccionado = vehiculo;
    notifyListeners();
    _guardarSeleccionVehiculo(vehiculo);
  }

  void limpiar() {
    _vehiculoSeleccionado = null;
    notifyListeners();
    _borrarSeleccionVehiculo();
  }

  Future<void> _guardarSeleccionVehiculo(Vehiculo? vehiculo) async {
    final prefs = await SharedPreferences.getInstance();
    if (vehiculo != null) {
      await prefs.setInt(_vehiculoChoosed, vehiculo.idvehiculo);
    } else {
      await prefs.remove(_vehiculoChoosed);
    }
  }

  Future<void> _borrarSeleccionVehiculo() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_vehiculoChoosed);
  }

  // TODO: Add vehiculo tabla
  Future<void> cargarSeleccionVehiculo(VehiculoService vehiculosService) async {
    final prefs = await SharedPreferences.getInstance();
    final id = prefs.getInt(_vehiculoChoosed);

    if (id == null) return;
    try {
      final vehiculo = await vehiculosService.findVehiculoPorId(id);
      _vehiculoSeleccionado = vehiculo;
      notifyListeners();
      } catch (e) {
        debugPrint('Error seteando vehiculo: ${e.toString()}');
      }
  }
}