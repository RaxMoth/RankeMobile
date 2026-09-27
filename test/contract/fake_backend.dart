import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';

/// The backend's API contract (synced from RankeBE/contract by
/// `tool/sync_contract.sh`): its route table, error codes and the JSON
/// fixtures generated from its real DTOs.
class Contract {
  static const dir = 'test/contract/fixtures';

  final List<Route> routes;
  final Set<String> errorCodes;

  Contract._(this.routes, this.errorCodes);

  factory Contract.load() => Contract._(
    [
      for (final r in _readJson('routes.json') as List<dynamic>)
        Route.parse(r as String),
    ],
    {
      for (final c in _readJson('error_codes.json') as List<dynamic>)
        c as String,
    },
  );

  /// The decoded response fixture `responses/<name>.json`.
  Object? response(String name) => _readJson('responses/$name.json');

  /// The decoded request fixture `requests/<name>.json` — the exact body
  /// the backend expects for that call.
  Object? request(String name) => _readJson('requests/$name.json');

  static List<String> fixtureNames(String subdir) =>
      (Directory('$dir/$subdir').listSync().whereType<File>().map(
        (f) => f.uri.pathSegments.last.replaceAll('.json', ''),
      )).toList()..sort();

  /// Resolves a concrete request to the backend route that would serve it,
  /// the way gin does: same method and segment count, static segments must
  /// match exactly and win over `:params`.
  Route? resolve(String method, String path) {
    final segments = _segments(path);
    Route? best;
    var bestStatic = -1;
    for (final route in routes) {
      if (route.method != method || route.segments.length != segments.length) {
        continue;
      }
      var statics = 0;
      var matches = true;
      for (var i = 0; i < segments.length; i++) {
        final s = route.segments[i];
        if (s.startsWith(':')) continue;
        if (s != segments[i]) {
          matches = false;
          break;
        }
        statics++;
      }
      if (matches && statics > bestStatic) {
        best = route;
        bestStatic = statics;
      }
    }
    return best;
  }

  static Object? _readJson(String relPath) {
    final file = File('$dir/$relPath');
    if (!file.existsSync()) {
      throw TestFailure(
        'Missing contract fixture $dir/$relPath — run tool/sync_contract.sh',
      );
    }
    return jsonDecode(file.readAsStringSync());
  }
}

/// One `METHOD /path` entry of routes.json.
class Route {
  final String method;
  final String path;
  final List<String> segments;

  Route(this.method, this.path) : segments = _segments(path);

  factory Route.parse(String line) {
    final [method, path] = line.split(' ');
    return Route(method, path);
  }

  @override
  String toString() => '$method $path';
}

List<String> _segments(String path) =>
    path.split('/').where((s) => s.isNotEmpty).toList();

/// A request the app sent, as the backend received it.
class RecordedRequest {
  final Route route;
  final Uri uri;
  final Object? body;
  final String? authorization;

  RecordedRequest(this.route, this.uri, this.body, this.authorization);
}

class _Reply {
  final int status;
  final String? fixture;
  final Object? json;
  final Map<String, String> headers;

  _Reply(this.status, this.fixture, this.json, this.headers);
}

/// An in-process stand-in for RankeBE, plugged into Dio as its
/// [HttpClientAdapter] so the app's real stack (ApiClient, AuthInterceptor,
/// data sources, repositories) runs end to end.
///
/// It only answers routes that exist in routes.json — a request to a path
/// or method the backend doesn't serve fails the test — and it replies with
/// the backend-generated response fixtures.
class FakeBackend implements HttpClientAdapter {
  final Contract contract;
  final requests = <RecordedRequest>[];
  final _replies = <String, List<_Reply>>{};

  /// Every route hit and every response fixture served, across the test.
  final routesHit = <String>{};
  final fixturesServed = <String>{};

  FakeBackend(this.contract);

  /// Answers [route] (as written in routes.json, e.g.
  /// `GET /api/v1/lists/:id`) with a response fixture or inline [json].
  /// Stub a route several times to answer successive calls in order; the
  /// last reply repeats.
  void stub(
    String route, {
    String? fixture,
    Object? json,
    int status = 200,
    Map<String, String> headers = const {},
  }) {
    if (!contract.routes.any((r) => r.toString() == route)) {
      throw TestFailure('Stubbed route "$route" is not in routes.json');
    }
    _replies
        .putIfAbsent(route, () => [])
        .add(_Reply(status, fixture, json, headers));
  }

  RecordedRequest get last {
    if (requests.isEmpty) throw TestFailure('No request reached the backend');
    return requests.last;
  }

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) async {
    final uri = options.uri;
    final route = contract.resolve(options.method, uri.path);
    if (route == null) {
      throw TestFailure(
        'The app called ${options.method} ${uri.path}, which the backend '
        'does not serve (not in routes.json).',
      );
    }

    Object? body;
    if (requestStream != null) {
      final bytes = await requestStream.fold<List<int>>(
        [],
        (acc, chunk) => acc..addAll(chunk),
      );
      if (bytes.isNotEmpty) body = jsonDecode(utf8.decode(bytes));
    }
    requests.add(
      RecordedRequest(
        route,
        uri,
        body,
        options.headers['Authorization'] as String?,
      ),
    );
    routesHit.add(route.toString());

    final queue = _replies[route.toString()];
    if (queue == null || queue.isEmpty) {
      throw TestFailure('No stub for $route (called as ${uri.path})');
    }
    final reply = queue.length > 1 ? queue.removeAt(0) : queue.first;
    if (reply.fixture != null) fixturesServed.add(reply.fixture!);
    final payload = reply.fixture != null
        ? contract.response(reply.fixture!)
        : reply.json;

    return ResponseBody.fromString(
      jsonEncode(payload),
      reply.status,
      headers: {
        Headers.contentTypeHeader: [Headers.jsonContentType],
        for (final h in reply.headers.entries) h.key: [h.value],
      },
    );
  }

  @override
  void close({bool force = false}) {}
}
