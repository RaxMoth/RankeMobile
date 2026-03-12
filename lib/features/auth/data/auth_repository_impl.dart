import 'package:fpdart/fpdart.dart';
import '../../../core/network/api_error.dart';
import '../../../core/network/api_helpers.dart';
import '../domain/auth_repository.dart';
import '../domain/entities/user.dart';
import 'auth_remote_data_source.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource _dataSource;

  AuthRepositoryImpl(this._dataSource);

  @override
  Future<Either<ApiError, User>> login({
    required String email,
    required String password,
  }) {
    return safeApiCall(() async {
      final data = await _dataSource.login(email: email, password: password);
      return _mapUser(data);
    });
  }

  @override
  Future<Either<ApiError, User>> register({
    required String email,
    required String password,
    required String displayName,
  }) {
    return safeApiCall(() async {
      final data = await _dataSource.register(
        email: email,
        password: password,
        displayName: displayName,
      );
      return _mapUser(data);
    });
  }

  @override
  Future<Either<ApiError, User>> appleSignIn({
    required String identityToken,
    String? fullName,
  }) {
    return safeApiCall(() async {
      final data = await _dataSource.appleSignIn(
        identityToken: identityToken,
        fullName: fullName,
      );
      return _mapUser(data);
    });
  }

  @override
  Future<Either<ApiError, void>> logout() {
    return safeApiCall(() => _dataSource.logout());
  }

  @override
  Future<Either<ApiError, User>> getCurrentUser() {
    return safeApiCall(() async {
      final data = await _dataSource.getCurrentUser();
      return _mapUser(data);
    });
  }

  User _mapUser(Map<String, dynamic> json) {
    return User(
      id: json['id'] as String,
      email: json['email'] as String,
      displayName: json['displayName'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }
}
