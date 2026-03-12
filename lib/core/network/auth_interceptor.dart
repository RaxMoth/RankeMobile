import 'dart:async';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:mutex/mutex.dart';
import '../constants/app_constants.dart';

class AuthInterceptor extends Interceptor {
  final Dio dio;
  final Dio refreshDio;
  final FlutterSecureStorage secureStorage;
  final _refreshMutex = Mutex();

  AuthInterceptor({
    required this.dio,
    required this.refreshDio,
    required this.secureStorage,
  });

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final accessToken = await secureStorage.read(
      key: AppConstants.accessTokenKey,
    );
    if (accessToken != null) {
      options.headers['Authorization'] = 'Bearer $accessToken';
    }
    handler.next(options);
  }

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    if (err.response?.statusCode != 401) {
      return handler.next(err);
    }

    try {
      await _refreshMutex.protect(() async {
        // Check if token was already refreshed by another concurrent request
        final currentToken = await secureStorage.read(
          key: AppConstants.accessTokenKey,
        );
        final originalToken = err.requestOptions.headers['Authorization']
            ?.toString()
            .replaceFirst('Bearer ', '');

        if (currentToken != null && currentToken != originalToken) {
          return;
        }

        final refreshToken = await secureStorage.read(
          key: AppConstants.refreshTokenKey,
        );
        if (refreshToken == null) {
          throw DioException(
            requestOptions: err.requestOptions,
            error: 'No refresh token',
          );
        }

        final response = await refreshDio.post(
          '/auth/refresh',
          data: {'refreshToken': refreshToken},
        );

        final newAccessToken = response.data['accessToken'] as String;
        final newRefreshToken = response.data['refreshToken'] as String;

        await secureStorage.write(
          key: AppConstants.accessTokenKey,
          value: newAccessToken,
        );
        await secureStorage.write(
          key: AppConstants.refreshTokenKey,
          value: newRefreshToken,
        );
      });

      // Retry original request with new token
      final accessToken = await secureStorage.read(
        key: AppConstants.accessTokenKey,
      );
      final retryOptions = err.requestOptions;
      retryOptions.headers['Authorization'] = 'Bearer $accessToken';

      final response = await dio.fetch(retryOptions);
      return handler.resolve(response);
    } catch (_) {
      // Refresh failed — clear tokens
      await secureStorage.delete(key: AppConstants.accessTokenKey);
      await secureStorage.delete(key: AppConstants.refreshTokenKey);
      return handler.next(err);
    }
  }
}
