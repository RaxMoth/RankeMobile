import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/colors.dart';
import '../../../core/theme/text_styles.dart';
import '../../../shared/widgets/board_tile.dart';
import '../domain/entities/ranked_list.dart';
import 'providers/bookmark_provider.dart';
import 'providers/lists_provider.dart';

/// Home Screen — shows the user's boards grouped by relationship.
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
            // Header
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('APEX', style: AppTextStyles.displayLarge),
                        const SizedBox(height: 2),
                        Text('MY BOARDS', style: AppTextStyles.subtitle),
                      ],
                    ),
                    IconButton(
                      onPressed: () {},
                      icon: const Icon(
                        Icons.notifications_none_rounded,
                        color: AppColors.textSecondary,
                        size: 24,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // Content
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
              loading: () => const SliverFillRemaining(
                child: Center(
                    child: CircularProgressIndicator(
                        color: AppColors.accent, strokeWidth: 2)),
              ),
              error: (e, _) => SliverFillRemaining(
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.error_outline,
                          color: AppColors.error, size: 32),
                      const SizedBox(height: 8),
                      Text('FAILED TO LOAD',
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
    items.add(_SectionHeader(title: 'MY BOARDS', count: owned.length, label: 'OWNED'));
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
    items.add(_SectionHeader(title: 'PARTICIPATING', count: participating.length, label: 'JOINED'));
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
    items.add(_SectionHeader(title: 'BOOKMARKED', count: bookmarked.length, label: 'SAVED'));
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

// ─── Section Header ──────────────────────────────────────────

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

// ─── Empty State ──────────────────────────────────────────────

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
            Text('NO BOARDS YET',
                style: AppTextStyles.sectionHeader
                    .copyWith(color: AppColors.textSecondary)),
            const SizedBox(height: 8),
            Text(
              'CREATE A BOARD OR DISCOVER\nPUBLIC BOARDS TO GET STARTED',
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
                  label: Text('CREATE',
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
                  label: Text('DISCOVER',
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
