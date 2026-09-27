import 'package:fpdart/fpdart.dart';

import '../../../core/network/api_error.dart';
import '../../../core/network/api_helpers.dart';
import '../../lists/data/lists_json.dart';
import '../../lists/domain/entities/ranked_list.dart';
import '../domain/entities/entry.dart';
import '../domain/entries_repository.dart';
import 'entries_remote_data_source.dart';

class EntriesRepositoryImpl implements EntriesRepository {
  final EntriesRemoteDataSource _dataSource;

  EntriesRepositoryImpl(this._dataSource);

  @override
  Future<Either<ApiError, Submission>> submitEntry({
    required String listId,
    required EntryInput input,
  }) {
    return safeApiCall(() async {
      final data = await _dataSource.submitEntry(listId, {
        'valueNumber': ?input.valueNumber,
        'valueDurationMs': ?input.valueDurationMs,
        'valueText': ?input.valueText,
        'note': ?input.note,
      });
      return ListsJson.submission(data);
    });
  }

  @override
  Future<Either<ApiError, void>> deleteMyEntry(String listId) {
    return safeApiCall(() => _dataSource.deleteMyEntry(listId));
  }

  @override
  Future<Either<ApiError, List<Submission>>> getPendingSubmissions(
    String listId,
  ) {
    return safeApiCall(() async {
      final data = await _dataSource.getPendingSubmissions(listId);
      return data
          .map((e) => ListsJson.submission(e as Map<String, dynamic>))
          .toList();
    });
  }

  @override
  Future<Either<ApiError, void>> approveSubmission({
    required String listId,
    required String submissionId,
  }) {
    return safeApiCall(
      () => _dataSource.approveSubmission(listId, submissionId),
    );
  }

  @override
  Future<Either<ApiError, void>> rejectSubmission({
    required String listId,
    required String submissionId,
  }) {
    return safeApiCall(
      () => _dataSource.rejectSubmission(listId, submissionId),
    );
  }
}
