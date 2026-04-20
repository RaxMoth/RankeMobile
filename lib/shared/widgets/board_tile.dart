import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:share_plus/share_plus.dart';

import '../../core/strings.dart';
import '../../core/theme/colors.dart';
import '../../core/theme/responsive.dart';
import '../../core/theme/text_styles.dart';
import '../../features/lists/domain/entities/ranked_list.dart';
import '../../features/lists/presentation/providers/bookmark_provider.dart';
import 'bottom_sheet_handle.dart';
import 'sheet_action_row.dart';

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
      onLongPress: () {
        HapticFeedback.mediumImpact();
        _showQuickActions(context, ref);
      },
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
                      _ValueTypeGlyph(type: summary.valueType),
                      const SizedBox(width: 8),
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

  void _showQuickActions(BuildContext context, WidgetRef ref) {
    final isBookmarked =
        ref.read(bookmarkProvider.notifier).isBookmarked(summary.id);
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
            children: [
              const BottomSheetHandle(),
              // Title preview
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  summary.title.toUpperCase(),
                  style: AppTextStyles.label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(height: 12),
              SheetActionRow(
                icon: isBookmarked ? Icons.bookmark : Icons.bookmark_border,
                label: isBookmarked ? S.bookmarked : S.bookmark,
                iconColor: isBookmarked
                    ? AppColors.accent
                    : AppColors.textSecondary,
                onTap: () {
                  ref.read(bookmarkProvider.notifier).toggle(summary.id);
                  Navigator.pop(ctx);
                },
              ),
              SheetActionRow(
                icon: Icons.share_outlined,
                label: S.share,
                iconColor: AppColors.textSecondary,
                onTap: () async {
                  Navigator.pop(ctx);
                  await SharePlus.instance.share(
                    ShareParams(text: S.shareBoardMessage(summary.title)),
                  );
                },
              ),
              SheetActionRow(
                icon: Icons.open_in_new,
                label: S.openDetails,
                iconColor: AppColors.textSecondary,
                onTap: () {
                  Navigator.pop(ctx);
                  onTap();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  static String _formatCount(int count) {
    if (count >= 1000) return '${(count / 1000).toStringAsFixed(1)}K';
    return count.toString();
  }
}

/// Single-glyph icon representing the board's value type.
class _ValueTypeGlyph extends StatelessWidget {
  final ValueType type;
  const _ValueTypeGlyph({required this.type});

  @override
  Widget build(BuildContext context) {
    final icon = switch (type) {
      ValueType.number => Icons.tag,
      ValueType.duration => Icons.timer_outlined,
      ValueType.text => Icons.short_text,
    };
    return Container(
      width: 20,
      height: 20,
      decoration: BoxDecoration(
        color: AppColors.accent.withAlpha(25),
        borderRadius: BorderRadius.circular(4),
      ),
      alignment: Alignment.center,
      child: Icon(icon, size: 13, color: AppColors.accent),
    );
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
        const SizedBox(width: 4),
        _RankDelta(previousRank: entry.previousRank, currentRank: entry.rank),
        const SizedBox(width: 4),
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

/// Small up/down/flat indicator showing how an entry's rank has changed
/// since the last snapshot. A lower rank number is better, so a lower
/// current rank than previous is a "rise" (▲).
class _RankDelta extends StatelessWidget {
  final int? previousRank;
  final int currentRank;

  const _RankDelta({required this.previousRank, required this.currentRank});

  @override
  Widget build(BuildContext context) {
    final prev = previousRank;
    if (prev == null) {
      return const SizedBox(width: 18);
    }
    final diff = prev - currentRank; // positive = moved up
    if (diff == 0) {
      return const SizedBox(
        width: 18,
        child: Text(
          '—',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 10,
            color: AppColors.textTertiary,
            fontWeight: FontWeight.w700,
          ),
        ),
      );
    }
    final isUp = diff > 0;
    final color = isUp ? AppColors.success : AppColors.error;
    final arrow = isUp ? '▲' : '▼';
    return SizedBox(
      width: 18,
      child: Text(
        '$arrow${diff.abs()}',
        style: TextStyle(
          fontSize: 9,
          fontWeight: FontWeight.w800,
          color: color,
          letterSpacing: -0.3,
        ),
      ),
    );
  }
}
