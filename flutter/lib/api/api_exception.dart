/// The transport error vocabulary, mirroring `server/internal/apierr`.
///
/// Every JSON endpoint answers with one of two envelopes:
///
/// ```json
/// {"ok": true,  "data": <payload>}
/// {"ok": false, "error": {"code": "...", "message": "..."}}
/// ```
///
/// `ApiClient` unwraps the success envelope and turns the failure envelope into
/// an [ApiException], so no page ever inspects `ok` itself.
library;

/// Machine readable error codes, exactly as the server spells them.
///
/// The set is deliberately small and stable; `switch` on these rather than on
/// the human readable message.
abstract final class ApiErrorCode {
  static const String unauthorized = 'unauthorized';
  static const String forbidden = 'forbidden';
  static const String notFound = 'not_found';
  static const String validationFailed = 'validation_failed';
  static const String conflict = 'conflict';
  static const String rateLimited = 'rate_limited';
  static const String insufficientBalance = 'insufficient_balance';
  static const String invalidKey = 'invalid_key';
  static const String alreadyPaid = 'already_paid';
  static const String pteError = 'pte_error';
  static const String internalError = 'internal_error';

  /// Produced by the client, never by the server: the request never completed,
  /// so there is no envelope to read.
  static const String networkError = 'network_error';

  /// Produced by the client when a 2xx body is not a valid envelope.
  static const String malformedResponse = 'malformed_response';
}

/// Thrown for every failure that reaches the UI.
class ApiException implements Exception {
  const ApiException({
    required this.code,
    required this.message,
    this.statusCode,
  });

  /// One of [ApiErrorCode].
  final String code;

  /// The server's user facing message, or a client-side description when the
  /// request never reached the server.
  final String message;

  /// The HTTP status, when there was a response.
  final int? statusCode;

  /// True when the session is gone and the app must return to `/login`.
  ///
  /// The server answers `401` for a missing, malformed, blacklisted or
  /// user-deleted token, so this single check covers every case.
  bool get isUnauthorized =>
      statusCode == 401 || code == ApiErrorCode.unauthorized;

  bool get isForbidden => statusCode == 403 || code == ApiErrorCode.forbidden;

  bool get isNotFound => statusCode == 404 || code == ApiErrorCode.notFound;

  bool get isRateLimited => code == ApiErrorCode.rateLimited;

  /// True when the caller could reasonably retry after fixing their input.
  bool get isUserFixable =>
      code == ApiErrorCode.validationFailed ||
      code == ApiErrorCode.invalidKey ||
      code == ApiErrorCode.insufficientBalance ||
      code == ApiErrorCode.conflict ||
      code == ApiErrorCode.alreadyPaid;

  @override
  String toString() => 'ApiException($code, $statusCode): $message';
}
