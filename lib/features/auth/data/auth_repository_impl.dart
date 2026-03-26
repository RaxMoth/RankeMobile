import 'package:dio/dio.dart';
import 'package:fpdart/fpdart.dart';

import '../../../core/network/api_error.dart';
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
  }

  @override
  Future<Either<ApiError, User>> register({
    required String email,
    required String password,
    required String displayName,
  }) async {
    try {
      final data = await _remoteDataSource.register(
        email: email,
        password: password,
        displayName: displayName,
      );
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
}
