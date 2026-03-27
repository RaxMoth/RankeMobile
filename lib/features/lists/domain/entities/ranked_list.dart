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
    String? inviteToken,
    required List<RankedEntry> entries,
    @Default([]) List<RankedEntry> pendingEntries,
    required int memberCount,
    MemberRole? currentUserRole,
    String? telegramLink,
    String? whatsappLink,
    String? discordLink,
  }) = _RankedList;
}

@freezed
class RankedEntry with _$RankedEntry {
  const factory RankedEntry({
    required String id,
    required String userId,
    required String displayName,
    required int rank,
    double? valueNumber,
    int? valueDurationMs,
    String? valueText,
    int? manualRank,
    String? note,
    required DateTime submittedAt,
    @Default(EntryStatus.approved) EntryStatus status,
  }) = _RankedEntry;
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

enum MemberRole { owner, admin, member }

enum EntryStatus { pending, approved, rejected }
