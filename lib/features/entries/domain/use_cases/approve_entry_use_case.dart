import 'package:fpdart/fpdart.dart';
import '../../../../core/network/api_error.dart';
import '../entries_repository.dart';

class ApproveEntryUseCase {
  final EntriesRepository _repository;

  ApproveEntryUseCase(this._repository);

  Future<Either<ApiError, void>> call({
    required String listId,
    required String entryId,
  }) {
    return _repository.approveEntry(listId: listId, entryId: entryId);
  }
}
