import 'package:flutter/material.dart';
<<<<<<< HEAD
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:share_plus/share_plus.dart';
import '../../../shared/widgets/error_view.dart';
import '../../../core/network/api_error.dart';
import '../../entries/presentation/submit_entry_sheet.dart';
import '../../entries/presentation/widgets/entry_row.dart';
import '../domain/entities/ranked_list.dart';
import 'providers/lists_provider.dart';

class ListDetailScreen extends ConsumerWidget {
=======
import 'package:go_router/go_router.dart';

import '../../../core/theme/colors.dart';
import '../../../core/theme/text_styles.dart';

/// List Detail Screen — full ranked leaderboard with standings
class ListDetailScreen extends StatelessWidget {
>>>>>>> 88d3438 (good progress)
  final String listId;

  const ListDetailScreen({super.key, required this.listId});

  @override
<<<<<<< HEAD
  Widget build(BuildContext context, WidgetRef ref) {
    final detailAsync = ref.watch(listDetailProvider(listId));

    return Scaffold(
      appBar: AppBar(
        title: detailAsync.whenOrNull(data: (d) => Text(d.title)) ??
            const Text('List'),
        actions: [
          if (detailAsync.hasValue && detailAsync.value!.inviteToken != null)
            PopupMenuButton<String>(
              onSelected: (action) =>
                  _onMenuAction(context, ref, action, detailAsync.value!),
              itemBuilder: (_) => [
                const PopupMenuItem(
                  value: 'share',
                  child: ListTile(
                    leading: Icon(Icons.share),
                    title: Text('Share invite link'),
                    contentPadding: EdgeInsets.zero,
                  ),
                ),
                const PopupMenuItem(
                  value: 'members',
                  child: ListTile(
                    leading: Icon(Icons.people),
                    title: Text('Manage members'),
                    contentPadding: EdgeInsets.zero,
                  ),
                ),
              ],
            ),
        ],
      ),
      body: detailAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => ErrorView(
          error: error is ApiError ? error : const ApiUnknownError(),
          onRetry: () => ref.invalidate(listDetailProvider(listId)),
        ),
        data: (rankedList) {
          if (rankedList.entries.isEmpty) {
            return const Center(
              child: Text('No entries yet. Be the first!'),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.symmetric(vertical: 8),
            itemCount: rankedList.entries.length,
            itemBuilder: (context, index) => EntryRow(
              entry: rankedList.entries[index],
              valueType: rankedList.valueType,
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showSubmitSheet(context, ref),
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showSubmitSheet(BuildContext context, WidgetRef ref) {
    final rankedList = ref.read(listDetailProvider(listId)).valueOrNull;
    if (rankedList == null) return;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (_) => SubmitEntrySheet(
        listId: listId,
        valueType: rankedList.valueType,
      ),
    );
  }

  void _onMenuAction(
    BuildContext context,
    WidgetRef ref,
    String action,
    RankedList rankedList,
  ) {
    switch (action) {
      case 'share':
        final token = rankedList.inviteToken;
        if (token != null) {
          Share.share('rankapp://invite/$token');
        }
      case 'members':
        context.push('/lists/$listId/members');
    }
  }
=======
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            _DetailHeader(onBack: () => context.pop()),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                children: [
                  const _ObjectiveSection(),
                  const _MetricsBar(),
                  const _StandingsHeader(),
                  // Standings list
                  const _StandingRow(
                    rank: 1,
                    name: 'K. NAKAMURA',
                    value: '+48.2%',
                    isCurrentUser: false,
                  ),
                  const _StandingRow(
                    rank: 2,
                    name: 'S. CHEN',
                    value: '+36.5%',
                    isCurrentUser: false,
                  ),
                  const _StandingRow(
                    rank: 1402,
                    name: 'MAX ROTH',
                    value: '+14.2%',
                    isCurrentUser: true,
                  ),
                  const _StandingRow(
                    rank: 3,
                    name: 'V. PETROV',
                    value: '+34.1%',
                    isCurrentUser: false,
                  ),
                  const SizedBox(height: 20),
                  const _AdminFooter(),
                  const SizedBox(height: 24),
                ],
              ),
            ),
            const _SubmitButton(),
          ],
        ),
      ),
    );
  }
}

// ─── Detail Header ────────────────────────────────────────────

class _DetailHeader extends StatelessWidget {
  final VoidCallback onBack;

  const _DetailHeader({required this.onBack});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(4, 8, 20, 16),
      child: Row(
        children: [
          IconButton(
            onPressed: onBack,
            icon: const Icon(Icons.chevron_left, color: AppColors.textPrimary, size: 28),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('YTD EQUITY RETURNS', style: AppTextStyles.screenTitle),
                const SizedBox(height: 2),
                Text(
                  'FINANCE  •  STANDARD METRIC',
                  style: AppTextStyles.subtitle,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Objective Section ────────────────────────────────────────

class _ObjectiveSection extends StatelessWidget {
  const _ObjectiveSection();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('OBJECTIVE', style: AppTextStyles.label),
          const SizedBox(height: 8),
          Text(
            'Track total realized and unrealized equity gains from Jan 1st to Dec 31st. Percentage-based reporting only.',
            style: AppTextStyles.bodySecondary,
          ),
        ],
      ),
    );
  }
}

// ─── Metrics Bar ──────────────────────────────────────────────

class _MetricsBar extends StatelessWidget {
  const _MetricsBar();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 24),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('PRIMARY METRIC', style: AppTextStyles.label.copyWith(color: AppColors.textTertiary)),
                const SizedBox(height: 6),
                Text(
                  'PERCENTAGE (%)',
                  style: AppTextStyles.body.copyWith(fontWeight: FontWeight.w800),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('ENTRIES', style: AppTextStyles.label.copyWith(color: AppColors.textTertiary)),
              const SizedBox(height: 6),
              Text(
                '12,402',
                style: AppTextStyles.body.copyWith(fontWeight: FontWeight.w800),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ─── Standings Header ─────────────────────────────────────────

class _StandingsHeader extends StatelessWidget {
  const _StandingsHeader();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text('OFFICIAL STANDINGS', style: AppTextStyles.sectionHeader),
          Row(
            children: [
              const Icon(Icons.star, color: AppColors.accent, size: 16),
              const SizedBox(width: 6),
              Text(
                'VERIFIED ONLY',
                style: AppTextStyles.badge.copyWith(color: AppColors.textSecondary),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ─── Standing Row ─────────────────────────────────────────────

class _StandingRow extends StatelessWidget {
  final int rank;
  final String name;
  final String value;
  final bool isCurrentUser;

  const _StandingRow({
    required this.rank,
    required this.name,
    required this.value,
    required this.isCurrentUser,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      decoration: BoxDecoration(
        color: isCurrentUser ? AppColors.accent.withAlpha(20) : AppColors.surface,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: isCurrentUser ? AppColors.accent.withAlpha(80) : AppColors.border,
        ),
      ),
      child: Row(
        children: [
          // Rank
          SizedBox(
            width: 48,
            child: Text(
              rank.toString().padLeft(2, '0'),
              style: AppTextStyles.rankNumber.copyWith(
                color: isCurrentUser ? AppColors.accent : AppColors.textMuted,
              ),
            ),
          ),
          const SizedBox(width: 12),
          // Avatar placeholder
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: AppColors.surfaceLight,
              borderRadius: BorderRadius.circular(6),
            ),
            child: Icon(
              Icons.person,
              color: isCurrentUser ? AppColors.accent : AppColors.textTertiary,
              size: 22,
            ),
          ),
          const SizedBox(width: 12),
          // Name + badge
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: AppTextStyles.body.copyWith(fontWeight: FontWeight.w700),
                ),
                if (isCurrentUser)
                  Padding(
                    padding: const EdgeInsets.only(top: 2),
                    child: Text(
                      'YOUR ENTRY',
                      style: AppTextStyles.badge.copyWith(color: AppColors.accent),
                    ),
                  ),
              ],
            ),
          ),
          // Value + status
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                value,
                style: AppTextStyles.statValue.copyWith(
                  color: isCurrentUser ? AppColors.accent : AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                'ACTIVE',
                style: AppTextStyles.badge.copyWith(color: AppColors.textTertiary),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ─── Admin Footer ─────────────────────────────────────────────

class _AdminFooter extends StatelessWidget {
  const _AdminFooter();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: AppColors.surfaceLight,
              borderRadius: BorderRadius.circular(6),
            ),
            child: const Icon(Icons.shield_outlined, color: AppColors.textTertiary, size: 18),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'ADMINISTERED BY',
                  style: AppTextStyles.badge.copyWith(color: AppColors.textTertiary),
                ),
                const SizedBox(height: 2),
                Text(
                  'GLOBAL MARKETS GROUP',
                  style: AppTextStyles.body.copyWith(fontWeight: FontWeight.w700, fontSize: 13),
                ),
              ],
            ),
          ),
          Text('EST. JAN 2024', style: AppTextStyles.badge.copyWith(color: AppColors.textTertiary)),
        ],
      ),
    );
  }
}

// ─── Submit Button ────────────────────────────────────────────

class _SubmitButton extends StatelessWidget {
  const _SubmitButton();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 16),
      child: ElevatedButton(
        onPressed: () {
          // TODO: open SubmitEntrySheet
        },
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 18),
        ),
        child: const Text('SUBMIT NEW ENTRY'),
      ),
    );
  }
>>>>>>> 88d3438 (good progress)
}
