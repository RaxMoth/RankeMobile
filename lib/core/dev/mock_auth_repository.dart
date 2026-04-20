import 'package:fpdart/fpdart.dart';

import '../../features/auth/domain/auth_repository.dart';
import '../../features/auth/domain/entities/user.dart';
import '../network/api_error.dart';
import 'dev_config.dart';

/// Mock auth repository returning fake user data for dev mode.
class MockAuthRepository implements AuthRepository {
  static const _devUser = User(
    id: 'dev-user-001',
    email: 'max@ranked.app',
    displayName: 'Max Roth',
    createdAt: null,
  );

  @override
  Future<Either<ApiError, User>> login({
    required String email,
    required String password,
  }) async {
    await Future<void>.delayed(DevConfig.networkDelay);
    return const Right(_devUser);
  }

  @override
  Future<Either<ApiError, User>> register({
    required String email,
    required String password,
    required String displayName,
  }) async {
    await Future<void>.delayed(DevConfig.networkDelay);
    return Right(User(
      id: 'dev-user-001',
      email: email,
      displayName: displayName,
    ));
  }

  @override
  Future<Either<ApiError, User>> signInWithApple({
    required String identityToken,
    String? fullName,
  }) async {
    await Future<void>.delayed(DevConfig.networkDelay);
    return const Right(_devUser);
  }

  @override
  Future<Either<ApiError, void>> logout() async {
    await Future<void>.delayed(DevConfig.networkDelay);
    return const Right(null);
  }
}
