import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/strings.dart';
import '../../../core/theme/colors.dart';
import '../../../core/theme/text_styles.dart';
import '../../../shared/widgets/board_tile.dart';
import '../../../shared/widgets/create_fab.dart';
import '../../../shared/widgets/shimmer_loading.dart';
import '../../../shared/widgets/user_avatar_menu.dart';
import '../domain/entities/ranked_list.dart';
import 'providers/bookmark_provider.dart';
import 'providers/discover_provider.dart';
import 'providers/home_filter_provider.dart';
import 'providers/lists_provider.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  static const double _minSwipeDistance = 44;
  static const double _horizontalDominance = 1.35;

  double _dragDx = 0;
  double _dragDy = 0;

  void _onHorizontalDragStart(DragStartDetails details) {
    _dragDx = 0;
    _dragDy = 0;
  }

  void _onHorizontalDragUpdate(DragUpdateDetails details) {
    _dragDx += details.delta.dx;
    _dragDy += details.delta.dy;
  }

  void _onHorizontalDragEnd(DragEndDetails details) {
    final isHorizontalGesture =
        _dragDx.abs() > (_dragDy.abs() * _horizontalDominance);
    if (!isHorizontalGesture || _dragDx.abs() < _minSwipeDistance) {
      return;
    }

    final active = ref.read(homeFilterProvider);
    final filters = HomeFilter.values;
    final currentIndex = filters.indexOf(active);

    if (_dragDx < 0 && currentIndex < filters.length - 1) {
      HapticFeedback.lightImpact();
      ref.read(homeFilterProvider.notifier).state = filters[currentIndex + 1];
      return;
    }

    if (_dragDx > 0 && currentIndex > 0) {
      HapticFeedback.lightImpact();
      ref.read(homeFilterProvider.notifier).state = filters[currentIndex - 1];
    }
  }

  @override
  Widget build(BuildContext context) {
    final listsAsync = ref.watch(listsProvider);
    final bookmarks = ref.watch(bookmarkProvider);
    final filter = ref.watch(homeFilterProvider);

    return Scaffold(
      backgroundColor: Colors.transparent,
      floatingActionButton: const CreateFab(),
      body: SafeArea(
        child: RefreshIndicator(
          color: AppColors.accent,
          backgroundColor: AppColors.surface,
          onRefresh: () => ref.read(listsProvider.notifier).refresh(),
          child: GestureDetector(
            behavior: HitTestBehavior.translucent,
            onHorizontalDragStart: _onHorizontalDragStart,
            onHorizontalDragUpdate: _onHorizontalDragUpdate,
            onHorizontalDragEnd: _onHorizontalDragEnd,
            child: CustomScrollView(
              slivers: [
                // Top row: avatar menu only (no title)
                const SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(20, 8, 20, 0),
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: UserAvatarMenu(),
                    ),
                  ),
                ),
                // Filter bar — full width, no title
                const SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(20, 12, 20, 8),
                    child: _FilterBar(),
                  ),
                ),
                // Content
                listsAsync.when(
                  data: (lists) {
                    final owned = lists
                        .where((l) => l.currentUserRole == MemberRole.owner)
                        .toList();
                    final participating = lists
                        .where(
                          (l) =>
                              l.currentUserRole == MemberRole.admin ||
                              l.currentUserRole == MemberRole.member,
                        )
                        .toList();
                    final shownIds = {
                      ...owned.map((l) => l.id),
                      ...participating.map((l) => l.id),
                    };
                    final saved = lists
                        .where(
                          (l) =>
                              bookmarks.contains(l.id) &&
                              !shownIds.contains(l.id),
                        )
                        .toList();

                    final filtered = switch (filter) {
                      HomeFilter.owned => owned,
                      HomeFilter.joined => participating,
                      HomeFilter.saved => saved,
                    };

                    if (filtered.isEmpty) {
                      return SliverFillRemaining(
                        child: _EmptyFilterState(filter: filter),
                      );
                    }

                    return SliverPadding(
                      padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
                      sliver: SliverList.builder(
                        itemCount: filtered.length,
                        itemBuilder: (context, index) {
                          final item = filtered[index];
                          return BoardTile(
                            summary: item,
                            showRankBadge: true,
                            showBookmark: filter == HomeFilter.saved,
                            onTap: () => context.push('/lists/${item.id}'),
                          );
                        },
                      ),
                    );
                  },
                  loading: () => const BoardListSkeleton(count: 5),
                  error: (e, _) => SliverFillRemaining(
                    child: Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.error_outline,
                            color: AppColors.error,
                            size: 32,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            S.failedToLoad,
                            style: AppTextStyles.sectionHeader.copyWith(
                              color: AppColors.error,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ─── Filter Bar — compact segmented pill ─────────────────────

class _FilterBar extends ConsumerWidget {
  const _FilterBar();

  static const _filters = [
    (HomeFilter.owned, Icons.shield_outlined, Icons.shield),
    (HomeFilter.joined, Icons.people_outlined, Icons.people),
    (HomeFilter.saved, Icons.bookmark_border, Icons.bookmark),
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final active = ref.watch(homeFilterProvider);

    return Container(
      height: 44,
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          for (final (filter, icon, activeIcon) in _filters)
            Expanded(
              child: GestureDetector(
                onTap: () {
                  HapticFeedback.lightImpact();
                  ref.read(homeFilterProvider.notifier).state = filter;
                },
                behavior: HitTestBehavior.opaque,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 180),
                  margin: const EdgeInsets.all(3),
                  decoration: BoxDecoration(
                    color: active == filter
                        ? AppColors.accent
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  alignment: Alignment.center,
                  child: Icon(
                    active == filter ? activeIcon : icon,
                    size: 20,
                    color: active == filter
                        ? AppColors.background
                        : AppColors.textTertiary,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

// ─── Empty Filter States ─────────────────────────────────────

class _EmptyFilterState extends ConsumerWidget {
  final HomeFilter filter;

  const _EmptyFilterState({required this.filter});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final (
      filterIcon,
      title,
      hint,
      actionLabel,
      actionIcon,
      route,
    ) = switch (filter) {
      HomeFilter.owned => (
        Icons.shield_outlined,
        S.noBoardsCreated,
        S.createBoardHint,
        S.create,
        Icons.add,
        '/create',
      ),
      HomeFilter.joined => (
        Icons.people_outlined,
        S.noBoardsJoined,
        S.joinBoardHint,
        S.discover,
        Icons.explore_outlined,
        '/discover',
      ),
      HomeFilter.saved => (
        Icons.bookmark_border,
        S.noSavedBoards,
        S.saveBoardHint,
        S.discover,
        Icons.explore_outlined,
        '/discover',
      ),
    };

    final showRecommendations = filter == HomeFilter.joined;

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(20, 32, 20, 24),
      child: Column(
        children: [
          Icon(filterIcon, color: AppColors.textTertiary, size: 48),
          const SizedBox(height: 16),
          Text(
            title,
            style: AppTextStyles.sectionHeader.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            hint,
            style: AppTextStyles.badge.copyWith(
              color: AppColors.textTertiary,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          OutlinedButton.icon(
            onPressed: () => GoRouter.of(context).go(route),
            icon: Icon(actionIcon, size: 16),
            label: Text(
              actionLabel,
              style: AppTextStyles.button.copyWith(color: AppColors.accent),
            ),
            style: OutlinedButton.styleFrom(
              side: const BorderSide(color: AppColors.accent),
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 10,
              ),
            ),
          ),
          if (showRecommendations) ...[
            const SizedBox(height: 32),
            const _RecommendedSection(),
          ],
        ],
      ),
    );
  }
}

class _RecommendedSection extends ConsumerWidget {
  const _RecommendedSection();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final async = ref.watch(recommendedBoardsProvider);
    return async.when(
      loading: () => const SizedBox.shrink(),
      error: (_, _) => const SizedBox.shrink(),
      data: (lists) {
        if (lists.isEmpty) return const SizedBox.shrink();
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.trending_up,
                    size: 14, color: AppColors.textTertiary),
                const SizedBox(width: 6),
                Text(
                  S.popularThisWeek,
                  style: AppTextStyles.label
                      .copyWith(color: AppColors.textTertiary),
                ),
              ],
            ),
            const SizedBox(height: 12),
            for (final summary in lists)
              BoardTile(
                summary: summary,
                onTap: () => context.push('/lists/${summary.id}'),
              ),
          ],
        );
      },
    );
  }
}
