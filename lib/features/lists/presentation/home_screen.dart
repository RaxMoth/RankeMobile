import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/strings.dart';
import '../../../core/theme/colors.dart';
import '../../../core/theme/text_styles.dart';
import '../../../shared/widgets/board_tile.dart';
import '../../../shared/widgets/shimmer_loading.dart';
import '../domain/entities/ranked_list.dart';
import 'providers/bookmark_provider.dart';
import 'providers/lists_provider.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final listsAsync = ref.watch(listsProvider);
    final bookmarks = ref.watch(bookmarkProvider);

    return SafeArea(
      child: RefreshIndicator(
        color: AppColors.accent,
        backgroundColor: AppColors.surface,
        onRefresh: () => ref.read(listsProvider.notifier).refresh(),
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 16),
                child: Text(S.appName, style: AppTextStyles.screenTitle),
              ),
            ),
            listsAsync.when(
              data: (lists) {
                final owned = lists
                    .where((l) => l.currentUserRole == MemberRole.owner)
                    .toList();
                final participating = lists
                    .where((l) =>
                        l.currentUserRole == MemberRole.admin ||
                        l.currentUserRole == MemberRole.member)
                    .toList();
                final shownIds = {
                  ...owned.map((l) => l.id),
                  ...participating.map((l) => l.id),
                };
                final bookmarked = lists
                    .where((l) =>
                        bookmarks.contains(l.id) && !shownIds.contains(l.id))
                    .toList();

                if (owned.isEmpty &&
                    participating.isEmpty &&
                    bookmarked.isEmpty) {
                  return const SliverFillRemaining(child: _EmptyHome());
                }

                final items = _buildFlatItems(
                  owned: owned,
                  participating: participating,
                  bookmarked: bookmarked,
                );

                return SliverPadding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  sliver: SliverList.builder(
                    itemCount: items.length,
                    itemBuilder: (context, index) => items[index],
                  ),
                );
              },
              loading: () => const BoardListSkeleton(count: 5),
              error: (e, _) => SliverFillRemaining(
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.error_outline,
                          color: AppColors.error, size: 32),
                      const SizedBox(height: 8),
                      Text(S.failedToLoad,
                          style: AppTextStyles.sectionHeader
                              .copyWith(color: AppColors.error)),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

List<Widget> _buildFlatItems({
  required List<ListSummary> owned,
  required List<ListSummary> participating,
  required List<ListSummary> bookmarked,
}) {
  final items = <Widget>[];
  if (owned.isNotEmpty) {
    items.add(_SectionHeader(title: S.myBoards, count: owned.length, label: S.owned));
    items.add(const SizedBox(height: 8));
    for (final s in owned) {
      items.add(Builder(
        builder: (context) => BoardTile(
          summary: s,
          showRankBadge: true,
          onTap: () => GoRouter.of(context).push('/lists/${s.id}'),
        ),
      ));
    }
    items.add(const SizedBox(height: 20));
  }
  if (participating.isNotEmpty) {
    items.add(_SectionHeader(title: S.participating, count: participating.length, label: S.joined));
    items.add(const SizedBox(height: 8));
    for (final s in participating) {
      items.add(Builder(
        builder: (context) => BoardTile(
          summary: s,
          showRankBadge: true,
          onTap: () => GoRouter.of(context).push('/lists/${s.id}'),
        ),
      ));
    }
    items.add(const SizedBox(height: 20));
  }
  if (bookmarked.isNotEmpty) {
    items.add(_SectionHeader(title: S.bookmarked, count: bookmarked.length, label: S.saved));
    items.add(const SizedBox(height: 8));
    for (final s in bookmarked) {
      items.add(Builder(
        builder: (context) => BoardTile(
          summary: s,
          showRankBadge: true,
          showBookmark: true,
          onTap: () => GoRouter.of(context).push('/lists/${s.id}'),
        ),
      ));
    }
    items.add(const SizedBox(height: 20));
  }
  items.add(const SizedBox(height: 24));
  return items;
}

class _SectionHeader extends StatelessWidget {
  final String title;
  final int count;
  final String label;

  const _SectionHeader({
    required this.title,
    required this.count,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style: AppTextStyles.sectionHeader),
        Text('$count $label',
            style: AppTextStyles.bodySecondary.copyWith(fontSize: 12)),
      ],
    );
  }
}

class _EmptyHome extends StatelessWidget {
  const _EmptyHome();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(40),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.dashboard_outlined,
                color: AppColors.textTertiary, size: 48),
            const SizedBox(height: 16),
            Text(S.noBoardsYet,
                style: AppTextStyles.sectionHeader
                    .copyWith(color: AppColors.textSecondary)),
            const SizedBox(height: 8),
            Text(
              S.noBoardsHint,
              style:
                  AppTextStyles.badge.copyWith(color: AppColors.textTertiary),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                OutlinedButton.icon(
                  onPressed: () => GoRouter.of(context).go('/create'),
                  icon: const Icon(Icons.add, size: 16),
                  label: Text(S.create,
                      style: AppTextStyles.button
                          .copyWith(color: AppColors.accent)),
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: AppColors.accent),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 10),
                  ),
                ),
                const SizedBox(width: 12),
                OutlinedButton.icon(
                  onPressed: () => GoRouter.of(context).go('/discover'),
                  icon: const Icon(Icons.explore_outlined, size: 16),
                  label: Text(S.discover,
                      style: AppTextStyles.button
                          .copyWith(color: AppColors.textSecondary)),
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: AppColors.border),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 10),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
