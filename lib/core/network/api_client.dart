import 'package:dio/dio.dart';
import '../config/app_config.dart';
import '../services/demo_api_interceptor.dart';
import '../services/telemetry_service.dart';

/// Cliente HTTP centralizado para toda la aplicación.
/// Toma dinámicamente la URL base desde AppConfig (que a su vez puede ser
/// actualizada por Firebase Remote Config o --dart-define), soporta el
/// interceptor de Usuario Demo (demo / 1234) y reporta errores de red a Crashlytics.
class ApiClient {
  ApiClient._() {
    _dio = Dio(
      BaseOptions(
        baseUrl: AppConfig.instance.apiBaseUrl,
        connectTimeout: const Duration(seconds: 15),
        receiveTimeout: const Duration(seconds: 20),
        sendTimeout: const Duration(seconds: 15),
        headers: const {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },
      ),
    );

    _dio.interceptors.add(DemoApiInterceptor.instance);

    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          options.baseUrl = AppConfig.instance.apiBaseUrl;
          handler.next(options);
        },
        onError: (DioException e, handler) {
          TelemetryService.instance.recordError(
            e,
            e.stackTrace,
            reason: 'API Error [${e.requestOptions.method}] ${e.requestOptions.path}',
          );
          handler.next(e);
        },
      ),
    );
  }

  static final ApiClient instance = ApiClient._();
  late final Dio _dio;

  Dio get dio => _dio;
}
