import 'package:fpdart/fpdart.dart';
import '../../../../core/network/api_error.dart';
import '../entities/ranked_list.dart';
import '../lists_repository.dart';

class GetListsUseCase {
  final ListsRepository _repository;

  GetListsUseCase(this._repository);

  Future<Either<ApiError, List<ListSummary>>> call() {
    return _repository.getLists();
  }
}
