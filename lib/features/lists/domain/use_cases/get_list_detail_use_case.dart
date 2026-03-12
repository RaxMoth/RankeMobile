import 'package:fpdart/fpdart.dart';
import '../../../../core/network/api_error.dart';
import '../entities/ranked_list.dart';
import '../lists_repository.dart';

class GetListDetailUseCase {
  final ListsRepository _repository;

  GetListDetailUseCase(this._repository);

  Future<Either<ApiError, RankedList>> call(String listId) {
    return _repository.getListDetail(listId);
  }
}
