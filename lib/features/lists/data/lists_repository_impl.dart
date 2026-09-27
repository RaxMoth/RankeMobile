import 'package:fpdart/fpdart.dart';

import '../../../core/network/api_error.dart';
import '../../../core/network/api_helpers.dart';
import '../../profile/domain/entities/user_profile.dart';
import '../domain/entities/public_lists_page.dart';
import '../domain/entities/ranked_list.dart';
import '../domain/lists_repository.dart';
import 'lists_json.dart';
import 'lists_remote_data_source.dart';

class ListsRepositoryImpl implements ListsRepository {
  final ListsRemoteDataSource _dataSource;

  ListsRepositoryImpl(this._dataSource);

  @override
  Future<Either<ApiError, List<ListSummary>>> getLists() {
    return safeApiCall(() async {
      final data = await _dataSource.getLists();
      return data
          .map((e) => ListsJson.listSummary(e as Map<String, dynamic>))
          .toList();
    });
  }

  @override
  Future<Either<ApiError, RankedList>> getListDetail(String listId) {
    return safeApiCall(() async {
      return ListsJson.rankedList(await _dataSource.getListDetail(listId));
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
        'description': ?description,
        'valueType': valueType.name,
        'rankOrder': rankOrder.name,
        'isPublic': isPublic,
        'category': ?category,
        'telegramLink': ?telegramLink,
        'whatsappLink': ?whatsappLink,
        'discordLink': ?discordLink,
      });
      return ListsJson.rankedList(data);
    });
  }

  @override
  Future<Either<ApiError, void>> deleteList(String listId) {
    return safeApiCall(() => _dataSource.deleteList(listId));
  }

  @override
  Future<Either<ApiError, void>> joinList(String listId) {
    return safeApiCall(() => _dataSource.joinList(listId));
  }

  @override
  Future<Either<ApiError, void>> leaveList(String listId) {
    return safeApiCall(() => _dataSource.leaveList(listId));
  }

  @override
  Future<Either<ApiError, RankedList>> getInvitePreview(String token) {
    return safeApiCall(() async {
      return ListsJson.rankedList(await _dataSource.getInvitePreview(token));
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
      return data
          .map((e) => ListsJson.listMember(e as Map<String, dynamic>))
          .toList();
    });
  }

  @override
  Future<Either<ApiError, void>> updateMemberRole({
    required String listId,
    required String userId,
    required MemberRole role,
  }) {
    return safeApiCall(
      () => _dataSource.updateMemberRole(listId, userId, role.name),
    );
  }

  @override
  Future<Either<ApiError, void>> removeMember({
    required String listId,
    required String userId,
  }) {
    return safeApiCall(() => _dataSource.removeMember(listId, userId));
  }

  @override
  Future<Either<ApiError, RankedList>> updateList({
    required String listId,
    String? title,
    String? description,
    bool? isPublic,
    bool? locked,
    String? category,
    String? telegramLink,
    String? whatsappLink,
    String? discordLink,
  }) {
    return safeApiCall(() async {
      // Absent key = unchanged; "" = clear (see ListsRepository.updateList).
      final data = await _dataSource.updateList(listId, {
        'title': ?title,
        'description': ?description,
        'isPublic': ?isPublic,
        'locked': ?locked,
        'category': ?category,
        'telegramLink': ?telegramLink,
        'whatsappLink': ?whatsappLink,
        'discordLink': ?discordLink,
      });
      return ListsJson.rankedList(data);
    });
  }

  @override
  Future<Either<ApiError, void>> deleteEntry({
    required String listId,
    required String entryId,
  }) {
    return safeApiCall(() => _dataSource.deleteEntry(listId, entryId));
  }

  @override
  Future<Either<ApiError, void>> reorderEntries({
    required String listId,
    required List<String> orderedEntryIds,
  }) {
    return safeApiCall(
      () => _dataSource.updateRanks(listId, [
        for (var i = 0; i < orderedEntryIds.length; i++)
          {'entryId': orderedEntryIds[i], 'rank': i + 1},
      ]),
    );
  }

  @override
  Future<Either<ApiError, String>> regenerateInvite(String listId) {
    return safeApiCall(() async {
      final data = await _dataSource.regenerateInvite(listId);
      return data['inviteToken'] as String;
    });
  }

  @override
  Future<Either<ApiError, PublicListsPage>> searchPublicLists({
    String? query,
    String? category,
    String? cursor,
    int? limit,
  }) {
    return safeApiCall(() async {
      final page = await _dataSource.searchPublicLists(
        query: query,
        category: category,
        cursor: cursor,
        limit: limit,
      );
      return PublicListsPage(
        items: page.items
            .map((e) => ListsJson.listSummary(e as Map<String, dynamic>))
            .toList(),
        nextCursor: page.nextCursor,
      );
    });
  }

  @override
  Future<Either<ApiError, UserProfile>> getUserProfile(String userId) {
    return safeApiCall(() async {
      return ListsJson.userProfile(await _dataSource.getUserProfile(userId));
    });
  }
}
