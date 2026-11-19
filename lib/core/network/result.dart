/// Resultado funcional para operaciones de negocio y datos en KolZumo.
/// Modela éxito con [Success] o falla controlada con [Failure].
sealed class Result<T> {
  const Result();

  factory Result.ok(T data) = Success<T>;
  factory Result.fail(AppFailure failure) = Failure<T>;

  bool get isSuccess => this is Success<T>;
  bool get isFailure => this is Failure<T>;

  T? get dataOrNull => switch (this) {
        Success(data: final d) => d,
        Failure() => null,
      };

  AppFailure? get failureOrNull => switch (this) {
        Success() => null,
        Failure(failure: final f) => f,
      };

  R when<R>({
    required R Function(T data) success,
    required R Function(AppFailure failure) failure,
  }) {
    return switch (this) {
      Success(data: final d) => success(d),
      Failure(failure: final f) => failure(f),
    };
  }
}

class Success<T> extends Result<T> {
  final T data;
  const Success(this.data);
}

class Failure<T> extends Result<T> {
  final AppFailure failure;
  const Failure(this.failure);
}

/// Jerarquía de errores formales de la aplicación KolZumo
sealed class AppFailure {
  final String message;
  final Object? error;
  final StackTrace? stackTrace;

  const AppFailure(this.message, {this.error, this.stackTrace});

  @override
  String toString() => '$runtimeType: $message';
}

/// Fallas de red o falta de conexión
class NetworkFailure extends AppFailure {
  const NetworkFailure([
    String message = 'Sin conexión a internet o tiempo de espera agotado.',
    Object? error,
    StackTrace? stackTrace,
  ]) : super(message, error: error, stackTrace: stackTrace);
}

/// Fallas del servidor VPS / HTTP 500 / 400
class ServerFailure extends AppFailure {
  final int? statusCode;
  const ServerFailure(super.message, {this.statusCode, super.error, super.stackTrace});
}

/// Fallas de base de datos local SQLite (Drift)
class DatabaseFailure extends AppFailure {
  const DatabaseFailure(super.message, {super.error, super.stackTrace});
}

/// Fallas de lógica de negocio o validación (cupo de crédito excedido, etc.)
class BusinessFailure extends AppFailure {
  const BusinessFailure(super.message, {super.error, super.stackTrace});
}

