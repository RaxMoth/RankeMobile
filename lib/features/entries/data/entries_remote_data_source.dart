import '../../../core/network/api_client.dart';

/// Remote data source for entries API calls
abstract class EntriesRemoteDataSource {
  Future<Map<String, dynamic>> submitEntry(
    String listId,
    Map<String, dynamic> data,
  );

  Future<List<dynamic>> getPendingEntries(String listId);

  Future<void> approveEntry(String listId, String entryId);

  Future<void> rejectEntry(String listId, String entryId);
}

class EntriesRemoteDataSourceImpl implements EntriesRemoteDataSource {
  final ApiClient _apiClient;

  EntriesRemoteDataSourceImpl(this._apiClient);

  @override
  Future<Map<String, dynamic>> submitEntry(
    String listId,
    Map<String, dynamic> data,
  ) async {
    final response = await _apiClient.dio.put<Map<String, dynamic>>(
      '/lists/$listId/entries/me',
      data: data,
    );
    return response.data as Map<String, dynamic>;
  }

  @override
  Future<List<dynamic>> getPendingEntries(String listId) async {
    final response = await _apiClient.dio.get<List<dynamic>>(
      '/lists/$listId/entries/pending',
    );
    return response.data as List<dynamic>;
  }

  @override
  Future<void> approveEntry(String listId, String entryId) async {
    await _apiClient.dio.post<void>('/lists/$listId/entries/$entryId/approve');
  }

  @override
  Future<void> rejectEntry(String listId, String entryId) async {
    await _apiClient.dio.post<void>('/lists/$listId/entries/$entryId/reject');
  }
}
