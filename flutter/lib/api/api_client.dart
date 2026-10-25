/// The single HTTP entry point of the app.
///
/// Every JSON endpoint is wrapped in the same envelope, so exactly one place
/// needs to know about it: [ApiClient] unwraps the success case and turns the
/// failure case into an [ApiException]. Pages therefore receive plain decoded
/// payloads and only deal with errors they can act on.
///
/// The base URL is deliberately relative (`/api/v1`). The Go binary serves both
/// the API and this bundle from one origin, so there is no CORS negotiation and
/// no host to configure.
library;

import 'dart:convert';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:dio_web_adapter/dio_web_adapter.dart';

import 'api_exception.dart';
import 'token_store.dart';

/// Calls the peo REST API.
class ApiClient {
  ApiClient({required this.tokenStore, String baseUrl = '/api/v1', Dio? dio})
    : dio = dio ?? Dio() {
    this.dio.options
      ..baseUrl = baseUrl
      ..connectTimeout = const Duration(seconds: 15)
      ..receiveTimeout = const Duration(seconds: 30)
      ..sendTimeout = const Duration(seconds: 30)
      // Responses are inspected by hand: a failure envelope carries the reason
      // in its body, and Dio's default "throw on non-2xx" would discard it.
      ..validateStatus = (_) => true;

    final adapter = this.dio.httpClientAdapter;
    if (adapter is BrowserHttpClientAdapter) {
      // The Go API handles OPTIONS preflight. Keep the browser preflight itself,
      // but avoid Dio's repetitive warning for each Authorization request.
      adapter.enableCORSWarning = false;
    }

    this.dio.options.headers['Accept'] = 'application/json';

    this.dio.interceptors.add(
      InterceptorsWrapper(onRequest: _attachToken, onError: _mapDioError),
    );
  }

  /// Supplied by the app so a rejected token drops the session everywhere. It
  /// is a callback rather than a direct dependency so the client stays unaware
  /// of the state layer, which sits above it.
  Future<void> Function()? onUnauthorized;

  final TokenStore tokenStore;
  final Dio dio;

  /// Called after the server has answered `401` and the token was cleared.
  /// Calling it exactly once per rejected request is enough: the guard that
  /// navigates is idempotent.
  Future<void> _attachToken(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    // Dio's Web adapter warns when sendTimeout is set on a request without a
    // body. Keep the timeout for uploads, where the adapter can apply it.
    if (options.data == null) {
      options.sendTimeout = null;
    }

    if (options.extra['anonymous'] != true) {
      final token = await tokenStore.read();
      if (token != null && token.isNotEmpty) {
        options.headers['Authorization'] = 'Bearer $token';
      }
    }
    handler.next(options);
  }

  void _mapDioError(DioException err, ErrorInterceptorHandler handler) {
    // A transport failure has no envelope to read, so it is reported as a
    // client-side code and the UI shows the network message.
    handler.reject(
      DioException(
        requestOptions: err.requestOptions,
        response: err.response,
        type: err.type,
        error: ApiException(
          code: ApiErrorCode.networkError,
          message: _networkMessage(err),
        ),
      ),
    );
  }

  static String _networkMessage(DioException err) {
    switch (err.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
      case DioExceptionType.transformTimeout:
        return 'The server took too long to answer. Please try again.';
      case DioExceptionType.connectionError:
        return 'Cannot reach the server. Check your connection.';
      case DioExceptionType.badCertificate:
        return 'The server certificate could not be verified.';
      case DioExceptionType.cancel:
        return 'The request was cancelled.';
      case DioExceptionType.badResponse:
      case DioExceptionType.unknown:
        return 'The request could not be completed.';
    }
  }

  /// Reads the envelope, returning its `data` member.
  ///
  /// On failure it throws [ApiException]. A `401` additionally clears the token
  /// and notifies [onUnauthorized], which is what moves the app back to the
  /// login page from anywhere.
  Future<Object?> _unwrap(Response<dynamic> res) async {
    final body = res.data;
    if (body is! Map) {
      throw ApiException(
        code: ApiErrorCode.malformedResponse,
        message: 'The server returned an unexpected response.',
        statusCode: res.statusCode,
      );
    }

    if (body['ok'] == true) {
      return body['data'];
    }

    final detail = body['error'];
    final code = (detail is Map && detail['code'] is String)
        ? detail['code'] as String
        : ApiErrorCode.internalError;
    final message = (detail is Map && detail['message'] is String)
        ? detail['message'] as String
        : 'The request failed.';

    final ex = ApiException(
      code: code,
      message: message,
      statusCode: res.statusCode,
    );
    if (ex.isUnauthorized) {
      await tokenStore.clear();
      final notify = onUnauthorized;
      if (notify != null) await notify();
    }
    throw ex;
  }

  Future<Response<dynamic>> _send(
    String method,
    String path, {
    Object? data,
    Map<String, dynamic>? query,
    bool anonymous = false,
    ResponseType? responseType,
  }) {
    return dio.request<dynamic>(
      path,
      data: data,
      queryParameters: query,
      options: Options(
        method: method,
        responseType: responseType,
        extra: anonymous ? const {'anonymous': true} : null,
      ),
    );
  }

  Future<DownloadedFile> downloadBytes(
    String path,
    Map<String, dynamic> query, {
    required CancelToken cancelToken,
    required ProgressCallback onProgress,
  }) async {
    try {
      final response = await dio.get<List<int>>(
        path,
        queryParameters: query,
        cancelToken: cancelToken,
        onReceiveProgress: onProgress,
        options: Options(responseType: ResponseType.bytes),
      );
      final bytes = response.data ?? const <int>[];
      if ((response.statusCode ?? 500) >= 400) {
        final payload = jsonDecode(utf8.decode(bytes));
        await _unwrap(
          Response<dynamic>(
            requestOptions: response.requestOptions,
            statusCode: response.statusCode,
            data: payload,
            headers: response.headers,
          ),
        );
      }
      final disposition = response.headers.value('content-disposition') ?? '';
      final filename = _contentDispositionFilename(disposition);
      return DownloadedFile(
        bytes,
        filename ?? _requestedBasename(query['file']) ?? 'download',
        response.headers.value('content-type') ?? 'application/octet-stream',
      );
    } on DioException catch (error) {
      throw _asApiException(error);
    }
  }

  static String? _contentDispositionFilename(String value) {
    final extended = RegExp(
      r"(?:^|;)\s*filename\*\s*=\s*UTF-8'[^']*'([^;]+)",
      caseSensitive: false,
    ).firstMatch(value);
    if (extended != null) {
      var encoded = extended.group(1)!.trim();
      if (encoded.startsWith('"') && encoded.endsWith('"')) {
        encoded = encoded.substring(1, encoded.length - 1);
      }
      try {
        final decoded = Uri.decodeComponent(encoded);
        if (decoded.isNotEmpty) return decoded;
      } on FormatException {
        // Fall back to the regular filename parameter below.
      }
    }

    final regular = RegExp(
      r'(?:^|;)\s*filename\s*=\s*(?:"((?:\\.|[^"])*)"|([^;]*))',
      caseSensitive: false,
    ).firstMatch(value);
    if (regular == null) return null;
    final raw = (regular.group(1) ?? regular.group(2) ?? '').trim();
    final unescaped = raw.replaceAllMapped(
      RegExp(r'\\(.)'),
      (match) => match.group(1)!,
    );
    return unescaped.isEmpty ? null : unescaped;
  }

  static String? _requestedBasename(Object? requestedPath) {
    if (requestedPath is! String || requestedPath.isEmpty) return null;
    final segments = requestedPath.split(RegExp(r'[/\\]'));
    for (final segment in segments.reversed) {
      if (segment.isNotEmpty && segment != '.' && segment != '..') {
        return segment;
      }
    }
    return null;
  }

  Future<void> uploadBytes(
    String path,
    Map<String, dynamic> query,
    List<int> bytes, {
    required CancelToken cancelToken,
    required ProgressCallback onProgress,
  }) async {
    try {
      final response = await dio.put<dynamic>(
        path,
        data: Uint8List.fromList(bytes),
        queryParameters: query,
        cancelToken: cancelToken,
        onSendProgress: onProgress,
        options: Options(headers: {'Content-Type': 'application/octet-stream'}),
      );
      await _unwrap(response);
    } on DioException catch (error) {
      throw _asApiException(error);
    }
  }

  /// A request whose payload is decoded from the envelope.
  Future<Object?> _json(
    String method,
    String path, {
    Object? data,
    Map<String, dynamic>? query,
    bool anonymous = false,
  }) async {
    try {
      final res = await _send(
        method,
        path,
        data: data,
        query: query,
        anonymous: anonymous,
      );
      return await _unwrap(res);
    } on DioException catch (e) {
      throw _asApiException(e);
    }
  }

  static ApiException _asApiException(DioException e) {
    final cause = e.error;
    if (cause is ApiException) return cause;
    return ApiException(
      code: ApiErrorCode.networkError,
      message: _networkMessage(e),
    );
  }

  /// `GET` returning an object.
  ///
  /// [fromJson] receives the decoded `data` member, so a DTO's generated
  /// `fromJson` can be passed straight in.
  Future<T> getObject<T>(
    String path,
    T Function(Map<String, dynamic> json) fromJson, {
    Map<String, dynamic>? query,
    bool anonymous = false,
  }) async {
    final data = await _json('GET', path, query: query, anonymous: anonymous);
    return fromJson(_asMap(data));
  }

  /// `GET` returning a list.
  Future<List<T>> getList<T>(
    String path,
    T Function(Map<String, dynamic> json) fromJson, {
    Map<String, dynamic>? query,
    bool anonymous = false,
  }) async {
    final data = await _json('GET', path, query: query, anonymous: anonymous);
    return _asList(data).map(fromJson).toList();
  }

  /// `POST`, `PUT` or `DELETE` returning an object.
  Future<T> writeObject<T>(
    String method,
    String path,
    T Function(Map<String, dynamic> json) fromJson, {
    Object? body,
    bool anonymous = false,
  }) async {
    final data = await _json(method, path, data: body, anonymous: anonymous);
    return fromJson(_asMap(data));
  }

  /// `POST`, `PUT` or `DELETE` where the caller only cares that it succeeded.
  Future<void> write(String method, String path, {Object? body}) async {
    await _json(method, path, data: body);
  }

  /// `GET /healthz`, which is the one route outside the envelope.
  ///
  /// It answers `{ok, mongo, redis, pterodactyl}` with `503` when any component
  /// is down, so the status code is not an error signal here and is ignored.
  Future<Map<String, dynamic>> health() async {
    try {
      final res = await dio.request<dynamic>(
        '/healthz',
        options: Options(method: 'GET', extra: const {'anonymous': true}),
      );
      final body = res.data;
      if (body is Map) return Map<String, dynamic>.from(body);
      throw const ApiException(
        code: ApiErrorCode.malformedResponse,
        message: 'The server returned an unexpected response.',
      );
    } on DioException catch (e) {
      throw _asApiException(e);
    }
  }

  /// Downloads the activation code archive.
  ///
  /// `GET /admin/keys/export` answers with `application/zip`, not the envelope,
  /// so it bypasses [_unwrap] entirely.
  Future<List<int>> downloadZip(String path) async {
    try {
      final res = await _send('GET', path, responseType: ResponseType.bytes);
      final body = res.data;
      if (body is List<int>) return body;
      if (body is List) return body.cast<int>();
      throw ApiException(
        code: ApiErrorCode.malformedResponse,
        message: 'The export could not be read.',
        statusCode: res.statusCode,
      );
    } on DioException catch (e) {
      throw _asApiException(e);
    }
  }

  static Map<String, dynamic> _asMap(Object? data) {
    if (data is Map) return Map<String, dynamic>.from(data);
    if (data == null) return const <String, dynamic>{};
    throw const ApiException(
      code: ApiErrorCode.malformedResponse,
      message: 'The server returned an unexpected response.',
    );
  }

  static List<Map<String, dynamic>> _asList(Object? data) {
    if (data is List) {
      return data
          .whereType<Map>()
          .map((e) => Map<String, dynamic>.from(e))
          .toList();
    }
    if (data == null) return const [];
    throw const ApiException(
      code: ApiErrorCode.malformedResponse,
      message: 'The server returned an unexpected response.',
    );
  }
}

class DownloadedFile {
  const DownloadedFile(this.bytes, this.filename, this.mimeType);
  final List<int> bytes;
  final String filename;
  final String mimeType;
}
