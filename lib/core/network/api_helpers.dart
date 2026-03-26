import 'package:dio/dio.dart';
import 'package:fpdart/fpdart.dart';
import 'api_error.dart';

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

    final data = e.response?.data;
    if (data is Map<String, dynamic>) {
      return Left(ApiServerError(
        code: data['code']?.toString() ?? 'UNKNOWN',
        message: data['message']?.toString() ?? 'Server error',
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
