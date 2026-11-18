import 'package:flutter/foundation.dart';
import 'package:kolzumo_app/infrastructure/models/resumen_dia_model.dart';
import '../services/day_closing_service.dart';

class DayClosingController extends ChangeNotifier {
  DayClosingController({DayClosingService? service}) : _service = service ?? MockDayClosingService();

  final DayClosingService _service;

  bool isProcessing = false;
  bool isClosed = false;
  String? errorMessage;
  String? mensajeBackend;

  Future<bool> finalizarDia(ResumenDia resumenDia) async {
    isProcessing = true;
    errorMessage = null;
    mensajeBackend = null;
    notifyListeners();

    
    final resultado = await _service.closeDay(resumenDia);
    mensajeBackend = resultado.mensaje;

    if (resultado.exitoso) {
      isClosed = true;
    }else{
      errorMessage = resultado.mensaje;
    }
    
    isProcessing = false;
    notifyListeners();
    return resultado.exitoso;
    
  }

  void reset() {
    isClosed = false;
    errorMessage = null;
    notifyListeners();
  }
}