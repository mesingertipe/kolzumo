import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Servicio de Autenticación Biométrica (Huella Digital / Face ID).
/// Gestiona:
/// 1. Detección de hardware biométrico en el dispositivo.
/// 2. Invitación en el primer inicio de sesión exitoso.
/// 3. Activación / Desactivación desde el apartado de Seguridad.
/// 4. Autenticación rápida con un toque en la pantalla de Login.
class BiometricService extends ChangeNotifier {
  final LocalAuthentication _localAuth = LocalAuthentication();

  static const String _keyBiometricEnabled = 'biometric_auth_enabled';
  static const String _keyBiometricUsername = 'biometric_saved_username';
  static const String _keyBiometricSecret = 'biometric_saved_secret';
  static const String _keyPromptedPrefix = 'biometric_prompted_user_';
  static const String _keyRememberedUser = 'remembered_last_username';

  bool _isHardwareAvailable = false;
  bool _isEnabled = false;
  String? _savedUsername;
  String? _rememberedUsername;

  bool get isHardwareAvailable => _isHardwareAvailable;
  bool get isEnabled => _isEnabled && _savedUsername != null;
  String? get savedUsername => _savedUsername;
  String? get rememberedUsername => _rememberedUsername;

  Future<void> init() async {
    final prefs = await SharedPreferences.getInstance();
    _isEnabled = prefs.getBool(_keyBiometricEnabled) ?? false;
    _savedUsername = prefs.getString(_keyBiometricUsername);
    _rememberedUsername = prefs.getString(_keyRememberedUser);

    if (!kIsWeb) {
      try {
        final isSupported = await _localAuth.isDeviceSupported();
        final canCheck = await _localAuth.canCheckBiometrics;
        final availableBiometrics = await _localAuth.getAvailableBiometrics();
        _isHardwareAvailable =
            (isSupported && canCheck) || availableBiometrics.isNotEmpty;
      } catch (e) {
        debugPrint('Biometría no disponible en este dispositivo: $e');
        _isHardwareAvailable = false;
      }
    }
    notifyListeners();
  }

  Future<void> saveRememberedUsername(String? username) async {
    final prefs = await SharedPreferences.getInstance();
    if (username == null || username.trim().isEmpty) {
      await prefs.remove(_keyRememberedUser);
      _rememberedUsername = null;
    } else {
      await prefs.setString(_keyRememberedUser, username.trim());
      _rememberedUsername = username.trim();
    }
    notifyListeners();
  }

  /// Verifica si al usuario ya se le preguntó en su primer inicio de sesión
  /// si desea activar el ingreso con biometría.
  Future<bool> shouldPromptFirstTime(String username) async {
    if (!_isHardwareAvailable || _isEnabled) return false;
    final prefs = await SharedPreferences.getInstance();
    final key = '$_keyPromptedPrefix${username.trim().toLowerCase()}';
    return !(prefs.getBool(key) ?? false);
  }

  Future<void> markPrompted(String username) async {
    final prefs = await SharedPreferences.getInstance();
    final key = '$_keyPromptedPrefix${username.trim().toLowerCase()}';
    await prefs.setBool(key, true);
  }

  /// Solicita validación de huella / Face ID al sistema operativo.
  Future<bool> verifyBiometric({
    String reason = 'Confirma tu identidad con huella o reconocimiento facial',
  }) async {
    if (!_isHardwareAvailable) return false;
    try {
      return await _localAuth.authenticate(
        localizedReason: reason,
        options: const AuthenticationOptions(
          stickyAuth: true,
          biometricOnly: false,
          useErrorDialogs: true,
        ),
      );
    } on PlatformException catch (e) {
      debugPrint('Error en autenticación biométrica: $e');
      return false;
    }
  }

  /// Activa el acceso biométrico tras validar la huella del vendedor.
  Future<bool> enableBiometrics({
    required String username,
    required String password,
  }) async {
    final verified = await verifyBiometric(
      reason: 'Valida tu huella o Face ID para activar el acceso biométrico',
    );
    if (!verified) return false;

    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyBiometricEnabled, true);
    await prefs.setString(_keyBiometricUsername, username.trim());
    await prefs.setString(_keyBiometricSecret, password);
    await markPrompted(username);

    _isEnabled = true;
    _savedUsername = username.trim();
    notifyListeners();
    return true;
  }

  /// Desactiva el acceso biométrico y limpia las credenciales asociadas.
  Future<void> disableBiometrics() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyBiometricEnabled, false);
    await prefs.remove(_keyBiometricSecret);
    _isEnabled = false;
    notifyListeners();
  }

  /// Autentica con biometría en el Login y retorna las credenciales guardadas.
  Future<({String username, String password})?> authenticateAndGetCredentials() async {
    if (!isEnabled) return null;
    final verified = await verifyBiometric(
      reason: 'Ingresa a KolZumo con tu huella o Face ID',
    );
    if (!verified) return null;

    final prefs = await SharedPreferences.getInstance();
    final user = prefs.getString(_keyBiometricUsername);
    final pass = prefs.getString(_keyBiometricSecret);
    if (user == null || pass == null) return null;
    return (username: user, password: pass);
  }
}
