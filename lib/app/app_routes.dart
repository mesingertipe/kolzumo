import 'package:flutter/material.dart';
import '../presentation/screens/form_ruta.dart';
import '../presentation/screens/paycheckout_screen.dart';
import '../presentation/screens/printer_devices_screen.dart';
import '../presentation/screens/profile.dart';
import '../presentation/screens/screen_customer.dart';
import '../presentation/screens/screen_home.dart';
import '../presentation/screens/settings.dart';
import '../presentation/screens/stock_screen.dart';

class AppRoutes {
  AppRoutes._();

  static const home = '/home';
  static const ruta = '/ruta';
  static const profile = '/profile';
  static const customers = '/customers';
  static const settings = '/settings';
  static const stock = '/stock';
  static const cart = '/cart';
  static const printers = '/printers';

  static Map<String, WidgetBuilder> get routes => {
    home: (_) => HomeApp(),
    ruta: (_) => const FormRuta(),
    profile: (_) => const ProfileScreen(),
    customers: (_) => const CustomersScreen(),
    settings: (_) => const SettingsScreen(),
    stock: (_) => const StockScreen(),
    cart: (_) => const CheckoutScreen(),
    printers: (_) => const ThermalPrinterScreen(),
  };
}