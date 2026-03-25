import 'package:flutter/material.dart';
<<<<<<< HEAD
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../shared/widgets/value_type_badge.dart';
import '../../../shared/widgets/error_view.dart';
import '../../../core/network/api_error.dart';
import '../domain/entities/ranked_list.dart';
import 'providers/lists_provider.dart';
import 'create_list_sheet.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final listsAsync = ref.watch(listsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Lists'),
        actions: [
          IconButton(
            icon: const Icon(Icons.person_outlined),
            onPressed: () => context.push('/profile'),
          ),
        ],
      ),
      body: listsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => ErrorView(
          error: error is ApiError ? error : const ApiUnknownError(),
          onRetry: () => ref.read(listsProvider.notifier).refresh(),
        ),
        data: (lists) {
          if (lists.isEmpty) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.list_alt, size: 64, color: Colors.grey.shade400),
                  const SizedBox(height: 16),
                  Text(
                    'No lists yet',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 8),
                  const Text('Create your first ranked list!'),
                ],
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: () async =>
                ref.read(listsProvider.notifier).refresh(),
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: lists.length,
              itemBuilder: (context, index) =>
                  _ListCard(summary: lists[index]),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showCreateSheet(context),
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showCreateSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (_) => const CreateListSheet(),
=======
import 'package:go_router/go_router.dart';

import '../../../core/theme/colors.dart';
import '../../../core/theme/text_styles.dart';

/// Home Screen — main dashboard with active boards and global directory
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: SafeArea(
        child: _HomeBody(),
      ),
      bottomNavigationBar: _BottomNav(),
>>>>>>> 88d3438 (good progress)
    );
  }
}

<<<<<<< HEAD
class _ListCard extends StatelessWidget {
  final ListSummary summary;

  const _ListCard({required this.summary});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        borderRadius: BorderRadius.circular(8),
        onTap: () => context.push('/lists/${summary.id}'),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      summary.title,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  ),
                  ValueTypeBadge(valueType: summary.valueType),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Icon(Icons.people_outlined,
                      size: 16, color: Colors.grey.shade600),
                  const SizedBox(width: 4),
                  Text(
                    '${summary.memberCount} members',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  if (summary.ownRank != null) ...[
                    const Spacer(),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: Theme.of(context)
                            .colorScheme
                            .primary
                            .withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        '#${summary.ownRank}',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                    ),
                  ],
=======
class _HomeBody extends StatelessWidget {
  const _HomeBody();

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        // Header
        SliverToBoxAdapter(child: _buildHeader(context)),
        // Search
        const SliverToBoxAdapter(child: _SearchBar()),
        // Active Boards
        const SliverToBoxAdapter(child: _ActiveBoardsSection()),
        // Global Directory
        const SliverToBoxAdapter(child: _DirectoryHeader()),
        // Directory list
        SliverPadding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          sliver: SliverList(
            delegate: SliverChildListDelegate([
              _DirectoryItem(
                title: 'YTD EQUITY RETURNS',
                category: 'FINANCE',
                categoryColor: AppColors.categoryFinance,
                memberCount: 12402,
                topValue: '14.2%',
                topLabel: 'TOP MARK',
              ),
              _DirectoryItem(
                title: 'DEADLIFT MAX (RAW)',
                category: 'FITNESS',
                categoryColor: AppColors.categoryFitness,
                memberCount: 8912,
                topValue: '320',
                topLabel: 'KG',
              ),
              _DirectoryItem(
                title: 'LEETCODE HARD CLEAR',
                category: 'CODING',
                categoryColor: AppColors.categoryCoding,
                memberCount: 4190,
                topValue: '412',
                topLabel: 'SOLVED',
              ),
              _DirectoryItem(
                title: 'DAILY STEPS AVG',
                category: 'HEALTH',
                categoryColor: AppColors.categoryHealth,
                memberCount: 22041,
                topValue: '31k',
                topLabel: 'STEPS',
              ),
            ]),
          ),
        ),
        const SliverToBoxAdapter(child: SizedBox(height: 16)),
        // Initialize button
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: _InitializeButton(
              onPressed: () => context.push('/create'),
            ),
          ),
        ),
        const SliverToBoxAdapter(child: SizedBox(height: 24)),
      ],
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('APEX', style: AppTextStyles.displayLarge),
              const SizedBox(height: 2),
              Text('TERMINAL READY', style: AppTextStyles.subtitle),
            ],
          ),
          IconButton(
            onPressed: () => context.push('/profile'),
            icon: const Icon(
              Icons.notifications_none_rounded,
              color: AppColors.textSecondary,
              size: 24,
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Search Bar ───────────────────────────────────────────────

class _SearchBar extends StatelessWidget {
  const _SearchBar();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
      child: Container(
        height: 48,
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: AppColors.border),
        ),
        child: Row(
          children: [
            const SizedBox(width: 14),
            const Icon(Icons.search, color: AppColors.textTertiary, size: 20),
            const SizedBox(width: 10),
            Text(
              'SEARCH LEADERBOARDS...',
              style: AppTextStyles.bodySecondary.copyWith(
                letterSpacing: 1.0,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Active Boards Section ────────────────────────────────────

class _ActiveBoardsSection extends StatelessWidget {
  const _ActiveBoardsSection();

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
              Text('MY ACTIVE BOARDS', style: AppTextStyles.sectionHeader),
              Text(
                'VIEW ALL  ›',
                style: AppTextStyles.bodySecondary.copyWith(fontSize: 12),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 100,
          child: ListView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            children: const [
              _ActiveBoardCard(
                rank: 4,
                title: 'Q3 SALES GROSS',
                value: '245k',
                unit: 'USD',
              ),
              SizedBox(width: 12),
              _ActiveBoardCard(
                rank: 12,
                title: '5K RUN TIME',
                value: '21:45',
                unit: 'MIN',
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),
      ],
    );
  }
}

class _ActiveBoardCard extends StatelessWidget {
  final int rank;
  final String title;
  final String value;
  final String unit;

  const _ActiveBoardCard({
    required this.rank,
    required this.title,
    required this.value,
    required this.unit,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 170,
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
          Text(
            'RANK ${rank.toString().padLeft(2, '0')}',
            style: AppTextStyles.label,
          ),
          Text(title, style: AppTextStyles.body.copyWith(fontWeight: FontWeight.w700, fontSize: 13)),
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(value, style: AppTextStyles.valueDisplay),
              const SizedBox(width: 4),
              Text(unit, style: AppTextStyles.unit),
            ],
          ),
        ],
      ),
    );
  }
}

// ─── Directory Header with Tabs ───────────────────────────────

class _DirectoryHeader extends StatelessWidget {
  const _DirectoryHeader();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text('GLOBAL DIRECTORY', style: AppTextStyles.sectionHeader),
          Row(
            children: [
              _TabChip(label: 'TRENDING', isActive: true),
              const SizedBox(width: 12),
              _TabChip(label: 'NEW', isActive: false),
              const SizedBox(width: 12),
              _TabChip(label: 'ALL', isActive: false),
            ],
          ),
        ],
      ),
    );
  }
}

class _TabChip extends StatelessWidget {
  final String label;
  final bool isActive;

  const _TabChip({required this.label, required this.isActive});

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      style: AppTextStyles.tab.copyWith(
        color: isActive ? AppColors.accent : AppColors.textTertiary,
      ),
    );
  }
}

// ─── Directory Item ───────────────────────────────────────────

class _DirectoryItem extends StatelessWidget {
  final String title;
  final String category;
  final Color categoryColor;
  final int memberCount;
  final String topValue;
  final String topLabel;

  const _DirectoryItem({
    required this.title,
    required this.category,
    required this.categoryColor,
    required this.memberCount,
    required this.topValue,
    required this.topLabel,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => context.push('/lists/demo'),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: AppColors.border),
        ),
        child: IntrinsicHeight(
          child: Row(
            children: [
              // Left accent bar
              Container(
                width: 3,
                decoration: BoxDecoration(
                  color: categoryColor,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(width: 14),
              // Title + metadata
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: AppTextStyles.boardTitle),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        _CategoryBadge(label: category, color: categoryColor),
                        const SizedBox(width: 10),
                        Icon(Icons.people_outline, size: 13, color: AppColors.textTertiary),
                        const SizedBox(width: 4),
                        Text(
                          _formatCount(memberCount),
                          style: AppTextStyles.bodySecondary.copyWith(fontSize: 12),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              // Top value
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    topValue,
                    style: AppTextStyles.statValue,
                  ),
                  Text(
                    topLabel,
                    style: AppTextStyles.unit.copyWith(fontSize: 10),
                  ),
>>>>>>> 88d3438 (good progress)
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
<<<<<<< HEAD
=======

  String _formatCount(int count) {
    if (count >= 1000) {
      return '${(count / 1000).toStringAsFixed(count % 1000 == 0 ? 0 : 1)}k';
    }
    return count.toString();
  }
}

class _CategoryBadge extends StatelessWidget {
  final String label;
  final Color color;

  const _CategoryBadge({required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: color.withAlpha(30),
        borderRadius: BorderRadius.circular(3),
      ),
      child: Text(
        label,
        style: AppTextStyles.badge.copyWith(color: color),
      ),
    );
  }
}

// ─── Initialize Button ────────────────────────────────────────

class _InitializeButton extends StatelessWidget {
  final VoidCallback onPressed;

  const _InitializeButton({required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: onPressed,
      style: OutlinedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 18),
        side: const BorderSide(color: AppColors.border),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
      ),
      child: Text(
        'INITIALIZE LEADERBOARD',
        style: AppTextStyles.button.copyWith(color: AppColors.textPrimary),
      ),
    );
  }
}

// ─── Bottom Navigation ────────────────────────────────────────

class _BottomNav extends StatelessWidget {
  const _BottomNav();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        border: Border(top: BorderSide(color: AppColors.border, width: 1)),
      ),
      child: BottomNavigationBar(
        currentIndex: 0,
        onTap: (index) {
          if (index == 2) context.push('/create');
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.menu, size: 22),
            label: 'HOME',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bar_chart_rounded, size: 22),
            label: 'ENTRIES',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add_circle_outline, size: 22),
            label: 'CREATE',
          ),
        ],
      ),
    );
  }
>>>>>>> 88d3438 (good progress)
}
