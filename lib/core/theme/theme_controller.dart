import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Controlador reactivo del Modo de Tema (Claro, Oscuro o según Sistema)
class ThemeController extends ChangeNotifier {
  static const String _keyThemeMode = 'app_theme_mode_preference';

  ThemeMode _themeMode = ThemeMode.light;

  ThemeMode get themeMode => _themeMode;
  bool get isDarkMode => _themeMode == ThemeMode.dark;

  Future<void> init() async {
    final prefs = await SharedPreferences.getInstance();
    final saved = prefs.getString(_keyThemeMode);
    if (saved == 'dark') {
      _themeMode = ThemeMode.dark;
    } else if (saved == 'system') {
      _themeMode = ThemeMode.system;
    } else {
      _themeMode = ThemeMode.light;
    }
    notifyListeners();
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    if (_themeMode == mode) return;
    _themeMode = mode;
    final prefs = await SharedPreferences.getInstance();
    if (mode == ThemeMode.dark) {
      await prefs.setString(_keyThemeMode, 'dark');
    } else if (mode == ThemeMode.system) {
      await prefs.setString(_keyThemeMode, 'system');
    } else {
      await prefs.setString(_keyThemeMode, 'light');
    }
    notifyListeners();
  }

  Future<void> toggleTheme() async {
    if (_themeMode == ThemeMode.dark) {
      await setThemeMode(ThemeMode.light);
    } else {
      await setThemeMode(ThemeMode.dark);
    }
  }
}

