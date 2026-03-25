<<<<<<< HEAD
import 'package:fpdart/fpdart.dart';
import '../../../core/network/api_error.dart';
import '../../../core/network/api_helpers.dart';
=======
import 'package:dio/dio.dart';
import 'package:fpdart/fpdart.dart';

import '../../../core/network/api_error.dart';
>>>>>>> 88d3438 (good progress)
import '../domain/auth_repository.dart';
import '../domain/entities/user.dart';
import 'auth_remote_data_source.dart';

<<<<<<< HEAD
class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource _dataSource;

  AuthRepositoryImpl(this._dataSource);
=======
/// Implementation of AuthRepository
class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource _remoteDataSource;

  AuthRepositoryImpl(this._remoteDataSource);
>>>>>>> 88d3438 (good progress)

  @override
  Future<Either<ApiError, User>> login({
    required String email,
    required String password,
<<<<<<< HEAD
  }) {
    return safeApiCall(() async {
      final data = await _dataSource.login(email: email, password: password);
      return _mapUser(data);
    });
=======
  }) async {
    try {
      final data = await _remoteDataSource.login(
        email: email,
        password: password,
      );
      return Right(_mapToUser(data));
    } on DioException catch (e) {
      return Left(_mapDioError(e));
    } catch (e) {
      return Left(ApiUnknownError(error: e));
    }
>>>>>>> 88d3438 (good progress)
  }

  @override
  Future<Either<ApiError, User>> register({
    required String email,
    required String password,
    required String displayName,
<<<<<<< HEAD
  }) {
    return safeApiCall(() async {
      final data = await _dataSource.register(
=======
  }) async {
    try {
      final data = await _remoteDataSource.register(
>>>>>>> 88d3438 (good progress)
        email: email,
        password: password,
        displayName: displayName,
      );
<<<<<<< HEAD
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
=======
      return Right(_mapToUser(data));
    } on DioException catch (e) {
      return Left(_mapDioError(e));
    } catch (e) {
      return Left(ApiUnknownError(error: e));
    }
  }

  @override
  Future<Either<ApiError, User>> signInWithApple() async {
    // TODO: implement Apple Sign In flow
    return const Left(ApiUnknownError(error: 'Not implemented'));
  }

  @override
  Future<Either<ApiError, void>> logout() async {
    try {
      await _remoteDataSource.logout();
      return const Right(null);
    } on DioException catch (e) {
      return Left(_mapDioError(e));
    } catch (e) {
      return Left(ApiUnknownError(error: e));
    }
  }

  User _mapToUser(Map<String, dynamic> data) {
    final userData = data['user'] as Map<String, dynamic>;
    return User(
      id: userData['id'] as String,
      email: userData['email'] as String,
      displayName: userData['display_name'] as String,
    );
  }

  ApiError _mapDioError(DioException e) {
    if (e.type == DioExceptionType.connectionError ||
        e.type == DioExceptionType.connectionTimeout) {
      return const ApiNetworkError();
    }
    final response = e.response;
    if (response != null) {
      final data = response.data;
      if (data is Map<String, dynamic>) {
        return ApiServerError(
          code: data['code'] as String? ?? 'UNKNOWN',
          message: data['message'] as String? ?? 'Server error',
          statusCode: response.statusCode ?? 500,
        );
      }
    }
    return ApiUnknownError(error: e);
  }
>>>>>>> 88d3438 (good progress)
}
