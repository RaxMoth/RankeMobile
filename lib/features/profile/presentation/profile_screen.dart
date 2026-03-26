import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/colors.dart';
import '../../../core/theme/text_styles.dart';
import '../../auth/presentation/providers/auth_provider.dart';
import '../../lists/domain/entities/ranked_list.dart';
import '../../lists/presentation/providers/bookmark_provider.dart';
import '../../lists/presentation/providers/lists_provider.dart';

/// Profile screen — user info, created boards, subscribed boards, logout
class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authAsync = ref.watch(authProvider);
    final listsAsync = ref.watch(listsProvider);
    final bookmarks = ref.watch(bookmarkProvider);

    return SafeArea(
      child: CustomScrollView(
        slivers: [
          // Header
          SliverToBoxAdapter(child: _buildHeader()),
          // User info
          SliverToBoxAdapter(
            child: authAsync.when(
              data: (user) => _UserInfoSection(
                displayName: user?.displayName ?? 'OPERATOR',
                email: user?.email ?? '—',
              ),
              loading: () => const _UserInfoSection(
                displayName: 'LOADING...',
                email: '—',
              ),
              error: (_, __) => const _UserInfoSection(
                displayName: 'OPERATOR',
                email: '—',
              ),
            ),
          ),
          // Stats
          SliverToBoxAdapter(
            child: listsAsync.when(
              data: (lists) {
                final owned = lists
                    .where((l) => l.currentUserRole == MemberRole.owner)
                    .length;
                final joined = lists
                    .where((l) => l.currentUserRole != null)
                    .length;
                return _StatsSection(
                  ownedCount: owned,
                  joinedCount: joined,
                  bookmarkedCount: bookmarks.length,
                );
              },
              loading: () => const _StatsSection(
                  ownedCount: 0, joinedCount: 0, bookmarkedCount: 0),
              error: (_, __) => const _StatsSection(
                  ownedCount: 0, joinedCount: 0, bookmarkedCount: 0),
            ),
          ),
          // My boards
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 24, 20, 12),
              child:
                  Text('MY BOARDS', style: AppTextStyles.sectionHeader),
            ),
          ),
          listsAsync.when(
            data: (lists) => lists.isEmpty
                ? const SliverToBoxAdapter(child: _EmptySection(message: 'NO BOARDS YET'))
                : SliverPadding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    sliver: SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (context, index) => _BoardListItem(
                          summary: lists[index],
                          onTap: () =>
                              context.push('/lists/${lists[index].id}'),
                        ),
                        childCount: lists.length,
                      ),
                    ),
                  ),
            loading: () => const SliverToBoxAdapter(
              child: Center(
                child: Padding(
                  padding: EdgeInsets.all(24),
                  child:
                      CircularProgressIndicator(color: AppColors.accent),
                ),
              ),
            ),
            error: (e, _) => SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Text(
                  'FAILED TO LOAD BOARDS',
                  style: AppTextStyles.badge
                      .copyWith(color: AppColors.error),
                ),
              ),
            ),
          ),
          // Logout
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 32, 20, 16),
              child: _LogoutButton(
                onPressed: () async {
                  await ref.read(authProvider.notifier).logout();
                  if (context.mounted) context.go('/login');
                },
              ),
            ),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 32)),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('PROFILE', style: AppTextStyles.displayLarge),
          const SizedBox(height: 2),
          Text('OPERATOR STATUS', style: AppTextStyles.subtitle),
        ],
      ),
    );
  }
}

class _UserInfoSection extends StatelessWidget {
  final String displayName;
  final String email;

  const _UserInfoSection({
    required this.displayName,
    required this.email,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 24, 20, 0),
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
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                color: AppColors.accent.withAlpha(25),
                borderRadius: BorderRadius.circular(26),
                border: Border.all(color: AppColors.accent, width: 1.5),
              ),
              child: Center(
                child: Text(
                  displayName.isNotEmpty
                      ? displayName[0].toUpperCase()
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
                    displayName.toUpperCase(),
                    style: AppTextStyles.screenTitle,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    email,
                    style: AppTextStyles.bodySecondary.copyWith(fontSize: 12),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StatsSection extends StatelessWidget {
  final int ownedCount;
  final int joinedCount;
  final int bookmarkedCount;

  const _StatsSection({
    required this.ownedCount,
    required this.joinedCount,
    required this.bookmarkedCount,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
      child: Row(
        children: [
          Expanded(
            child: _StatCard(
              label: 'OWNED',
              value: ownedCount.toString(),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _StatCard(
              label: 'JOINED',
              value: joinedCount.toString(),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _StatCard(
              label: 'SAVED',
              value: bookmarkedCount.toString(),
            ),
          ),
        ],
      ),
    );
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
          Text(label, style: AppTextStyles.badge.copyWith(color: AppColors.textTertiary)),
          const SizedBox(height: 6),
          Text(value, style: AppTextStyles.statValue),
        ],
      ),
    );
  }
}

class _BoardListItem extends StatelessWidget {
  final ListSummary summary;
  final VoidCallback onTap;

  const _BoardListItem({required this.summary, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
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
                      _typeBadge(summary.valueType),
                      const SizedBox(width: 8),
                      Icon(Icons.people_outline,
                          size: 13, color: AppColors.textTertiary),
                      const SizedBox(width: 4),
                      Text(
                        '${summary.memberCount}',
                        style:
                            AppTextStyles.bodySecondary.copyWith(fontSize: 12),
                      ),
                      if (summary.ownRank != null) ...[
                        const SizedBox(width: 8),
                        Text(
                          '#${summary.ownRank}',
                          style: AppTextStyles.label,
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),
            const Icon(Icons.chevron_right,
                color: AppColors.textTertiary, size: 18),
          ],
        ),
      ),
    );
  }

  Widget _typeBadge(ValueType type) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
      decoration: BoxDecoration(
        color: AppColors.accent.withAlpha(25),
        borderRadius: BorderRadius.circular(3),
      ),
      child: Text(
        type.name.toUpperCase(),
        style: AppTextStyles.badge.copyWith(color: AppColors.accent),
      ),
    );
  }
}

class _EmptySection extends StatelessWidget {
  final String message;

  const _EmptySection({required this.message});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: AppColors.border),
        ),
        child: Center(
          child: Text(
            message,
            style: AppTextStyles.bodySecondary
                .copyWith(color: AppColors.textTertiary),
          ),
        ),
      ),
    );
  }
}

class _LogoutButton extends StatelessWidget {
  final VoidCallback onPressed;

  const _LogoutButton({required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: onPressed,
      style: OutlinedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 16),
        side: const BorderSide(color: AppColors.error),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
      ),
      child: Text(
        'SIGN OUT',
        style: AppTextStyles.button.copyWith(color: AppColors.error),
      ),
    );
  }
}
