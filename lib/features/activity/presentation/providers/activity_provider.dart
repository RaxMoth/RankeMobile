import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../auth/presentation/providers/auth_provider.dart';
import '../../../lists/presentation/providers/lists_provider.dart';
import '../../domain/activity_event.dart';
import '../../domain/build_activity_feed.dart';

/// Derived activity feed: combines submissions + rank changes from the user's
/// joined/owned boards. Sorted by recency.
///
/// Source data is `listsProvider` (summaries with topEntries) — in production
/// this would be a dedicated activity endpoint. The derivation rules live in
/// [buildActivityFeed] so they stay testable in pure-Dart.
final activityFeedProvider =
    Provider.autoDispose<AsyncValue<List<ActivityEvent>>>((ref) {
  final lists = ref.watch(listsProvider);
  final currentUserId = ref.watch(authProvider).valueOrNull?.id;

  return lists.whenData(
    (summaries) => buildActivityFeed(
      summaries: summaries,
      currentUserId: currentUserId,
    ),
  );
});
