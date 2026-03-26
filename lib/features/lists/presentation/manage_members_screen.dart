import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:share_plus/share_plus.dart';

import '../../../core/theme/colors.dart';
import '../../../core/theme/text_styles.dart';
import '../domain/entities/ranked_list.dart';
import 'providers/lists_provider.dart';

/// Manage members screen — owner/admin controls for member management
class ManageMembersScreen extends ConsumerWidget {
  final String listId;

  const ManageMembersScreen({super.key, required this.listId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final membersAsync = ref.watch(membersProvider(listId));

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(context, ref),
            Expanded(
              child: membersAsync.when(
                data: (members) => _MembersList(
                  members: members,
                  listId: listId,
                ),
                loading: () => const Center(
                  child: CircularProgressIndicator(color: AppColors.accent),
                ),
                error: (e, _) => Center(
                  child: Text(
                    'FAILED TO LOAD MEMBERS',
                    style: AppTextStyles.sectionHeader
                        .copyWith(color: AppColors.error),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(4, 8, 12, 16),
      child: Row(
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
                Text('MANAGE MEMBERS', style: AppTextStyles.screenTitle),
                const SizedBox(height: 2),
                Text('ROLE & ACCESS CONTROL', style: AppTextStyles.subtitle),
              ],
            ),
          ),
          IconButton(
            onPressed: () => _shareInvite(context, ref),
            icon: const Icon(Icons.person_add_outlined,
                color: AppColors.accent, size: 22),
          ),
        ],
      ),
    );
  }

  Future<void> _shareInvite(BuildContext context, WidgetRef ref) async {
    try {
      final link = await ref
          .read(listDetailProvider(listId).notifier)
          .getInviteLink();
      await Share.share('Join my board on Apex: rankapp://invite/$link');
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('FAILED TO GET INVITE: $e'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    }
  }
}

class _MembersList extends ConsumerWidget {
  final List<ListMember> members;
  final String listId;

  const _MembersList({required this.members, required this.listId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (members.isEmpty) {
      return Center(
        child: Text(
          'NO MEMBERS',
          style: AppTextStyles.bodySecondary
              .copyWith(color: AppColors.textTertiary),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      itemCount: members.length,
      itemBuilder: (context, index) {
        final member = members[index];
        return _MemberRow(
          member: member,
          listId: listId,
        );
      },
    );
  }
}

class _MemberRow extends ConsumerWidget {
  final ListMember member;
  final String listId;

  const _MemberRow({required this.member, required this.listId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Dismissible(
      key: ValueKey(member.userId),
      direction: member.role == MemberRole.owner
          ? DismissDirection.none
          : DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        margin: const EdgeInsets.only(bottom: 8),
        decoration: BoxDecoration(
          color: AppColors.error,
          borderRadius: BorderRadius.circular(8),
        ),
        child: const Icon(Icons.person_remove, color: Colors.white, size: 20),
      ),
      confirmDismiss: (_) => _confirmRemove(context),
      onDismissed: (_) {
        ref.read(membersProvider(listId).notifier).removeMember(member.userId);
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: member.role == MemberRole.owner
                ? AppColors.accent.withAlpha(60)
                : AppColors.border,
          ),
        ),
        child: Row(
          children: [
            // Avatar
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: member.role == MemberRole.owner
                    ? AppColors.accent.withAlpha(25)
                    : AppColors.surfaceLight,
                borderRadius: BorderRadius.circular(6),
              ),
              child: Center(
                child: Text(
                  member.displayName.isNotEmpty
                      ? member.displayName[0].toUpperCase()
                      : '?',
                  style: AppTextStyles.body.copyWith(
                    fontWeight: FontWeight.w800,
                    color: member.role == MemberRole.owner
                        ? AppColors.accent
                        : AppColors.textTertiary,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            // Name
            Expanded(
              child: Text(
                member.displayName.toUpperCase(),
                style: AppTextStyles.body.copyWith(fontWeight: FontWeight.w700),
              ),
            ),
            // Role badge (tappable for non-owners)
            GestureDetector(
              onTap: member.role != MemberRole.owner
                  ? () => _showRolePicker(context, ref)
                  : null,
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: _roleColor(member.role).withAlpha(20),
                  borderRadius: BorderRadius.circular(4),
                  border: Border.all(color: _roleColor(member.role).withAlpha(60)),
                ),
                child: Text(
                  member.role.name.toUpperCase(),
                  style: AppTextStyles.badge
                      .copyWith(color: _roleColor(member.role)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _roleColor(MemberRole role) {
    return switch (role) {
      MemberRole.owner => AppColors.accent,
      MemberRole.admin => AppColors.categoryCoding,
      MemberRole.member => AppColors.textSecondary,
    };
  }

  Future<bool> _confirmRemove(BuildContext context) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.card,
        title: Text('REMOVE MEMBER',
            style: AppTextStyles.screenTitle.copyWith(fontSize: 16)),
        content: Text(
          'Remove ${member.displayName} from this board?',
          style: AppTextStyles.bodySecondary,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text('CANCEL',
                style: AppTextStyles.button
                    .copyWith(color: AppColors.textSecondary)),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: Text('REMOVE',
                style: AppTextStyles.button.copyWith(color: AppColors.error)),
          ),
        ],
      ),
    );
    return result ?? false;
  }

  void _showRolePicker(BuildContext context, WidgetRef ref) {
    final availableRoles = [MemberRole.admin, MemberRole.member];
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.card,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (ctx) => Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('SET ROLE', style: AppTextStyles.screenTitle),
            const SizedBox(height: 4),
            Text(member.displayName.toUpperCase(),
                style: AppTextStyles.subtitle),
            const SizedBox(height: 16),
            ...availableRoles.map(
              (role) => ListTile(
                leading: Icon(
                  role == MemberRole.admin
                      ? Icons.shield_outlined
                      : Icons.person_outline,
                  color: _roleColor(role),
                ),
                title: Text(role.name.toUpperCase(),
                    style: AppTextStyles.body
                        .copyWith(fontWeight: FontWeight.w700)),
                trailing: member.role == role
                    ? const Icon(Icons.check, color: AppColors.accent, size: 18)
                    : null,
                onTap: () {
                  Navigator.pop(ctx);
                  ref
                      .read(membersProvider(listId).notifier)
                      .updateRole(userId: member.userId, role: role);
                },
              ),
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }
}
