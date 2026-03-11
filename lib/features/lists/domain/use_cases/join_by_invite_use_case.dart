import 'package:fpdart/fpdart.dart';
import '../../../../core/network/api_error.dart';
import '../entities/ranked_list.dart';
import '../lists_repository.dart';

class JoinByInviteUseCase {
  final ListsRepository _repository;

  JoinByInviteUseCase(this._repository);

  Future<Either<ApiError, RankedList>> call(String token) {
    return _repository.joinByInvite(token);
  }
}
