import 'dart:async';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/foundation.dart';
import '../../firebase_options.dart';
import '../config/app_config.dart';
import 'demo_api_interceptor.dart';

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  try {
    await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  } catch (_) {}
}

class PushNotificationEvent {
  final String title;
  final String body;
  final Map<String, dynamic> data;
  final DateTime receivedAt;

  const PushNotificationEvent({
    required this.title,
    required this.body,
    this.data = const {},
    required this.receivedAt,
  });
}

/// Servicio unificado de Firebase:
/// - Crashlytics (errores fatales, no fatales y contexto del vendedor/ruta/build)
/// - Remote Config (validación de versión mínima por build y parámetros dinámicos)
/// - Cloud Messaging (Push Notifications en primer y segundo plano)
/// - Analytics (eventos operativos y estadísticas de ventas)
class TelemetryService extends ChangeNotifier {
  TelemetryService._();
  static final TelemetryService instance = TelemetryService._();

  bool _isInitialized = false;
  String? _fcmToken;
  PushNotificationEvent? _latestNotification;

  bool get isInitialized => _isInitialized;
  String? get fcmToken => _fcmToken;

  PushNotificationEvent? consumeLatestNotification() {
    final n = _latestNotification;
    _latestNotification = null;
    return n;
  }

  Future<void> initialize() async {
    await AppConfig.instance.initPackageInfo();

    try {
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );
      _isInitialized = true;

      // Remote Config primero para sincronizar parámetros inmediatamente
      await _setupRemoteConfig();
      await _setupCrashlytics();
      await _setupPushNotifications();
    } catch (e, stack) {
      debugPrint('Firebase inicializó en modo local/resiliente: $e\n$stack');
      _isInitialized = false;
    }
    notifyListeners();
  }

  Future<void> _setupCrashlytics() async {
    if (kIsWeb) return;
    final crashlytics = FirebaseCrashlytics.instance;
    await crashlytics.setCrashlyticsCollectionEnabled(true);

    await crashlytics.setCustomKey('app_version', AppConfig.instance.versionName);
    await crashlytics.setCustomKey('build_number', AppConfig.instance.buildNumber);

    FlutterError.onError = (errorDetails) {
      crashlytics.recordFlutterFatalError(errorDetails);
    };

    PlatformDispatcher.instance.onError = (error, stack) {
      crashlytics.recordError(error, stack, fatal: true);
      return true;
    };
  }

  Future<void> _setupRemoteConfig() async {
    try {
      final remoteConfig = FirebaseRemoteConfig.instance;
      await remoteConfig.setConfigSettings(
        RemoteConfigSettings(
          fetchTimeout: const Duration(seconds: 10),
          minimumFetchInterval: Duration.zero,
        ),
      );

      await remoteConfig.setDefaults({
        'api_base_url': AppConfig.instance.apiBaseUrl,
        'brand_name': AppConfig.instance.brandName,
        'ticket_footer': AppConfig.instance.ticketFooter,
        'seller_profile_id': AppConfig.instance.sellerProfileId,
        'min_required_build_android': 1,
        'latest_build_android': AppConfig.instance.buildNumber,
        'min_required_build_ios': 1,
        'latest_build_ios': AppConfig.instance.buildNumber,
        'force_update_message': AppConfig.instance.forceUpdateMessage,
        'demo_mode_enabled': AppConfig.instance.demoModeEnabled,
        'store_url_android':
            'https://play.google.com/store/apps/details?id=co.com.kolzumo.app',
        'store_url_ios': 'https://apps.apple.com',
      });

      final fetched = await remoteConfig.fetchAndActivate();
      debugPrint('Remote Config fetchAndActivate completado: $fetched');
      _syncRemoteValues(remoteConfig);

      remoteConfig.onConfigUpdated.listen((_) async {
        await remoteConfig.activate();
        _syncRemoteValues(remoteConfig);
      });
    } catch (e) {
      debugPrint('Remote Config usará valores por defecto: $e');
    }
  }

  void _syncRemoteValues(FirebaseRemoteConfig rc) {
    final isIos = defaultTargetPlatform == TargetPlatform.iOS;
    final minBuild = rc.getInt(
      isIos ? 'min_required_build_ios' : 'min_required_build_android',
    );
    final latestBuild = rc.getInt(
      isIos ? 'latest_build_ios' : 'latest_build_android',
    );

    final isDemoRemote = rc.getBool('demo_mode_enabled');
    debugPrint('Sincronizando Remote Config: demo_mode_enabled = $isDemoRemote');

    AppConfig.instance.applyRemoteConfig(
      apiBaseUrl: rc.getString('api_base_url'),
      brandName: rc.getString('brand_name'),
      ticketFooter: rc.getString('ticket_footer'),
      sellerProfileId: rc.getInt('seller_profile_id'),
      minRequiredBuild: minBuild,
      latestRecommendedBuild: latestBuild,
      forceUpdateMessage: rc.getString('force_update_message'),
      demoModeEnabled: isDemoRemote,
      storeUrlAndroid: rc.getString('store_url_android'),
      storeUrlIos: rc.getString('store_url_ios'),
    );
    if (isDemoRemote) {
      DemoApiInterceptor.instance.activateDemoMode();
    } else {
      DemoApiInterceptor.instance.deactivateDemoMode();
    }
    notifyListeners();
  }

  Future<void> _setupPushNotifications() async {
    if (kIsWeb) return;
    try {
      FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
      final messaging = FirebaseMessaging.instance;

      await messaging.requestPermission(
        alert: true,
        badge: true,
        sound: true,
      );

      _fcmToken = await messaging.getToken();
      await messaging.subscribeToTopic('kolzumo_vendedores');

      FirebaseMessaging.onMessage.listen((RemoteMessage message) {
        final notification = message.notification;
        if (notification != null) {
          _latestNotification = PushNotificationEvent(
            title: notification.title ?? 'Notificación KolZumo',
            body: notification.body ?? '',
            data: message.data,
            receivedAt: DateTime.now(),
          );
          notifyListeners();
        }
      });
    } catch (e) {
      debugPrint('Push Notifications no disponibles en este entorno: $e');
    }
  }

  Future<void> setUserContext({
    required int idVendedor,
    required String nombreVendedor,
    String? rutaActiva,
    String? placaVehiculo,
  }) async {
    if (!_isInitialized || kIsWeb) return;
    try {
      final crashlytics = FirebaseCrashlytics.instance;
      await crashlytics.setUserIdentifier('vendedor_$idVendedor');
      await crashlytics.setCustomKey('id_vendedor', idVendedor);
      await crashlytics.setCustomKey('nombre_vendedor', nombreVendedor);
      if (rutaActiva != null) {
        await crashlytics.setCustomKey('ruta_activa', rutaActiva);
      }
      if (placaVehiculo != null) {
        await crashlytics.setCustomKey('vehiculo_placa', placaVehiculo);
      }

      await FirebaseAnalytics.instance.setUserId(id: 'vendedor_$idVendedor');
      await FirebaseAnalytics.instance.setUserProperty(
        name: 'ruta_activa',
        value: rutaActiva ?? 'sin_ruta',
      );
    } catch (_) {}
  }

  Future<void> recordError(
    dynamic error,
    StackTrace? stackTrace, {
    String? reason,
    bool fatal = false,
  }) async {
    debugPrint('[$reason] Error: $error');
    if (!_isInitialized || kIsWeb) return;
    try {
      await FirebaseCrashlytics.instance.recordError(
        error,
        stackTrace,
        reason: reason,
        fatal: fatal,
      );
    } catch (_) {}
  }

  Future<void> logEvent(String name, [Map<String, Object>? parameters]) async {
    if (!_isInitialized) return;
    try {
      await FirebaseAnalytics.instance.logEvent(
        name: name,
        parameters: parameters,
      );
    } catch (_) {}
  }
}

