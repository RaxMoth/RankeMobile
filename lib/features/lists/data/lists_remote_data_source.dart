import '../../../core/network/api_client.dart';

class ListsRemoteDataSource {
  final ApiClient _apiClient;

  ListsRemoteDataSource(this._apiClient);

  Future<List<dynamic>> getLists() async {
    final response = await _apiClient.dio.get('/lists');
    return response.data as List<dynamic>;
  }

  Future<Map<String, dynamic>> getListDetail(String listId) async {
    final response = await _apiClient.dio.get('/lists/$listId');
    return response.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> createList({
    required String title,
    String? description,
    required String valueType,
    required String rankOrder,
    required bool isPublic,
  }) async {
    final response = await _apiClient.dio.post(
      '/lists',
      data: {
        'title': title,
        if (description != null) 'description': description,
        'valueType': valueType,
        'rankOrder': rankOrder,
        'isPublic': isPublic,
      },
    );
    return response.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> getInvitePreview(String token) async {
    final response = await _apiClient.dio.get('/lists/invite/$token');
    return response.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> joinByInvite(String token) async {
    final response = await _apiClient.dio.post('/lists/invite/$token/join');
    return response.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> getInviteLink(String listId) async {
    final response = await _apiClient.dio.get('/lists/$listId/invite');
    return response.data as Map<String, dynamic>;
  }

  Future<List<dynamic>> getMembers(String listId) async {
    final response = await _apiClient.dio.get('/lists/$listId/members');
    return response.data as List<dynamic>;
  }

  Future<void> updateMemberRole({
    required String listId,
    required String userId,
    required String role,
  }) async {
    await _apiClient.dio.patch(
      '/lists/$listId/members/$userId',
      data: {'role': role},
    );
  }

  Future<void> removeMember({
    required String listId,
    required String userId,
  }) async {
    await _apiClient.dio.delete('/lists/$listId/members/$userId');
  }
}
