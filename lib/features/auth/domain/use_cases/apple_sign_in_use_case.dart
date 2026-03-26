import 'package:fpdart/fpdart.dart';
import '../../../../core/network/api_error.dart';
import '../auth_repository.dart';
import '../entities/user.dart';

class AppleSignInUseCase {
  final AuthRepository _repository;

  AppleSignInUseCase(this._repository);

  Future<Either<ApiError, User>> call({
    required String identityToken,
    String? fullName,
  }) {
    return _repository.signInWithApple();
  }
}
