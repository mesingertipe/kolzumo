import 'package:dio/dio.dart';
import 'package:kolzumo_app/infrastructure/models/userauth.dart';

class UsuarioService {

  Future<UserAuth> getUser({required String username}) async {

    try {

      Response response = await Dio().post('http://vps.easesoft.com.co:8080/BackRutaVenta-0.0.1-SNAPSHOT/usuarios/validarusuario',
        data: {
          'nombre': username,
        },

      );

      if (response.statusCode == 200) {
        
        // Manejo de error de usuario de acuerdo con respuesta del back end
        if (response.data['nombre'] == 'error en el back end') {
          return _nullUser('');
        } else {
          
          UserAuth userValidated = UserAuth.fromJson(response.data);
          return userValidated;

        }

      } else {
        
        throw Exception('Failed to load data');

      }

    } catch (e) {
      
      throw Exception('Failed to fetch data: $e');
    }
  }

  UserAuth _nullUser(String nombre){
    UserAuth userNull;
    userNull = UserAuth(
      idusuario: 0, nombre: nombre, documento: null, direccion: null, telefono: null, email: null, clave: '', idperfil: 0, nombreperfil: '', estado: 0, nombreestado: '', fechaestado: DateTime.now(), mensaje: '', autorizado: false, idvendedor: -1
      );

    return userNull;
  }
}