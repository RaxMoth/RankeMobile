import '../../profile/domain/entities/user_profile.dart';
import '../domain/entities/ranked_list.dart';

/// JSON → entity mapping for every list-shaped backend payload.
///
/// One mapper per wire shape (RankeBE `internal/handler/dto`), shared by
/// every repository that receives it. `test/contract` runs each against
/// the backend's generated fixtures, so a renamed or retyped field fails a
/// test instead of a screen.
///
/// Optional fields are omitted from the JSON when unset (Go `omitempty`),
/// so everything nullable is read with a null-aware cast.
abstract class ListsJson {
  static ListSummary listSummary(Map<String, dynamic> json) => ListSummary(
    id: json['id'] as String,
    title: json['title'] as String,
    valueType: ValueType.values.byName(json['valueType'] as String),
    rankOrder: RankOrder.values.byName(json['rankOrder'] as String),
    isPublic: json['isPublic'] as bool,
    memberCount: json['memberCount'] as int,
    ownRank: json['ownRank'] as int?,
    currentUserRole: _role(json['currentUserRole']),
    category: json['category'] as String?,
    topEntries: _entries(json['topEntries']),
    pendingCount: json['pendingCount'] as int? ?? 0,
  );

  static RankedList rankedList(Map<String, dynamic> json) => RankedList(
    id: json['id'] as String,
    title: json['title'] as String,
    description: json['description'] as String?,
    valueType: ValueType.values.byName(json['valueType'] as String),
    rankOrder: RankOrder.values.byName(json['rankOrder'] as String),
    isPublic: json['isPublic'] as bool,
    locked: json['locked'] as bool? ?? false,
    category: json['category'] as String?,
    inviteToken: json['inviteToken'] as String?,
    entries: _entries(json['entries']),
    memberCount: json['memberCount'] as int,
    currentUserRole: _role(json['currentUserRole']),
    telegramLink: json['telegramLink'] as String?,
    whatsappLink: json['whatsappLink'] as String?,
    discordLink: json['discordLink'] as String?,
    mySubmission: json['mySubmission'] == null
        ? null
        : submission(json['mySubmission'] as Map<String, dynamic>),
  );

  /// A leaderboard row (always an approved entry).
  static RankedEntry rankedEntry(Map<String, dynamic> json) => RankedEntry(
    id: json['id'] as String,
    userId: json['userId'] as String,
    displayName: json['displayName'] as String,
    rank: json['rank'] as int,
    previousRank: json['previousRank'] as int?,
    valueNumber: (json['valueNumber'] as num?)?.toDouble(),
    valueDurationMs: json['valueDurationMs'] as int?,
    valueText: json['valueText'] as String?,
    manualRank: json['manualRank'] as int?,
    note: json['note'] as String?,
    submittedAt: DateTime.parse(json['submittedAt'] as String),
  );

  /// A submission in moderation: the response to submitting an entry, a
  /// row of the review queue, or the viewer's `mySubmission`.
  static Submission submission(Map<String, dynamic> json) => Submission(
    id: json['id'] as String,
    userId: json['userId'] as String,
    displayName: json['displayName'] as String?,
    valueNumber: (json['valueNumber'] as num?)?.toDouble(),
    valueDurationMs: json['valueDurationMs'] as int?,
    valueText: json['valueText'] as String?,
    note: json['note'] as String?,
    status: EntryStatus.values.byName(json['status'] as String),
    submittedAt: DateTime.parse(json['submittedAt'] as String),
    reviewedAt: json['reviewedAt'] != null
        ? DateTime.parse(json['reviewedAt'] as String)
        : null,
  );

  static ListMember listMember(Map<String, dynamic> json) => ListMember(
    userId: json['userId'] as String,
    displayName: json['displayName'] as String,
    role: MemberRole.values.byName(json['role'] as String),
  );

  static UserProfile userProfile(Map<String, dynamic> json) => UserProfile(
    userId: json['userId'] as String,
    displayName: json['displayName'] as String,
    memberSince: json['memberSince'] != null
        ? DateTime.parse(json['memberSince'] as String)
        : null,
    boards: (json['boards'] as List<dynamic>? ?? [])
        .map((e) => listSummary(e as Map<String, dynamic>))
        .toList(),
  );

  static MemberRole? _role(Object? raw) =>
      raw == null ? null : MemberRole.values.byName(raw as String);

  static List<RankedEntry> _entries(Object? raw) =>
      (raw as List<dynamic>? ?? [])
          .map((e) => rankedEntry(e as Map<String, dynamic>))
          .toList();
}
