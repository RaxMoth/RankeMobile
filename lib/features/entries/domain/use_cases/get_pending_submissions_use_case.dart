import 'package:fpdart/fpdart.dart';
import '../../../../core/network/api_error.dart';
import '../../../lists/domain/entities/ranked_list.dart';
import '../entries_repository.dart';

class GetPendingSubmissionsUseCase {
  final EntriesRepository _repository;

  GetPendingSubmissionsUseCase(this._repository);

  Future<Either<ApiError, List<Submission>>> call(String listId) {
    return _repository.getPendingSubmissions(listId);
  }
}
