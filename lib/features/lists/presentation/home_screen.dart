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
                // Bookmarked: boards whose ID is in bookmarks, excluding already shown
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

                return SliverList(
                  delegate: SliverChildListDelegate([
                    if (owned.isNotEmpty)
                      _BoardSection(
                        title: 'MY BOARDS',
                        subtitle: '${owned.length} OWNED',
                        lists: owned,
                      ),
                    if (participating.isNotEmpty)
                      _BoardSection(
                        title: 'PARTICIPATING',
                        subtitle: '${participating.length} JOINED',
                        lists: participating,
                      ),
                    if (bookmarked.isNotEmpty)
                      _BoardSection(
                        title: 'BOOKMARKED',
                        subtitle: '${bookmarked.length} SAVED',
                        lists: bookmarked,
                        isBookmarkSection: true,
                      ),
                    const SizedBox(height: 24),
                  ]),
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

// ─── Board Section ────────────────────────────────────────────

class _BoardSection extends StatelessWidget {
  final String title;
  final String subtitle;
  final List<ListSummary> lists;
  final bool isBookmarkSection;

  const _BoardSection({
    required this.title,
    required this.subtitle,
    required this.lists,
    this.isBookmarkSection = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(title, style: AppTextStyles.sectionHeader),
              Text(subtitle,
                  style: AppTextStyles.bodySecondary.copyWith(fontSize: 12)),
            ],
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 108,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            itemCount: lists.length,
            separatorBuilder: (_, __) => const SizedBox(width: 12),
            itemBuilder: (context, index) => _HomeBoardCard(
              summary: lists[index],
              showBookmark: isBookmarkSection,
            ),
          ),
        ),
        const SizedBox(height: 24),
      ],
    );
  }
}

// ─── Board Card ───────────────────────────────────────────────

class _HomeBoardCard extends ConsumerWidget {
  final ListSummary summary;
  final bool showBookmark;

  const _HomeBoardCard({required this.summary, this.showBookmark = false});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return GestureDetector(
      onTap: () => context.push('/lists/${summary.id}'),
      child: Container(
        width: 180,
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: AppColors.border),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Top row: rank or role badge
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if (summary.ownRank != null)
                  Text(
                    'RANK ${summary.ownRank.toString().padLeft(2, '0')}',
                    style: AppTextStyles.label,
                  )
                else if (summary.currentUserRole != null)
                  Text(
                    summary.currentUserRole!.name.toUpperCase(),
                    style: AppTextStyles.label,
                  )
                else
                  const SizedBox.shrink(),
                if (showBookmark)
                  GestureDetector(
                    onTap: () =>
                        ref.read(bookmarkProvider.notifier).toggle(summary.id),
                    child: const Icon(Icons.bookmark,
                        color: AppColors.accent, size: 16),
                  ),
              ],
            ),
            // Title
            Text(
              summary.title.toUpperCase(),
              style: AppTextStyles.body
                  .copyWith(fontWeight: FontWeight.w700, fontSize: 13),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            // Bottom stats
            Row(
              children: [
                const Icon(Icons.people_outline,
                    size: 13, color: AppColors.textTertiary),
                const SizedBox(width: 4),
                Text(
                  _formatCount(summary.memberCount),
                  style: AppTextStyles.bodySecondary.copyWith(fontSize: 12),
                ),
                const Spacer(),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
                  decoration: BoxDecoration(
                    color: AppColors.accent.withAlpha(25),
                    borderRadius: BorderRadius.circular(3),
                  ),
                  child: Text(
                    summary.valueType.name.toUpperCase(),
                    style:
                        AppTextStyles.badge.copyWith(color: AppColors.accent),
                  ),
                ),
              ],
            ),
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
