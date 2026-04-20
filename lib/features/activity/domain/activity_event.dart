import '../../lists/domain/entities/ranked_list.dart';

enum ActivityKind { newEntry, rankUp, rankDown, newMember }

class ActivityEvent {
  final String id;
  final ActivityKind kind;
  final String boardId;
  final String boardTitle;
  final String actorName;
  final int? rank;
  final int? previousRank;
  final ValueType valueType;
  final DateTime at;
  final bool isOwn;

  const ActivityEvent({
    required this.id,
    required this.kind,
    required this.boardId,
    required this.boardTitle,
    required this.actorName,
    this.rank,
    this.previousRank,
    required this.valueType,
    required this.at,
    this.isOwn = false,
  });
}
