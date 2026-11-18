import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:kolzumo_app/core/config/app_config.dart';
import 'package:kolzumo_app/core/services/telemetry_service.dart';
import 'package:kolzumo_app/infrastructure/models/userauth.dart';
import 'package:kolzumo_app/services/storage_service.dart';
import '../services/usuarioservice.dart';

enum AuthErrorType {
  none,
  userNotFound,
  invalidPassword,
  unauthorizedProfile,
  inactiveAccount,
  networkError,
  serverError,
}

class AuthResult {
  final bool success;
  final AuthErrorType errorType;
  final String message;

  const AuthResult.ok()
      : success = true,
        errorType = AuthErrorType.none,
        message = 'Bienvenido';

  const AuthResult.error(this.errorType, this.message) : success = false;
}

class Auth extends ChangeNotifier {
  final UsuarioService usuarioService = UsuarioService();
  final StorageService _storageService = StorageService();

  UserAuth? userAccount;
  bool isAuthenticating = false;

  Auth({this.userAccount}) {
    if (userAccount != null) {
      TelemetryService.instance.setUserContext(
        idVendedor: userAccount!.idvendedor,
        nombreVendedor: userAccount!.nombre,
      );
    }
  }

  /// Autenticación enriquecida con diagnóstico claro de errores.
  Future<AuthResult> authenticate({
    required String username,
    required String password,
  }) async {
    isAuthenticating = true;
    notifyListeners();

    try {
      final UserAuth respoUserValidate = await usuarioService.getUser(
        username: username.trim(),
      );

      if (respoUserValidate.idusuario == 0 || respoUserValidate.idvendedor == -1) {
        return const AuthResult.error(
          AuthErrorType.userNotFound,
          'El usuario ingresado no existe en el sistema.',
        );
      }

      if (respoUserValidate.estado != 1) {
        return AuthResult.error(
          AuthErrorType.inactiveAccount,
          'Tu cuenta se encuentra inactiva (${respoUserValidate.nombreestado.isNotEmpty ? respoUserValidate.nombreestado : "Inactivo"}). Contacta al administrador.',
        );
      }

      final requiredProfileId = AppConfig.instance.sellerProfileId;
      if (respoUserValidate.idperfil != requiredProfileId &&
          !respoUserValidate.autorizado) {
        return AuthResult.error(
          AuthErrorType.unauthorizedProfile,
          'El usuario tiene perfil "${respoUserValidate.nombreperfil}" y no está habilitado como Vendedor en ruta.',
        );
      }

      if (password != respoUserValidate.clave) {
        return const AuthResult.error(
          AuthErrorType.invalidPassword,
          'La contraseña ingresada es incorrecta. Inténtalo de nuevo.',
        );
      }

      userAccount = respoUserValidate;
      await _storageService.saveSession(userAccount!);

      await TelemetryService.instance.setUserContext(
        idVendedor: userAccount!.idvendedor,
        nombreVendedor: userAccount!.nombre,
      );
      await TelemetryService.instance.logEvent('login_success', {
        'id_vendedor': userAccount!.idvendedor,
        'perfil': userAccount!.nombreperfil,
      });

      notifyListeners();
      return const AuthResult.ok();
    } on DioException catch (e) {
      String msg = 'No fue posible conectar con el servidor. Verifica tu conexión a internet.';
      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout ||
          e.type == DioExceptionType.sendTimeout) {
        msg = 'El servidor tardó demasiado en responder (tiempo agotado).';
      } else if (e.type == DioExceptionType.badResponse) {
        msg = 'El servidor respondió con un error (${e.response?.statusCode}).';
      }
      return AuthResult.error(AuthErrorType.networkError, msg);
    } catch (e, stack) {
      debugPrint('Error en el servicio de autenticación: $e');
      await TelemetryService.instance.recordError(
        e,
        stack,
        reason: 'Auth.authenticate failed',
      );
      return const AuthResult.error(
        AuthErrorType.serverError,
        'Ocurrió un error inesperado al validar tus credenciales.',
      );
    } finally {
      isAuthenticating = false;
      notifyListeners();
    }
  }

  /// Compatibilidad retroactiva con llamadas booleanas.
  Future<bool> login({required String username, required String password}) async {
    final res = await authenticate(username: username, password: password);
    return res.success;
  }

  Future<void> logout() async {
    await TelemetryService.instance.logEvent('logout');
    userAccount = null;
    await _storageService.clearSession();
    notifyListeners();
  }
}
