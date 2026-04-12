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
                  Text(
                    summary.title.toUpperCase(),
                    style: AppTextStyles.body
                        .copyWith(fontWeight: FontWeight.w700, fontSize: 13),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
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
                ],
              ),
            ),
            _buildTrailing(ref),
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
