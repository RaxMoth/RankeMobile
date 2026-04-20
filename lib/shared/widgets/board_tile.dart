import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/theme/colors.dart';
import '../../core/theme/responsive.dart';
import '../../core/theme/text_styles.dart';
import '../../features/lists/domain/entities/ranked_list.dart';
import '../../features/lists/presentation/providers/bookmark_provider.dart';

/// Reusable board list tile used on Home and Profile screens.
///
/// [showRankBadge] shows rank/role on the left (Home style).
/// [showBookmark] replaces the trailing chevron with a bookmark toggle.
class BoardTile extends ConsumerWidget {
  final ListSummary summary;
  final VoidCallback onTap;
  final bool showRankBadge;
  final bool showBookmark;

  const BoardTile({
    super.key,
    required this.summary,
    required this.onTap,
    this.showRankBadge = false,
    this.showBookmark = false,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: AppColors.border),
        ),
        child: Row(
          children: [
            if (showRankBadge) ...[
              SizedBox(
                width: Responsive.scale(context, 52),
                child: _buildRankBadge(),
              ),
              const SizedBox(width: 8),
            ],
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          summary.title.toUpperCase(),
                          style: AppTextStyles.body.copyWith(
                              fontWeight: FontWeight.w700, fontSize: 13),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(width: 8),
                      _buildTrailing(ref),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      _typeBadge(summary.valueType),
                      const SizedBox(width: 8),
                      const Icon(Icons.people_outline,
                          size: 13, color: AppColors.textTertiary),
                      const SizedBox(width: 4),
                      Text(
                        _formatCount(summary.memberCount),
                        style:
                            AppTextStyles.bodySecondary.copyWith(fontSize: 12),
                      ),
                      if (summary.ownRank != null && !showRankBadge) ...[
                        const SizedBox(width: 8),
                        Text('#${summary.ownRank}',
                            style: AppTextStyles.label),
                      ],
                    ],
                  ),
                  if (summary.topEntries.isNotEmpty) ...[
                    const SizedBox(height: 10),
                    Container(
                      height: 1,
                      color: AppColors.border,
                    ),
                    const SizedBox(height: 8),
                    for (int i = 0; i < summary.topEntries.length; i++) ...[
                      _EntryPreviewRow(
                        entry: summary.topEntries[i],
                        valueType: summary.valueType,
                        isOwn: summary.ownRank != null &&
                            summary.topEntries[i].rank == summary.ownRank,
                      ),
                      if (i < summary.topEntries.length - 1)
                        const SizedBox(height: 4),
                    ],
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRankBadge() {
    if (summary.ownRank != null) {
      return Text(
        '#${summary.ownRank.toString().padLeft(2, '0')}',
        style: AppTextStyles.label,
      );
    }
    if (summary.currentUserRole != null) {
      return Text(
        summary.currentUserRole!.name.toUpperCase(),
        style: AppTextStyles.badge.copyWith(color: AppColors.textTertiary),
      );
    }
    return const SizedBox.shrink();
  }

  Widget _buildTrailing(WidgetRef ref) {
    if (showBookmark) {
      return GestureDetector(
        onTap: () => ref.read(bookmarkProvider.notifier).toggle(summary.id),
        child: const Padding(
          padding: EdgeInsets.only(left: 8),
          child: Icon(Icons.bookmark, color: AppColors.accent, size: 18),
        ),
      );
    }
    return const Icon(Icons.chevron_right,
        color: AppColors.textTertiary, size: 18);
  }

  static Widget _typeBadge(ValueType type) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
      decoration: BoxDecoration(
        color: AppColors.accent.withAlpha(25),
        borderRadius: BorderRadius.circular(3),
      ),
      child: Text(
        type.name.toUpperCase(),
        style: AppTextStyles.badge.copyWith(color: AppColors.accent),
      ),
    );
  }

  static String _formatCount(int count) {
    if (count >= 1000) return '${(count / 1000).toStringAsFixed(1)}K';
    return count.toString();
  }
}

/// Compact single-row preview of a ranked entry: rank + name + value.
/// Shown inline under board metadata on Home tiles.
class _EntryPreviewRow extends StatelessWidget {
  final RankedEntry entry;
  final ValueType valueType;
  final bool isOwn;

  const _EntryPreviewRow({
    required this.entry,
    required this.valueType,
    required this.isOwn,
  });

  @override
  Widget build(BuildContext context) {
    final rankColor = entry.rank == 1
        ? AppColors.accent
        : (isOwn ? AppColors.accent : AppColors.textTertiary);
    final nameColor = isOwn ? AppColors.textPrimary : AppColors.textSecondary;

    return Row(
      children: [
        SizedBox(
          width: 22,
          child: Text(
            '#${entry.rank}',
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w800,
              color: rankColor,
              letterSpacing: 0.3,
            ),
          ),
        ),
        const SizedBox(width: 6),
        Expanded(
          child: Text(
            isOwn ? 'You' : entry.displayName,
            style: TextStyle(
              fontSize: 12,
              fontWeight: isOwn ? FontWeight.w700 : FontWeight.w500,
              color: nameColor,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        const SizedBox(width: 8),
        Text(
          _formatValue(entry, valueType),
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w700,
            color: entry.rank == 1
                ? AppColors.accent
                : AppColors.textSecondary,
            fontFeatures: const [FontFeature.tabularFigures()],
          ),
        ),
      ],
    );
  }

  static String _formatValue(RankedEntry entry, ValueType type) {
    switch (type) {
      case ValueType.number:
        final v = entry.valueNumber;
        if (v == null) return '—';
        if (v == v.roundToDouble()) return v.toStringAsFixed(0);
        return v.toStringAsFixed(1);
      case ValueType.duration:
        final ms = entry.valueDurationMs;
        if (ms == null) return '—';
        final totalSec = ms ~/ 1000;
        final h = totalSec ~/ 3600;
        final m = (totalSec % 3600) ~/ 60;
        final s = totalSec % 60;
        if (h > 0) {
          return '$h:${m.toString().padLeft(2, '0')}:${s.toString().padLeft(2, '0')}';
        }
        return '${m.toString().padLeft(2, '0')}:${s.toString().padLeft(2, '0')}';
      case ValueType.text:
        return entry.valueText ?? '—';
    }
  }
}
