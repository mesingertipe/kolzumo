import 'package:flutter/material.dart';
import 'package:kolzumo_app/infrastructure/models/userauth.dart';
import 'package:kolzumo_app/services/storage_service.dart';
import '../services/usuarioservice.dart';

class Auth extends ChangeNotifier {
  
  UsuarioService usuarioService = UsuarioService();
  final StorageService _storageService = StorageService();

  UserAuth? userAccount;

  Auth({this.userAccount});

  Future<bool> login({required String username, required String password}) async {

    try {
      
      UserAuth respoUserValidate = await usuarioService.getUser(username: username);


      // Validar perfil 5 (Vendedor) y estado activo 
      if (respoUserValidate.idperfil == 5 && respoUserValidate.estado == 1) {

        // Validar clave
        if (password == respoUserValidate.clave) {

          userAccount = respoUserValidate;

          await _storageService.saveSession(userAccount!);

          notifyListeners();
          return true;

        } else {
          return false;
        }       

      }else{
        return false;
      }  
      
    } catch (e) {
      debugPrint('Error en el servicio de autenticación: $e');
      return false;
    }

  }

  Future<void> logout() async {
    userAccount = null;
    
    await _storageService.clearSession();
    notifyListeners();
  }
}
