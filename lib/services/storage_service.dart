import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../infrastructure/models/userauth.dart';

class StorageService {
  static const String _sessionKey = 'user_session';
  static const String _inventarioKey = 'inventario_sincronizado';

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

  // * Inventario

  Future<bool> yaSincronizado(int idVendedor) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_inventarioKey) ?? false;
  }

  Future<void> marcarSincronizado(int idVendedor) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_inventarioKey, true);
  }

  /// Útil para forzar resync manual o al cerrar sesión
  Future<void> resetear() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_inventarioKey);
  }
}