<<<<<<< HEAD
import 'dart:async';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:mutex/mutex.dart';
import '../constants/app_constants.dart';
=======
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:mutex/mutex.dart';
>>>>>>> 88d3438 (good progress)

const kAccessTokenKey = 'access_token';
const kRefreshTokenKey = 'refresh_token';

/// JWT attach + 401 → refresh + retry
class AuthInterceptor extends Interceptor {
<<<<<<< HEAD
  final Dio dio;
  final Dio refreshDio;
  final FlutterSecureStorage secureStorage;
  final _refreshMutex = Mutex();

  AuthInterceptor({
    required this.dio,
    required this.refreshDio,
    required this.secureStorage,
  });
=======
  final FlutterSecureStorage _storage;
  final Mutex _refreshMutex = Mutex();

  /// Separate Dio instance for refresh calls (no interceptor — avoids infinite loop)
  late final Dio _refreshDio;

  AuthInterceptor({FlutterSecureStorage? storage})
      : _storage = storage ?? const FlutterSecureStorage() {
    _refreshDio = Dio(BaseOptions(
      baseUrl: 'https://api.example.com', // TODO: use shared config
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 30),
    ));
  }
>>>>>>> 88d3438 (good progress)

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
<<<<<<< HEAD
    final accessToken = await secureStorage.read(
      key: AppConstants.accessTokenKey,
    );
    if (accessToken != null) {
      options.headers['Authorization'] = 'Bearer $accessToken';
    }
    handler.next(options);
=======
    final token = await _storage.read(key: kAccessTokenKey);
    if (token != null) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    super.onRequest(options, handler);
>>>>>>> 88d3438 (good progress)
  }

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
<<<<<<< HEAD
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
=======
    if (err.response?.statusCode == 401) {
      try {
        // Use mutex so only one refresh call is made when multiple 401s arrive
        await _refreshMutex.acquire();
        try {
          final refreshed = await _attemptTokenRefresh();
          if (refreshed) {
            // Retry the original request with the new token
            final token = await _storage.read(key: kAccessTokenKey);
            err.requestOptions.headers['Authorization'] = 'Bearer $token';
            final response = await _refreshDio.fetch(err.requestOptions);
            return handler.resolve(response);
          }
        } finally {
          _refreshMutex.release();
        }
      } catch (_) {
        // Refresh failed — clear tokens and let the error propagate
        await _clearTokens();
        // TODO: redirect to login via GoRouter
      }
    }
    super.onError(err, handler);
>>>>>>> 88d3438 (good progress)
  }

  Future<bool> _attemptTokenRefresh() async {
    final refreshToken = await _storage.read(key: kRefreshTokenKey);
    if (refreshToken == null) return false;

    try {
      final response = await _refreshDio.post(
        '/auth/refresh',
        data: {'refresh_token': refreshToken},
      );

      if (response.statusCode == 200) {
        final data = response.data as Map<String, dynamic>;
        await _storage.write(
          key: kAccessTokenKey,
          value: data['access_token'] as String,
        );
        await _storage.write(
          key: kRefreshTokenKey,
          value: data['refresh_token'] as String,
        );
        return true;
      }
    } catch (_) {
      // Refresh request itself failed
    }
    return false;
  }

  Future<void> _clearTokens() async {
    await _storage.delete(key: kAccessTokenKey);
    await _storage.delete(key: kRefreshTokenKey);
  }
}
