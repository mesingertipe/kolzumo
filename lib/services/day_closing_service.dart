import 'dart:convert';
import 'dart:developer' as developer;

import 'package:dio/dio.dart' show Response, Dio, DioException, DioExceptionType;
import 'package:flutter/foundation.dart';
import 'package:kolzumo_app/infrastructure/models/resumen_dia_model.dart';

class ResultadoCierreDia {
  final bool exitoso;
  final String mensaje;
 
  ResultadoCierreDia.ok(this.mensaje) : exitoso = true;
  ResultadoCierreDia.fallo(this.mensaje) : exitoso = false;
}

abstract class DayClosingService {
  Future<ResultadoCierreDia> closeDay(ResumenDia resumenDia);
}

class MockDayClosingService implements DayClosingService {
  
  @override
  Future<ResultadoCierreDia> closeDay(ResumenDia resumenDia) async {
    await Future.delayed(const Duration(seconds: 2));
     try {
      Response response = await Dio()
        .post('http://vps.easesoft.com.co:8080/BackRutaVenta-0.0.1-SNAPSHOT/tbasicas/cargaresumendiavendedor',
          data: {
            'idresumenvendedordia': resumenDia.idresumenvendedordia,
            'idvendedor': resumenDia.idvendedor,
            'nombrevendedor': resumenDia.nombrevendedor,
            'fecha': DateTime.now().toIso8601String(),
            // 'fecha': DateTime.now().subtract(const Duration(days: 20)).toIso8601String().split('T')[0],
            'listaventas': resumenDia.listaventas
              .map((v) => v.toJson())
              .toList(),
            'listainventario': resumenDia.listainventario
              .map((i) => i.toJson())
              .toList(),
          }
        );

      developer.log('resumendia object: ${jsonEncode(resumenDia.toJson())}', name: 'resumendia_Object');
      developer.log('Data completa: ${jsonEncode(response.data)}', name: 'DEBUG');
      
      if (response.statusCode == 200) {
        final mensajeBackend = response.data is Map
            ? (response.data['mensaje'] ?? 'Día cerrado correctamente')
            : 'Día cerrado correctamente';
 
        return ResultadoCierreDia.ok(mensajeBackend as String);

      } 

      return ResultadoCierreDia.fallo(
        'Error del servidor (${response.statusCode})',
      );

    } on DioException catch (e) {
      return ResultadoCierreDia.fallo(_mensajeDesdeDioException(e));
    } catch (e) {
      throw Exception('Error inesperado: $e');
    }
  }

  String _mensajeDesdeDioException(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return 'Tiempo de espera agotado. Revisa tu conexión.';
      case DioExceptionType.connectionError:
        return 'No hay conexión a internet.';
      case DioExceptionType.badResponse:
        return 'Error del servidor (${e.response?.statusCode}).';
      case DioExceptionType.unknown:
        return 'Error en ${e.error}';
      default:
        debugPrint('error dio: ${e.response}');
        return 'No se pudo cerrar el día.';
    }
  }
}
