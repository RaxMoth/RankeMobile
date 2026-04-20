import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_it/get_it.dart';

import '../../domain/entities/ranked_list.dart';
import '../../domain/use_cases/search_public_lists_use_case.dart';

final discoverQueryProvider = StateProvider<String>((ref) => '');
final discoverCategoryProvider = StateProvider<String?>((ref) => null);

final discoverResultsProvider = AsyncNotifierProvider.autoDispose<
    DiscoverNotifier, List<ListSummary>>(DiscoverNotifier.new);

class DiscoverNotifier extends AutoDisposeAsyncNotifier<List<ListSummary>> {
  @override
  Future<List<ListSummary>> build() async {
    final query = ref.watch(discoverQueryProvider);
    final category = ref.watch(discoverCategoryProvider);
    final useCase = GetIt.instance<SearchPublicListsUseCase>();
    final result = await useCase.call(
      query: query.isEmpty ? null : query,
      category: category,
    );
    return result.fold(
      (error) => throw error,
      (lists) => lists,
    );
  }
}

/// Top public boards to surface to users with no boards yet.
/// Sorted by memberCount desc, capped at 3.
final recommendedBoardsProvider =
    FutureProvider.autoDispose<List<ListSummary>>((ref) async {
  final useCase = GetIt.instance<SearchPublicListsUseCase>();
  final result = await useCase.call();
  return result.fold(
    (error) => throw error,
    (lists) {
      final sorted = [...lists]
        ..sort((a, b) => b.memberCount.compareTo(a.memberCount));
      return sorted.take(3).toList();
    },
  );
});
