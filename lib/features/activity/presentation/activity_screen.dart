import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/strings.dart';
import '../../../core/theme/colors.dart';
import '../../../core/theme/text_styles.dart';
import '../../../shared/widgets/create_fab.dart';
import '../../lists/presentation/providers/lists_provider.dart';
import '../domain/activity_event.dart';
import 'providers/activity_provider.dart';

class ActivityScreen extends ConsumerWidget {
  const ActivityScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final feedAsync = ref.watch(activityFeedProvider);

    return Scaffold(
      floatingActionButton: const CreateFab(),
      body: SafeArea(
        child: RefreshIndicator(
          color: AppColors.accent,
          backgroundColor: AppColors.surface,
          onRefresh: () => ref.read(listsProvider.notifier).refresh(),
          child: feedAsync.when(
            loading: () =>
                const Center(child: CircularProgressIndicator(color: AppColors.accent)),
            error: (e, _) => Center(
              child: Text(
                S.failedToLoad,
                style:
                    AppTextStyles.sectionHeader.copyWith(color: AppColors.error),
              ),
            ),
            data: (events) {
              if (events.isEmpty) {
                return ListView(
                  children: [
                    const SizedBox(height: 120),
                    const Icon(Icons.bolt_outlined,
                        color: AppColors.textTertiary, size: 48),
                    const SizedBox(height: 16),
                    Center(
                      child: Text(
                        S.noActivityYet,
                        style: AppTextStyles.sectionHeader
                            .copyWith(color: AppColors.textSecondary),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Center(
                      child: Text(
                        S.noActivityHint,
                        style: AppTextStyles.badge
                            .copyWith(color: AppColors.textTertiary),
                      ),
                    ),
                  ],
                );
              }
              return ListView.separated(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
                itemCount: events.length,
                separatorBuilder: (_, _) => const SizedBox(height: 8),
                itemBuilder: (_, i) => _ActivityTile(event: events[i]),
              );
            },
          ),
        ),
      ),
    );
  }
}

class _ActivityTile extends StatelessWidget {
  final ActivityEvent event;
  const _ActivityTile({required this.event});

  @override
  Widget build(BuildContext context) {
    final (icon, iconColor) = switch (event.kind) {
      ActivityKind.newEntry => (Icons.add_circle_outline, AppColors.accent),
      ActivityKind.rankUp => (Icons.trending_up, AppColors.success),
      ActivityKind.rankDown => (Icons.trending_down, AppColors.error),
      ActivityKind.newMember => (Icons.person_add_outlined, AppColors.accent),
    };

    return GestureDetector(
      onTap: () => context.push('/lists/${event.boardId}'),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: event.isOwn
              ? AppColors.accent.withAlpha(15)
              : AppColors.surface,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color:
                event.isOwn ? AppColors.accent.withAlpha(60) : AppColors.border,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: iconColor.withAlpha(25),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Icon(icon, size: 18, color: iconColor),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _headline(),
                    style: AppTextStyles.body.copyWith(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    event.boardTitle.toUpperCase(),
                    style: AppTextStyles.badge
                        .copyWith(color: AppColors.textTertiary),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Text(
              _relativeTime(event.at),
              style: AppTextStyles.badge
                  .copyWith(color: AppColors.textTertiary, fontSize: 10),
            ),
          ],
        ),
      ),
    );
  }

  String _headline() {
    switch (event.kind) {
      case ActivityKind.newEntry:
        return '${event.actorName} submitted at rank #${event.rank}';
      case ActivityKind.rankUp:
        return '${event.actorName} rose to #${event.rank} from #${event.previousRank}';
      case ActivityKind.rankDown:
        return '${event.actorName} dropped to #${event.rank} from #${event.previousRank}';
      case ActivityKind.newMember:
        return '${event.actorName} joined';
    }
  }

  String _relativeTime(DateTime dt) {
    final diff = DateTime.now().difference(dt);
    if (diff.inDays > 0) return S.dAgo(diff.inDays);
    if (diff.inHours > 0) return S.hAgo(diff.inHours);
    if (diff.inMinutes > 0) return S.mAgo(diff.inMinutes);
    return S.justNow;
  }
}
