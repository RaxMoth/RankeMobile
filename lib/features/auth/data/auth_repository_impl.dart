import 'package:fpdart/fpdart.dart';

import '../../../core/network/api_error.dart';
import '../../../core/network/api_helpers.dart';
import '../domain/auth_repository.dart';
import '../domain/entities/user.dart';
import 'auth_remote_data_source.dart';

/// Implementation of AuthRepository
class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource _remoteDataSource;

  AuthRepositoryImpl(this._remoteDataSource);

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
      return _mapToUser(data);
    });
  }

  @override
  Future<Either<ApiError, User>> signInWithApple({
    required String identityToken,
    String? fullName,
  }) async {
    // TODO: implement Apple Sign In flow
    return const Left(ApiUnknownError(error: 'Not implemented'));
  }

  @override
  Future<Either<ApiError, void>> logout() {
    return safeApiCall(() async {
      await _remoteDataSource.logout();
    });
  }

  User _mapToUser(Map<String, dynamic> data) {
    final userData = data['user'] as Map<String, dynamic>;
    return User(
      id: userData['id'] as String,
      email: userData['email'] as String,
      displayName: userData['display_name'] as String,
    );
  }
}
