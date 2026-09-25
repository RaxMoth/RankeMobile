import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_it/get_it.dart';

import '../../../../core/network/api_error.dart';
import '../../domain/entities/ranked_list.dart';
import '../../domain/use_cases/search_public_lists_use_case.dart';

final discoverQueryProvider = StateProvider<String>((ref) => '');
final discoverCategoryProvider = StateProvider<String?>((ref) => null);

/// Accumulated Discover results across every page loaded so far.
///
/// The first page's loading/error states are carried by the surrounding
/// [AsyncValue]; [isLoadingMore] and [loadMoreError] describe only the
/// follow-up pages, so a failed page 3 keeps pages 1–2 on screen.
class DiscoverState {
  final List<ListSummary> items;
  final String? nextCursor;
  final bool isLoadingMore;
  final ApiError? loadMoreError;

  const DiscoverState({
    required this.items,
    this.nextCursor,
    this.isLoadingMore = false,
    this.loadMoreError,
  });

  bool get hasMore => nextCursor != null;

  DiscoverState copyWith({
    List<ListSummary>? items,
    String? Function()? nextCursor,
    bool? isLoadingMore,
    ApiError? Function()? loadMoreError,
  }) {
    return DiscoverState(
      items: items ?? this.items,
      nextCursor: nextCursor != null ? nextCursor() : this.nextCursor,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      loadMoreError: loadMoreError != null
          ? loadMoreError()
          : this.loadMoreError,
    );
  }
}

final discoverResultsProvider =
    AsyncNotifierProvider.autoDispose<DiscoverNotifier, DiscoverState>(
      DiscoverNotifier.new,
    );

class DiscoverNotifier extends AutoDisposeAsyncNotifier<DiscoverState> {
  /// Bumped on every rebuild (new query / category / refresh). A page that
  /// resolves after a rebuild belongs to a search the user has moved on
  /// from, so it's dropped instead of being appended to the new results.
  int _generation = 0;

  SearchPublicListsUseCase get _useCase =>
      GetIt.instance<SearchPublicListsUseCase>();

  String? get _query {
    final q = ref.read(discoverQueryProvider);
    return q.isEmpty ? null : q;
  }

  @override
  Future<DiscoverState> build() async {
    // Watching (not reading) here is what re-runs the search when either
    // filter changes.
    ref.watch(discoverQueryProvider);
    final category = ref.watch(discoverCategoryProvider);
    _generation++;

    final result = await _useCase.call(query: _query, category: category);
    return result.fold(
      (error) => throw error,
      (page) => DiscoverState(items: page.items, nextCursor: page.nextCursor),
    );
  }

  /// Fetches the next page and appends it. No-op while the first page is
  /// loading, while another page is in flight, or when there are no more
  /// pages. A failure is recorded on the state for the UI to offer a retry.
  Future<void> loadMore() async {
    // During a rebuild Riverpod keeps the previous search's value visible
    // under AsyncLoading — don't page through results that are being replaced.
    if (state.isLoading) return;
    final current = state.valueOrNull;
    if (current == null || !current.hasMore || current.isLoadingMore) return;

    final generation = _generation;
    state = AsyncData(
      current.copyWith(isLoadingMore: true, loadMoreError: () => null),
    );

    final result = await _useCase.call(
      query: _query,
      category: ref.read(discoverCategoryProvider),
      cursor: current.nextCursor,
    );
    if (generation != _generation) return;

    final latest = state.valueOrNull ?? current;
    state = AsyncData(
      result.fold(
        (error) =>
            latest.copyWith(isLoadingMore: false, loadMoreError: () => error),
        (page) {
          // Keyset pages shouldn't overlap, but a board edited between two
          // requests can shift position; de-dupe by id so it never renders
          // twice.
          final seen = {for (final s in latest.items) s.id};
          return latest.copyWith(
            items: [
              ...latest.items,
              ...page.items.where((s) => seen.add(s.id)),
            ],
            nextCursor: () => page.nextCursor,
            isLoadingMore: false,
          );
        },
      ),
    );
  }
}

/// Top public boards to surface to users with no boards yet.
/// Sorted by memberCount desc, capped at 3. Draws from the first page only.
final recommendedBoardsProvider = FutureProvider.autoDispose<List<ListSummary>>(
  (ref) async {
    final useCase = GetIt.instance<SearchPublicListsUseCase>();
    final result = await useCase.call();
    return result.fold((error) => throw error, (page) {
      final sorted = [...page.items]
        ..sort((a, b) => b.memberCount.compareTo(a.memberCount));
      return sorted.take(3).toList();
    });
  },
);
