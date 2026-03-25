import '../../../core/network/api_client.dart';

<<<<<<< HEAD
class ListsRemoteDataSource {
  final ApiClient _apiClient;

  ListsRemoteDataSource(this._apiClient);

  Future<List<dynamic>> getLists() async {
=======
/// Remote data source for lists API calls
abstract class ListsRemoteDataSource {
  Future<List<dynamic>> getMyLists();
  Future<Map<String, dynamic>> getListDetail(String listId);
  Future<Map<String, dynamic>> createList(Map<String, dynamic> data);
  Future<void> deleteList(String listId);
  Future<Map<String, dynamic>> getInvitePreview(String token);
  Future<void> joinList(String token);
  Future<List<dynamic>> getMembers(String listId);
  Future<void> removeMember(String listId, String userId);
  Future<void> updateMemberRole(String listId, String userId, String role);
}

class ListsRemoteDataSourceImpl implements ListsRemoteDataSource {
  final ApiClient _apiClient;

  ListsRemoteDataSourceImpl(this._apiClient);

  @override
  Future<List<dynamic>> getMyLists() async {
>>>>>>> 88d3438 (good progress)
    final response = await _apiClient.dio.get('/lists');
    return response.data as List<dynamic>;
  }

<<<<<<< HEAD
=======
  @override
>>>>>>> 88d3438 (good progress)
  Future<Map<String, dynamic>> getListDetail(String listId) async {
    final response = await _apiClient.dio.get('/lists/$listId');
    return response.data as Map<String, dynamic>;
  }

<<<<<<< HEAD
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

=======
  @override
  Future<Map<String, dynamic>> createList(Map<String, dynamic> data) async {
    final response = await _apiClient.dio.post('/lists', data: data);
    return response.data as Map<String, dynamic>;
  }

  @override
  Future<void> deleteList(String listId) async {
    await _apiClient.dio.delete('/lists/$listId');
  }

  @override
>>>>>>> 88d3438 (good progress)
  Future<Map<String, dynamic>> getInvitePreview(String token) async {
    final response = await _apiClient.dio.get('/lists/invite/$token');
    return response.data as Map<String, dynamic>;
  }

<<<<<<< HEAD
  Future<Map<String, dynamic>> joinByInvite(String token) async {
    final response = await _apiClient.dio.post('/lists/invite/$token/join');
    return response.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> getInviteLink(String listId) async {
    final response = await _apiClient.dio.get('/lists/$listId/invite');
    return response.data as Map<String, dynamic>;
  }

=======
  @override
  Future<void> joinList(String token) async {
    await _apiClient.dio.post('/lists/invite/$token/join');
  }

  @override
>>>>>>> 88d3438 (good progress)
  Future<List<dynamic>> getMembers(String listId) async {
    final response = await _apiClient.dio.get('/lists/$listId/members');
    return response.data as List<dynamic>;
  }

<<<<<<< HEAD
  Future<void> updateMemberRole({
    required String listId,
    required String userId,
    required String role,
  }) async {
=======
  @override
  Future<void> removeMember(String listId, String userId) async {
    await _apiClient.dio.delete('/lists/$listId/members/$userId');
  }

  @override
  Future<void> updateMemberRole(
    String listId,
    String userId,
    String role,
  ) async {
>>>>>>> 88d3438 (good progress)
    await _apiClient.dio.patch(
      '/lists/$listId/members/$userId',
      data: {'role': role},
    );
  }
<<<<<<< HEAD

  Future<void> removeMember({
    required String listId,
    required String userId,
  }) async {
    await _apiClient.dio.delete('/lists/$listId/members/$userId');
  }
=======
>>>>>>> 88d3438 (good progress)
}
