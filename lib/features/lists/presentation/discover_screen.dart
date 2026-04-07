import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/dev/mock_lists_repository.dart';
import '../../../core/theme/colors.dart';
import '../../../core/theme/responsive.dart';
import '../../../core/theme/text_styles.dart';
import '../../../shared/widgets/value_type_badge.dart';
import '../domain/entities/ranked_list.dart';
import 'providers/bookmark_provider.dart';
import 'providers/discover_provider.dart';

class DiscoverScreen extends ConsumerStatefulWidget {
  const DiscoverScreen({super.key});

  @override
  ConsumerState<DiscoverScreen> createState() => _DiscoverScreenState();
}

class _DiscoverScreenState extends ConsumerState<DiscoverScreen> {
  final _searchController = TextEditingController();
  Timer? _debounce;

  @override
  void dispose() {
    _searchController.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  void _onSearchChanged(String value) {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 300), () {
      ref.read(discoverQueryProvider.notifier).state = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    final resultsAsync = ref.watch(discoverResultsProvider);
    final selectedCategory = ref.watch(discoverCategoryProvider);

    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            // Header
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('DISCOVER', style: AppTextStyles.screenTitle),
                    const SizedBox(height: 4),
                    Text('EXPLORE PUBLIC BOARDS',
                        style: AppTextStyles.subtitle),
                    const SizedBox(height: 16),
                    // Search bar
                    TextField(
                      controller: _searchController,
                      style: AppTextStyles.body,
                      onChanged: _onSearchChanged,
                      decoration: InputDecoration(
                        hintText: 'SEARCH BOARDS...',
                        hintStyle: AppTextStyles.bodySecondary
                            .copyWith(color: AppColors.textTertiary),
                        prefixIcon: const Icon(Icons.search,
                            color: AppColors.textTertiary, size: 20),
                        suffixIcon: _searchController.text.isNotEmpty
                            ? IconButton(
                                icon: const Icon(Icons.clear,
                                    color: AppColors.textTertiary, size: 18),
                                onPressed: () {
                                  _searchController.clear();
                                  ref
                                      .read(discoverQueryProvider.notifier)
                                      .state = '';
                                },
                              )
                            : null,
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ),
            // Category chips
            SliverToBoxAdapter(
              child: SizedBox(
                height: Responsive.scale(context, 36),
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  children: [
                    _CategoryChip(
                      label: 'ALL',
                      isSelected: selectedCategory == null,
                      onTap: () => ref
                          .read(discoverCategoryProvider.notifier)
                          .state = null,
                    ),
                    ...BoardCategory.all.map((cat) => Padding(
                          padding: const EdgeInsets.only(left: 8),
                          child: _CategoryChip(
                            label: cat,
                            isSelected: selectedCategory == cat,
                            onTap: () => ref
                                .read(discoverCategoryProvider.notifier)
                                .state = cat,
                          ),
                        )),
                  ],
                ),
              ),
            ),
            const SliverToBoxAdapter(child: SizedBox(height: 16)),
            // Results
            resultsAsync.when(
              data: (lists) {
                if (lists.isEmpty) {
                  return SliverFillRemaining(
                    child: Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.search_off,
                              color: AppColors.textTertiary, size: 48),
                          const SizedBox(height: 12),
                          Text('NO BOARDS FOUND',
                              style: AppTextStyles.sectionHeader
                                  .copyWith(color: AppColors.textTertiary)),
                        ],
                      ),
                    ),
                  );
                }
                return SliverPadding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  sliver: SliverList.builder(
                    itemCount: lists.length,
                    itemBuilder: (context, index) =>
                        _DiscoverBoardCard(summary: lists[index]),
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
                  child: Text('ERROR: $e',
                      style: AppTextStyles.body
                          .copyWith(color: AppColors.error)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CategoryChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _CategoryChip({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.accent : AppColors.surface,
          borderRadius: BorderRadius.circular(6),
          border: Border.all(
            color: isSelected ? AppColors.accent : AppColors.border,
          ),
        ),
        child: Text(
          label,
          style: AppTextStyles.badge.copyWith(
            color: isSelected ? AppColors.background : AppColors.textSecondary,
            fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
          ),
        ),
      ),
    );
  }
}

class _DiscoverBoardCard extends ConsumerWidget {
  final ListSummary summary;

  const _DiscoverBoardCard({required this.summary});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bookmarks = ref.watch(bookmarkProvider);
    final isBookmarked = bookmarks.contains(summary.id);

    return GestureDetector(
      onTap: () => context.push('/lists/${summary.id}'),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.card,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: AppColors.border),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    summary.title.toUpperCase(),
                    style: AppTextStyles.boardTitle,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(width: 8),
                ValueTypeBadge(valueType: summary.valueType),
                const SizedBox(width: 8),
                GestureDetector(
                  onTap: () =>
                      ref.read(bookmarkProvider.notifier).toggle(summary.id),
                  child: Icon(
                    isBookmarked
                        ? Icons.bookmark
                        : Icons.bookmark_border,
                    color: isBookmarked
                        ? AppColors.accent
                        : AppColors.textTertiary,
                    size: 22,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            // Stats row
            Row(
              children: [
                Icon(Icons.people_outline,
                    size: 14, color: AppColors.textTertiary),
                const SizedBox(width: 4),
                Text(
                  _formatCount(summary.memberCount),
                  style: AppTextStyles.badge
                      .copyWith(color: AppColors.textTertiary),
                ),
                const SizedBox(width: 16),
                if (summary.category != null) ...[
                  Icon(Icons.tag, size: 14, color: AppColors.textTertiary),
                  const SizedBox(width: 4),
                  Text(
                    summary.category!,
                    style: AppTextStyles.badge
                        .copyWith(color: AppColors.textTertiary),
                  ),
                ],
                const Spacer(),
                if (summary.currentUserRole != null)
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: AppColors.accent.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      'JOINED',
                      style: AppTextStyles.badge
                          .copyWith(color: AppColors.accent, fontSize: 9),
                    ),
                  ),
                if (summary.ownRank != null) ...[
                  const SizedBox(width: 8),
                  Text(
                    '#${summary.ownRank}',
                    style: AppTextStyles.rankNumber.copyWith(fontSize: 14),
                  ),
                ],
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
