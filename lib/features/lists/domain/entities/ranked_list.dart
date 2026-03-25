import 'package:freezed_annotation/freezed_annotation.dart';
<<<<<<< HEAD
import '../../../entries/domain/entities/entry.dart';
=======
>>>>>>> 88d3438 (good progress)

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
    String? inviteToken,
    required List<RankedEntry> entries,
    required int memberCount,
  }) = _RankedList;
}

@freezed
<<<<<<< HEAD
=======
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
  }) = _RankedEntry;
}

@freezed
>>>>>>> 88d3438 (good progress)
class ListSummary with _$ListSummary {
  const factory ListSummary({
    required String id,
    required String title,
    required ValueType valueType,
<<<<<<< HEAD
    required RankOrder rankOrder,
    required bool isPublic,
=======
>>>>>>> 88d3438 (good progress)
    required int memberCount,
    int? ownRank,
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
