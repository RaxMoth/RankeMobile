// API contract tests: the app's real network stack against the backend's
// contract (test/contract/fixtures, synced from RankeBE/contract).
//
// Every repository call runs ApiClient → AuthInterceptor → data source →
// repository against [FakeBackend], which
//   * only answers routes that exist in the backend's routes.json,
//   * replies with fixtures generated from the backend's real DTOs, and
//   * records the body the app sent, compared with requests/*.json — the
//     same files the backend binds in its own contract test.
//
// Coverage checks at the end make the contract two-way: every backend route
// and every fixture must be exercised here (or be explicitly listed as not
// used by the app), so a new endpoint or shape can't be silently ignored.
//
// After a backend API change: tool/sync_contract.sh && flutter test.

import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';

import 'package:ranke_mobile/core/constants/app_constants.dart';
import 'package:ranke_mobile/core/network/api_client.dart';
import 'package:ranke_mobile/core/network/api_error.dart';
import 'package:ranke_mobile/core/network/api_error_codes.dart';
import 'package:ranke_mobile/core/network/auth_interceptor.dart';
import 'package:ranke_mobile/features/auth/data/auth_remote_data_source.dart';
import 'package:ranke_mobile/features/auth/data/auth_repository_impl.dart';
import 'package:ranke_mobile/features/entries/data/entries_remote_data_source.dart';
import 'package:ranke_mobile/features/entries/data/entries_repository_impl.dart';
import 'package:ranke_mobile/features/entries/domain/entities/entry.dart';
import 'package:ranke_mobile/features/lists/data/lists_remote_data_source.dart';
import 'package:ranke_mobile/features/lists/data/lists_repository_impl.dart';
import 'package:ranke_mobile/features/lists/domain/entities/ranked_list.dart';

import 'fake_backend.dart';

// Fixture identities (see RankeBE internal/handler/contract_test.go).
const alice = '11111111-1111-4111-8111-111111111111';
const bob = '11111111-1111-4111-8111-111111111112';
const listId = '22222222-2222-4222-8222-222222222222';
const entryA = '33333333-3333-4333-8333-333333333331';
const entryB = '33333333-3333-4333-8333-333333333332';
const inviteToken = '44444444-4444-4444-8444-444444444444';
const submissionId = '55555555-5555-4555-8555-555555555555';
const accessToken = 'eyJhbGciOiJIUzI1NiJ9.access';
const refreshToken =
    '5f0c2d7e9a1b3c4d5e6f708192a3b4c5d6e7f8091a2b3c4d5e6f708192a3b4c5';

/// Backend routes the app deliberately never calls.
const routesNotUsedByApp = {
  'GET /health': 'infrastructure probe',
  'GET /healthz': 'infrastructure probe',
  'GET /readyz': 'infrastructure probe',
  'POST /api/v1/auth/apple/notifications': 'Apple server-to-server webhook',
  'PATCH /api/v1/users/me': 'no profile editing in the app yet',
};

T right<T>(Either<ApiError, T> result) =>
    result.fold((e) => throw TestFailure('expected success, got $e'), (v) => v);

ApiServerError left<T>(Either<ApiError, T> result) => result.fold(
  (e) => e is ApiServerError
      ? e
      : throw TestFailure('expected an ApiServerError, got $e'),
  (v) => throw TestFailure('expected a failure, got $v'),
);

void main() {
  final contract = Contract.load();
  final routesHit = <String>{};
  final fixturesServed = <String>{};
  final requestFixturesChecked = <String>{};

  late FakeBackend backend;
  late FlutterSecureStorage storage;
  late AuthRepositoryImpl auth;
  late ListsRepositoryImpl lists;
  late EntriesRepositoryImpl entries;

  /// Asserts the last request hit [route] with the body in requests/[name].
  void expectRequest(String route, {String? body}) {
    expect(backend.last.route.toString(), route);
    if (body != null) {
      requestFixturesChecked.add(body);
      expect(
        backend.last.body,
        contract.request(body),
        reason: 'body sent to $route differs from contract requests/$body',
      );
    }
  }

  setUp(() {
    FlutterSecureStorage.setMockInitialValues({
      AppConstants.accessTokenKey: accessToken,
      AppConstants.refreshTokenKey: refreshToken,
    });
    storage = const FlutterSecureStorage();
    backend = FakeBackend(contract);
    final client = ApiClient(
      httpClientAdapter: backend,
      logRequests: false,
      authInterceptor: AuthInterceptor(
        storage: storage,
        refreshDio: Dio(BaseOptions(baseUrl: AppConstants.apiBaseUrl))
          ..httpClientAdapter = backend,
      ),
    );
    auth = AuthRepositoryImpl(AuthRemoteDataSourceImpl(client));
    lists = ListsRepositoryImpl(ListsRemoteDataSourceImpl(client));
    entries = EntriesRepositoryImpl(EntriesRemoteDataSourceImpl(client));
  });

  tearDown(() {
    routesHit.addAll(backend.routesHit);
    fixturesServed.addAll(backend.fixturesServed);
  });

  // ── Auth ─────────────────────────────────────────────────────────

  group('auth', () {
    Future<void> expectSignedInAsAlice(
      Future<Either<ApiError, dynamic>> call,
    ) async {
      final user = right(await call);
      expect(user.id, alice);
      expect(user.email, 'alice@example.com');
      expect(user.displayName, 'Alice');
      expect(user.createdAt, DateTime.utc(2026, 1, 15, 9, 30));
      expect(await storage.read(key: AppConstants.accessTokenKey), accessToken);
      expect(
        await storage.read(key: AppConstants.refreshTokenKey),
        refreshToken,
      );
    }

    setUp(() => FlutterSecureStorage.setMockInitialValues({}));

    test('register', () async {
      backend.stub('POST /api/v1/auth/register', fixture: 'auth_response');
      await expectSignedInAsAlice(
        auth.register(
          email: 'alice@example.com',
          password: 'correct-horse-battery',
          displayName: 'Alice',
        ),
      );
      expectRequest('POST /api/v1/auth/register', body: 'auth_register');
    });

    test('login', () async {
      backend.stub('POST /api/v1/auth/login', fixture: 'auth_response');
      await expectSignedInAsAlice(
        auth.login(
          email: 'alice@example.com',
          password: 'correct-horse-battery',
        ),
      );
      expectRequest('POST /api/v1/auth/login', body: 'auth_login');
    });

    test('sign in with Apple', () async {
      backend.stub('POST /api/v1/auth/apple', fixture: 'auth_response');
      await expectSignedInAsAlice(
        auth.signInWithApple(
          identityToken: 'eyJhbGciOiJSUzI1NiJ9.apple-identity-token',
          fullName: 'Alice Example',
        ),
      );
      expectRequest('POST /api/v1/auth/apple', body: 'auth_apple');
    });
  });

  group('session', () {
    test('restore resumes a stored session from /users/me', () async {
      backend.stub('GET /api/v1/users/me', fixture: 'user_me');
      final user = right(await auth.restoreSession());
      expect(user?.id, alice);
      expect(user?.email, 'alice@example.com');
      expect(backend.last.authorization, 'Bearer $accessToken');
      expectRequest('GET /api/v1/users/me');
    });

    test(
      'an expired access token is refreshed once and the call retried',
      () async {
        FlutterSecureStorage.setMockInitialValues({
          AppConstants.accessTokenKey: 'expired-access-token',
          AppConstants.refreshTokenKey: refreshToken,
        });
        backend
          ..stub(
            'GET /api/v1/users/me',
            json: {
              'error': {
                'code': 'UNAUTHORIZED',
                'message': 'invalid or expired token',
              },
            },
            status: 401,
          )
          ..stub('GET /api/v1/users/me', fixture: 'user_me')
          ..stub('POST /api/v1/auth/refresh', fixture: 'refresh_response');

        expect(right(await auth.restoreSession())?.id, alice);

        final refresh = backend.requests[1];
        expect(refresh.route.toString(), 'POST /api/v1/auth/refresh');
        expect(refresh.body, contract.request('auth_refresh'));
        requestFixturesChecked.add('auth_refresh');
        expect(backend.last.authorization, 'Bearer $accessToken');
        expect(
          await storage.read(key: AppConstants.accessTokenKey),
          accessToken,
        );
      },
    );

    test(
      'logout revokes the stored refresh token and clears the session',
      () async {
        backend.stub('POST /api/v1/auth/logout', fixture: 'message');
        right(await auth.logout());
        expectRequest('POST /api/v1/auth/logout', body: 'auth_refresh');
        expect(await storage.read(key: AppConstants.accessTokenKey), isNull);
        expect(await storage.read(key: AppConstants.refreshTokenKey), isNull);
      },
    );

    test('account deletion clears the session', () async {
      backend.stub('DELETE /api/v1/users/me', fixture: 'message');
      right(await auth.deleteAccount());
      expectRequest('DELETE /api/v1/users/me');
      expect(await storage.read(key: AppConstants.accessTokenKey), isNull);
    });
  });

  // ── Lists ────────────────────────────────────────────────────────

  group('lists', () {
    void expectFullBoard(RankedList board) {
      expect(board.id, listId);
      expect(board.title, 'Heaviest bench');
      expect(board.description, 'Paused reps only');
      expect(board.valueType, ValueType.number);
      expect(board.rankOrder, RankOrder.desc);
      expect(board.isPublic, isTrue);
      expect(board.locked, isFalse);
      expect(board.category, 'FITNESS');
      expect(board.inviteToken, inviteToken);
      expect(board.telegramLink, 'https://t.me/bench');
      expect(board.whatsappLink, 'https://chat.whatsapp.com/bench');
      expect(board.discordLink, 'https://discord.gg/bench');
      expect(board.memberCount, 12);
      expect(board.currentUserRole, MemberRole.owner);
      expect(board.mySubmission, isNull);
      expectPodium(board.entries);
    }

    test('home feed: summaries with podium, rank and role', () async {
      backend.stub('GET /api/v1/lists', fixture: 'list_summaries');
      final summaries = right(await lists.getLists());
      expectRequest('GET /api/v1/lists');

      expect(summaries, hasLength(2));
      final bench = summaries[0];
      expect(bench.id, listId);
      expect(bench.valueType, ValueType.number);
      expect(bench.rankOrder, RankOrder.desc);
      expect(bench.category, 'FITNESS');
      expect(bench.memberCount, 12);
      expect(bench.ownRank, 1);
      expect(bench.currentUserRole, MemberRole.owner);
      expect(bench.pendingCount, 3);
      expectPodium(bench.topEntries);

      final movies = summaries[1];
      expect(movies.valueType, ValueType.text);
      expect(movies.isPublic, isFalse);
      expect(movies.ownRank, isNull);
      expect(movies.category, isNull);
      expect(movies.currentUserRole, MemberRole.member);
      expect(movies.topEntries, isEmpty);
      expect(movies.pendingCount, 0);
    });

    test('board detail: every field the screens read', () async {
      backend.stub('GET /api/v1/lists/:id', fixture: 'list_detail');
      expectFullBoard(right(await lists.getListDetail(listId)));
      expectRequest('GET /api/v1/lists/:id');
    });

    test('board detail seen by a non-member has no role', () async {
      backend.stub('GET /api/v1/lists/:id', fixture: 'list_detail_not_member');
      final board = right(await lists.getListDetail(listId));
      expect(board.currentUserRole, isNull);
      expect(board.entries, isEmpty);
      expect(board.description, isNull);
      expect(board.category, isNull);
      expect(board.telegramLink, isNull);
      expect(board.valueType, ValueType.duration);
    });

    test('create', () async {
      backend.stub('POST /api/v1/lists', fixture: 'list_detail');
      expectFullBoard(
        right(
          await lists.createList(
            title: 'Fastest 5K',
            description: 'Personal bests, chip time only',
            valueType: ValueType.duration,
            rankOrder: RankOrder.asc,
            isPublic: true,
            category: 'FITNESS',
            telegramLink: 'https://t.me/fastest5k',
            whatsappLink: 'https://chat.whatsapp.com/fastest5k',
            discordLink: 'https://discord.gg/fastest5k',
          ),
        ),
      );
      expectRequest('POST /api/v1/lists', body: 'list_create');
    });

    test('update: omitted keys stay, empty strings clear', () async {
      backend.stub('PATCH /api/v1/lists/:id', fixture: 'list_detail');
      right(
        await lists.updateList(
          listId: listId,
          title: 'Fastest 5K (2026)',
          description: '',
          isPublic: false,
          locked: true,
          category: 'RUNNING',
          telegramLink: '',
          discordLink: 'https://discord.gg/new5k',
        ),
      );
      expectRequest('PATCH /api/v1/lists/:id', body: 'list_update');
    });

    test('delete', () async {
      backend.stub('DELETE /api/v1/lists/:id', fixture: 'message');
      right(await lists.deleteList(listId));
      expectRequest('DELETE /api/v1/lists/:id');
    });

    test('discover: page, viewer role and cursor header', () async {
      backend.stub(
        'GET /api/v1/lists/public',
        fixture: 'public_lists_page',
        headers: {'X-Next-Cursor': 'next-page-token'},
      );
      final page = right(
        await lists.searchPublicLists(
          query: 'bench',
          category: 'FITNESS',
          cursor: 'this-page',
          limit: 30,
        ),
      );
      expectRequest('GET /api/v1/lists/public');
      expect(backend.last.uri.queryParameters, {
        'q': 'bench',
        'category': 'FITNESS',
        'cursor': 'this-page',
        'limit': '30',
      });

      expect(page.nextCursor, 'next-page-token');
      expect(page.items, hasLength(2));
      expect(page.items[0].currentUserRole, MemberRole.admin);
      expect(page.items[0].category, 'FITNESS');
      expect(page.items[1].currentUserRole, isNull);
      expect(page.items[1].valueType, ValueType.duration);
    });

    test('public profile: boards carry the viewer\'s role', () async {
      backend.stub('GET /api/v1/users/:id/profile', fixture: 'user_profile');
      final profile = right(await lists.getUserProfile(bob));
      expectRequest('GET /api/v1/users/:id/profile');
      expect(profile.userId, bob);
      expect(profile.displayName, 'Bob');
      expect(profile.memberSince, DateTime.utc(2026, 1, 15, 9, 30));
      expect(profile.boards.single.id, listId);
      expect(profile.boards.single.currentUserRole, MemberRole.owner);
      expect(profile.boards.single.ownRank, isNull);
    });
  });

  group('membership', () {
    test('join a public board', () async {
      backend.stub('POST /api/v1/lists/:id/join', fixture: 'message');
      right(await lists.joinList(listId));
      expectRequest('POST /api/v1/lists/:id/join');
    });

    test('leave a board', () async {
      backend.stub('DELETE /api/v1/lists/:id/members/me', fixture: 'message');
      right(await lists.leaveList(listId));
      expectRequest('DELETE /api/v1/lists/:id/members/me');
    });

    test('members', () async {
      backend.stub('GET /api/v1/lists/:id/members', fixture: 'list_members');
      final members = right(await lists.getMembers(listId));
      expectRequest('GET /api/v1/lists/:id/members');
      expect(members.map((m) => (m.userId, m.displayName, m.role)), [
        (alice, 'Alice', MemberRole.owner),
        (bob, 'Bob', MemberRole.member),
      ]);
    });

    test('change a member\'s role', () async {
      backend.stub(
        'PATCH /api/v1/lists/:id/members/:userId',
        fixture: 'message',
      );
      right(
        await lists.updateMemberRole(
          listId: listId,
          userId: bob,
          role: MemberRole.moderator,
        ),
      );
      expectRequest(
        'PATCH /api/v1/lists/:id/members/:userId',
        body: 'member_role_update',
      );
      expect(backend.last.uri.path, endsWith('/members/$bob'));
    });

    test('remove a member', () async {
      backend.stub(
        'DELETE /api/v1/lists/:id/members/:userId',
        fixture: 'message',
      );
      right(await lists.removeMember(listId: listId, userId: bob));
      expectRequest('DELETE /api/v1/lists/:id/members/:userId');
    });
  });

  group('invites', () {
    test('invite link is shared verbatim from the backend', () async {
      backend.stub('GET /api/v1/lists/:id/invite', fixture: 'invite_link');
      final link = right(await lists.getInviteLink(listId));
      expectRequest('GET /api/v1/lists/:id/invite');
      expect(link, 'rankapp://app/invite/$inviteToken');
      // The app routes invite links on their path.
      expect(Uri.parse(link).path, '/invite/$inviteToken');
    });

    test('regenerate', () async {
      backend.stub(
        'POST /api/v1/lists/:id/invite/regenerate',
        fixture: 'invite_link',
      );
      expect(right(await lists.regenerateInvite(listId)), inviteToken);
      expectRequest('POST /api/v1/lists/:id/invite/regenerate');
    });

    test('preview for a non-member', () async {
      backend.stub(
        'GET /api/v1/lists/invite/:token',
        fixture: 'invite_preview',
      );
      final preview = right(await lists.getInvitePreview(inviteToken));
      expectRequest('GET /api/v1/lists/invite/:token');
      expect(preview.title, 'Heaviest bench');
      expect(preview.isPublic, isFalse);
      expect(preview.memberCount, 12);
      expect(preview.currentUserRole, isNull);
      expect(preview.entries, isEmpty);
    });

    test('preview for an existing member', () async {
      backend.stub(
        'GET /api/v1/lists/invite/:token',
        fixture: 'invite_preview_member',
      );
      final preview = right(await lists.getInvitePreview(inviteToken));
      expect(preview.currentUserRole, MemberRole.member);
    });

    test('join by invite', () async {
      backend.stub(
        'POST /api/v1/lists/invite/:token/join',
        fixture: 'list_detail',
      );
      right(await lists.joinByInvite(inviteToken));
      expectRequest('POST /api/v1/lists/invite/:token/join');
    });
  });

  // ── Entries ──────────────────────────────────────────────────────

  group('entries', () {
    const route = 'PUT /api/v1/lists/:id/entries/me';

    for (final (name, input) in [
      (
        'entry_upsert_number',
        const EntryInput(valueNumber: 142.5, note: 'Bench press, paused'),
      ),
      ('entry_upsert_duration', const EntryInput(valueDurationMs: 1143000)),
      (
        'entry_upsert_text',
        const EntryInput(valueText: 'The Rise of Skywalker'),
      ),
    ]) {
      test('submit ($name) queues it for review', () async {
        backend.stub(route, fixture: 'submission_created', status: 201);
        final submission = right(
          await entries.submitEntry(listId: listId, input: input),
        );
        expectRequest(route, body: name);
        expect(submission.status, EntryStatus.pending);
        expect(submission.id, submissionId);
        expect(submission.userId, alice);
        expect(submission.valueNumber, 160.0);
        expect(submission.note, 'Paused, 3 sec');
        expect(submission.reviewedAt, isNull);
      });
    }

    test(
      'a locked board rejects with LIST_LOCKED and a readable message',
      () async {
        backend.stub(route, fixture: 'error', status: 403);
        final error = left(
          await entries.submitEntry(
            listId: listId,
            input: const EntryInput(valueNumber: 1),
          ),
        );
        expect(error.statusCode, 403);
        expect(error.code, ApiErrorCode.listLocked);
        expect(error.userMessage, 'this board is locked — no new entries');
      },
    );

    test('delete my own entry', () async {
      backend.stub('DELETE /api/v1/lists/:id/entries/me', fixture: 'message');
      right(await entries.deleteMyEntry(listId));
      expectRequest('DELETE /api/v1/lists/:id/entries/me');
    });

    test('admin deletes an entry on this board', () async {
      backend.stub(
        'DELETE /api/v1/lists/:id/entries/:entryId',
        fixture: 'message',
      );
      right(await lists.deleteEntry(listId: listId, entryId: entryA));
      expectRequest('DELETE /api/v1/lists/:id/entries/:entryId');
      expect(backend.last.uri.path, endsWith('/lists/$listId/entries/$entryA'));
    });

    test('admin reorders a text board (best first)', () async {
      backend.stub('PATCH /api/v1/lists/:id/entries/ranks', fixture: 'message');
      right(
        await lists.reorderEntries(
          listId: listId,
          orderedEntryIds: [entryB, entryA],
        ),
      );
      expectRequest(
        'PATCH /api/v1/lists/:id/entries/ranks',
        body: 'entry_ranks_update',
      );
    });
  });

  // ── Moderation ───────────────────────────────────────────────────

  group('moderation', () {
    test('review queue: who submitted what', () async {
      backend.stub(
        'GET /api/v1/lists/:id/submissions/pending',
        fixture: 'pending_submissions',
      );
      final queue = right(await entries.getPendingSubmissions(listId));
      expectRequest('GET /api/v1/lists/:id/submissions/pending');
      final submission = queue.single;
      expect(submission.id, submissionId);
      expect(submission.userId, bob);
      expect(submission.displayName, 'Bob');
      expect(submission.valueNumber, 150.0);
      expect(submission.note, 'New PR');
      expect(submission.status, EntryStatus.pending);
      expect(submission.submittedAt, DateTime.utc(2026, 1, 21, 12));
    });

    test('approve and reject by submission id', () async {
      backend
        ..stub(
          'POST /api/v1/lists/:id/submissions/:submissionId/approve',
          fixture: 'message',
        )
        ..stub(
          'POST /api/v1/lists/:id/submissions/:submissionId/reject',
          fixture: 'message',
        );
      right(
        await entries.approveSubmission(
          listId: listId,
          submissionId: submissionId,
        ),
      );
      expectRequest('POST /api/v1/lists/:id/submissions/:submissionId/approve');
      expect(backend.last.uri.path, contains('/submissions/$submissionId/'));
      right(
        await entries.rejectSubmission(
          listId: listId,
          submissionId: submissionId,
        ),
      );
      expectRequest('POST /api/v1/lists/:id/submissions/:submissionId/reject');
    });

    test('the board tells the viewer their submission was rejected', () async {
      backend.stub(
        'GET /api/v1/lists/:id',
        fixture: 'list_detail_rejected_submission',
      );
      final board = right(await lists.getListDetail(listId));
      expect(board.currentUserRole, MemberRole.member);
      expect(board.entries, hasLength(2));
      final mine = board.mySubmission!;
      expect(mine.id, submissionId);
      expect(mine.status, EntryStatus.rejected);
      expect(mine.valueNumber, 160.0);
      expect(mine.reviewedAt, DateTime.utc(2026, 2, 1, 18, 45));
    });
  });

  // ── Registry + coverage ──────────────────────────────────────────

  test('error-code registry matches the backend', () {
    expect(ApiErrorCode.all, contract.errorCodes);
  });

  test('routes the app skips still exist on the backend', () {
    final routes = contract.routes.map((r) => r.toString()).toSet();
    for (final route in routesNotUsedByApp.keys) {
      expect(
        routes,
        contains(route),
        reason: 'stale entry in routesNotUsedByApp',
      );
    }
  });

  // Runs after every test above — the contract must be fully exercised.
  tearDownAll(() {
    final problems = <String>[
      for (final r in contract.routes)
        if (!routesHit.contains('$r') && !routesNotUsedByApp.containsKey('$r'))
          'backend route "$r" is never called by the app — use it or add it to routesNotUsedByApp',
      for (final f in Contract.fixtureNames('responses'))
        if (!fixturesServed.contains(f))
          'response fixture "$f" is never parsed by a test',
      for (final f in Contract.fixtureNames('requests'))
        if (!requestFixturesChecked.contains(f))
          'request fixture "$f" is never compared with what the app sends',
    ];
    if (problems.isNotEmpty) {
      throw TestFailure(
        'API contract not fully covered:\n  ${problems.join('\n  ')}',
      );
    }
  });
}

/// The two-entry podium in the list fixtures: Alice (every optional field
/// set) ahead of Bob (none set).
void expectPodium(List<RankedEntry> podium) {
  expect(podium, hasLength(2));
  final first = podium[0];
  expect(first.id, entryA);
  expect(first.userId, alice);
  expect(first.displayName, 'Alice');
  expect(first.rank, 1);
  expect(first.previousRank, 2);
  expect(first.valueNumber, 142.5);
  expect(first.manualRank, 1);
  expect(first.note, 'Paused');
  expect(first.submittedAt, DateTime.utc(2026, 1, 20, 7, 5));

  final second = podium[1];
  expect(second.userId, bob);
  expect(second.rank, 2);
  expect(second.valueNumber, 100.0);
  expect(second.previousRank, isNull);
  expect(second.manualRank, isNull);
  expect(second.note, isNull);
}
