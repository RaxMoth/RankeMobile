import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../shared/widgets/error_view.dart';
import '../../../core/network/api_error.dart';
import '../domain/entities/ranked_list.dart';
import 'providers/lists_provider.dart';

class ManageMembersScreen extends ConsumerWidget {
  final String listId;

  const ManageMembersScreen({super.key, required this.listId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final membersAsync = ref.watch(membersProvider(listId));

    return Scaffold(
      appBar: AppBar(title: const Text('Members')),
      body: membersAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => ErrorView(
          error: error is ApiError ? error : const ApiUnknownError(),
          onRetry: () => ref.invalidate(membersProvider(listId)),
        ),
        data: (members) => ListView.builder(
          itemCount: members.length,
          itemBuilder: (context, index) {
            final member = members[index];
            return ListTile(
              leading: CircleAvatar(
                child: Text(member.displayName[0].toUpperCase()),
              ),
              title: Text(member.displayName),
              trailing: _RoleBadge(role: member.role),
              onLongPress: member.role == MemberRole.owner
                  ? null
                  : () => _showMemberActions(context, ref, member),
            );
          },
        ),
      ),
    );
  }

  void _showMemberActions(
    BuildContext context,
    WidgetRef ref,
    ListMember member,
  ) {
    showModalBottomSheet(
      context: context,
      builder: (_) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.arrow_upward),
              title: Text(member.role == MemberRole.admin
                  ? 'Demote to Member'
                  : 'Promote to Admin'),
              onTap: () {
                Navigator.pop(context);
                final newRole = member.role == MemberRole.admin
                    ? MemberRole.member
                    : MemberRole.admin;
                ref.read(membersProvider(listId).notifier).updateRole(
                      userId: member.userId,
                      role: newRole,
                    );
              },
            ),
            ListTile(
              leading: const Icon(Icons.remove_circle_outline, color: Colors.red),
              title: const Text('Remove', style: TextStyle(color: Colors.red)),
              onTap: () {
                Navigator.pop(context);
                ref
                    .read(membersProvider(listId).notifier)
                    .removeMember(member.userId);
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _RoleBadge extends StatelessWidget {
  final MemberRole role;

  const _RoleBadge({required this.role});

  @override
  Widget build(BuildContext context) {
    final (label, color) = switch (role) {
      MemberRole.owner => ('Owner', Colors.amber),
      MemberRole.admin => ('Admin', Colors.blue),
      MemberRole.member => ('Member', Colors.grey),
    };

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w500,
          color: color,
        ),
      ),
    );
  }
}
