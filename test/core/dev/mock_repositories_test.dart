import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';

import 'package:ranke_mobile/core/dev/mock_entries_repository.dart';
import 'package:ranke_mobile/core/dev/mock_lists_repository.dart';
import 'package:ranke_mobile/core/network/api_error.dart';
import 'package:ranke_mobile/core/network/api_error_codes.dart';
import 'package:ranke_mobile/features/entries/domain/entities/entry.dart';
import 'package:ranke_mobile/features/lists/domain/entities/ranked_list.dart';

/// Dev mode (`--dart-define=USE_MOCK=true`) must behave like the backend —
/// including always-on moderation — or features get built against
/// behaviour production never has. These pin the mocks to the rules
/// RankeBE's integration tests enforce.
T right<T>(Either<ApiError, T> r) =>
    r.getOrElse((e) => throw TestFailure('expected success, got $e'));

void main() {
  late MockListsRepository lists;
  late MockEntriesRepository entries;

  setUp(() {
    lists = MockListsRepository();
    entries = MockEntriesRepository(lists);
  });

  Future<String> board(
    ValueType type, {
    RankOrder order = RankOrder.desc,
  }) async => right(
    await lists.createList(
      title: 'T',
      valueType: type,
      rankOrder: order,
      isPublic: true,
    ),
  ).id;

  Future<Submission> submit(String listId, EntryInput input) async =>
      right(await entries.submitEntry(listId: listId, input: input));

  Future<void> approve(String listId, Submission s) async => right(
    await entries.approveSubmission(listId: listId, submissionId: s.id),
  );

  test('a submission waits for review; approval ranks it', () async {
    final id = await board(ValueType.number);
    final submission = await submit(id, const EntryInput(valueNumber: 5));
    expect(submission.status, EntryStatus.pending);

    var detail = right(await lists.getListDetail(id));
    expect(detail.entries, isEmpty);
    expect(detail.mySubmission?.status, EntryStatus.pending);
    final summary = right(await lists.getLists()).firstWhere((l) => l.id == id);
    expect(summary.pendingCount, 1);

    await approve(id, submission);
    detail = right(await lists.getListDetail(id));
    expect(detail.entries.single.rank, 1);
    expect(detail.mySubmission, isNull);
    expect(right(await entries.getPendingSubmissions(id)), isEmpty);
  });

  test('an edit waits for review while the approved value stays', () async {
    final id = await board(ValueType.number);
    await approve(id, await submit(id, const EntryInput(valueNumber: 5)));

    await submit(id, const EntryInput(valueNumber: 8));
    final edit = await submit(id, const EntryInput(valueNumber: 9));
    // A resubmission replaces the pending one.
    expect(right(await entries.getPendingSubmissions(id)).single.id, edit.id);
    expect(right(await lists.getListDetail(id)).entries.single.valueNumber, 5);

    right(await entries.rejectSubmission(listId: id, submissionId: edit.id));
    final detail = right(await lists.getListDetail(id));
    expect(detail.entries.single.valueNumber, 5);
    expect(detail.mySubmission?.status, EntryStatus.rejected);

    final again = await entries.approveSubmission(
      listId: id,
      submissionId: edit.id,
    );
    expect(again.getLeft().toNullable()?.hasCode(ApiErrorCode.notFound), isTrue);
  });

  test('a locked board rejects submissions with LIST_LOCKED', () async {
    final id = await board(ValueType.number);
    right(await lists.updateList(listId: id, locked: true));

    final result = await entries.submitEntry(
      listId: id,
      input: const EntryInput(valueNumber: 5),
    );
    expect(
      result.getLeft().toNullable()?.hasCode(ApiErrorCode.listLocked),
      isTrue,
    );
  });

  test('updateList: null keeps a field, empty string clears it', () async {
    final id = right(
      await lists.createList(
        title: 'T',
        description: 'keep me?',
        valueType: ValueType.number,
        rankOrder: RankOrder.asc,
        isPublic: true,
        category: 'FITNESS',
        telegramLink: 'https://t.me/x',
      ),
    ).id;

    final updated = right(
      await lists.updateList(listId: id, description: '', category: 'GAMING'),
    );
    expect(updated.description, isNull);
    expect(updated.category, 'GAMING');
    expect(updated.telegramLink, 'https://t.me/x');
  });

  test('the owner cannot leave their board', () async {
    final id = await board(ValueType.number);
    expect(
      (await lists.leaveList(
        id,
      )).getLeft().toNullable()?.hasCode(ApiErrorCode.validationError),
      isTrue,
    );
  });

  test('invite links are full app URLs routed on their path', () async {
    final id = await board(ValueType.number);
    final link = Uri.parse(right(await lists.getInviteLink(id)));
    expect(link.scheme, 'rankapp');
    expect(link.pathSegments.first, 'invite');
  });

  test('reordering a text board sets the ranks in the given order', () async {
    final id = await board(ValueType.text);
    await approve(id, await submit(id, const EntryInput(valueText: 'a')));
    final entryId = right(await lists.getListDetail(id)).entries.single.id;

    right(await lists.reorderEntries(listId: id, orderedEntryIds: [entryId]));
    final entry = right(await lists.getListDetail(id)).entries.single;
    expect((entry.rank, entry.manualRank), (1, 1));
  });
}
