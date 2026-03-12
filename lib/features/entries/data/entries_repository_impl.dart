import 'package:fpdart/fpdart.dart';
import '../../../core/network/api_error.dart';
import '../../../core/network/api_helpers.dart';
import '../domain/entities/entry.dart';
import '../domain/entries_repository.dart';
import 'entries_remote_data_source.dart';

class EntriesRepositoryImpl implements EntriesRepository {
  final EntriesRemoteDataSource _dataSource;

  EntriesRepositoryImpl(this._dataSource);

  @override
  Future<Either<ApiError, RankedEntry>> submitEntry({
    required String listId,
    required EntryInput input,
  }) {
    return safeApiCall(() async {
      final data = await _dataSource.submitEntry(listId: listId, input: input);
      return RankedEntry(
        id: data['id'] as String,
        userId: data['userId'] as String,
        displayName: data['displayName'] as String,
        rank: data['rank'] as int,
        valueNumber: (data['valueNumber'] as num?)?.toDouble(),
        valueDurationMs: data['valueDurationMs'] as int?,
        valueText: data['valueText'] as String?,
        manualRank: data['manualRank'] as int?,
        note: data['note'] as String?,
        submittedAt: DateTime.parse(data['submittedAt'] as String),
      );
    });
  }
}
