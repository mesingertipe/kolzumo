import 'package:dio/dio.dart';
import 'package:drift/drift.dart';
import 'package:kolzumo_app/core/network/result.dart';
import 'package:kolzumo_app/data/database/database.dart';
import 'package:kolzumo_app/infrastructure/helpers/resultado_sincronizacion_helper.dart';
import 'package:kolzumo_app/infrastructure/models/cliente_model.dart' as model;
import 'package:kolzumo_app/services/cliente_service.dart';

/// Repositorio unificado de clientes: Única Fuente de la Verdad (SSOT).
/// Implementa patrón Offline-First respaldado por Result<T>.
class ClientesRepository {
  final AppDatabase _db;
  final ClienteService _api;

  ClientesRepository(this._db, this._api);

  /// Obtiene los clientes de una ruta.
  /// 1. Consulta primero SQLite local (garantía 100% offline).
  /// 2. Si no hay clientes locales y hay red, consulta API remota y persiste en DB.
  Future<Result<List<model.Cliente>>> getClientesPorRuta({
    required int? rutaId,
    required String nombreRuta,
    bool forceRemoteRefresh = false,
  }) async {
    try {
      // 1. Consulta local primero si tenemos el ID de ruta
      if (!forceRemoteRefresh && rutaId != null) {
        final locales = await _db.clientesDao.obtenerPorRutaId(rutaId);
        if (locales.isNotEmpty) {
          final clientesMapeados = locales.map(_mapDbToModel).toList();
          return Result.ok(clientesMapeados);
        }
      }

      // 2. Consulta API remota si no hay locales o se pidió refresco forzado
      try {
        final remotos = await _api.getClientes(nombreRuta);
        if (remotos.isNotEmpty) {
          await sincronizarEnDb(remotos);
        }
        return Result.ok(remotos);
      } on DioException catch (dioErr) {
        // En caso de fallo de red, fallback a lo que haya en la base de datos local
        if (rutaId != null) {
          final locales = await _db.clientesDao.obtenerPorRutaId(rutaId);
          if (locales.isNotEmpty) {
            return Result.ok(locales.map(_mapDbToModel).toList());
          }
        }
        return Result.fail(
          NetworkFailure('Error de conexión al cargar clientes: ${dioErr.message}', dioErr),
        );
      }
    } catch (e, stack) {
      return Result.fail(
        DatabaseFailure('Error inesperado al obtener clientes: $e', error: e, stackTrace: stack),
      );
    }
  }

  /// Sincroniza la lista de clientes completa en Drift SQLite
  Future<ResultadoSincronizacion> sincronizarEnDb(List<model.Cliente> clientes) async {
    try {
      await _db.batch((batch) {
        batch.insertAllOnConflictUpdate(
          _db.clientes,
          clientes.map((item) {
            return ClientesCompanion.insert(
              id: Value(item.idcliente),
              tipoDocumentoId: item.idtipodocumento,
              documento: item.documento,
              nombreEstablecimiento: item.nombreestablecimiento,
              direccion: item.direccion,
              telefono: Value(item.telefono),
              email: Value(item.email),
              administrador: Value(item.administrador),
              barrio: Value(item.barrio),
              ivaDiscrimina: Value(item.ivadiscrimina == 1),
              pagoCredito: Value(item.pagocredito == 1),
              cupo: Value(item.cupo),
              plazo: Value(item.plazo),
              activo: Value(item.estado == 1),
              categoriaClienteId: item.idcategoriaCliente,
              rutaId: item.idruta,
              ciudadId: item.idciudad,
            );
          }).toList(),
        );
      });
      return ResultadoSincronizacion.ok(clientes.length);
    } catch (e) {
      return ResultadoSincronizacion.fallo(e.toString());
    }
  }

  /// Mapeador de Drift DataClass -> Model de Dominio
  model.Cliente _mapDbToModel(Cliente row) {
    final now = DateTime.now();
    return model.Cliente(
      idcliente: row.id,
      idtipodocumento: row.tipoDocumentoId,
      nombretipodocumento: '',
      documento: row.documento,
      nombreestablecimiento: row.nombreEstablecimiento,
      direccion: row.direccion,
      telefono: row.telefono ?? '',
      email: row.email ?? '',
      administrador: row.administrador ?? '',
      barrio: row.barrio ?? '',
      gps: null,
      consecutivoentrega: 0,
      ivadiscrimina: row.ivaDiscrimina ? 1 : 0,
      iva: '0%',
      pagocredito: row.pagoCredito ? 1 : 0,
      credito: row.pagoCredito ? 'Si' : 'No',
      cupo: row.cupo,
      plazo: row.plazo ?? 0,
      estado: row.activo ? 1 : 0,
      nombreestado: row.activo ? 'Activo' : 'Inactivo',
      idcategoriaCliente: row.categoriaClienteId,
      nombrecategoriaCliente: '',
      idruta: row.rutaId,
      nombreruta: '',
      idciudad: row.ciudadId,
      nombreciudad: '',
      horariodesde: '',
      horariohasta: '',
      horariodesdetime: now,
      horariohastatime: now,
      mensaje: null,
    );
  }
}
