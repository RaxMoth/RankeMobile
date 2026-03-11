// JWT attach + 401 → refresh + retry
import 'package:dio/dio.dart';

class AuthInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    // Attach JWT here
    super.onRequest(options, handler);
  }

  @override
  void onError(DioError err, ErrorInterceptorHandler handler) {
    // Handle 401, refresh token, retry
    super.onError(err, handler);
  }
}
