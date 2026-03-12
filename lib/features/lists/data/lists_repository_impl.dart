import 'package:fpdart/fpdart.dart';
import '../../../core/network/api_error.dart';
import '../../../core/network/api_helpers.dart';
import '../../entries/domain/entities/entry.dart';
import '../domain/entities/ranked_list.dart';
import '../domain/lists_repository.dart';
import 'lists_remote_data_source.dart';

class ListsRepositoryImpl implements ListsRepository {
  final ListsRemoteDataSource _dataSource;

  ListsRepositoryImpl(this._dataSource);

  @override
  Future<Either<ApiError, List<ListSummary>>> getLists() {
    return safeApiCall(() async {
      final data = await _dataSource.getLists();
      return data.map((e) => _mapListSummary(e as Map<String, dynamic>)).toList();
    });
  }

  @override
  Future<Either<ApiError, RankedList>> getListDetail(String listId) {
    return safeApiCall(() async {
      final data = await _dataSource.getListDetail(listId);
      return _mapRankedList(data);
    });
  }

  @override
  Future<Either<ApiError, RankedList>> createList({
    required String title,
    String? description,
    required ValueType valueType,
    required RankOrder rankOrder,
    required bool isPublic,
  }) {
    return safeApiCall(() async {
      final data = await _dataSource.createList(
        title: title,
        description: description,
        valueType: valueType.name,
        rankOrder: rankOrder.name,
        isPublic: isPublic,
      );
      return _mapRankedList(data);
    });
  }

  @override
  Future<Either<ApiError, RankedList>> getInvitePreview(String token) {
    return safeApiCall(() async {
      final data = await _dataSource.getInvitePreview(token);
      return _mapRankedList(data);
    });
  }

  @override
  Future<Either<ApiError, RankedList>> joinByInvite(String token) {
    return safeApiCall(() async {
      final data = await _dataSource.joinByInvite(token);
      return _mapRankedList(data);
    });
  }

  @override
  Future<Either<ApiError, String>> getInviteLink(String listId) {
    return safeApiCall(() async {
      final data = await _dataSource.getInviteLink(listId);
      return data['inviteLink'] as String;
    });
  }

  @override
  Future<Either<ApiError, List<ListMember>>> getMembers(String listId) {
    return safeApiCall(() async {
      final data = await _dataSource.getMembers(listId);
      return data.map((e) => _mapMember(e as Map<String, dynamic>)).toList();
    });
  }

  @override
  Future<Either<ApiError, void>> updateMemberRole({
    required String listId,
    required String userId,
    required MemberRole role,
  }) {
    return safeApiCall(() async {
      await _dataSource.updateMemberRole(
        listId: listId,
        userId: userId,
        role: role.name,
      );
    });
  }

  @override
  Future<Either<ApiError, void>> removeMember({
    required String listId,
    required String userId,
  }) {
    return safeApiCall(() async {
      await _dataSource.removeMember(listId: listId, userId: userId);
    });
  }

  RankedList _mapRankedList(Map<String, dynamic> json) {
    return RankedList(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String?,
      valueType: ValueType.values.byName(json['valueType'] as String),
      rankOrder: RankOrder.values.byName(json['rankOrder'] as String),
      isPublic: json['isPublic'] as bool,
      inviteToken: json['inviteToken'] as String?,
      entries: (json['entries'] as List<dynamic>?)
              ?.map((e) => _mapEntry(e as Map<String, dynamic>))
              .toList() ??
          [],
      memberCount: json['memberCount'] as int,
    );
  }

  ListSummary _mapListSummary(Map<String, dynamic> json) {
    return ListSummary(
      id: json['id'] as String,
      title: json['title'] as String,
      valueType: ValueType.values.byName(json['valueType'] as String),
      rankOrder: RankOrder.values.byName(json['rankOrder'] as String),
      isPublic: json['isPublic'] as bool,
      memberCount: json['memberCount'] as int,
      ownRank: json['ownRank'] as int?,
    );
  }

  RankedEntry _mapEntry(Map<String, dynamic> json) {
    return RankedEntry(
      id: json['id'] as String,
      userId: json['userId'] as String,
      displayName: json['displayName'] as String,
      rank: json['rank'] as int,
      valueNumber: (json['valueNumber'] as num?)?.toDouble(),
      valueDurationMs: json['valueDurationMs'] as int?,
      valueText: json['valueText'] as String?,
      manualRank: json['manualRank'] as int?,
      note: json['note'] as String?,
      submittedAt: DateTime.parse(json['submittedAt'] as String),
    );
  }

  ListMember _mapMember(Map<String, dynamic> json) {
    return ListMember(
      userId: json['userId'] as String,
      displayName: json['displayName'] as String,
      role: MemberRole.values.byName(json['role'] as String),
    );
  }
}
