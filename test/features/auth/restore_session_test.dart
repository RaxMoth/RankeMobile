import 'dart:convert';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';

import 'package:ranke_mobile/core/constants/app_constants.dart';
import 'package:ranke_mobile/core/network/api_client.dart';
import 'package:ranke_mobile/core/network/api_error.dart';
import 'package:ranke_mobile/core/network/auth_interceptor.dart';
import 'package:ranke_mobile/features/auth/data/auth_remote_data_source.dart';
import 'package:ranke_mobile/features/auth/data/auth_repository_impl.dart';

/// Answers every request with [respond], counting calls.
class _Backend implements HttpClientAdapter {
  _Backend(this.respond);

  final Future<ResponseBody> Function(RequestOptions) respond;
  int calls = 0;

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) {
    calls++;
    return respond(options);
  }

  @override
  void close({bool force = false}) {}
}

ResponseBody _json(int status, Object body) => ResponseBody.fromString(
  jsonEncode(body),
  status,
  headers: {
    Headers.contentTypeHeader: [Headers.jsonContentType],
  },
);

const _cachedUser =
    '{"id":"u1","email":"a@example.com","displayName":"Ann","createdAt":"2026-01-15T09:30:00.000Z"}';

void main() {
  const storage = FlutterSecureStorage();

  AuthRepositoryImpl repoWith(_Backend backend) {
    final client = ApiClient(
      httpClientAdapter: backend,
      logRequests: false,
      authInterceptor: AuthInterceptor(
        storage: storage,
        refreshDio: Dio()..httpClientAdapter = backend,
      ),
    );
    return AuthRepositoryImpl(
      AuthRemoteDataSourceImpl(client),
      storage: storage,
    );
  }

  test('no stored session → signed out, no network call', () async {
    FlutterSecureStorage.setMockInitialValues({});
    final backend = _Backend((_) async => _json(500, {}));

    expect(
      await repoWith(backend).restoreSession(),
      const Right<ApiError, Null>(null),
    );
    expect(backend.calls, 0);
  });

  test('a session the backend rejects is cleared', () async {
    FlutterSecureStorage.setMockInitialValues({
      AppConstants.accessTokenKey: 'revoked',
      AppConstants.refreshTokenKey: 'revoked-refresh',
      AppConstants.userDataKey: _cachedUser,
    });
    const unauthorized = {
      'error': {'code': 'UNAUTHORIZED', 'message': 'invalid refresh token'},
    };
    final backend = _Backend((_) async => _json(401, unauthorized));

    final result = await repoWith(backend).restoreSession();

    expect(result.getOrElse((_) => throw TestFailure('$result')), isNull);
    expect(await storage.read(key: AppConstants.accessTokenKey), isNull);
    expect(await storage.read(key: AppConstants.userDataKey), isNull);
  });

  test(
    'offline launch resumes with the cached user and keeps the tokens',
    () async {
      FlutterSecureStorage.setMockInitialValues({
        AppConstants.accessTokenKey: 'access',
        AppConstants.refreshTokenKey: 'refresh',
        AppConstants.userDataKey: _cachedUser,
      });
      final backend = _Backend(
        (options) async => throw DioException.connectionError(
          requestOptions: options,
          reason: 'offline',
        ),
      );

      final user = (await repoWith(backend).restoreSession()).getOrElse(
        (e) => throw TestFailure('expected cached user, got $e'),
      );

      expect(user?.id, 'u1');
      expect(user?.displayName, 'Ann');
      expect(await storage.read(key: AppConstants.accessTokenKey), 'access');
    },
  );

  test('offline without a cached user reports the network error', () async {
    FlutterSecureStorage.setMockInitialValues({
      AppConstants.accessTokenKey: 'access',
    });
    final backend = _Backend(
      (options) async => throw DioException.connectionError(
        requestOptions: options,
        reason: 'offline',
      ),
    );

    final result = await repoWith(backend).restoreSession();

    expect(result.getLeft().toNullable(), isA<ApiNetworkError>());
  });
}
