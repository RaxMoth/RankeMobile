import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/colors.dart';
import '../../../core/theme/text_styles.dart';
import '../../../shared/widgets/value_type_badge.dart';
import 'providers/lists_provider.dart';

/// Invite preview screen — shown via deep link, lets user preview and join a board.
class InvitePreviewScreen extends ConsumerWidget {
  final String token;

  const InvitePreviewScreen({super.key, required this.token});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final previewAsync = ref.watch(invitePreviewProvider(token));

    return Scaffold(
      body: SafeArea(
        child: previewAsync.when(
          data: (list) => _InviteContent(
            list: list,
            onJoin: () async {
              try {
                await ref
                    .read(invitePreviewProvider(token).notifier)
                    .join();
                ref.invalidate(listsProvider);
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('JOINED ${list.title.toUpperCase()}'),
                      backgroundColor: AppColors.success,
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                  context.go('/lists/${list.id}');
                }
              } catch (e) {
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('FAILED TO JOIN: $e'),
                      backgroundColor: AppColors.error,
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                }
              }
            },
            onBack: () => context.go('/home'),
          ),
          loading: () => const Center(
            child: CircularProgressIndicator(color: AppColors.accent),
          ),
          error: (e, _) => Center(
            child: Padding(
              padding: const EdgeInsets.all(40),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.link_off,
                      color: AppColors.error, size: 48),
                  const SizedBox(height: 16),
                  Text('INVALID INVITE',
                      style: AppTextStyles.sectionHeader
                          .copyWith(color: AppColors.error)),
                  const SizedBox(height: 8),
                  Text(
                    'THIS INVITE LINK MAY HAVE EXPIRED\nOR BEEN REVOKED',
                    style: AppTextStyles.badge
                        .copyWith(color: AppColors.textTertiary),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 24),
                  TextButton(
                    onPressed: () => context.go('/home'),
                    child: Text('GO HOME',
                        style: AppTextStyles.button
                            .copyWith(color: AppColors.accent)),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _InviteContent extends StatelessWidget {
  final dynamic list;
  final VoidCallback onJoin;
  final VoidCallback onBack;

  const _InviteContent({
    required this.list,
    required this.onJoin,
    required this.onBack,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          // Header
          Row(
            children: [
              IconButton(
                onPressed: onBack,
                icon: const Icon(Icons.chevron_left,
                    color: AppColors.textPrimary, size: 28),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('INVITE', style: AppTextStyles.displayLarge),
                    const SizedBox(height: 2),
                    Text('YOU\'VE BEEN INVITED',
                        style: AppTextStyles.subtitle),
                  ],
                ),
              ),
            ],
          ),
          const Spacer(),
          // Board preview card
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.accent.withAlpha(60)),
            ),
            child: Column(
              children: [
                const Icon(Icons.group_add_outlined,
                    color: AppColors.accent, size: 48),
                const SizedBox(height: 20),
                Text(
                  list.title.toUpperCase(),
                  style: AppTextStyles.screenTitle,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ValueTypeBadge(valueType: list.valueType),
                    const SizedBox(width: 12),
                    Icon(Icons.people_outline,
                        size: 14, color: AppColors.textTertiary),
                    const SizedBox(width: 4),
                    Text(
                      '${list.memberCount} MEMBERS',
                      style: AppTextStyles.badge
                          .copyWith(color: AppColors.textTertiary),
                    ),
                  ],
                ),
                if (list.description != null &&
                    list.description!.isNotEmpty) ...[
                  const SizedBox(height: 16),
                  Text(
                    list.description!,
                    style: AppTextStyles.bodySecondary,
                    textAlign: TextAlign.center,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
                const SizedBox(height: 8),
                Text(
                  list.rankOrder.name == 'desc'
                      ? 'HIGHEST WINS'
                      : 'LOWEST WINS',
                  style: AppTextStyles.badge
                      .copyWith(color: AppColors.textTertiary),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          // Join button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: list.currentUserRole != null ? null : onJoin,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.accent,
                disabledBackgroundColor: AppColors.surfaceLight,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8)),
              ),
              child: Text(
                list.currentUserRole != null
                    ? 'ALREADY A MEMBER'
                    : 'JOIN BOARD',
                style: AppTextStyles.button.copyWith(
                  color: list.currentUserRole != null
                      ? AppColors.textTertiary
                      : AppColors.background,
                ),
              ),
            ),
          ),
          const SizedBox(height: 12),
          TextButton(
            onPressed: onBack,
            child: Text('MAYBE LATER',
                style: AppTextStyles.button
                    .copyWith(color: AppColors.textSecondary)),
          ),
          const Spacer(),
        ],
      ),
    );
  }
}
