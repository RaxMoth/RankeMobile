import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:get_it/get_it.dart';

import 'package:ranke_mobile/core/network/api_client.dart';
import 'package:ranke_mobile/core/network/api_error.dart';
import 'package:ranke_mobile/features/lists/data/lists_remote_data_source.dart';
import 'package:ranke_mobile/features/lists/domain/entities/public_lists_page.dart';
import 'package:ranke_mobile/features/lists/domain/entities/ranked_list.dart';
import 'package:ranke_mobile/features/lists/domain/lists_repository.dart';
import 'package:ranke_mobile/features/lists/domain/use_cases/search_public_lists_use_case.dart';
import 'package:ranke_mobile/features/lists/presentation/providers/discover_provider.dart';

ListSummary _board(String id) => ListSummary(
  id: id,
  title: 'Board $id',
  valueType: ValueType.number,
  rankOrder: RankOrder.desc,
  isPublic: true,
  memberCount: 1,
);

typedef _Response = Completer<Either<ApiError, PublicListsPage>>;

/// Records every call and pairs calls with responses in FIFO order, whichever
/// arrives first — the provider fetches page 1 as soon as it's listened to,
/// before a test gets to queue an answer. Holding a response open simulates
/// a slow network.
class _FakeRepo implements ListsRepository {
  final calls = <({String? query, String? cursor})>[];
  final _answered = <_Response>[]; // answers waiting for a call
  final _waiting = <_Response>[]; // calls waiting for an answer

  _Response next() {
    if (_waiting.isNotEmpty) return _waiting.removeAt(0);
    final c = _Response();
    _answered.add(c);
    return c;
  }

  void answer(List<String> ids, {String? cursor}) => next().complete(
    Right(PublicListsPage(items: ids.map(_board).toList(), nextCursor: cursor)),
  );

  @override
  Future<Either<ApiError, PublicListsPage>> searchPublicLists({
    String? query,
    String? category,
    String? cursor,
    int? limit,
  }) {
    calls.add((query: query, cursor: cursor));
    if (_answered.isNotEmpty) return _answered.removeAt(0).future;
    final c = _Response();
    _waiting.add(c);
    return c.future;
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

void main() {
  group('DiscoverNotifier pagination', () {
    late _FakeRepo repo;
    late ProviderContainer container;

    setUp(() {
      repo = _FakeRepo();
      GetIt.instance.registerSingleton<SearchPublicListsUseCase>(
        SearchPublicListsUseCase(repo),
      );
      container = ProviderContainer();
      // autoDispose providers need a listener to stay alive between reads.
      container.listen(discoverResultsProvider, (_, _) {});
    });

    tearDown(() async {
      container.dispose();
      await GetIt.instance.reset();
    });

    DiscoverState state() =>
        container.read(discoverResultsProvider).requireValue;
    DiscoverNotifier notifier() =>
        container.read(discoverResultsProvider.notifier);

    test('appends pages using the cursor until the last page', () async {
      repo.answer(['a', 'b'], cursor: 'c1');
      await container.read(discoverResultsProvider.future);
      expect(state().items.map((s) => s.id), ['a', 'b']);
      expect(state().hasMore, isTrue);

      repo.answer(['c', 'd']);
      await notifier().loadMore();

      expect(repo.calls.last.cursor, 'c1');
      expect(state().items.map((s) => s.id), ['a', 'b', 'c', 'd']);
      expect(state().hasMore, isFalse);

      await notifier().loadMore(); // no more pages → no request
      expect(repo.calls, hasLength(2));
    });

    test('concurrent loadMore calls issue a single request', () async {
      repo.answer(['a'], cursor: 'c1');
      await container.read(discoverResultsProvider.future);

      final pending = repo.next();
      final first = notifier().loadMore();
      final second = notifier().loadMore();
      expect(state().isLoadingMore, isTrue);
      pending.complete(Right(PublicListsPage(items: [_board('b')])));
      await Future.wait([first, second]);

      expect(repo.calls, hasLength(2));
      expect(state().items.map((s) => s.id), ['a', 'b']);
    });

    test('a failed page keeps earlier results and can be retried', () async {
      repo.answer(['a'], cursor: 'c1');
      await container.read(discoverResultsProvider.future);

      repo.next().complete(const Left(ApiNetworkError()));
      await notifier().loadMore();
      expect(state().items.map((s) => s.id), ['a']);
      expect(state().loadMoreError, isA<ApiNetworkError>());
      expect(state().hasMore, isTrue);

      repo.answer(['b']);
      await notifier().loadMore();
      expect(state().loadMoreError, isNull);
      expect(state().items.map((s) => s.id), ['a', 'b']);
    });

    test('drops duplicate boards across pages', () async {
      repo.answer(['a', 'b'], cursor: 'c1');
      await container.read(discoverResultsProvider.future);

      repo.answer(['b', 'c']);
      await notifier().loadMore();
      expect(state().items.map((s) => s.id), ['a', 'b', 'c']);
    });

    test('a page for a superseded search is discarded', () async {
      repo.answer(['old1'], cursor: 'c1');
      await container.read(discoverResultsProvider.future);

      final slowPage = repo.next();
      final loading = notifier().loadMore();

      // User types a new query while page 2 of the old search is in flight.
      repo.answer(['new1']);
      container.read(discoverQueryProvider.notifier).state = 'new';
      await container.read(discoverResultsProvider.future);

      slowPage.complete(Right(PublicListsPage(items: [_board('old2')])));
      await loading;

      expect(state().items.map((s) => s.id), ['new1']);
      expect(repo.calls.last.query, 'new');
    });
  });

  group('ListsRemoteDataSource.searchPublicLists', () {
    Future<({List<dynamic> items, String? nextCursor})> fetch(
      Map<String, List<String>> headers, {
      String? cursor,
      void Function(RequestOptions)? onRequest,
    }) {
      final client = ApiClient();
      client.dio.interceptors.clear(); // no auth / logging in unit tests
      client.dio.httpClientAdapter = _StubAdapter(
        body: {
          'data': [
            {'id': 'x'},
          ],
        },
        headers: headers,
        onRequest: onRequest,
      );
      return ListsRemoteDataSourceImpl(
        client,
      ).searchPublicLists(cursor: cursor);
    }

    test('reads the cursor from X-Next-Cursor', () async {
      final page = await fetch({
        'x-next-cursor': ['abc123'],
      });
      expect(page.items, hasLength(1));
      expect(page.nextCursor, 'abc123');
    });

    test('null cursor when the header is absent', () async {
      final page = await fetch({});
      expect(page.nextCursor, isNull);
    });

    test('sends the cursor as a query parameter', () async {
      late RequestOptions sent;
      await fetch({}, cursor: 'abc123', onRequest: (o) => sent = o);
      expect(sent.queryParameters['cursor'], 'abc123');
    });
  });
}

class _StubAdapter implements HttpClientAdapter {
  final Object body;
  final Map<String, List<String>> headers;
  final void Function(RequestOptions)? onRequest;

  _StubAdapter({required this.body, required this.headers, this.onRequest});

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) async {
    onRequest?.call(options);
    return ResponseBody.fromString(
      jsonEncode(body),
      200,
      headers: {
        Headers.contentTypeHeader: [Headers.jsonContentType],
        ...headers,
      },
    );
  }

  @override
  void close({bool force = false}) {}
}
