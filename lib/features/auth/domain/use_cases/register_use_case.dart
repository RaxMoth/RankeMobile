import 'package:fpdart/fpdart.dart';
import '../../../../core/network/api_error.dart';
import '../auth_repository.dart';
import '../entities/user.dart';

class RegisterUseCase {
  final AuthRepository _repository;

  RegisterUseCase(this._repository);

  Future<Either<ApiError, User>> call({
    required String email,
    required String password,
    required String displayName,
  }) {
    return _repository.register(
      email: email,
      password: password,
      displayName: displayName,
    );
  }
}
