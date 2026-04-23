import '../../../core/network/api_client.dart';
import '../../../core/network/api_helpers.dart';
import '../../../core/network/api_paths.dart';

/// Remote data source for lists API calls.
///
/// Every method returns the **unwrapped** `data` payload from the backend's
/// response envelope. See [unwrapEnvelope].
abstract class ListsRemoteDataSource {
  Future<List<dynamic>> getLists();
  Future<Map<String, dynamic>> getListDetail(String listId);
  Future<Map<String, dynamic>> createList(Map<String, dynamic> data);
  Future<void> deleteList(String listId);
  Future<Map<String, dynamic>> getInvitePreview(String token);
  Future<Map<String, dynamic>> joinByInvite(String token);
  Future<Map<String, dynamic>> getInviteLink(String listId);
  Future<List<dynamic>> getMembers(String listId);
  Future<void> removeMember(String listId, String userId);
  Future<void> updateMemberRole(String listId, String userId, String role);
  Future<Map<String, dynamic>> updateList(
    String listId,
    Map<String, dynamic> data,
  );
  Future<void> deleteEntry(String listId, String entryId);
  Future<Map<String, dynamic>> regenerateInvite(String listId);
  Future<List<dynamic>> searchPublicLists({String? query, String? category});
  Future<Map<String, dynamic>> getUserProfile(String userId);
}

class ListsRemoteDataSourceImpl implements ListsRemoteDataSource {
  final ApiClient _apiClient;

  ListsRemoteDataSourceImpl(this._apiClient);

  @override
  Future<List<dynamic>> getLists() async {
    final response = await _apiClient.dio.get<Map<String, dynamic>>(
      ApiPaths.lists,
    );
    return unwrapEnvelope<List<dynamic>>(response.data);
  }

  @override
  Future<Map<String, dynamic>> getListDetail(String listId) async {
    final response = await _apiClient.dio.get<Map<String, dynamic>>(
      ApiPaths.listById(listId),
    );
    return unwrapEnvelope<Map<String, dynamic>>(response.data);
  }

  @override
  Future<Map<String, dynamic>> createList(Map<String, dynamic> data) async {
    final response = await _apiClient.dio.post<Map<String, dynamic>>(
      ApiPaths.lists,
      data: data,
    );
    return unwrapEnvelope<Map<String, dynamic>>(response.data);
  }

  @override
  Future<void> deleteList(String listId) async {
    await _apiClient.dio.delete<void>(ApiPaths.listById(listId));
  }

  @override
  Future<Map<String, dynamic>> getInvitePreview(String token) async {
    final response = await _apiClient.dio.get<Map<String, dynamic>>(
      ApiPaths.inviteByToken(token),
    );
    return unwrapEnvelope<Map<String, dynamic>>(response.data);
  }

  @override
  Future<Map<String, dynamic>> joinByInvite(String token) async {
    final response = await _apiClient.dio.post<Map<String, dynamic>>(
      ApiPaths.inviteJoin(token),
    );
    return unwrapEnvelope<Map<String, dynamic>>(response.data);
  }

  @override
  Future<Map<String, dynamic>> getInviteLink(String listId) async {
    final response = await _apiClient.dio.get<Map<String, dynamic>>(
      ApiPaths.listInvite(listId),
    );
    return unwrapEnvelope<Map<String, dynamic>>(response.data);
  }

  @override
  Future<List<dynamic>> getMembers(String listId) async {
    final response = await _apiClient.dio.get<Map<String, dynamic>>(
      ApiPaths.listMembers(listId),
    );
    return unwrapEnvelope<List<dynamic>>(response.data);
  }

  @override
  Future<void> removeMember(String listId, String userId) async {
    await _apiClient.dio.delete<void>(ApiPaths.listMember(listId, userId));
  }

  @override
  Future<void> updateMemberRole(
    String listId,
    String userId,
    String role,
  ) async {
    await _apiClient.dio.patch<void>(
      ApiPaths.listMember(listId, userId),
      data: {'role': role},
    );
  }

  @override
  Future<Map<String, dynamic>> updateList(
    String listId,
    Map<String, dynamic> data,
  ) async {
    final response = await _apiClient.dio.patch<Map<String, dynamic>>(
      ApiPaths.listById(listId),
      data: data,
    );
    return unwrapEnvelope<Map<String, dynamic>>(response.data);
  }

  @override
  Future<void> deleteEntry(String listId, String entryId) async {
    await _apiClient.dio.delete<void>(ApiPaths.entryById(listId, entryId));
  }

  @override
  Future<Map<String, dynamic>> regenerateInvite(String listId) async {
    final response = await _apiClient.dio.post<Map<String, dynamic>>(
      ApiPaths.listInviteRegenerate(listId),
    );
    return unwrapEnvelope<Map<String, dynamic>>(response.data);
  }

  @override
  Future<List<dynamic>> searchPublicLists({
    String? query,
    String? category,
  }) async {
    // Build a clean query-param map with only non-null entries.
    // (`?query` as a map value is not valid Dart.)
    final params = <String, dynamic>{
      if (query != null && query.isNotEmpty) 'q': query,
      if (category != null && category.isNotEmpty) 'category': category,
    };
    final response = await _apiClient.dio.get<Map<String, dynamic>>(
      ApiPaths.listsPublic,
      queryParameters: params.isEmpty ? null : params,
    );
    return unwrapEnvelope<List<dynamic>>(response.data);
  }

  @override
  Future<Map<String, dynamic>> getUserProfile(String userId) async {
    final response = await _apiClient.dio.get<Map<String, dynamic>>(
      ApiPaths.userProfile(userId),
    );
    return unwrapEnvelope<Map<String, dynamic>>(response.data);
  }
}
