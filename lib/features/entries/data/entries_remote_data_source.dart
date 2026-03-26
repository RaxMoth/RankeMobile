import '../../../core/network/api_client.dart';

/// Remote data source for entries API calls
abstract class EntriesRemoteDataSource {
  Future<Map<String, dynamic>> submitEntry(
    String listId,
    Map<String, dynamic> data,
  );
}

class EntriesRemoteDataSourceImpl implements EntriesRemoteDataSource {
  final ApiClient _apiClient;

  EntriesRemoteDataSourceImpl(this._apiClient);

  @override
  Future<Map<String, dynamic>> submitEntry(
    String listId,
    Map<String, dynamic> data,
  ) async {
    final response = await _apiClient.dio.put(
      '/lists/$listId/entries/me',
      data: data,
    );
    return response.data as Map<String, dynamic>;
  }
}
