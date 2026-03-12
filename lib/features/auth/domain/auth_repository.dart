import 'package:fpdart/fpdart.dart';
import '../../../core/network/api_error.dart';
import 'entities/user.dart';

abstract class AuthRepository {
  Future<Either<ApiError, User>> login({
    required String email,
    required String password,
  });

  Future<Either<ApiError, User>> register({
    required String email,
    required String password,
    required String displayName,
  });

  Future<Either<ApiError, User>> appleSignIn({
    required String identityToken,
    String? fullName,
  });

  Future<Either<ApiError, void>> logout();

  Future<Either<ApiError, User>> getCurrentUser();
}
