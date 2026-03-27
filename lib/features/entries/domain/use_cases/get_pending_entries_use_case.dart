import 'package:fpdart/fpdart.dart';
import '../../../../core/network/api_error.dart';
import '../../../lists/domain/entities/ranked_list.dart';
import '../entries_repository.dart';

class GetPendingEntriesUseCase {
  final EntriesRepository _repository;

  GetPendingEntriesUseCase(this._repository);

  Future<Either<ApiError, List<RankedEntry>>> call(String listId) {
    return _repository.getPendingEntries(listId);
  }
}
