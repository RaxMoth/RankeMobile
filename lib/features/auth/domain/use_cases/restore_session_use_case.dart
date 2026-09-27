import 'package:fpdart/fpdart.dart';
import '../../../../core/network/api_error.dart';
import '../auth_repository.dart';
import '../entities/user.dart';

class RestoreSessionUseCase {
  final AuthRepository _repository;

  RestoreSessionUseCase(this._repository);

  Future<Either<ApiError, User?>> call() => _repository.restoreSession();
}
