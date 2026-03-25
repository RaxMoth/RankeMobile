<<<<<<< HEAD
=======
/// Typed API errors for consistent error handling across the app.
/// Use with `Either<ApiError, T>` from fpdart in repository methods.
>>>>>>> 88d3438 (good progress)
sealed class ApiError {
  const ApiError();
}

<<<<<<< HEAD
class ApiNetworkError extends ApiError {
  final String? message;

  const ApiNetworkError({this.message});

  @override
  String toString() => message ?? 'No internet connection';
}

=======
/// No network connectivity
class ApiNetworkError extends ApiError {
  const ApiNetworkError();

  @override
  String toString() => 'No network connection';
}

/// Known error from the server error envelope
>>>>>>> 88d3438 (good progress)
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
<<<<<<< HEAD
  String toString() => message;
}

class ApiUnknownError extends ApiError {
  final dynamic originalError;

  const ApiUnknownError({this.originalError});

  @override
  String toString() => 'An unexpected error occurred';
=======
  String toString() => 'ApiServerError($statusCode): $code — $message';
}

/// Unexpected / unknown error
class ApiUnknownError extends ApiError {
  final Object? error;

  const ApiUnknownError({this.error});

  @override
  String toString() => 'ApiUnknownError: $error';
>>>>>>> 88d3438 (good progress)
}
