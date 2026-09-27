import '../../../core/network/api_client.dart';
import '../../../core/network/api_helpers.dart';
import '../../../core/network/api_paths.dart';

/// Remote data source for entries and their moderation.
///
/// Every method returns the **unwrapped** `data` payload from the backend's
/// response envelope. See [unwrapEnvelope].
abstract class EntriesRemoteDataSource {
  /// Queues the caller's entry for review; returns the submission.
  Future<Map<String, dynamic>> submitEntry(
    String listId,
    Map<String, dynamic> data,
  );

  Future<void> deleteMyEntry(String listId);

  Future<List<dynamic>> getPendingSubmissions(String listId);

  Future<void> approveSubmission(String listId, String submissionId);

  Future<void> rejectSubmission(String listId, String submissionId);
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
  Future<void> deleteMyEntry(String listId) async {
    await _apiClient.dio.delete<void>(ApiPaths.entryMine(listId));
  }

  @override
  Future<List<dynamic>> getPendingSubmissions(String listId) async {
    final response = await _apiClient.dio.get<Map<String, dynamic>>(
      ApiPaths.submissionsPending(listId),
    );
    return unwrapEnvelope<List<dynamic>>(response.data);
  }

  @override
  Future<void> approveSubmission(String listId, String submissionId) async {
    await _apiClient.dio.post<void>(
      ApiPaths.submissionApprove(listId, submissionId),
    );
  }

  @override
  Future<void> rejectSubmission(String listId, String submissionId) async {
    await _apiClient.dio.post<void>(
      ApiPaths.submissionReject(listId, submissionId),
    );
  }
}
