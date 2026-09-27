import 'dart:convert';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:ranke_mobile/core/constants/app_constants.dart';
import 'package:ranke_mobile/core/network/auth_interceptor.dart';

/// Backend stand-in: `/api/v1/lists` accepts only [validToken];
/// `/api/v1/auth/refresh` rotates to it (or fails when [refreshFails]).
class _Backend implements HttpClientAdapter {
  String validToken = 'fresh-access';
  bool refreshFails = false;
  int refreshCalls = 0;
  final authorizations = <String?>[];

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) async {
    ResponseBody json(int status, Object body) => ResponseBody.fromString(
      jsonEncode(body),
      status,
      headers: {
        Headers.contentTypeHeader: [Headers.jsonContentType],
      },
    );
    const unauthorized = {
      'error': {'code': 'UNAUTHORIZED', 'message': 'invalid or expired token'},
    };

    switch (options.path) {
      case '/api/v1/auth/refresh':
        refreshCalls++;
        // Slow enough for concurrent 401s to pile up behind the mutex.
        await Future<void>.delayed(const Duration(milliseconds: 20));
        if (refreshFails) return json(401, unauthorized);
        return json(200, {
          'data': {
            'accessToken': validToken,
            'refreshToken': 'rotated-refresh',
            'expiresIn': 900,
          },
        });
      case '/api/v1/auth/login':
        return json(401, unauthorized);
      default:
        final auth = options.headers['Authorization'] as String?;
        authorizations.add(auth);
        return auth == 'Bearer $validToken'
            ? json(200, {'data': <Object>[]})
            : json(401, unauthorized);
    }
  }

  @override
  void close({bool force = false}) {}
}

void main() {
  late _Backend backend;
  late Dio dio;
  late int expiredEvents;
  const storage = FlutterSecureStorage();

  setUp(() {
    FlutterSecureStorage.setMockInitialValues({
      AppConstants.accessTokenKey: 'stale-access',
      AppConstants.refreshTokenKey: 'current-refresh',
    });
    backend = _Backend();
    expiredEvents = 0;
    dio = Dio()..httpClientAdapter = backend;
    dio.interceptors.add(
      AuthInterceptor(
        storage: storage,
        refreshDio: Dio()..httpClientAdapter = backend,
        onSessionExpired: () => expiredEvents++,
      ),
    );
  });

  test('an expired token is refreshed and the request retried', () async {
    final response = await dio.get<dynamic>('/api/v1/lists');

    expect(response.statusCode, 200);
    expect(backend.refreshCalls, 1);
    expect(backend.authorizations, [
      'Bearer stale-access',
      'Bearer fresh-access',
    ]);
    expect(
      await storage.read(key: AppConstants.accessTokenKey),
      'fresh-access',
    );
    expect(
      await storage.read(key: AppConstants.refreshTokenKey),
      'rotated-refresh',
    );
  });

  test('concurrent 401s share a single refresh', () async {
    // The backend treats reuse of a rotated refresh token as theft and
    // revokes the whole session, so a second refresh would sign the user
    // out everywhere.
    final responses = await Future.wait([
      dio.get<dynamic>('/api/v1/lists'),
      dio.get<dynamic>('/api/v1/lists'),
      dio.get<dynamic>('/api/v1/lists'),
    ]);

    expect(responses.map((r) => r.statusCode), [200, 200, 200]);
    expect(backend.refreshCalls, 1);
    expect(expiredEvents, 0);
  });

  test(
    'a 401 from an auth endpoint is an answer, not an expired session',
    () async {
      await expectLater(
        dio.post<dynamic>('/api/v1/auth/login', data: {'email': 'a@b.co'}),
        throwsA(
          isA<DioException>().having(
            (e) => e.response?.statusCode,
            'status',
            401,
          ),
        ),
      );
      expect(backend.refreshCalls, 0);
      expect(expiredEvents, 0);
      expect(
        await storage.read(key: AppConstants.refreshTokenKey),
        'current-refresh',
      );
    },
  );

  test('a failed refresh ends the session once', () async {
    backend.refreshFails = true;

    await expectLater(
      dio.get<dynamic>('/api/v1/lists'),
      throwsA(
        isA<DioException>().having(
          (e) => e.response?.statusCode,
          'status',
          401,
        ),
      ),
    );
    expect(expiredEvents, 1);
    expect(await storage.read(key: AppConstants.accessTokenKey), isNull);
    expect(await storage.read(key: AppConstants.refreshTokenKey), isNull);
  });

  test(
    'without a refresh token the session ends without calling refresh',
    () async {
      FlutterSecureStorage.setMockInitialValues({
        AppConstants.accessTokenKey: 'stale-access',
      });

      await expectLater(
        dio.get<dynamic>('/api/v1/lists'),
        throwsA(isA<DioException>()),
      );
      expect(backend.refreshCalls, 0);
      expect(expiredEvents, 1);
    },
  );
}
