import 'package:fpdart/fpdart.dart';
import '../../../../core/network/api_error.dart';
import '../entries_repository.dart';

class RejectSubmissionUseCase {
  final EntriesRepository _repository;

  RejectSubmissionUseCase(this._repository);

  Future<Either<ApiError, void>> call({
    required String listId,
    required String submissionId,
  }) {
    return _repository.rejectSubmission(
      listId: listId,
      submissionId: submissionId,
    );
  }
}
