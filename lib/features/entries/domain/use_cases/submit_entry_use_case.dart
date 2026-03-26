import 'package:fpdart/fpdart.dart';
import '../../../../core/network/api_error.dart';
import '../../../lists/domain/entities/ranked_list.dart';
import '../entities/entry.dart';
import '../entries_repository.dart';

class SubmitEntryUseCase {
  final EntriesRepository _repository;

  SubmitEntryUseCase(this._repository);

  Future<Either<ApiError, RankedEntry>> call({
    required String listId,
    required EntryInput input,
  }) {
    return _repository.submitEntry(listId: listId, input: input);
  }
}
