import '../../../core/network/api_client.dart';
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
    );
    return response.data as Map<String, dynamic>;
  }
}
