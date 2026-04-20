import '../../../core/network/api_client.dart';

/// Remote data source for lists API calls
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
    final response = await _apiClient.dio.get<List<dynamic>>('/lists');
    return response.data as List<dynamic>;
  }

  @override
  Future<Map<String, dynamic>> getListDetail(String listId) async {
    final response = await _apiClient.dio.get<Map<String, dynamic>>(
      '/lists/$listId',
    );
    return response.data as Map<String, dynamic>;
  }

  @override
  Future<Map<String, dynamic>> createList(Map<String, dynamic> data) async {
    final response = await _apiClient.dio.post<Map<String, dynamic>>(
      '/lists',
      data: data,
    );
    return response.data as Map<String, dynamic>;
  }

  @override
  Future<void> deleteList(String listId) async {
    await _apiClient.dio.delete<void>('/lists/$listId');
  }

  @override
  Future<Map<String, dynamic>> getInvitePreview(String token) async {
    final response = await _apiClient.dio.get<Map<String, dynamic>>(
      '/lists/invite/$token',
    );
    return response.data as Map<String, dynamic>;
  }

  @override
  Future<Map<String, dynamic>> joinByInvite(String token) async {
    final response = await _apiClient.dio.post<Map<String, dynamic>>(
      '/lists/invite/$token/join',
    );
    return response.data as Map<String, dynamic>;
  }

  @override
  Future<Map<String, dynamic>> getInviteLink(String listId) async {
    final response = await _apiClient.dio.get<Map<String, dynamic>>(
      '/lists/$listId/invite',
    );
    return response.data as Map<String, dynamic>;
  }

  @override
  Future<List<dynamic>> getMembers(String listId) async {
    final response = await _apiClient.dio.get<List<dynamic>>(
      '/lists/$listId/members',
    );
    return response.data as List<dynamic>;
  }

  @override
  Future<void> removeMember(String listId, String userId) async {
    await _apiClient.dio.delete<void>('/lists/$listId/members/$userId');
  }

  @override
  Future<void> updateMemberRole(
    String listId,
    String userId,
    String role,
  ) async {
    await _apiClient.dio.patch<void>(
      '/lists/$listId/members/$userId',
      data: {'role': role},
    );
  }

  @override
  Future<Map<String, dynamic>> updateList(
    String listId,
    Map<String, dynamic> data,
  ) async {
    final response = await _apiClient.dio.patch<Map<String, dynamic>>(
      '/lists/$listId',
      data: data,
    );
    return response.data as Map<String, dynamic>;
  }

  @override
  Future<void> deleteEntry(String listId, String entryId) async {
    await _apiClient.dio.delete<void>('/lists/$listId/entries/$entryId');
  }

  @override
  Future<Map<String, dynamic>> regenerateInvite(String listId) async {
    final response = await _apiClient.dio.post<Map<String, dynamic>>(
      '/lists/$listId/invite/regenerate',
    );
    return response.data as Map<String, dynamic>;
  }

  @override
  Future<List<dynamic>> searchPublicLists({
    String? query,
    String? category,
  }) async {
    final response = await _apiClient.dio.get<List<dynamic>>(
      '/lists/public',
      queryParameters: {'q': ?query, 'category': ?category},
    );
    return response.data as List<dynamic>;
  }

  @override
  Future<Map<String, dynamic>> getUserProfile(String userId) async {
    final response = await _apiClient.dio.get<Map<String, dynamic>>(
      '/users/$userId/profile',
    );
    return response.data as Map<String, dynamic>;
  }
}
