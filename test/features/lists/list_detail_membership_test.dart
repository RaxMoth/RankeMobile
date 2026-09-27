import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:ranke_mobile/core/app_keys.dart';
import 'package:ranke_mobile/core/strings.dart';
import 'package:ranke_mobile/features/auth/domain/entities/user.dart';
import 'package:ranke_mobile/features/auth/presentation/providers/auth_provider.dart';
import 'package:ranke_mobile/features/lists/domain/entities/ranked_list.dart';
import 'package:ranke_mobile/features/lists/presentation/list_detail_screen.dart';
import 'package:ranke_mobile/features/lists/presentation/providers/lists_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

const _me = User(id: 'me', email: 'me@example.com', displayName: 'Me');

class _SignedIn extends AuthNotifier {
  @override
  Future<User?> build() async => _me;
}

/// Serves a fixed board and records the membership calls the screen makes.
class _FakeDetail extends ListDetailNotifier {
  _FakeDetail(this.board, this.calls);

  final RankedList board;
  final List<String> calls;

  @override
  Future<RankedList> build(String arg) async => board;

  @override
  Future<void> join() async => calls.add('join');

  @override
  Future<void> deleteMyEntry() async => calls.add('deleteMyEntry');

  @override
  Future<void> deleteEntry(String entryId) async =>
      calls.add('deleteEntry:$entryId');
}

/// A review queue with one submission from Bob; records approvals.
class _FakeQueue extends PendingSubmissionsNotifier {
  _FakeQueue(this.calls);

  final List<String> calls;

  @override
  Future<List<Submission>> build(String arg) async => [
    Submission(
      id: 's1',
      userId: 'bob',
      displayName: 'Bob',
      valueNumber: 50,
      status: EntryStatus.pending,
      submittedAt: DateTime.utc(2026),
    ),
  ];

  @override
  Future<void> approve(String submissionId) async =>
      calls.add('approve:$submissionId');
}

RankedList _board({
  MemberRole? role,
  bool isPublic = true,
  bool locked = false,
  Submission? mySubmission,
}) => RankedList(
  id: 'b1',
  title: 'Board',
  valueType: ValueType.number,
  rankOrder: RankOrder.desc,
  isPublic: isPublic,
  locked: locked,
  memberCount: 3,
  currentUserRole: role,
  mySubmission: mySubmission,
  entries: [
    RankedEntry(
      id: 'mine',
      userId: _me.id,
      displayName: 'Me',
      rank: 1,
      valueNumber: 10,
      submittedAt: DateTime.utc(2026),
    ),
  ],
);

void main() {
  late List<String> calls;

  setUp(() {
    SharedPreferences.setMockInitialValues({});
    calls = [];
  });

  Future<void> pumpBoard(WidgetTester tester, RankedList board) async {
    tester.view.physicalSize = const Size(393, 852);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          authProvider.overrideWith(_SignedIn.new),
          listDetailProvider.overrideWith(() => _FakeDetail(board, calls)),
          pendingSubmissionsProvider.overrideWith(() => _FakeQueue(calls)),
        ],
        child: const MaterialApp(home: ListDetailScreen(listId: 'b1')),
      ),
    );
    await tester.pumpAndSettle();
  }

  testWidgets('a visitor on a public board is offered to join, not to submit', (
    tester,
  ) async {
    await pumpBoard(tester, _board());

    expect(find.byKey(AppKeys.submitEntryButton), findsNothing);
    await tester.tap(find.byKey(AppKeys.joinBoardButton));
    await tester.pumpAndSettle();
    expect(calls, ['join']);
  });

  testWidgets('a member can submit', (tester) async {
    await pumpBoard(tester, _board(role: MemberRole.member));

    expect(find.byKey(AppKeys.submitEntryButton), findsOneWidget);
    expect(find.byKey(AppKeys.joinBoardButton), findsNothing);
  });

  testWidgets('nobody can submit to a locked board', (tester) async {
    await pumpBoard(tester, _board(role: MemberRole.member, locked: true));

    expect(find.byKey(AppKeys.submitEntryButton), findsNothing);
  });

  testWidgets('a member deletes their own entry through /entries/me', (
    tester,
  ) async {
    await pumpBoard(tester, _board(role: MemberRole.member));

    await tester.drag(find.byType(Dismissible), const Offset(-300, 0));
    await tester.pumpAndSettle();
    await tester.tap(find.widgetWithText(ElevatedButton, S.remove));
    await tester.pumpAndSettle();

    expect(calls, ['deleteMyEntry']);
  });

  group('moderation', () {
    Submission mine(EntryStatus status) => Submission(
      id: 'm1',
      userId: _me.id,
      valueNumber: 12,
      status: status,
      submittedAt: DateTime.utc(2026),
    );

    testWidgets('the submitter sees their submission waiting for review', (
      tester,
    ) async {
      await pumpBoard(
        tester,
        _board(
          role: MemberRole.member,
          mySubmission: mine(EntryStatus.pending),
        ),
      );
      expect(find.text(S.mySubmissionPending('12')), findsOneWidget);
    });

    testWidgets('the submitter sees when it was rejected', (tester) async {
      await pumpBoard(
        tester,
        _board(
          role: MemberRole.member,
          mySubmission: mine(EntryStatus.rejected),
        ),
      );
      expect(find.text(S.mySubmissionRejected('12')), findsOneWidget);
    });

    testWidgets('members have no review tab', (tester) async {
      await pumpBoard(tester, _board(role: MemberRole.member));
      expect(find.byKey(AppKeys.listDetailTab('admin')), findsNothing);
    });

    testWidgets('a moderator reviews the queue but cannot manage the board', (
      tester,
    ) async {
      await pumpBoard(tester, _board(role: MemberRole.moderator));

      expect(find.text(S.review), findsOneWidget);
      await tester.tap(find.byKey(AppKeys.listDetailTab('admin')));
      await tester.pumpAndSettle();
      expect(find.text(S.editBoard), findsNothing);
      expect(find.text(S.manageMembers), findsNothing);

      await tester.tap(find.byKey(AppKeys.pendingApprove));
      await tester.pumpAndSettle();
      expect(calls, ['approve:s1']);
    });

    testWidgets('an admin gets the queue and the board actions', (
      tester,
    ) async {
      await pumpBoard(tester, _board(role: MemberRole.admin));

      await tester.tap(find.byKey(AppKeys.listDetailTab('admin')));
      await tester.pumpAndSettle();
      expect(find.byKey(AppKeys.pendingApprove), findsOneWidget);
      expect(find.text(S.editBoard), findsOneWidget);
    });
  });
}
