import 'package:flutter/foundation.dart';
import 'package:package_info_plus/package_info_plus.dart';

/// Configuración centralizada de la aplicación (Cero Hardcoding).
/// Combina variables de compilación (--dart-define) con actualización
/// en caliente desde Firebase Remote Config y metadatos reales del paquete.
class AppConfig extends ChangeNotifier {
  AppConfig._();
  static final AppConfig instance = AppConfig._();

  static const String _defaultApiBaseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'http://vps.easesoft.com.co:8080/BackRutaVenta-0.0.1-SNAPSHOT',
  );
  static const String _defaultBrandName = String.fromEnvironment(
    'BRAND_NAME',
    defaultValue: 'KolZumo',
  );
  static const String _defaultTicketFooter = String.fromEnvironment(
    'TICKET_FOOTER',
    defaultValue: 'Gracias por su compra\nSoftware KolZumo',
  );
  static const int _defaultSellerProfileId = int.fromEnvironment(
    'SELLER_PROFILE_ID',
    defaultValue: 5,
  );
  static const bool _defaultDemoModeEnabled = bool.fromEnvironment(
    'DEMO_MODE_ENABLED',
    defaultValue: true,
  );

  String _apiBaseUrl = _defaultApiBaseUrl;
  String _brandName = _defaultBrandName;
  String _ticketFooter = _defaultTicketFooter;
  int _sellerProfileId = _defaultSellerProfileId;
  bool _demoModeEnabled = _defaultDemoModeEnabled;

  // Control de versiones por Build desde Firebase Remote Config
  int _minRequiredBuild = 1;
  int _latestRecommendedBuild = 1;
  String _forceUpdateMessage =
      'Existe una nueva versión obligatoria de KolZumo para continuar operando en ruta.';
  String _storeUrlAndroid =
      'https://play.google.com/store/apps/details?id=co.com.kolzumo.app';
  String _storeUrlIos = 'https://apps.apple.com';

  // Metadatos reales del APK / IPA
  String _appName = 'KolZumo';
  String _packageName = 'co.com.kolzumo.app';
  String _versionName = '0.1.0';
  int _buildNumber = 1;

  String get apiBaseUrl => _apiBaseUrl;
  String get brandName => _brandName;
  String get ticketFooter => _ticketFooter;
  int get sellerProfileId => _sellerProfileId;
  bool get demoModeEnabled => _demoModeEnabled;

  int get minRequiredBuild => _minRequiredBuild;
  int get latestRecommendedBuild => _latestRecommendedBuild;
  String get forceUpdateMessage => _forceUpdateMessage;
  String get storeUrl =>
      defaultTargetPlatform == TargetPlatform.iOS ? _storeUrlIos : _storeUrlAndroid;

  String get appName => _appName;
  String get packageName => _packageName;
  String get versionName => _versionName;
  int get buildNumber => _buildNumber;
  String get fullVersionLabel => 'v$_versionName (Build $_buildNumber)';

  bool get isForceUpdateRequired => _buildNumber < _minRequiredBuild;
  bool get isOptionalUpdateAvailable =>
      !isForceUpdateRequired && _buildNumber < _latestRecommendedBuild;

  Future<void> initPackageInfo() async {
    try {
      final info = await PackageInfo.fromPlatform();
      _appName = info.appName.isNotEmpty ? info.appName : _brandName;
      _packageName = info.packageName;
      _versionName = info.version;
      _buildNumber = int.tryParse(info.buildNumber) ?? 1;
      notifyListeners();
    } catch (e) {
      debugPrint('No se pudo leer PackageInfo: $e');
    }
  }

  void applyRemoteConfig({
    String? apiBaseUrl,
    String? brandName,
    String? ticketFooter,
    int? sellerProfileId,
    int? minRequiredBuild,
    int? latestRecommendedBuild,
    String? forceUpdateMessage,
    String? storeUrlAndroid,
    String? storeUrlIos,
    bool? demoModeEnabled,
  }) {
    if (apiBaseUrl != null && apiBaseUrl.trim().isNotEmpty) {
      _apiBaseUrl = apiBaseUrl.trim().replaceAll(RegExp(r'/+$'), '');
    }
    if (brandName != null && brandName.trim().isNotEmpty) {
      _brandName = brandName.trim();
    }
    if (ticketFooter != null && ticketFooter.trim().isNotEmpty) {
      _ticketFooter = ticketFooter.trim();
    }
    if (sellerProfileId != null && sellerProfileId > 0) {
      _sellerProfileId = sellerProfileId;
    }
    if (minRequiredBuild != null && minRequiredBuild > 0) {
      _minRequiredBuild = minRequiredBuild;
    }
    if (latestRecommendedBuild != null && latestRecommendedBuild > 0) {
      _latestRecommendedBuild = latestRecommendedBuild;
    }
    if (forceUpdateMessage != null && forceUpdateMessage.trim().isNotEmpty) {
      _forceUpdateMessage = forceUpdateMessage.trim();
    }
    if (storeUrlAndroid != null && storeUrlAndroid.trim().isNotEmpty) {
      _storeUrlAndroid = storeUrlAndroid.trim();
    }
    if (storeUrlIos != null && storeUrlIos.trim().isNotEmpty) {
      _storeUrlIos = storeUrlIos.trim();
    }
    if (demoModeEnabled != null) {
      _demoModeEnabled = demoModeEnabled;
    }
    notifyListeners();
  }
}

