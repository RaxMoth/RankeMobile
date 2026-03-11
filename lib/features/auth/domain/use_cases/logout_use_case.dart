import 'package:fpdart/fpdart.dart';
import '../../../../core/network/api_error.dart';
import '../auth_repository.dart';

class LogoutUseCase {
  final AuthRepository _repository;

  LogoutUseCase(this._repository);

  Future<Either<ApiError, void>> call() {
    return _repository.logout();
  }
}
