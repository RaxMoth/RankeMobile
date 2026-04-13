import 'package:fpdart/fpdart.dart';

import '../../../core/network/api_error.dart';
import '../../../core/network/api_helpers.dart';
import '../../profile/domain/entities/user_profile.dart';
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
    String? category,
    String? telegramLink,
    String? whatsappLink,
    String? discordLink,
  }) {
    return safeApiCall(() async {
      final data = await _dataSource.createList({
        'title': title,
        if (description != null) 'description': description,
        'valueType': valueType.name,
        'rankOrder': rankOrder.name,
        'isPublic': isPublic,
        if (category != null) 'category': category,
        if (telegramLink != null) 'telegramLink': telegramLink,
        if (whatsappLink != null) 'whatsappLink': whatsappLink,
        if (discordLink != null) 'discordLink': discordLink,
      });
      return _mapRankedList(data);
    });
  }

  @override
  Future<Either<ApiError, void>> deleteList(String listId) {
    return safeApiCall(() async {
      await _dataSource.deleteList(listId);
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
  Future<Either<ApiError, void>> joinByInvite(String token) {
    return safeApiCall(() async {
      await _dataSource.joinByInvite(token);
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
      await _dataSource.updateMemberRole(listId, userId, role.name);
    });
  }

  @override
  Future<Either<ApiError, void>> removeMember({
    required String listId,
    required String userId,
  }) {
    return safeApiCall(() async {
      await _dataSource.removeMember(listId, userId);
    });
  }

  @override
  Future<Either<ApiError, RankedList>> updateList({
    required String listId,
    String? title,
    String? description,
    bool? isPublic,
    bool? locked,
    String? telegramLink,
    String? whatsappLink,
    String? discordLink,
  }) {
    return safeApiCall(() async {
      final data = await _dataSource.updateList(listId, {
        if (title != null) 'title': title,
        if (description != null) 'description': description,
        if (isPublic != null) 'isPublic': isPublic,
        if (locked != null) 'locked': locked,
        if (telegramLink != null) 'telegramLink': telegramLink,
        if (whatsappLink != null) 'whatsappLink': whatsappLink,
        if (discordLink != null) 'discordLink': discordLink,
      });
      return _mapRankedList(data);
    });
  }

  @override
  Future<Either<ApiError, void>> deleteEntry({
    required String listId,
    required String entryId,
  }) {
    return safeApiCall(() async {
      await _dataSource.deleteEntry(listId, entryId);
    });
  }

  @override
  Future<Either<ApiError, String>> regenerateInvite(String listId) {
    return safeApiCall(() async {
      final data = await _dataSource.regenerateInvite(listId);
      return data['inviteToken'] as String;
    });
  }

  @override
  Future<Either<ApiError, List<ListSummary>>> searchPublicLists({
    String? query,
    String? category,
  }) {
    return safeApiCall(() async {
      final data = await _dataSource.searchPublicLists(
        query: query,
        category: category,
      );
      return data.map((e) => _mapListSummary(e as Map<String, dynamic>)).toList();
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
      locked: json['locked'] as bool? ?? false,
      inviteToken: json['inviteToken'] as String?,
      entries: (json['entries'] as List<dynamic>?)
              ?.map((e) => _mapEntry(e as Map<String, dynamic>))
              .toList() ??
          [],
      memberCount: json['memberCount'] as int,
      currentUserRole: json['currentUserRole'] != null
          ? MemberRole.values.byName(json['currentUserRole'] as String)
          : null,
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
      currentUserRole: json['currentUserRole'] != null
          ? MemberRole.values.byName(json['currentUserRole'] as String)
          : null,
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

  @override
  Future<Either<ApiError, UserProfile>> getUserProfile(String userId) {
    return safeApiCall(() async {
      final data = await _dataSource.getUserProfile(userId);
      final boardsJson = data['boards'] as List<dynamic>? ?? [];
      return UserProfile(
        userId: data['userId'] as String,
        displayName: data['displayName'] as String,
        memberSince: data['memberSince'] != null
            ? DateTime.parse(data['memberSince'] as String)
            : null,
        boards: boardsJson
            .map((e) => _mapListSummary(e as Map<String, dynamic>))
            .toList(),
      );
    });
  }
}
