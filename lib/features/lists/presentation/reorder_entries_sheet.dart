import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/strings.dart';
import '../../../core/theme/colors.dart';
import '../../../core/theme/text_styles.dart';
import '../../../shared/widgets/confirm_sheet.dart';
import '../domain/entities/ranked_list.dart';
import 'providers/lists_provider.dart';

/// Owner/admin sheet for ranking a text board: text values have no natural
/// order, so the standings are whatever order is saved here (#1 on top).
class ReorderEntriesSheet extends ConsumerStatefulWidget {
  final String listId;
  final List<RankedEntry> entries;

  const ReorderEntriesSheet({
    super.key,
    required this.listId,
    required this.entries,
  });

  @override
  ConsumerState<ReorderEntriesSheet> createState() =>
      _ReorderEntriesSheetState();
}

class _ReorderEntriesSheetState extends ConsumerState<ReorderEntriesSheet> {
  late final List<RankedEntry> _order = [...widget.entries];
  bool _saving = false;

  Future<void> _save() async {
    setState(() => _saving = true);
    try {
      await ref.read(listDetailProvider(widget.listId).notifier).reorderEntries(
        [for (final e in _order) e.id],
      );
      if (mounted) Navigator.pop(context);
    } catch (e) {
      if (mounted) showErrorSnackBar(context, S.failedToUpdate(e));
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(S.reorderEntries, style: AppTextStyles.screenTitle),
            const SizedBox(height: 8),
            Text(S.reorderHint, style: AppTextStyles.bodySecondary),
            const SizedBox(height: 16),
            Flexible(
              child: ReorderableListView.builder(
                shrinkWrap: true,
                buildDefaultDragHandles: false,
                itemCount: _order.length,
                onReorder: (from, to) => setState(() {
                  final moved = _order.removeAt(from);
                  _order.insert(to > from ? to - 1 : to, moved);
                }),
                itemBuilder: (context, i) {
                  final entry = _order[i];
                  return ReorderableDragStartListener(
                    key: ValueKey(entry.id),
                    index: i,
                    child: Container(
                      constraints: const BoxConstraints(minHeight: 52),
                      margin: const EdgeInsets.only(bottom: 8),
                      padding: const EdgeInsets.symmetric(horizontal: 14),
                      decoration: BoxDecoration(
                        color: AppColors.surface,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: AppColors.border),
                      ),
                      child: Row(
                        children: [
                          SizedBox(
                            width: 36,
                            child: Text(
                              '#${i + 1}',
                              style: AppTextStyles.badge,
                            ),
                          ),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  entry.valueText ?? '',
                                  style: AppTextStyles.body,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                Text(
                                  entry.displayName,
                                  style: AppTextStyles.bodySecondary,
                                ),
                              ],
                            ),
                          ),
                          const Icon(
                            Icons.drag_handle,
                            color: AppColors.textTertiary,
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _saving || _order.isEmpty ? null : _save,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: _saving
                    ? const SizedBox(
                        height: 18,
                        width: 18,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Text(S.saveOrder),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
