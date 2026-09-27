import 'package:fpdart/fpdart.dart';
import '../../../../core/network/api_error.dart';
import '../entries_repository.dart';

class ApproveSubmissionUseCase {
  final EntriesRepository _repository;

  ApproveSubmissionUseCase(this._repository);

  Future<Either<ApiError, void>> call({
    required String listId,
    required String submissionId,
  }) {
    return _repository.approveSubmission(
      listId: listId,
      submissionId: submissionId,
    );
  }
}
