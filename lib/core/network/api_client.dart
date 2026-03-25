import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
<<<<<<< HEAD
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import '../constants/app_constants.dart';
import 'auth_interceptor.dart';
=======
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
>>>>>>> 88d3438 (good progress)

import 'auth_interceptor.dart';

/// Dio instance factory — configured with interceptors and base options
class ApiClient {
<<<<<<< HEAD
  late final Dio dio;
  late final Dio refreshDio;

  ApiClient({required FlutterSecureStorage secureStorage}) {
    // Separate Dio instance for refresh calls (no auth interceptor — avoids loop)
    refreshDio = Dio(
      BaseOptions(
        baseUrl: AppConstants.apiBaseUrl,
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 30),
        contentType: Headers.jsonContentType,
      ),
    );

    dio = Dio(
      BaseOptions(
        baseUrl: AppConstants.apiBaseUrl,
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 30),
=======
  // TODO: Move to environment config
  static const String _baseUrl = 'https://api.example.com';

  late final Dio dio;

  ApiClient() {
    dio = Dio(
      BaseOptions(
        baseUrl: _baseUrl,
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 30),
        sendTimeout: const Duration(seconds: 30),
>>>>>>> 88d3438 (good progress)
        contentType: Headers.jsonContentType,
      ),
    );

<<<<<<< HEAD
    dio.interceptors.add(
      AuthInterceptor(
        dio: dio,
        refreshDio: refreshDio,
        secureStorage: secureStorage,
      ),
    );

=======
    // Auth interceptor for JWT attachment and 401 refresh
    dio.interceptors.add(AuthInterceptor());

    // Pretty logger for debug builds only
>>>>>>> 88d3438 (good progress)
    if (kDebugMode) {
      dio.interceptors.add(
        PrettyDioLogger(
          requestHeader: true,
          requestBody: true,
          responseBody: true,
          responseHeader: false,
          error: true,
          compact: true,
<<<<<<< HEAD
=======
          maxWidth: 90,
>>>>>>> 88d3438 (good progress)
        ),
      );
    }
  }
}
