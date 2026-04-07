import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:mutex/mutex.dart';

import '../constants/app_constants.dart';

const kAccessTokenKey = 'access_token';
const kRefreshTokenKey = 'refresh_token';

/// JWT attach + 401 → refresh + retry
class AuthInterceptor extends Interceptor {
  final FlutterSecureStorage _storage;
  final Mutex _refreshMutex = Mutex();

  /// Separate Dio instance for refresh calls (no interceptor — avoids infinite loop)
  late final Dio _refreshDio;

  AuthInterceptor({FlutterSecureStorage? storage})
      : _storage = storage ?? const FlutterSecureStorage() {
    _refreshDio = Dio(BaseOptions(
      baseUrl: AppConstants.apiBaseUrl,
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 30),
    ));
  }

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final token = await _storage.read(key: kAccessTokenKey);
    if (token != null) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    super.onRequest(options, handler);
  }

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
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
