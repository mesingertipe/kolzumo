import 'package:kolzumo_app/controllers/day_closing_controller.dart';
import 'package:kolzumo_app/core/config/app_config.dart';
import 'package:kolzumo_app/core/services/auto_sync_service.dart';
import 'package:kolzumo_app/core/services/biometric_service.dart';
import 'package:kolzumo_app/core/services/telemetry_service.dart';
import 'package:kolzumo_app/data/repositories/resumen_dia_repo.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import '../controllers/thermal_printer_controller.dart';
import '../data/database/database.dart';
import '../data/repositories/precios_repo.dart';
import '../infrastructure/models/userauth.dart';
import '../logic/auth_logic.dart';
import '../providers/cart_provider.dart';
import '../providers/checkout_provider.dart';
import '../providers/cliente_provider.dart';
import '../providers/inventario_provider.dart';
import '../providers/orders_provider.dart';
import '../providers/precio_provider.dart';
import '../providers/ruta_provider.dart';
import '../providers/vehiculo_provider.dart';
import '../services/session_sync_service.dart';

List<SingleChildWidget> buildAppProviders({
  required AppDatabase database,
  required PreciosRepository preciosRepository,
  required ResumenDiaRepository resumenDiaRepository,
  required UserAuth? initialUser,
  required BiometricService biometricService,
}) {
  return [
    ChangeNotifierProvider<AppConfig>.value(value: AppConfig.instance),
    ChangeNotifierProvider<TelemetryService>.value(
      value: TelemetryService.instance,
    ),
    ChangeNotifierProvider<BiometricService>.value(value: biometricService),
    Provider<AppDatabase>.value(value: database),
    Provider<PreciosRepository>.value(value: preciosRepository),
    Provider<ResumenDiaRepository>.value(value: resumenDiaRepository),
    Provider<SessionSyncService>(
      create: (_) => SessionSyncService(database, preciosRepository),
    ),
    ChangeNotifierProvider(create: (_) => Auth(userAccount: initialUser)),
    ChangeNotifierProvider(create: (_) => RutaProvider()),
    ChangeNotifierProvider(create: (_) => CartProvider()),
    ChangeNotifierProvider(create: (_) => InventarioProvider()),
    ChangeNotifierProvider(create: (_) => ClienteProvider()),
    ChangeNotifierProvider(create: (_) => PreciosProvider()),
    ChangeNotifierProvider(create: (_) => PedidosPendientesProvider()),
    ChangeNotifierProvider(create: (_) => VehiculoProvider()),
    ChangeNotifierProvider(create: (_) => ThermalPrinterController()..init()),
    ChangeNotifierProvider(create: (_) => DayClosingController()),
    ChangeNotifierProxyProvider<Auth, AutoSyncQueueService>(
      create: (ctx) => AutoSyncQueueService(
        database: database,
        resumenDiaRepository: resumenDiaRepository,
        getCurrentUser: () => ctx.read<Auth>().userAccount,
      )..start(),
      update: (ctx, auth, syncService) {
        return syncService ??
            (AutoSyncQueueService(
              database: database,
              resumenDiaRepository: resumenDiaRepository,
              getCurrentUser: () => auth.userAccount,
            )..start());
      },
    ),
    ChangeNotifierProxyProvider<ClienteProvider, CheckoutProvider>(
      create: (_) => CheckoutProvider(),
      update: (_, clienteProvider, checkout) {
        checkout ??= CheckoutProvider();
        checkout.actualizarCliente(clienteProvider.clienteSeleccionado);
        return checkout;
      },
    ),
  ];
}
