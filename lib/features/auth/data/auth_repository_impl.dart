import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:fpdart/fpdart.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/network/api_error.dart';
import '../../../core/network/api_helpers.dart';
import '../domain/auth_repository.dart';
import '../domain/entities/user.dart';
import 'auth_remote_data_source.dart';

/// Production AuthRepository — talks to the Go backend over HTTP and
/// persists tokens in flutter_secure_storage.
///
/// All server responses are wrapped in the standard `{ "data": ... }`
/// envelope. The remote data source already unwraps it; this class only
/// has to parse the inner payload.
///
/// Auth payload shape (matches backend `authResponse` DTO):
///   {
///     "user": { "id": "...", "email": "...", "displayName": "..." },
///     "accessToken":  "eyJ...",
///     "refreshToken": "..."
///   }
class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource _remoteDataSource;
  final FlutterSecureStorage _storage;

  AuthRepositoryImpl(
    this._remoteDataSource, {
    FlutterSecureStorage? storage,
  }) : _storage = storage ?? const FlutterSecureStorage();

  @override
  Future<Either<ApiError, User>> login({
    required String email,
    required String password,
  }) {
    return safeApiCall(() async {
      final data = await _remoteDataSource.login(
        email: email,
        password: password,
      );
      await _persistTokens(data);
      return _mapToUser(data);
    });
  }

  @override
  Future<Either<ApiError, User>> register({
    required String email,
    required String password,
    required String displayName,
  }) {
    return safeApiCall(() async {
      final data = await _remoteDataSource.register(
        email: email,
        password: password,
        displayName: displayName,
      );
      await _persistTokens(data);
      return _mapToUser(data);
    });
  }

  @override
  Future<Either<ApiError, User>> signInWithApple({
    required String identityToken,
    String? fullName,
  }) {
    return safeApiCall(() async {
      final data = await _remoteDataSource.signInWithApple(
        identityToken: identityToken,
        fullName: fullName,
      );
      await _persistTokens(data);
      return _mapToUser(data);
    });
  }

  @override
  Future<Either<ApiError, void>> logout() {
    return safeApiCall(() async {
      // Server needs the refresh token in the body to revoke it. Best-effort:
      // even if the network call fails we still clear local tokens so the
      // user is logged out on this device.
      final refreshToken =
          await _storage.read(key: AppConstants.refreshTokenKey);
      try {
        await _remoteDataSource.logout(refreshToken: refreshToken);
      } finally {
        await _clearTokens();
      }
    });
  }

  // ── helpers ─────────────────────────────────────────────────

  Future<void> _persistTokens(Map<String, dynamic> data) async {
    final access = data['accessToken'];
    final refresh = data['refreshToken'];
    if (access is String) {
      await _storage.write(
        key: AppConstants.accessTokenKey,
        value: access,
      );
    }
    if (refresh is String) {
      await _storage.write(
        key: AppConstants.refreshTokenKey,
        value: refresh,
      );
    }
  }

  Future<void> _clearTokens() async {
    await _storage.delete(key: AppConstants.accessTokenKey);
    await _storage.delete(key: AppConstants.refreshTokenKey);
  }

  User _mapToUser(Map<String, dynamic> data) {
    final userData = data['user'] as Map<String, dynamic>;
    return User(
      id: userData['id'] as String,
      email: userData['email'] as String,
      displayName: userData['displayName'] as String,
    );
  }
}
