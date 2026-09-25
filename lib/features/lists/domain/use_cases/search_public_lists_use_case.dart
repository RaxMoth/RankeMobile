import 'package:fpdart/fpdart.dart';
import '../../../../core/network/api_error.dart';
import '../entities/public_lists_page.dart';
import '../lists_repository.dart';

class SearchPublicListsUseCase {
  final ListsRepository _repository;

  SearchPublicListsUseCase(this._repository);

  Future<Either<ApiError, PublicListsPage>> call({
    String? query,
    String? category,
    String? cursor,
    int? limit,
  }) {
    return _repository.searchPublicLists(
      query: query,
      category: category,
      cursor: cursor,
      limit: limit,
    );
  }
}
