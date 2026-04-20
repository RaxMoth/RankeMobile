import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/strings.dart';
import '../../../core/theme/colors.dart';
import '../../../core/theme/responsive.dart';
import '../../../core/theme/text_styles.dart';
import '../../auth/presentation/providers/auth_provider.dart';
import '../../lists/domain/entities/ranked_list.dart';
import '../../lists/presentation/providers/bookmark_provider.dart';
import '../../lists/presentation/providers/home_filter_provider.dart';
import '../../lists/presentation/providers/lists_provider.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authAsync = ref.watch(authProvider);
    final listsAsync = ref.watch(listsProvider);
    final bookmarks = ref.watch(bookmarkProvider);

    return SafeArea(
      child: RefreshIndicator(
        color: AppColors.accent,
        backgroundColor: AppColors.surface,
        onRefresh: () async {
          ref.invalidate(listsProvider);
        },
        child: CustomScrollView(
          slivers: [
            // Header — gear icon only, right-aligned
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 8, 12, 0),
                child: Align(
                  alignment: Alignment.centerRight,
                  child: IconButton(
                    onPressed: () => context.push('/settings'),
                    icon: const Icon(Icons.settings_outlined,
                        color: AppColors.textSecondary, size: 22),
                  ),
                ),
              ),
            ),
            // User info
            SliverToBoxAdapter(
              child: authAsync.when(
                data: (user) => _UserInfoSection(
                  displayName: user?.displayName ?? '—',
                  email: user?.email ?? '—',
                ),
                loading: () => const _UserInfoSection(
                  displayName: S.loading,
                  email: '—',
                ),
                error: (_, _) => const _UserInfoSection(
                  displayName: '—',
                  email: '—',
                ),
              ),
            ),
            // Stats (tappable)
            SliverToBoxAdapter(
              child: listsAsync.when(
                data: (lists) {
                  final owned = lists
                      .where((l) => l.currentUserRole == MemberRole.owner)
                      .length;
                  final joined = lists
                      .where((l) =>
                          l.currentUserRole == MemberRole.admin ||
                          l.currentUserRole == MemberRole.member)
                      .length;
                  return _StatsSection(
                    ownedCount: owned,
                    joinedCount: joined,
                    bookmarkedCount: bookmarks.length,
                  );
                },
                loading: () => const _StatsSection(
                    ownedCount: 0, joinedCount: 0, bookmarkedCount: 0),
                error: (_, _) => const _StatsSection(
                    ownedCount: 0, joinedCount: 0, bookmarkedCount: 0),
              ),
            ),
            // Quick actions
            SliverToBoxAdapter(
              child: authAsync.when(
                data: (user) => user != null
                    ? _QuickActionsSection(userId: user.id)
                    : const SizedBox.shrink(),
                loading: () => const SizedBox.shrink(),
                error: (_, _) => const SizedBox.shrink(),
              ),
            ),
            const SliverToBoxAdapter(child: SizedBox(height: 32)),
          ],
        ),
      ),
    );
  }
}

// ─── User Info ───────────────────────────────────────────────

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
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
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
                    displayName,
                    style: AppTextStyles.screenTitle
                        .copyWith(letterSpacing: 0),
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

// ─── Stats (tappable → navigate to Home with filter) ─────────

class _StatsSection extends ConsumerWidget {
  final int ownedCount;
  final int joinedCount;
  final int bookmarkedCount;

  const _StatsSection({
    required this.ownedCount,
    required this.joinedCount,
    required this.bookmarkedCount,
  });

  void _goToHomeFilter(BuildContext context, WidgetRef ref, HomeFilter filter) {
    HapticFeedback.lightImpact();
    ref.read(homeFilterProvider.notifier).state = filter;
    GoRouter.of(context).go('/home');
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
      child: Row(
        children: [
          Expanded(
            child: _StatCard(
              label: S.owned,
              value: ownedCount.toString(),
              onTap: () => _goToHomeFilter(context, ref, HomeFilter.owned),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _StatCard(
              label: S.joined,
              value: joinedCount.toString(),
              onTap: () => _goToHomeFilter(context, ref, HomeFilter.joined),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _StatCard(
              label: S.saved,
              value: bookmarkedCount.toString(),
              onTap: () => _goToHomeFilter(context, ref, HomeFilter.saved),
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
  final VoidCallback? onTap;

  const _StatCard({
    required this.label,
    required this.value,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
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
                style: AppTextStyles.badge
                    .copyWith(color: AppColors.textTertiary)),
            const SizedBox(height: 6),
            Text(value, style: AppTextStyles.statValue),
          ],
        ),
      ),
    );
  }
}

// ─── Quick Actions ───────────────────────────────────────────

class _QuickActionsSection extends StatelessWidget {
  final String userId;

  const _QuickActionsSection({required this.userId});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
      child: GestureDetector(
        onTap: () => context.push('/users/$userId'),
        behavior: HitTestBehavior.opaque,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: AppColors.border),
          ),
          child: Row(
            children: [
              const Icon(Icons.person_outline,
                  color: AppColors.textSecondary, size: 22),
              const SizedBox(width: 14),
              Expanded(
                child: Text(
                  S.viewPublicProfile,
                  style: AppTextStyles.body.copyWith(fontWeight: FontWeight.w600),
                ),
              ),
              const Icon(Icons.chevron_right,
                  color: AppColors.textTertiary, size: 18),
            ],
          ),
        ),
      ),
    );
  }
}
