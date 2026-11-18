import 'package:dio/dio.dart';
import 'package:kolzumo_app/core/network/api_client.dart';
import 'package:kolzumo_app/infrastructure/models/userauth.dart';

class UsuarioService {
  final Dio _dio = ApiClient.instance.dio;

  Future<UserAuth> getUser({required String username}) async {
    try {
      final Response response = await _dio.post(
        '/usuarios/validarusuario',
        data: {
          'nombre': username.trim(),
        },
      );

      if (response.statusCode == 200 && response.data is Map<String, dynamic>) {
        final data = response.data as Map<String, dynamic>;
        if (data['nombre'] == 'error en el back end' ||
            data['idusuario'] == null ||
            data['idusuario'] == 0) {
          return _nullUser(
            username,
            mensaje: data['mensaje']?.toString() ?? 'Usuario no encontrado',
          );
        }
        return UserAuth.fromJson(data);
      } else {
        throw Exception('Respuesta inválida del servidor (${response.statusCode})');
      }
    } on DioException {
      rethrow;
    } catch (e) {
      throw Exception('Error al consultar usuario: $e');
    }
  }

  UserAuth _nullUser(String nombre, {String mensaje = ''}) {
    return UserAuth(
      idusuario: 0,
      nombre: nombre,
      documento: null,
      direccion: null,
      telefono: null,
      email: null,
      clave: '',
      idperfil: 0,
      nombreperfil: '',
      estado: 0,
      nombreestado: '',
      fechaestado: DateTime.now(),
      mensaje: mensaje,
      autorizado: false,
      idvendedor: -1,
    );
  }
}
