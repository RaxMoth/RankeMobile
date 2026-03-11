/// API Response Model
class ApiResponse<T> {
  final T? data;
  final String? message;
  final bool success;
  final int? statusCode;

  ApiResponse({
    this.data,
    this.message,
    required this.success,
    this.statusCode,
  });

  /// Create success response
  factory ApiResponse.success({required T data, String? message}) {
    return ApiResponse(
      data: data,
      message: message ?? 'Success',
      success: true,
      statusCode: 200,
    );
  }

  /// Create error response
  factory ApiResponse.error({
    required String message,
    int? statusCode,
  }) {
    return ApiResponse(
      message: message,
      success: false,
      statusCode: statusCode ?? 500,
    );
  }
}

/// Pagination Model
class PaginationModel<T> {
  final List<T> items;
  final int currentPage;
  final int totalPages;
  final int totalItems;
  final bool hasNextPage;

  PaginationModel({
    required this.items,
    required this.currentPage,
    required this.totalPages,
    required this.totalItems,
    required this.hasNextPage,
  });

  /// Check if has previous page
  bool get hasPreviousPage => currentPage > 1;

  /// Create pagination from json
  factory PaginationModel.fromJson(
    Map<String, dynamic> json,
    T Function(dynamic) itemParser,
  ) {
    return PaginationModel(
      items: (json['items'] as List).map((e) => itemParser(e)).toList(),
      currentPage: json['currentPage'] ?? 1,
      totalPages: json['totalPages'] ?? 1,
      totalItems: json['totalItems'] ?? 0,
      hasNextPage: json['hasNextPage'] ?? false,
    );
  }
}

/// Generic Exception
class AppException implements Exception {
  final String message;
  final String? code;
  final dynamic originalError;

  AppException({
    required this.message,
    this.code,
    this.originalError,
  });

  @override
  String toString() => message;
}

/// Network Exception
class NetworkException extends AppException {
  NetworkException({
    String message = 'Network error occurred',
    String? code,
    dynamic originalError,
  }) : super(
    message: message,
    code: code ?? 'NETWORK_ERROR',
    originalError: originalError,
  );
}

/// Server Exception
class ServerException extends AppException {
  final int? statusCode;

  ServerException({
    String message = 'Server error occurred',
    this.statusCode,
    String? code,
    dynamic originalError,
  }) : super(
    message: message,
    code: code ?? 'SERVER_ERROR',
    originalError: originalError,
  );
}

/// Cache Exception
class CacheException extends AppException {
  CacheException({
    String message = 'Cache error occurred',
    String? code,
    dynamic originalError,
  }) : super(
    message: message,
    code: code ?? 'CACHE_ERROR',
    originalError: originalError,
  );
}

/// Validation Exception
class ValidationException extends AppException {
  final Map<String, String>? errors;

  ValidationException({
    String message = 'Validation error occurred',
    this.errors,
    String? code,
    dynamic originalError,
  }) : super(
    message: message,
    code: code ?? 'VALIDATION_ERROR',
    originalError: originalError,
  );
}
