import 'package:fpdart/fpdart.dart';
import 'package:uuid/uuid.dart';

import '../../features/entries/domain/entities/entry.dart';
import '../../features/entries/domain/entries_repository.dart';
import '../../features/lists/domain/entities/ranked_list.dart';
import '../network/api_error.dart';
import '../network/api_error_codes.dart';
import 'dev_config.dart';
import 'mock_lists_repository.dart';

const _uuid = Uuid();
const _currentUserId = 'dev-user-001';

/// Mock entries repository mirroring the backend's always-on moderation:
/// a submission waits in the board's queue (held by [MockListsRepository])
/// until it is approved, and only then is ranked on the board.
class MockEntriesRepository implements EntriesRepository {
  final MockListsRepository _listsRepo;

  MockEntriesRepository(this._listsRepo);

  /// A locked board rejects with LIST_LOCKED; otherwise the caller's
  /// pending submission is created or replaced.
  @override
  Future<Either<ApiError, Submission>> submitEntry({
    required String listId,
    required EntryInput input,
  }) async {
    await Future<void>.delayed(DevConfig.networkDelay);

    final listResult = await _listsRepo.getListDetail(listId);
    return listResult.fold((error) => Left(error), (list) {
      if (list.locked) {
        return const Left(ApiServerError(
          code: ApiErrorCode.listLocked,
          message: 'this board is locked — no new entries',
          statusCode: 403,
        ));
      }
      final submission = Submission(
        id: _uuid.v4(),
        userId: _currentUserId,
        displayName: 'Max Roth',
        valueNumber: input.valueNumber,
        valueDurationMs: input.valueDurationMs,
        valueText: input.valueText,
        note: input.note,
        status: EntryStatus.pending,
        submittedAt: DateTime.now(),
      );
      final queue = _listsRepo.submissions.putIfAbsent(listId, () => []);
      queue.removeWhere(
        (s) => s.userId == _currentUserId && s.status == EntryStatus.pending,
      );
      queue.add(submission);
      return Right(submission);
    });
  }

  @override
  Future<Either<ApiError, void>> deleteMyEntry(String listId) async {
    await Future<void>.delayed(DevConfig.networkDelay);
    _listsRepo.submissions[listId]?.removeWhere(
      (s) => s.userId == _currentUserId && s.status == EntryStatus.pending,
    );
    final listResult = await _listsRepo.getListDetail(listId);
    return listResult.fold((error) => Left(error), (list) {
      final entries = [
        for (final e in list.entries)
          if (e.userId != _currentUserId) e,
      ];
      _sortAndRank(entries, list.valueType, list.rankOrder);
      _listsRepo.updateEntries(listId, entries);
      return const Right(null);
    });
  }

  @override
  Future<Either<ApiError, List<Submission>>> getPendingSubmissions(
    String listId,
  ) async {
    await Future<void>.delayed(DevConfig.networkDelay);
    return Right([
      for (final s in _listsRepo.submissions[listId] ?? <Submission>[])
        if (s.status == EntryStatus.pending) s,
    ]);
  }

  /// Puts the submission on the board (replacing the author's entry, text
  /// entries keeping their position) and records the previous rank.
  @override
  Future<Either<ApiError, void>> approveSubmission({
    required String listId,
    required String submissionId,
  }) async {
    await Future<void>.delayed(DevConfig.networkDelay);
    final submission = _review(listId, submissionId, EntryStatus.approved);
    if (submission == null) return const Left(_notFound);

    final listResult = await _listsRepo.getListDetail(listId);
    return listResult.fold((error) => Left(error), (list) {
      final existing =
          list.entries.where((e) => e.userId == submission.userId).firstOrNull;
      final entry = RankedEntry(
        id: existing?.id ?? _uuid.v4(),
        userId: submission.userId,
        displayName: submission.displayName ?? existing?.displayName ?? '',
        rank: 0,
        previousRank: existing?.rank,
        valueNumber: submission.valueNumber,
        valueDurationMs: submission.valueDurationMs,
        valueText: submission.valueText,
        manualRank: existing?.manualRank ??
            (list.valueType == ValueType.text ? list.entries.length + 1 : null),
        note: submission.note,
        submittedAt: submission.submittedAt,
      );
      final entries = [
        for (final e in list.entries)
          if (e.userId != submission.userId) e,
        entry,
      ];
      _sortAndRank(entries, list.valueType, list.rankOrder);
      _listsRepo.updateEntries(listId, entries);
      return const Right(null);
    });
  }

  @override
  Future<Either<ApiError, void>> rejectSubmission({
    required String listId,
    required String submissionId,
  }) async {
    await Future<void>.delayed(DevConfig.networkDelay);
    return _review(listId, submissionId, EntryStatus.rejected) == null
        ? const Left(_notFound)
        : const Right(null);
  }

  static const _notFound = ApiServerError(
    code: ApiErrorCode.notFound,
    message: 'no pending submission with that id on this board',
    statusCode: 404,
  );

  /// Marks a pending submission reviewed; null when there's none to review.
  Submission? _review(String listId, String submissionId, EntryStatus to) {
    final queue = _listsRepo.submissions[listId];
    final i = queue?.indexWhere(
          (s) => s.id == submissionId && s.status == EntryStatus.pending,
        ) ??
        -1;
    if (i < 0) return null;
    final reviewed = queue![i].copyWith(status: to, reviewedAt: DateTime.now());
    queue[i] = reviewed;
    return reviewed;
  }

  /// Orders [entries] best-first and assigns ranks the way the backend
  /// does: ties share a rank and the next rank skips (50, 50, 40 → 1, 1, 3).
  void _sortAndRank(
      List<RankedEntry> entries, ValueType valueType, RankOrder rankOrder) {
    num? key(RankedEntry e) => switch (valueType) {
          ValueType.number => e.valueNumber,
          ValueType.duration => e.valueDurationMs,
          ValueType.text => e.manualRank,
        };
    final descending =
        valueType != ValueType.text && rankOrder == RankOrder.desc;
    int compare(RankedEntry a, RankedEntry b) {
      final ka = key(a), kb = key(b);
      if (ka == null || kb == null) {
        return ka == null ? (kb == null ? 0 : 1) : -1; // nulls last
      }
      return descending ? kb.compareTo(ka) : ka.compareTo(kb);
    }

    entries.sort((a, b) {
      final c = compare(a, b);
      return c != 0 ? c : a.submittedAt.compareTo(b.submittedAt);
    });
    for (var i = 0; i < entries.length; i++) {
      final tied = i > 0 && compare(entries[i - 1], entries[i]) == 0;
      entries[i] = entries[i].copyWith(rank: tied ? entries[i - 1].rank : i + 1);
    }
  }
}
