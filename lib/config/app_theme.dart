import 'package:flutter/material.dart';

class AppTheme {
  static const Color primaryColor = Color.fromARGB(255, 118, 206, 121);
  static const Color secondColor = Color.fromARGB(255, 199, 234, 187);
  static const Color thirdColor = Color.fromARGB(255, 162, 203, 139);
  static const Color orangeBadge = Color.fromARGB(255, 255, 195, 106);

  ThemeData get lightTheme => ThemeData(
    colorSchemeSeed: primaryColor,
    appBarTheme: const AppBarTheme(
      elevation: 10,
      shadowColor: Colors.black45,
      backgroundColor: primaryColor,
      foregroundColor: Colors.white,
    ),
  );
}