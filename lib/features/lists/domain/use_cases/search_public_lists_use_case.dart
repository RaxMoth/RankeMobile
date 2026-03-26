import 'package:fpdart/fpdart.dart';
import '../../../../core/network/api_error.dart';
import '../entities/ranked_list.dart';
import '../lists_repository.dart';

class SearchPublicListsUseCase {
  final ListsRepository _repository;

  SearchPublicListsUseCase(this._repository);

  Future<Either<ApiError, List<ListSummary>>> call({
    String? query,
    String? category,
  }) {
    return _repository.searchPublicLists(query: query, category: category);
  }
}
