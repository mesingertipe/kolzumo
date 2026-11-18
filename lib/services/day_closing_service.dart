import 'dart:convert';
import 'dart:developer' as developer;

import 'package:dio/dio.dart' show Response, Dio, DioException, DioExceptionType;
import 'package:flutter/foundation.dart';
import 'package:kolzumo_app/core/network/api_client.dart';
import 'package:kolzumo_app/core/services/telemetry_service.dart';
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
  final Dio _dio = ApiClient.instance.dio;

  @override
  Future<ResultadoCierreDia> closeDay(ResumenDia resumenDia) async {
    try {
      final Response response = await _dio.post(
        '/tbasicas/cargaresumendiavendedor',
        data: {
          'idresumenvendedordia': resumenDia.idresumenvendedordia,
          'idvendedor': resumenDia.idvendedor,
          'nombrevendedor': resumenDia.nombrevendedor,
          'fecha': DateTime.now().toIso8601String(),
          'listaventas': resumenDia.listaventas.map((v) => v.toJson()).toList(),
          'listainventario':
              resumenDia.listainventario.map((i) => i.toJson()).toList(),
        },
      );

      developer.log(
        'resumendia object: ${jsonEncode(resumenDia.toJson())}',
        name: 'resumendia_Object',
      );
      developer.log(
        'Data completa: ${jsonEncode(response.data)}',
        name: 'DEBUG',
      );

      if (response.statusCode == 200) {
        final mensajeBackend = response.data is Map
            ? (response.data['mensaje'] ?? 'Día cerrado correctamente')
            : 'Día cerrado correctamente';

        await TelemetryService.instance.logEvent('day_closed_success', {
          'id_vendedor': resumenDia.idvendedor,
          'total_ventas': resumenDia.listaventas.length,
        });

        return ResultadoCierreDia.ok(mensajeBackend.toString());
      }

      return ResultadoCierreDia.fallo(
        'Error del servidor (${response.statusCode})',
      );
    } on DioException catch (e) {
      return ResultadoCierreDia.fallo(_mensajeDesdeDioException(e));
    } catch (e, stack) {
      await TelemetryService.instance.recordError(
        e,
        stack,
        reason: 'closeDay failed',
      );
      return ResultadoCierreDia.fallo('Error inesperado al cerrar el día: $e');
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
        return 'Error de conexión (${e.error})';
      default:
        debugPrint('error dio: ${e.response}');
        return 'No se pudo cerrar el día.';
    }
  }
}
