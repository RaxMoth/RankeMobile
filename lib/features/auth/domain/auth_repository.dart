import 'package:fpdart/fpdart.dart';

import '../../../core/network/api_error.dart';
import 'entities/user.dart';

/// Abstract auth repository interface
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

  Future<Either<ApiError, User>> signInWithApple({
    required String identityToken,
    String? fullName,
  });

  Future<Either<ApiError, void>> logout();

  /// Resumes a stored session on app launch. Right(null) means signed out.
  Future<Either<ApiError, User?>> restoreSession();

  /// Permanently deletes the account and signs out locally.
  Future<Either<ApiError, void>> deleteAccount();
}
