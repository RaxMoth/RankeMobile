import 'package:fpdart/fpdart.dart';
<<<<<<< HEAD
import '../../../core/network/api_error.dart';
import 'entities/user.dart';

=======

import '../../../core/network/api_error.dart';
import 'entities/user.dart';

/// Abstract auth repository interface
>>>>>>> 88d3438 (good progress)
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

<<<<<<< HEAD
  Future<Either<ApiError, User>> appleSignIn({
    required String identityToken,
    String? fullName,
  });

  Future<Either<ApiError, void>> logout();

  Future<Either<ApiError, User>> getCurrentUser();
=======
  Future<Either<ApiError, User>> signInWithApple();

  Future<Either<ApiError, void>> logout();
>>>>>>> 88d3438 (good progress)
}
