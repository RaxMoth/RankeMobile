import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_it/get_it.dart';

import '../../domain/entities/ranked_list.dart';
import '../../domain/use_cases/search_public_lists_use_case.dart';

final discoverQueryProvider = StateProvider<String>((ref) => '');
final discoverCategoryProvider = StateProvider<String?>((ref) => null);

final discoverResultsProvider =
    AsyncNotifierProvider<DiscoverNotifier, List<ListSummary>>(
        DiscoverNotifier.new);

class DiscoverNotifier extends AsyncNotifier<List<ListSummary>> {
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
