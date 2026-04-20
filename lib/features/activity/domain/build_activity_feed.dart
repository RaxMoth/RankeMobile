import '../../lists/domain/entities/ranked_list.dart';
import 'activity_event.dart';

/// Maximum number of events surfaced in the activity feed.
/// Further history is expected to come from a paginated backend endpoint.
const int kMaxActivityEvents = 50;

/// Pure function that derives an activity feed from a set of list summaries
/// plus the current user's id. Extracted from `activityFeedProvider` so the
/// rules are testable in isolation and so presentation doesn't carry domain
/// logic.
///
/// Temporary implementation: activity is synthesized from the topEntries of
/// each joined/owned board. When a real `/activity` endpoint lands, swap the
/// provider's data source — this function can be deleted or repurposed for
/// optimistic local events.
List<ActivityEvent> buildActivityFeed({
  required List<ListSummary> summaries,
  required String? currentUserId,
  int max = kMaxActivityEvents,
}) {
  final events = <ActivityEvent>[];
  for (final s in summaries) {
    // Only surface boards the user is part of.
    if (s.currentUserRole == null) continue;

    for (final entry in s.topEntries) {
      final isOwn = currentUserId != null &&
          s.ownRank != null &&
          entry.rank == s.ownRank;

      // Rank-change event (if we know previous rank and it moved)
      if (entry.previousRank != null && entry.previousRank != entry.rank) {
        events.add(ActivityEvent(
          id: '${s.id}-${entry.id}-rank',
          kind: entry.previousRank! > entry.rank
              ? ActivityKind.rankUp
              : ActivityKind.rankDown,
          boardId: s.id,
          boardTitle: s.title,
          actorName: isOwn ? 'You' : entry.displayName,
          rank: entry.rank,
          previousRank: entry.previousRank,
          valueType: s.valueType,
          at: entry.submittedAt,
          isOwn: isOwn,
        ));
      }

      // New submission event
      events.add(ActivityEvent(
        id: '${s.id}-${entry.id}-submit',
        kind: ActivityKind.newEntry,
        boardId: s.id,
        boardTitle: s.title,
        actorName: isOwn ? 'You' : entry.displayName,
        rank: entry.rank,
        valueType: s.valueType,
        at: entry.submittedAt,
        isOwn: isOwn,
      ));
    }
  }

  events.sort((a, b) => b.at.compareTo(a.at));
  if (events.length <= max) return events;
  return events.sublist(0, max);
}
