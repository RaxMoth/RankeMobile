import 'package:freezed_annotation/freezed_annotation.dart';

part 'ranked_list.freezed.dart';

enum ValueType { number, duration, text }

enum RankOrder { asc, desc }

@freezed
class RankedList with _$RankedList {
  const factory RankedList({
    required String id,
    required String title,
    String? description,
    required ValueType valueType,
    required RankOrder rankOrder,
    required bool isPublic,
    @Default(false) bool locked,
    String? category,
    String? inviteToken,
    required List<RankedEntry> entries,
    required int memberCount,
    MemberRole? currentUserRole,
    String? telegramLink,
    String? whatsappLink,
    String? discordLink,

    /// The viewer's latest submission while it waits for review or after it
    /// was rejected; null once approved (it's on the board then).
    Submission? mySubmission,
  }) = _RankedList;
}

/// A leaderboard row. Only approved entries reach a board — see
/// [Submission] for the review queue.
@freezed
class RankedEntry with _$RankedEntry {
  const factory RankedEntry({
    required String id,
    required String userId,
    required String displayName,
    required int rank,
    int? previousRank,
    double? valueNumber,
    int? valueDurationMs,
    String? valueText,
    int? manualRank,
    String? note,
    required DateTime submittedAt,
  }) = _RankedEntry;
}

/// An entry going through moderation. Every submission waits for an
/// owner, admin or moderator to approve it before it becomes a
/// [RankedEntry] on the board.
@freezed
class Submission with _$Submission {
  const factory Submission({
    required String id,
    required String userId,

    /// Only set in the review queue (who submitted it).
    String? displayName,
    double? valueNumber,
    int? valueDurationMs,
    String? valueText,
    String? note,
    required EntryStatus status,
    required DateTime submittedAt,
    DateTime? reviewedAt,
  }) = _Submission;
}

@freezed
class ListSummary with _$ListSummary {
  const factory ListSummary({
    required String id,
    required String title,
    required ValueType valueType,
    required RankOrder rankOrder,
    required bool isPublic,
    required int memberCount,
    int? ownRank,
    MemberRole? currentUserRole,
    String? category,
    @Default([]) List<RankedEntry> topEntries,

    /// Submissions waiting for review; 0 unless the viewer can review.
    @Default(0) int pendingCount,
  }) = _ListSummary;
}

@freezed
class ListMember with _$ListMember {
  const factory ListMember({
    required String userId,
    required String displayName,
    required MemberRole role,
  }) = _ListMember;
}

/// Per-board roles. Owners and admins run the board; moderators only
/// review submissions; members submit.
enum MemberRole {
  owner,
  admin,
  moderator,
  member;

  /// Can approve/reject submissions.
  bool get canReview => this != member;

  /// Can edit the board, manage members and remove entries.
  bool get canManage => this == owner || this == admin;
}

/// Where a [Submission] stands in moderation.
enum EntryStatus { pending, approved, rejected }
