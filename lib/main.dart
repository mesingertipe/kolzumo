import 'package:flutter/material.dart';
import 'package:kolzumo_app/app/app_providers.dart';
import 'package:kolzumo_app/app/app_routes.dart';
import 'package:kolzumo_app/app/auth_gate.dart';
import 'package:kolzumo_app/data/repositories/resumen_dia_repo.dart';
import 'package:kolzumo_app/infrastructure/models/userauth.dart';
import 'package:kolzumo_app/services/storage_service.dart';
import 'package:provider/provider.dart';
import 'data/database/database.dart';
import 'data/repositories/precios_repo.dart';
import 'config/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
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
    ));
}

class MainApp extends StatelessWidget {

  final UserAuth? initialUser;
  final AppDatabase database;
  final PreciosRepository preciosRepository;
  final ResumenDiaRepository resumenDiaRepository;

  const MainApp({
    super.key, 
    this.initialUser, 
    required this.database, 
    required this.preciosRepository,
    required this.resumenDiaRepository
  });

  @override
  Widget build(BuildContext context) { 

    return MultiProvider(
      providers: buildAppProviders(
        database: database, 
        preciosRepository: preciosRepository, 
        resumenDiaRepository: resumenDiaRepository,
        initialUser: initialUser
      ),
      child: MaterialApp(
          theme: AppTheme().lightTheme,
          debugShowCheckedModeBanner: false,
          home: const AuthGate(),
          routes: AppRoutes.routes,
        ),
    );
  }
}
