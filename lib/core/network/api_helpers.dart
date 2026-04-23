import 'package:dio/dio.dart';
import 'package:fpdart/fpdart.dart';
import 'api_error.dart';

/// Backend response envelope contract — must match RankeBE's `response.go`.
///
/// Success: `{ "data": <T> }`
/// Failure: `{ "error": { "code": "<CODE>", "message": "<msg>" } }` + 4xx/5xx
const String _envelopeDataKey = 'data';
const String _envelopeErrorKey = 'error';

/// Wraps a Dio call and maps exceptions to [ApiError].
Future<Either<ApiError, T>> safeApiCall<T>(
  Future<T> Function() call,
) async {
  try {
    final result = await call();
    return Right(result);
  } on DioException catch (e) {
    if (e.type == DioExceptionType.connectionError ||
        e.type == DioExceptionType.connectionTimeout ||
        e.type == DioExceptionType.receiveTimeout ||
        e.type == DioExceptionType.sendTimeout) {
      return const Left(ApiNetworkError());
    }

    final body = e.response?.data;
    // Envelope error: `{ "error": { "code": "...", "message": "..." } }`
    if (body is Map<String, dynamic> &&
        body[_envelopeErrorKey] is Map<String, dynamic>) {
      final err = body[_envelopeErrorKey] as Map<String, dynamic>;
      return Left(ApiServerError(
        code: err['code']?.toString() ?? 'UNKNOWN',
        message: err['message']?.toString() ?? 'Server error',
        statusCode: e.response?.statusCode ?? 500,
      ));
    }

    // Legacy / fallback: flat `{ "code", "message" }`
    if (body is Map<String, dynamic>) {
      return Left(ApiServerError(
        code: body['code']?.toString() ?? 'UNKNOWN',
        message: body['message']?.toString() ?? 'Server error',
        statusCode: e.response?.statusCode ?? 500,
      ));
    }

    return Left(ApiServerError(
      code: 'HTTP_${e.response?.statusCode ?? 0}',
      message: e.message ?? 'Server error',
      statusCode: e.response?.statusCode ?? 500,
    ));
  } catch (e) {
    return Left(ApiUnknownError(error: e));
  }
}

/// Unwraps the `{ "data": ... }` envelope from a success response.
///
/// Every data source method should call this on Dio's returned body rather
/// than casting `.data` directly. Keeps envelope knowledge in one place.
///
/// Throws [FormatException] if the body is not a Map or lacks the `data` key
/// — those are real bugs (backend drift), and [safeApiCall] will convert them
/// to [ApiUnknownError].
T unwrapEnvelope<T>(Object? body) {
  if (body is! Map<String, dynamic>) {
    throw FormatException(
      'Expected JSON object with "data" key, got: ${body.runtimeType}',
    );
  }
  if (!body.containsKey(_envelopeDataKey)) {
    throw const FormatException('Response envelope missing "data" key');
  }
  final data = body[_envelopeDataKey];
  if (data is! T) {
    throw FormatException(
      'Envelope "data" had type ${data.runtimeType}, expected $T',
    );
  }
  return data;
}
