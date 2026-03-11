import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../shared/widgets/app_button.dart';
import '../../../shared/widgets/error_view.dart';
import '../../../shared/widgets/value_type_badge.dart';
import '../../../core/network/api_error.dart';
import '../../entries/presentation/widgets/entry_row.dart';
import 'providers/lists_provider.dart';

class InvitePreviewScreen extends ConsumerStatefulWidget {
  final String token;

  const InvitePreviewScreen({super.key, required this.token});

  @override
  ConsumerState<InvitePreviewScreen> createState() =>
      _InvitePreviewScreenState();
}

class _InvitePreviewScreenState extends ConsumerState<InvitePreviewScreen> {
  bool _joining = false;

  Future<void> _join() async {
    setState(() => _joining = true);
    try {
      final list = await ref
          .read(invitePreviewProvider(widget.token).notifier)
          .join();
      if (mounted) context.go('/lists/${list.id}');
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.toString())),
        );
      }
    } finally {
      if (mounted) setState(() => _joining = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final previewAsync = ref.watch(invitePreviewProvider(widget.token));

    return Scaffold(
      appBar: AppBar(title: const Text('Join List')),
      body: previewAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => ErrorView(
          error: error is ApiError ? error : const ApiUnknownError(),
          onRetry: () =>
              ref.invalidate(invitePreviewProvider(widget.token)),
        ),
        data: (list) => Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(list.title,
                  style: Theme.of(context).textTheme.headlineSmall),
              const SizedBox(height: 8),
              Row(
                children: [
                  ValueTypeBadge(valueType: list.valueType),
                  const SizedBox(width: 12),
                  Text('${list.memberCount} members'),
                ],
              ),
              const SizedBox(height: 24),
              if (list.entries.isNotEmpty) ...[
                Text('Top entries',
                    style: Theme.of(context).textTheme.titleSmall),
                const SizedBox(height: 8),
                ...list.entries.take(3).map(
                      (e) => EntryRow(entry: e, valueType: list.valueType),
                    ),
              ],
              const Spacer(),
              AppButton(
                label: 'Join',
                onPressed: _join,
                isLoading: _joining,
                width: double.infinity,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
