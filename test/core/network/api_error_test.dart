import 'package:flutter_test/flutter_test.dart';

import 'package:ranke_mobile/core/network/api_error.dart';
import 'package:ranke_mobile/core/network/api_error_codes.dart';
import 'package:ranke_mobile/core/strings.dart';

ApiServerError server(String code, [String message = 'server says']) =>
    ApiServerError(code: code, message: message, statusCode: 400);

void main() {
  group('userMessage', () {
    test('known codes show the backend message, written for users', () {
      expect(
        server(
          ApiErrorCode.validationError,
          'password must be at least 8 characters',
        ).userMessage,
        'password must be at least 8 characters',
      );
      expect(server(ApiErrorCode.emailTaken).userMessage, 'server says');
    });

    test('internal errors and rate limits use app copy', () {
      expect(server(ApiErrorCode.internalError).userMessage, S.genericError);
      expect(server(ApiErrorCode.rateLimited).userMessage, S.rateLimited);
    });

    test('anything outside the contract never leaks to the UI', () {
      // e.g. a proxy's HTML 502, or Dio's own exception text.
      expect(
        server('HTTP_502', 'DioException [bad response]: ...').userMessage,
        S.genericError,
      );
      expect(server(ApiErrorCode.forbidden, '').userMessage, S.genericError);
      expect(
        const ApiUnknownError(error: 'FormatException').userMessage,
        S.genericError,
      );
      expect(const ApiNetworkError().userMessage, S.noNetwork);
    });
  });

  test('describeError hides non-API exceptions', () {
    expect(describeError(server(ApiErrorCode.listLocked, 'locked')), 'locked');
    expect(describeError(StateError('boom')), S.genericError);
    expect(S.failed(StateError('boom')), 'FAILED: ${S.genericError}');
  });
}
