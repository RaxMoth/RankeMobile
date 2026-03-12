import 'package:flutter/material.dart';
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
  final String listId;

  const ListDetailScreen({super.key, required this.listId});

  @override
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
}
