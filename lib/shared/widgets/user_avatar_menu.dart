import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/strings.dart';
import '../../core/theme/colors.dart';
import '../../core/theme/text_styles.dart';
import '../../features/auth/presentation/providers/auth_provider.dart';
import 'bottom_sheet_handle.dart';
import 'sheet_action_row.dart';

/// Small circular avatar shown in the top-right of Home. Tap opens a
/// bottom sheet with profile/settings/logout actions — replacing the
/// former Profile bottom-nav tab.
class UserAvatarMenu extends ConsumerWidget {
  const UserAvatarMenu({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authProvider).valueOrNull;
    final initial =
        (user?.displayName.isNotEmpty ?? false) ? user!.displayName[0] : '?';

    return GestureDetector(
      onTap: () {
        HapticFeedback.lightImpact();
        _openMenu(context, ref);
      },
      child: Container(
        width: 34,
        height: 34,
        decoration: BoxDecoration(
          color: AppColors.accent.withAlpha(25),
          borderRadius: BorderRadius.circular(17),
          border: Border.all(color: AppColors.accent, width: 1.2),
        ),
        alignment: Alignment.center,
        child: Text(
          initial.toUpperCase(),
          style: AppTextStyles.label.copyWith(color: AppColors.accent),
        ),
      ),
    );
  }

  void _openMenu(BuildContext context, WidgetRef ref) {
    final user = ref.read(authProvider).valueOrNull;
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: AppColors.card,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (ctx) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const BottomSheetHandle(),
              if (user != null)
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
                  child: Row(
                    children: [
                      Container(
                        width: 44,
                        height: 44,
                        decoration: BoxDecoration(
                          color: AppColors.accent.withAlpha(25),
                          borderRadius: BorderRadius.circular(22),
                          border:
                              Border.all(color: AppColors.accent, width: 1.5),
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          user.displayName.isNotEmpty
                              ? user.displayName[0].toUpperCase()
                              : '?',
                          style: AppTextStyles.valueDisplay
                              .copyWith(color: AppColors.accent),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              user.displayName,
                              style: AppTextStyles.body.copyWith(
                                fontWeight: FontWeight.w700,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            Text(
                              user.email,
                              style: AppTextStyles.bodySecondary
                                  .copyWith(fontSize: 12),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              const SizedBox(height: 8),
              SheetActionRow(
                icon: Icons.bar_chart_outlined,
                label: S.viewStats,
                onTap: () {
                  Navigator.pop(ctx);
                  context.push('/profile');
                },
              ),
              if (user != null)
                SheetActionRow(
                  icon: Icons.person_outline,
                  label: S.viewPublicProfileMenu,
                  onTap: () {
                    Navigator.pop(ctx);
                    context.push('/users/${user.id}');
                  },
                ),
              SheetActionRow(
                icon: Icons.settings_outlined,
                label: S.settingsMenu,
                onTap: () {
                  Navigator.pop(ctx);
                  context.push('/settings');
                },
              ),
              const Divider(color: AppColors.border, height: 24),
              SheetActionRow(
                icon: Icons.logout,
                label: S.logoutAction,
                destructive: true,
                onTap: () async {
                  Navigator.pop(ctx);
                  await ref.read(authProvider.notifier).logout();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

