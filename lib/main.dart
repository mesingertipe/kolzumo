import 'package:flutter/material.dart';
import 'package:kolzumo_app/app/app_providers.dart';
import 'package:kolzumo_app/app/app_routes.dart';
import 'package:kolzumo_app/app/auth_gate.dart';
import 'package:kolzumo_app/core/config/app_config.dart';
import 'package:kolzumo_app/core/services/biometric_service.dart';
import 'package:kolzumo_app/core/services/telemetry_service.dart';
import 'package:kolzumo_app/core/theme/theme_controller.dart';
import 'package:kolzumo_app/data/repositories/resumen_dia_repo.dart';
import 'package:kolzumo_app/infrastructure/models/userauth.dart';
import 'package:kolzumo_app/presentation/utils/items_ui/version_guard_wrapper.dart';
import 'package:kolzumo_app/services/storage_service.dart';
import 'package:provider/provider.dart';
import 'data/database/database.dart';
import 'data/repositories/precios_repo.dart';
import 'config/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Inicializa Firebase (Crashlytics, Remote Config, FCM, Analytics) y PackageInfo
  await TelemetryService.instance.initialize();

  // Inicializa servicio biométrico (Huella / Face ID)
  final biometricService = BiometricService();
  await biometricService.init();

  // Inicializa preferencia de tema visual (Claro / Oscuro)
  final themeController = ThemeController();
  await themeController.init();

  final database = AppDatabase();
  final preciosRepository = PreciosRepository(database);
  final resumenDiaRepository = ResumenDiaRepository(database);

  final storageService = StorageService();
  final UserAuth? initialUser = await storageService.getSavedSession();

  runApp(
    MainApp(
      initialUser: initialUser,
      database: database,
      preciosRepository: preciosRepository,
      resumenDiaRepository: resumenDiaRepository,
      biometricService: biometricService,
      themeController: themeController,
    ),
  );
}

class MainApp extends StatelessWidget {
  final UserAuth? initialUser;
  final AppDatabase database;
  final PreciosRepository preciosRepository;
  final ResumenDiaRepository resumenDiaRepository;
  final BiometricService biometricService;
  final ThemeController themeController;

  const MainApp({
    super.key,
    this.initialUser,
    required this.database,
    required this.preciosRepository,
    required this.resumenDiaRepository,
    required this.biometricService,
    required this.themeController,
  });

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: buildAppProviders(
        database: database,
        preciosRepository: preciosRepository,
        resumenDiaRepository: resumenDiaRepository,
        initialUser: initialUser,
        biometricService: biometricService,
        themeController: themeController,
      ),
      child: Consumer<ThemeController>(
        builder: (context, themeCtrl, _) {
          return MaterialApp(
            title: AppConfig.instance.brandName,
            theme: AppTheme().lightTheme,
            darkTheme: AppTheme().darkTheme,
            themeMode: themeCtrl.themeMode,
            debugShowCheckedModeBanner: false,
            builder: (context, child) => VersionGuardWrapper(
              child: child ?? const SizedBox.shrink(),
            ),
            home: const AuthGate(),
            routes: AppRoutes.routes,
          );
        },
      ),
    );
  }
}
