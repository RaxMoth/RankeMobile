import 'package:flutter/material.dart';
import '../../domain/entities/entry.dart';
import '../../../lists/domain/entities/ranked_list.dart';
import 'duration_picker.dart';

class EntryRow extends StatelessWidget {
  final RankedEntry entry;
  final ValueType valueType;
  final bool highlight;

  const EntryRow({
    super.key,
    required this.entry,
    required this.valueType,
    this.highlight = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: highlight
            ? Theme.of(context).colorScheme.primary.withValues(alpha: 0.08)
            : Theme.of(context).cardTheme.color,
        borderRadius: BorderRadius.circular(8),
        border: highlight
            ? Border.all(
                color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.3))
            : null,
      ),
      child: Row(
        children: [
          SizedBox(
            width: 36,
            child: Text(
              '#${entry.rank}',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  entry.displayName,
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                if (entry.note != null && entry.note!.isNotEmpty)
                  Text(
                    entry.note!,
                    style: Theme.of(context).textTheme.bodySmall,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
              ],
            ),
          ),
          Text(
            _formatValue(),
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontFeatures: const [FontFeature.tabularFigures()],
                ),
          ),
        ],
      ),
    );
  }

  String _formatValue() {
    return switch (valueType) {
      ValueType.number => entry.valueNumber?.toString() ?? '-',
      ValueType.duration =>
        entry.valueDurationMs != null
            ? formatDuration(entry.valueDurationMs!)
            : '-',
      ValueType.text => entry.valueText ?? '-',
    };
  }
}
