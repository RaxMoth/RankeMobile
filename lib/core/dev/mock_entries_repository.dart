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

/// Mock entries repository that inserts entries into the mock lists repository.
class MockEntriesRepository implements EntriesRepository {
  final MockListsRepository _listsRepo;

  MockEntriesRepository(this._listsRepo);

  @override
  Future<Either<ApiError, RankedEntry>> submitEntry({
    required String listId,
    required EntryInput input,
  }) async {
    await Future.delayed(DevConfig.networkDelay);

    final listResult = await _listsRepo.getListDetail(listId);
    return listResult.fold(
      (error) => Left(error),
      (list) {
        final newEntry = RankedEntry(
          id: _uuid.v4(),
          userId: _currentUserId,
          displayName: 'Max Roth',
          rank: 0, // will be recalculated
          valueNumber: input.valueNumber,
          valueDurationMs: input.valueDurationMs,
          valueText: input.valueText,
          note: input.note,
          submittedAt: DateTime.now(),
        );

        // Replace existing entry from current user or add new
        final entries =
            list.entries.where((e) => e.userId != _currentUserId).toList()
              ..add(newEntry);

        // Sort by value
        entries.sort((a, b) {
          if (list.valueType == ValueType.number) {
            final aVal = a.valueNumber ?? 0;
            final bVal = b.valueNumber ?? 0;
            return list.rankOrder == RankOrder.desc
                ? bVal.compareTo(aVal)
                : aVal.compareTo(bVal);
          } else if (list.valueType == ValueType.duration) {
            final aVal = a.valueDurationMs ?? 0;
            final bVal = b.valueDurationMs ?? 0;
            return list.rankOrder == RankOrder.desc
                ? bVal.compareTo(aVal)
                : aVal.compareTo(bVal);
          }
          return 0; // text: maintain insertion order
        });

        // Assign ranks
        final ranked = <RankedEntry>[];
        for (int i = 0; i < entries.length; i++) {
          ranked.add(entries[i].copyWith(rank: i + 1));
        }

        // Persist into mock lists repo
        _listsRepo.updateEntries(listId, ranked);

        final userEntry =
            ranked.firstWhere((e) => e.userId == _currentUserId);
        return Right(userEntry);
      },
    );
  }
}
