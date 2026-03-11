import 'package:freezed_annotation/freezed_annotation.dart';
import '../../../entries/domain/entities/entry.dart';

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
class ListSummary with _$ListSummary {
  const factory ListSummary({
    required String id,
    required String title,
    required ValueType valueType,
    required RankOrder rankOrder,
    required bool isPublic,
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
