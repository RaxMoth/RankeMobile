import '../../../core/network/api_client.dart';
import '../../../core/network/api_helpers.dart';
import '../../../core/network/api_paths.dart';

/// Remote data source for entries API calls.
///
/// Every method returns the **unwrapped** `data` payload from the backend's
/// response envelope. See [unwrapEnvelope].
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
      ApiPaths.entryMine(listId),
      data: data,
    );
    return unwrapEnvelope<Map<String, dynamic>>(response.data);
  }

  @override
  Future<List<dynamic>> getPendingEntries(String listId) async {
    final response = await _apiClient.dio.get<Map<String, dynamic>>(
      ApiPaths.entriesPending(listId),
    );
    return unwrapEnvelope<List<dynamic>>(response.data);
  }

  @override
  Future<void> approveEntry(String listId, String entryId) async {
    await _apiClient.dio.post<void>(ApiPaths.entryApprove(listId, entryId));
  }

  @override
  Future<void> rejectEntry(String listId, String entryId) async {
    await _apiClient.dio.post<void>(ApiPaths.entryReject(listId, entryId));
  }
}
