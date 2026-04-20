import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/strings.dart';
import '../../../core/theme/colors.dart';
import '../../../core/theme/text_styles.dart';
import '../../auth/presentation/providers/auth_provider.dart';

/// Settings screen — account, privacy, legal.
class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
          children: [
            // Header
            _buildHeader(context),
            const SizedBox(height: 24),
            // Account section
            Text(
              S.account,
              style: AppTextStyles.badge.copyWith(
                color: AppColors.textTertiary,
              ),
            ),
            const SizedBox(height: 8),
            _SettingsRow(
              icon: Icons.logout,
              label: S.signOut,
              onTap: () async {
                await ref.read(authProvider.notifier).logout();
                if (context.mounted) context.go('/login');
              },
            ),
            const SizedBox(height: 24),
            // Legal section
            Text(
              S.legal,
              style: AppTextStyles.badge.copyWith(
                color: AppColors.textTertiary,
              ),
            ),
            const SizedBox(height: 8),
            _SettingsCard(
              children: [
                _SettingsRow(
                  icon: Icons.shield_outlined,
                  label: S.dataAndPrivacy,
                  onTap: () => _showPlaceholder(context, S.dataAndPrivacy),
                ),
                const Divider(color: AppColors.border, height: 1, indent: 48),
                _SettingsRow(
                  icon: Icons.description_outlined,
                  label: S.termsOfService,
                  onTap: () => _showPlaceholder(context, S.termsOfService),
                ),
                const Divider(color: AppColors.border, height: 1, indent: 48),
                _SettingsRow(
                  icon: Icons.policy_outlined,
                  label: S.privacyPolicy,
                  onTap: () => _showPlaceholder(context, S.privacyPolicy),
                ),
              ],
            ),
            const SizedBox(height: 48),
            // App version
            Center(
              child: Text(
                S.appVersion,
                style: AppTextStyles.badge.copyWith(
                  color: AppColors.textTertiary,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 0),
      child: Row(
        children: [
          IconButton(
            onPressed: () => context.pop(),
            icon: const Icon(
              Icons.chevron_left,
              color: AppColors.textPrimary,
              size: 28,
            ),
          ),
          const SizedBox(width: 4),
          Text(S.settings, style: AppTextStyles.screenTitle),
        ],
      ),
    );
  }

  void _showPlaceholder(BuildContext context, String title) {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: AppColors.card,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (ctx) => Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.border,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 24),
            Text(title, style: AppTextStyles.screenTitle),
            const SizedBox(height: 16),
            Text(
              S.comingSoon,
              style: AppTextStyles.bodySecondary.copyWith(
                color: AppColors.textTertiary,
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}

// ─── Settings Card (groups multiple rows) ────────────────────

class _SettingsCard extends StatelessWidget {
  final List<Widget> children;

  const _SettingsCard({required this.children});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(mainAxisSize: MainAxisSize.min, children: children),
    );
  }
}

// ─── Settings Row ────────────────────────────────────────────

class _SettingsRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _SettingsRow({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        constraints: const BoxConstraints(minHeight: 52),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            Icon(icon, color: AppColors.textSecondary, size: 22),
            const SizedBox(width: 14),
            Expanded(
              child: Text(
                label,
                style: AppTextStyles.body.copyWith(fontWeight: FontWeight.w600),
              ),
            ),
            const Icon(
              Icons.chevron_right,
              color: AppColors.textTertiary,
              size: 18,
            ),
          ],
        ),
      ),
    );
  }
}
