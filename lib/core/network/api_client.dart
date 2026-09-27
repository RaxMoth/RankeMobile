import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

import '../constants/app_constants.dart';
import 'auth_interceptor.dart';

/// Dio instance factory — configured with interceptors and base options.
///
/// [authInterceptor] and [httpClientAdapter] are injectable so tests can
/// run the real request pipeline against a fake backend.
class ApiClient {
  late final Dio dio;

  ApiClient({
    AuthInterceptor? authInterceptor,
    HttpClientAdapter? httpClientAdapter,
    bool logRequests = kDebugMode,
  }) {
    dio = Dio(
      BaseOptions(
        baseUrl: AppConstants.apiBaseUrl,
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 30),
        sendTimeout: const Duration(seconds: 30),
        contentType: Headers.jsonContentType,
      ),
    );
    if (httpClientAdapter != null) dio.httpClientAdapter = httpClientAdapter;

    // Auth interceptor for JWT attachment and 401 refresh
    dio.interceptors.add(authInterceptor ?? AuthInterceptor());

    // Pretty logger for debug builds only
    if (logRequests) {
      dio.interceptors.add(
        PrettyDioLogger(
          requestHeader: true,
          requestBody: true,
          responseBody: true,
          responseHeader: false,
          error: true,
          compact: true,
          maxWidth: 90,
        ),
      );
    }
  }
}
