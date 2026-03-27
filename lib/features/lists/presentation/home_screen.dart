import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/colors.dart';
import '../../../core/theme/text_styles.dart';
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

                return SliverPadding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  sliver: SliverList(
                    delegate: SliverChildListDelegate([
                      if (owned.isNotEmpty) ...[
                        _SectionHeader(
                          title: 'MY BOARDS',
                          count: owned.length,
                          label: 'OWNED',
                        ),
                        const SizedBox(height: 8),
                        ...owned.map((s) => _BoardTile(summary: s)),
                        const SizedBox(height: 20),
                      ],
                      if (participating.isNotEmpty) ...[
                        _SectionHeader(
                          title: 'PARTICIPATING',
                          count: participating.length,
                          label: 'JOINED',
                        ),
                        const SizedBox(height: 8),
                        ...participating.map((s) => _BoardTile(summary: s)),
                        const SizedBox(height: 20),
                      ],
                      if (bookmarked.isNotEmpty) ...[
                        _SectionHeader(
                          title: 'BOOKMARKED',
                          count: bookmarked.length,
                          label: 'SAVED',
                        ),
                        const SizedBox(height: 8),
                        ...bookmarked.map((s) => _BoardTile(
                              summary: s,
                              showBookmark: true,
                            )),
                        const SizedBox(height: 20),
                      ],
                      const SizedBox(height: 24),
                    ]),
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

// ─── Board Tile (full-width vertical list item) ──────────────

class _BoardTile extends ConsumerWidget {
  final ListSummary summary;
  final bool showBookmark;

  const _BoardTile({required this.summary, this.showBookmark = false});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return GestureDetector(
      onTap: () => context.push('/lists/${summary.id}'),
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: AppColors.border),
        ),
        child: Row(
          children: [
            // Rank or role badge
            SizedBox(
              width: 52,
              child: summary.ownRank != null
                  ? Text(
                      '#${summary.ownRank.toString().padLeft(2, '0')}',
                      style: AppTextStyles.label,
                    )
                  : summary.currentUserRole != null
                      ? Text(
                          summary.currentUserRole!.name.toUpperCase(),
                          style: AppTextStyles.badge
                              .copyWith(color: AppColors.textTertiary),
                        )
                      : const SizedBox.shrink(),
            ),
            const SizedBox(width: 8),
            // Title and stats
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    summary.title.toUpperCase(),
                    style: AppTextStyles.body
                        .copyWith(fontWeight: FontWeight.w700, fontSize: 13),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(Icons.people_outline,
                          size: 13, color: AppColors.textTertiary),
                      const SizedBox(width: 4),
                      Text(
                        _formatCount(summary.memberCount),
                        style:
                            AppTextStyles.bodySecondary.copyWith(fontSize: 12),
                      ),
                      const SizedBox(width: 10),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 5, vertical: 1),
                        decoration: BoxDecoration(
                          color: AppColors.accent.withAlpha(25),
                          borderRadius: BorderRadius.circular(3),
                        ),
                        child: Text(
                          summary.valueType.name.toUpperCase(),
                          style: AppTextStyles.badge
                              .copyWith(color: AppColors.accent),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            // Bookmark or chevron
            if (showBookmark)
              GestureDetector(
                onTap: () =>
                    ref.read(bookmarkProvider.notifier).toggle(summary.id),
                child: const Padding(
                  padding: EdgeInsets.only(left: 8),
                  child:
                      Icon(Icons.bookmark, color: AppColors.accent, size: 18),
                ),
              )
            else
              const Icon(Icons.chevron_right,
                  color: AppColors.textTertiary, size: 18),
          ],
        ),
      ),
    );
  }

  String _formatCount(int count) {
    if (count >= 1000) return '${(count / 1000).toStringAsFixed(1)}K';
    return count.toString();
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
          ],
        ),
      ),
    );
  }
}
