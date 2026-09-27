import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:fpdart/fpdart.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/network/api_error.dart';
import '../../../core/network/api_error_codes.dart';
import '../../../core/network/api_helpers.dart';
import '../domain/auth_repository.dart';
import '../domain/entities/user.dart';
import 'auth_json.dart';
import 'auth_remote_data_source.dart';

/// Production AuthRepository — talks to the Go backend over HTTP and
/// persists tokens in flutter_secure_storage.
///
/// Auth responses (`contract/responses/auth_response.json`) carry the user
/// and both tokens at the top level of `data`. The signed-in user is also
/// cached next to the tokens so a launch without network can still resume
/// the session.
class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource _remoteDataSource;
  final FlutterSecureStorage _storage;

  AuthRepositoryImpl(this._remoteDataSource, {FlutterSecureStorage? storage})
    : _storage = storage ?? const FlutterSecureStorage();

  @override
  Future<Either<ApiError, User>> login({
    required String email,
    required String password,
  }) {
    return safeApiCall(() async {
      return _signedIn(
        await _remoteDataSource.login(email: email, password: password),
      );
    });
  }

  @override
  Future<Either<ApiError, User>> register({
    required String email,
    required String password,
    required String displayName,
  }) {
    return safeApiCall(() async {
      return _signedIn(
        await _remoteDataSource.register(
          email: email,
          password: password,
          displayName: displayName,
        ),
      );
    });
  }

  @override
  Future<Either<ApiError, User>> signInWithApple({
    required String identityToken,
    String? fullName,
  }) {
    return safeApiCall(() async {
      return _signedIn(
        await _remoteDataSource.signInWithApple(
          identityToken: identityToken,
          fullName: fullName,
        ),
      );
    });
  }

  @override
  Future<Either<ApiError, void>> logout() {
    return safeApiCall(() async {
      // Server needs the refresh token in the body to revoke it. Best-effort:
      // even if the network call fails we still clear local state so the
      // user is logged out on this device.
      final refreshToken = await _storage.read(
        key: AppConstants.refreshTokenKey,
      );
      try {
        await _remoteDataSource.logout(refreshToken: refreshToken);
      } finally {
        await _clearSession();
      }
    });
  }

  @override
  Future<Either<ApiError, User?>> restoreSession() async {
    final hasSession =
        await _storage.read(key: AppConstants.accessTokenKey) != null ||
        await _storage.read(key: AppConstants.refreshTokenKey) != null;
    if (!hasSession) return const Right(null);

    final result = await safeApiCall(() async {
      final user = AuthJson.user(await _remoteDataSource.getMe());
      await _cacheUser(user);
      return user;
    });

    return switch (result) {
      Right(:final value) => Right(value),
      // The token was rejected and couldn't be refreshed: signed out.
      Left(:final value) when value.hasCode(ApiErrorCode.unauthorized) =>
        await _clearSession().then((_) => const Right(null)),
      // Offline or a server hiccup: keep the session and resume with the
      // cached user; the next successful call proves the tokens.
      Left(:final value) => switch (await _cachedUser()) {
        final User cached => Right(cached),
        null => Left(value),
      },
    };
  }

  @override
  Future<Either<ApiError, void>> deleteAccount() {
    return safeApiCall(() async {
      await _remoteDataSource.deleteAccount();
      await _clearSession();
    });
  }

  // ── helpers ─────────────────────────────────────────────────

  /// Persists the tokens + user from an auth response and returns the user.
  Future<User> _signedIn(Map<String, dynamic> data) async {
    await _storage.write(
      key: AppConstants.accessTokenKey,
      value: data['accessToken'] as String,
    );
    await _storage.write(
      key: AppConstants.refreshTokenKey,
      value: data['refreshToken'] as String,
    );
    final user = AuthJson.user(data['user'] as Map<String, dynamic>);
    await _cacheUser(user);
    return user;
  }

  Future<void> _cacheUser(User user) => _storage.write(
    key: AppConstants.userDataKey,
    value: jsonEncode(AuthJson.userToJson(user)),
  );

  Future<User?> _cachedUser() async {
    final raw = await _storage.read(key: AppConstants.userDataKey);
    if (raw == null) return null;
    try {
      return AuthJson.user(jsonDecode(raw) as Map<String, dynamic>);
    } catch (_) {
      return null;
    }
  }

  Future<void> _clearSession() async {
    await _storage.delete(key: AppConstants.accessTokenKey);
    await _storage.delete(key: AppConstants.refreshTokenKey);
    await _storage.delete(key: AppConstants.userDataKey);
  }
}
