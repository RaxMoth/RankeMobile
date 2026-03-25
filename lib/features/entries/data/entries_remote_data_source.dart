import '../../../core/network/api_client.dart';
<<<<<<< HEAD
import '../domain/entities/entry.dart';

class EntriesRemoteDataSource {
  final ApiClient _apiClient;

  EntriesRemoteDataSource(this._apiClient);

  Future<Map<String, dynamic>> submitEntry({
    required String listId,
    required EntryInput input,
  }) async {
    final response = await _apiClient.dio.put(
      '/lists/$listId/entries/me',
      data: {
        if (input.valueNumber != null) 'valueNumber': input.valueNumber,
        if (input.valueDurationMs != null) 'valueDurationMs': input.valueDurationMs,
        if (input.valueText != null) 'valueText': input.valueText,
        if (input.note != null) 'note': input.note,
      },
=======

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
>>>>>>> 88d3438 (good progress)
    );
    return response.data as Map<String, dynamic>;
  }
}
