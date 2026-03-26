import 'package:dio/dio.dart';
import 'package:fpdart/fpdart.dart';
import '../../../core/network/api_error.dart';
import '../../lists/domain/entities/ranked_list.dart';
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
  }) async {
    try {
      final data = await _dataSource.submitEntry(listId, {
        if (input.valueNumber != null) 'valueNumber': input.valueNumber,
        if (input.valueDurationMs != null) 'valueDurationMs': input.valueDurationMs,
        if (input.valueText != null) 'valueText': input.valueText,
        if (input.note != null) 'note': input.note,
      });
      return Right(RankedEntry(
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
      ));
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionError ||
          e.type == DioExceptionType.connectionTimeout) {
        return const Left(ApiNetworkError());
      }
      return Left(ApiUnknownError(error: e));
    } catch (e) {
      return Left(ApiUnknownError(error: e));
    }
  }
}
