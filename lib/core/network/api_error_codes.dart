/// Every `error.code` the backend can put in an error envelope.
///
/// Mirrors RankeBE `handler.ErrorCodes`; `test/contract` fails if this set
/// and the backend's `contract/error_codes.json` ever differ. Branch on
/// these constants — never on the (human-readable) message.
abstract class ApiErrorCode {
  static const validationError = 'VALIDATION_ERROR';
  static const invalidValueType = 'INVALID_VALUE_TYPE';
  static const unauthorized = 'UNAUTHORIZED';
  static const forbidden = 'FORBIDDEN';
  static const notFound = 'NOT_FOUND';
  static const listNotFound = 'LIST_NOT_FOUND';
  static const listLocked = 'LIST_LOCKED';
  static const internalError = 'INTERNAL_ERROR';
  static const emailTaken = 'EMAIL_TAKEN';
  static const rateLimited = 'RATE_LIMITED';

  static const all = {
    validationError,
    invalidValueType,
    unauthorized,
    forbidden,
    notFound,
    listNotFound,
    listLocked,
    internalError,
    emailTaken,
    rateLimited,
  };
}
