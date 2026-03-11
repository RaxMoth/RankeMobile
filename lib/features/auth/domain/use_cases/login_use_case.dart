import 'package:fpdart/fpdart.dart';
import '../../../../core/network/api_error.dart';
import '../auth_repository.dart';
import '../entities/user.dart';

class LoginUseCase {
  final AuthRepository _repository;

  LoginUseCase(this._repository);

  Future<Either<ApiError, User>> call({
    required String email,
    required String password,
  }) {
    return _repository.login(email: email, password: password);
  }
}
