sealed class ApiError {
  const ApiError();
}

class ApiNetworkError extends ApiError {
  final String? message;

  const ApiNetworkError({this.message});

  @override
  String toString() => message ?? 'No internet connection';
}

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
  String toString() => message;
}

class ApiUnknownError extends ApiError {
  final dynamic originalError;

  const ApiUnknownError({this.originalError});

  @override
  String toString() => 'An unexpected error occurred';
}
