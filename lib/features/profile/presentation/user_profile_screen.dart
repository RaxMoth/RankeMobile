import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/colors.dart';
import '../../../core/theme/responsive.dart';
import '../../../core/theme/text_styles.dart';
import '../../../shared/widgets/board_tile.dart';
import '../../lists/domain/entities/ranked_list.dart';
import 'providers/profile_provider.dart';

/// Public user profile screen — shows a user's boards and stats.
class UserProfileScreen extends ConsumerWidget {
  final String userId;

  const UserProfileScreen({super.key, required this.userId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profileAsync = ref.watch(userProfileProvider(userId));

    return Scaffold(
      body: SafeArea(
        child: profileAsync.when(
          data: (profile) => _ProfileContent(profile: profile),
          loading: () => const Center(
            child: CircularProgressIndicator(color: AppColors.accent),
          ),
          error: (e, _) => Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.error_outline,
                    color: AppColors.error, size: 32),
                const SizedBox(height: 12),
                Text('USER NOT FOUND',
                    style: AppTextStyles.sectionHeader
                        .copyWith(color: AppColors.error)),
                const SizedBox(height: 16),
                TextButton(
                  onPressed: () => context.pop(),
                  child: const Text('GO BACK'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ProfileContent extends StatelessWidget {
  final dynamic profile;

  const _ProfileContent({required this.profile});

  @override
  Widget build(BuildContext context) {
    final owned = profile.boards
        .where((ListSummary b) =>
            b.currentUserRole == MemberRole.owner)
        .toList();
    final participating = profile.boards
        .where((ListSummary b) =>
            b.currentUserRole != MemberRole.owner)
        .toList();

    final items = <Widget>[];

    if (owned.isNotEmpty) {
      items.add(_sectionLabel('OWNED BOARDS', owned.length));
      items.add(const SizedBox(height: 8));
      for (final s in owned) {
        items.add(BoardTile(
          summary: s,
          onTap: () => context.push('/lists/${s.id}'),
        ));
      }
      items.add(const SizedBox(height: 20));
    }

    if (participating.isNotEmpty) {
      items.add(_sectionLabel('PARTICIPATING', participating.length));
      items.add(const SizedBox(height: 8));
      for (final s in participating) {
        items.add(BoardTile(
          summary: s,
          onTap: () => context.push('/lists/${s.id}'),
        ));
      }
      items.add(const SizedBox(height: 20));
    }

    return CustomScrollView(
      slivers: [
        // Header
        SliverToBoxAdapter(
          child: _buildHeader(context),
        ),
        // Stats
        SliverToBoxAdapter(
          child: _buildStats(owned.length, participating.length),
        ),
        // Board sections
        if (items.isEmpty)
          const SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.fromLTRB(20, 40, 20, 0),
              child: Center(
                child: Text('NO PUBLIC BOARDS'),
              ),
            ),
          )
        else
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            sliver: SliverList.builder(
              itemCount: items.length,
              itemBuilder: (context, index) => items[index],
            ),
          ),
        const SliverToBoxAdapter(child: SizedBox(height: 32)),
      ],
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(4, 8, 20, 0),
      child: Column(
        children: [
          Row(
            children: [
              IconButton(
                onPressed: () => context.pop(),
                icon: const Icon(Icons.chevron_left,
                    color: AppColors.textPrimary, size: 28),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('OPERATOR', style: AppTextStyles.displayLarge),
                    const SizedBox(height: 2),
                    Text('PUBLIC PROFILE', style: AppTextStyles.subtitle),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          // Avatar + name card
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: AppColors.border),
              ),
              child: Row(
                children: [
                  Container(
                    width: Responsive.scale(context, 52),
                    height: Responsive.scale(context, 52),
                    decoration: BoxDecoration(
                      color: AppColors.accent.withAlpha(25),
                      borderRadius:
                          BorderRadius.circular(Responsive.scale(context, 26)),
                      border: Border.all(color: AppColors.accent, width: 1.5),
                    ),
                    child: Center(
                      child: Text(
                        profile.displayName.isNotEmpty
                            ? profile.displayName[0].toUpperCase()
                            : '?',
                        style: AppTextStyles.valueDisplay
                            .copyWith(color: AppColors.accent),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          profile.displayName.toUpperCase(),
                          style: AppTextStyles.screenTitle,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        if (profile.memberSince != null) ...[
                          const SizedBox(height: 4),
                          Text(
                            'MEMBER SINCE ${_formatDate(profile.memberSince!)}',
                            style: AppTextStyles.bodySecondary
                                .copyWith(fontSize: 12),
                          ),
                        ],
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStats(int ownedCount, int participatingCount) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
      child: Row(
        children: [
          Expanded(
            child: _StatCard(label: 'BOARDS', value: '${ownedCount + participatingCount}'),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _StatCard(label: 'OWNED', value: '$ownedCount'),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _StatCard(label: 'JOINED', value: '$participatingCount'),
          ),
        ],
      ),
    );
  }

  Widget _sectionLabel(String title, int count) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style: AppTextStyles.sectionHeader),
        Text('$count',
            style: AppTextStyles.bodySecondary.copyWith(fontSize: 12)),
      ],
    );
  }

  String _formatDate(DateTime date) {
    const months = [
      'JAN', 'FEB', 'MAR', 'APR', 'MAY', 'JUN',
      'JUL', 'AUG', 'SEP', 'OCT', 'NOV', 'DEC',
    ];
    return '${months[date.month - 1]} ${date.year}';
  }
}

class _StatCard extends StatelessWidget {
  final String label;
  final String value;

  const _StatCard({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label,
              style:
                  AppTextStyles.badge.copyWith(color: AppColors.textTertiary)),
          const SizedBox(height: 6),
          Text(value, style: AppTextStyles.statValue),
        ],
      ),
    );
  }
}
