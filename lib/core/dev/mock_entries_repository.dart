import 'package:fpdart/fpdart.dart';
import 'package:uuid/uuid.dart';

import '../../features/entries/domain/entities/entry.dart';
import '../../features/entries/domain/entries_repository.dart';
import '../../features/lists/domain/entities/ranked_list.dart';
import '../network/api_error.dart';
import 'dev_config.dart';
import 'mock_lists_repository.dart';

const _uuid = Uuid();
const _currentUserId = 'dev-user-001';

/// Mock entries repository with pending approval workflow.
class MockEntriesRepository implements EntriesRepository {
  final MockListsRepository _listsRepo;

  /// Pending entries keyed by listId
  final Map<String, List<RankedEntry>> _pendingEntries = {};

  MockEntriesRepository(this._listsRepo);

  @override
  Future<Either<ApiError, RankedEntry>> submitEntry({
    required String listId,
    required EntryInput input,
  }) async {
    await Future.delayed(DevConfig.networkDelay);

    final newEntry = RankedEntry(
      id: _uuid.v4(),
      userId: _currentUserId,
      displayName: 'Max Roth',
      rank: 0,
      valueNumber: input.valueNumber,
      valueDurationMs: input.valueDurationMs,
      valueText: input.valueText,
      note: input.note,
      submittedAt: DateTime.now(),
      status: EntryStatus.pending,
    );

    _pendingEntries.putIfAbsent(listId, () => []);
    // Replace existing pending entry from same user, or add new
    _pendingEntries[listId]!.removeWhere((e) => e.userId == _currentUserId);
    _pendingEntries[listId]!.add(newEntry);

    return Right(newEntry);
  }

  @override
  Future<Either<ApiError, List<RankedEntry>>> getPendingEntries(
      String listId) async {
    await Future.delayed(DevConfig.networkDelay);
    return Right(List.unmodifiable(_pendingEntries[listId] ?? []));
  }

  @override
  Future<Either<ApiError, void>> approveEntry({
    required String listId,
    required String entryId,
  }) async {
    await Future.delayed(DevConfig.networkDelay);

    final pending = _pendingEntries[listId];
    if (pending == null) {
      return const Left(ApiUnknownError(error: 'No pending entries'));
    }

    final idx = pending.indexWhere((e) => e.id == entryId);
    if (idx == -1) {
      return const Left(ApiUnknownError(error: 'Entry not found'));
    }

    final entry = pending.removeAt(idx).copyWith(status: EntryStatus.approved);

    // Add to standings and re-rank
    final listResult = await _listsRepo.getListDetail(listId);
    return listResult.fold(
      (error) => Left(error),
      (list) {
        final entries = [...list.entries, entry];
        _sortAndRank(entries, list.valueType, list.rankOrder);
        _listsRepo.updateEntries(listId, entries);
        return const Right(null);
      },
    );
  }

  @override
  Future<Either<ApiError, void>> rejectEntry({
    required String listId,
    required String entryId,
  }) async {
    await Future.delayed(DevConfig.networkDelay);

    final pending = _pendingEntries[listId];
    if (pending == null) {
      return const Left(ApiUnknownError(error: 'No pending entries'));
    }

    pending.removeWhere((e) => e.id == entryId);
    return const Right(null);
  }

  void _sortAndRank(
      List<RankedEntry> entries, ValueType valueType, RankOrder rankOrder) {
    entries.sort((a, b) {
      if (valueType == ValueType.number) {
        final aVal = a.valueNumber ?? 0;
        final bVal = b.valueNumber ?? 0;
        return rankOrder == RankOrder.desc
            ? bVal.compareTo(aVal)
            : aVal.compareTo(bVal);
      } else if (valueType == ValueType.duration) {
        final aVal = a.valueDurationMs ?? 0;
        final bVal = b.valueDurationMs ?? 0;
        return rankOrder == RankOrder.desc
            ? bVal.compareTo(aVal)
            : aVal.compareTo(bVal);
      }
      return 0;
    });

    for (int i = 0; i < entries.length; i++) {
      entries[i] = entries[i].copyWith(rank: i + 1);
    }
  }
}
