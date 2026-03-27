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
      return Right(_parseEntry(data));
    } on DioException catch (e) {
      return Left(_mapDioError(e));
    } catch (e) {
      return Left(ApiUnknownError(error: e));
    }
  }

  @override
  Future<Either<ApiError, List<RankedEntry>>> getPendingEntries(
      String listId) async {
    try {
      final data = await _dataSource.getPendingEntries(listId);
      final entries = data
          .cast<Map<String, dynamic>>()
          .map(_parseEntry)
          .toList();
      return Right(entries);
    } on DioException catch (e) {
      return Left(_mapDioError(e));
    } catch (e) {
      return Left(ApiUnknownError(error: e));
    }
  }

  @override
  Future<Either<ApiError, void>> approveEntry({
    required String listId,
    required String entryId,
  }) async {
    try {
      await _dataSource.approveEntry(listId, entryId);
      return const Right(null);
    } on DioException catch (e) {
      return Left(_mapDioError(e));
    } catch (e) {
      return Left(ApiUnknownError(error: e));
    }
  }

  @override
  Future<Either<ApiError, void>> rejectEntry({
    required String listId,
    required String entryId,
  }) async {
    try {
      await _dataSource.rejectEntry(listId, entryId);
      return const Right(null);
    } on DioException catch (e) {
      return Left(_mapDioError(e));
    } catch (e) {
      return Left(ApiUnknownError(error: e));
    }
  }

  RankedEntry _parseEntry(Map<String, dynamic> data) {
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
      status: _parseStatus(data['status'] as String?),
    );
  }

  EntryStatus _parseStatus(String? status) {
    return switch (status) {
      'pending' => EntryStatus.pending,
      'rejected' => EntryStatus.rejected,
      _ => EntryStatus.approved,
    };
  }

  ApiError _mapDioError(DioException e) {
    if (e.type == DioExceptionType.connectionError ||
        e.type == DioExceptionType.connectionTimeout) {
      return const ApiNetworkError();
    }
    return ApiUnknownError(error: e);
  }
}
