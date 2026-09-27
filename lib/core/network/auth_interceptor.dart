import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:mutex/mutex.dart';

import '../constants/app_constants.dart';
import 'api_helpers.dart';
import 'api_paths.dart';

/// Attaches the access token and, on a 401, refreshes it once and retries.
///
/// * Calls under `/auth/` are never refreshed: a 401 there is a real answer
///   (wrong password, bad refresh token), not an expired session.
/// * Concurrent 401s share one refresh. The backend rotates refresh tokens
///   and treats reuse of a rotated one as theft, so a second refresh with
///   a stale token would sign the user out everywhere. A request that waited
///   on the mutex first checks whether the token already changed and just
///   retries with it.
/// * When the session can't be recovered, tokens are cleared and
///   [onSessionExpired] fires so the app can return to login.
class AuthInterceptor extends Interceptor {
  final FlutterSecureStorage _storage;
  final Mutex _refreshMutex = Mutex();
  final void Function()? onSessionExpired;

  /// Separate Dio for refresh + retry (no interceptors — avoids loops).
  final Dio _refreshDio;

  AuthInterceptor({
    FlutterSecureStorage? storage,
    Dio? refreshDio,
    this.onSessionExpired,
  }) : _storage = storage ?? const FlutterSecureStorage(),
       _refreshDio =
           refreshDio ??
           Dio(
             BaseOptions(
               baseUrl: AppConstants.apiBaseUrl,
               connectTimeout: const Duration(seconds: 10),
               receiveTimeout: const Duration(seconds: 30),
               contentType: Headers.jsonContentType,
             ),
           );

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final token = await _storage.read(key: AppConstants.accessTokenKey);
    if (token != null) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    handler.next(options);
  }

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    final options = err.requestOptions;
    if (err.response?.statusCode != 401 || _isAuthCall(options.path)) {
      return handler.next(err);
    }

    final sentToken = _bearer(options);
    final String? token = await _refreshMutex.protect(() async {
      final current = await _storage.read(key: AppConstants.accessTokenKey);
      // Another request refreshed while we waited — reuse its token.
      if (current != null && current != sentToken) return current;
      return _refresh();
    });

    if (token == null) {
      await _clearTokens();
      onSessionExpired?.call();
      return handler.next(err);
    }

    try {
      options.headers['Authorization'] = 'Bearer $token';
      return handler.resolve(await _refreshDio.fetch<dynamic>(options));
    } on DioException catch (retryErr) {
      return handler.next(retryErr);
    }
  }

  /// Exchanges the stored refresh token for a new pair. Returns the new
  /// access token, or null when the session is gone.
  Future<String?> _refresh() async {
    final refreshToken = await _storage.read(key: AppConstants.refreshTokenKey);
    if (refreshToken == null) return null;
    try {
      final response = await _refreshDio.post<Map<String, dynamic>>(
        ApiPaths.authRefresh,
        data: {'refreshToken': refreshToken},
      );
      final payload = unwrapEnvelope<Map<String, dynamic>>(response.data);
      final access = payload['accessToken'] as String;
      await _storage.write(key: AppConstants.accessTokenKey, value: access);
      await _storage.write(
        key: AppConstants.refreshTokenKey,
        value: payload['refreshToken'] as String,
      );
      return access;
    } catch (_) {
      return null;
    }
  }

  static bool _isAuthCall(String path) => path.contains('/auth/');

  static String? _bearer(RequestOptions options) {
    final header = options.headers['Authorization'];
    return header is String && header.startsWith('Bearer ')
        ? header.substring(7)
        : null;
  }

  Future<void> _clearTokens() async {
    await _storage.delete(key: AppConstants.accessTokenKey);
    await _storage.delete(key: AppConstants.refreshTokenKey);
  }
}
