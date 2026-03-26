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
