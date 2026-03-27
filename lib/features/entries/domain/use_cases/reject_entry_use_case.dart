import 'package:fpdart/fpdart.dart';
import '../../../../core/network/api_error.dart';
import '../entries_repository.dart';

class RejectEntryUseCase {
  final EntriesRepository _repository;

  RejectEntryUseCase(this._repository);

  Future<Either<ApiError, void>> call({
    required String listId,
    required String entryId,
  }) {
    return _repository.rejectEntry(listId: listId, entryId: entryId);
  }
}
