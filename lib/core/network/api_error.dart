import '../strings.dart';
import 'api_error_codes.dart';

/// Typed API errors for consistent error handling across the app.
/// Use with `Either<ApiError, T>` from fpdart in repository methods.
sealed class ApiError {
  const ApiError();
}

/// No network connectivity
class ApiNetworkError extends ApiError {
  const ApiNetworkError();

  @override
  String toString() => 'No network connection';
}

/// Known error from the server error envelope
class ApiServerError extends ApiError {
  final String code;
  final String message;
  final int statusCode;

  const ApiServerError({
    required this.code,
    required this.message,
    required this.statusCode,
  });

  @override
  String toString() => 'ApiServerError($statusCode): $code — $message';
}

/// Unexpected / unknown error
class ApiUnknownError extends ApiError {
  final Object? error;

  const ApiUnknownError({this.error});

  @override
  String toString() => 'ApiUnknownError: $error';
}

extension ApiErrorMessage on ApiError {
  /// User-facing message safe to surface in the UI (SnackBars, `ErrorView`).
  /// Prefer this over `toString()`, which returns developer text (status
  /// codes, error codes) that must never reach the user.
  ///
  /// The backend writes its error messages for end users, so a known code
  /// shows the server's message. Internal errors and anything that didn't
  /// come from the backend's error envelope (proxies, HTML error pages,
  /// unknown codes) fall back to a generic message.
  String get userMessage => switch (this) {
    ApiNetworkError() => S.noNetwork,
    ApiServerError(code: ApiErrorCode.internalError) => S.genericError,
    ApiServerError(code: ApiErrorCode.rateLimited) => S.rateLimited,
    ApiServerError(:final code, :final message)
        when ApiErrorCode.all.contains(code) && message.isNotEmpty =>
      message,
    ApiServerError() => S.genericError,
    ApiUnknownError() => S.genericError,
  };

  /// True when the server rejected the call with [code].
  bool hasCode(String code) =>
      this is ApiServerError && (this as ApiServerError).code == code;
}

/// User-facing text for any error caught in the UI — an [ApiError] shows
/// its [ApiErrorMessage.userMessage], anything else a generic message.
String describeError(Object error) =>
    error is ApiError ? error.userMessage : S.genericError;
