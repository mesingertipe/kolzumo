import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../infrastructure/models/userauth.dart';

class StorageService {
  static const String _sessionKey = 'user_session';
  static const String _inventarioKey = 'inventario_sincronizado';
  static const String _consecutivoPrefixKey = 'consecutivo_prefix_vendedor_';
  static const String _consecutivoPadKey = 'consecutivo_pad_vendedor_';

  /// Recupera la sesión del disco de forma segura y devuelve el objeto listo o null.
  Future<UserAuth?> getSavedSession() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final String? userSessionRaw = prefs.getString(_sessionKey);

      if (userSessionRaw == null) return null;

      final Map<String, dynamic> userMap = jsonDecode(userSessionRaw);
      return UserAuth.fromJson(userMap);
    } catch (e) {
      debugPrint('Error en StorageService al leer la sesión: $e');
      return null;
    }
  }

  /// Guarda la sesión en el disco local
  Future<void> saveSession(UserAuth user) async {
    final prefs = await SharedPreferences.getInstance();
    final String userAccountLog = jsonEncode(user.toJson());
    await prefs.setString(_sessionKey, userAccountLog);
  }

  /// Elimina la sesión del almacenamiento
  Future<void> clearSession() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_sessionKey);
  }

  // * Inventario y Sincronización por Vendedor

  Future<bool> yaSincronizado(int idVendedor) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('${_inventarioKey}_$idVendedor') ??
        prefs.getBool(_inventarioKey) ??
        false;
  }

  Future<void> marcarSincronizado(int idVendedor) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('${_inventarioKey}_$idVendedor', true);
    await prefs.setBool(_inventarioKey, true);
  }

  /// Útil para forzar resync manual o al cerrar el día / sesión
  Future<void> resetear([int? idVendedor]) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_inventarioKey);
    if (idVendedor != null) {
      await prefs.remove('${_inventarioKey}_$idVendedor');
    }
  }

  // * Prefijo dinámico del consecutivo del vendedor (Cero Hardcoding)

  Future<void> saveConsecutivoFormat({
    required int idVendedor,
    required String prefix,
    required int padWidth,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('$_consecutivoPrefixKey$idVendedor', prefix);
    await prefs.setInt('$_consecutivoPadKey$idVendedor', padWidth);
  }

  Future<({String prefix, int padWidth})> getConsecutivoFormat(
    int idVendedor,
  ) async {
    final prefs = await SharedPreferences.getInstance();
    final prefix = prefs.getString('$_consecutivoPrefixKey$idVendedor') ?? '';
    final padWidth = prefs.getInt('$_consecutivoPadKey$idVendedor') ?? 4;
    return (prefix: prefix, padWidth: padWidth);
  }
}
