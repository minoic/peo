import 'dart:convert';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:peo_web/api/api_client.dart';
import 'package:peo_web/api/api_exception.dart';
import 'package:peo_web/api/peo_api.dart';
import 'package:peo_web/api/token_store.dart';
import 'package:peo_web/state/session_cubit.dart';

class _MemoryTokenStore extends TokenStore {
  String? token;
  @override
  Future<String?> read() async => token;
  @override
  Future<void> write(String value) async => token = value;
  @override
  Future<void> clear() async => token = null;
}

class _FakeAdapter implements HttpClientAdapter {
  _FakeAdapter(this.statusCode, this.body);
  final int statusCode;
  final Map<String, Object?> body;
  String? authorization;

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) async {
    authorization = options.headers['Authorization'] as String?;
    return ResponseBody.fromString(
      jsonEncode(body),
      statusCode,
      headers: <String, List<String>>{
        Headers.contentTypeHeader: <String>['application/json'],
      },
    );
  }

  @override
  void close({bool force = false}) {}
}

class _DownloadAdapter implements HttpClientAdapter {
  _DownloadAdapter(this.headers);
  final Map<String, List<String>> headers;

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) async => ResponseBody.fromBytes(
    <int>[1, 2, 3],
    200,
    headers: <String, List<String>>{
      Headers.contentTypeHeader: <String>['application/octet-stream'],
      ...headers,
    },
  );

  @override
  void close({bool force = false}) {}
}

void main() {
  for (final testCase in <(String, String)>[
    ('attachment; filename="server.log"', 'server.log'),
    ("attachment; filename*=utf-8''%E6%9C%8D%E5%8A%A1%E5%99%A8.log", '服务器.log'),
    ("attachment; filename*=utf-8''a%20b.txt", 'a b.txt'),
    ("attachment; filename=legacy.txt; filename*=utf-8''a+b.txt", 'a+b.txt'),
    ("attachment; filename*=utf-8''a%3Bb.txt", 'a;b.txt'),
    ('attachment; filename="a\\"b; c.txt"', 'a"b; c.txt'),
    ("attachment; filename*=utf-8''bad%ZZ; filename=backup.zip", 'backup.zip'),
    (
      "attachment; filename*=ISO-8859-1''bad; filename=backup.zip",
      'backup.zip',
    ),
  ]) {
    test('download parses ${testCase.$2} from Content-Disposition', () async {
      final adapter = _DownloadAdapter(<String, List<String>>{
        'content-disposition': <String>[testCase.$1],
      });
      final client = ApiClient(
        tokenStore: _MemoryTokenStore(),
        baseUrl: 'https://example.test/api/v1',
        dio: Dio()..httpClientAdapter = adapter,
      );

      final file = await PeoApi(client).downloadServerFile(
        'server-id',
        '/world/${testCase.$2}',
        cancelToken: CancelToken(),
        onProgress: (_, _) {},
      );

      expect(file.filename, testCase.$2);
      expect(file.bytes, <int>[1, 2, 3]);
    });
  }

  test('download falls back to the requested file basename', () async {
    final client = ApiClient(
      tokenStore: _MemoryTokenStore(),
      baseUrl: 'https://example.test/api/v1',
      dio: Dio()..httpClientAdapter = _DownloadAdapter(const {}),
    );

    final file = await PeoApi(client).downloadServerFile(
      'server-id',
      '/world/存档.zip',
      cancelToken: CancelToken(),
      onProgress: (_, _) {},
    );

    expect(file.filename, '存档.zip');
  });

  test('backup download keeps its response filename', () async {
    final client = ApiClient(
      tokenStore: _MemoryTokenStore(),
      baseUrl: 'https://example.test/api/v1',
      dio: Dio()
        ..httpClientAdapter = _DownloadAdapter(<String, List<String>>{
          'content-disposition': <String>['attachment; filename="backup.zip"'],
        }),
    );

    final file = await PeoApi(client).downloadServerBackup(
      'server-id',
      'backup-id',
      cancelToken: CancelToken(),
      onProgress: (_, _) {},
    );

    expect(file.filename, 'backup.zip');
  });

  test('authenticated requests attach the stored Bearer token', () async {
    final tokenStore = _MemoryTokenStore()..token = 'jwt-value';
    final adapter = _FakeAdapter(200, <String, Object?>{
      'ok': true,
      'data': <String, Object?>{
        'user': <String, Object?>{
          'name': 'alice',
          'email': 'alice@example.test',
        },
      },
    });
    final client = ApiClient(
      tokenStore: tokenStore,
      baseUrl: 'https://example.test/api/v1',
      dio: Dio()..httpClientAdapter = adapter,
    );

    final user = await PeoApi(client).me();

    expect(user.name, 'alice');
    expect(adapter.authorization, 'Bearer jwt-value');
  });

  test(
    '401 clears the token, notifies the session, and preserves the API error',
    () async {
      final tokenStore = _MemoryTokenStore()..token = 'expired-token';
      final adapter = _FakeAdapter(401, <String, Object?>{
        'ok': false,
        'error': <String, Object?>{
          'code': 'unauthorized',
          'message': 'token expired',
        },
      });
      final client = ApiClient(
        tokenStore: tokenStore,
        baseUrl: 'https://example.test/api/v1',
        dio: Dio()..httpClientAdapter = adapter,
      );
      var notifications = 0;
      client.onUnauthorized = () async => notifications++;

      await expectLater(
        PeoApi(client).me(),
        throwsA(
          isA<ApiException>()
              .having((error) => error.isUnauthorized, 'unauthorized', true)
              .having((error) => error.message, 'message', 'token expired')
              .having((error) => error.statusCode, 'status code', 401),
        ),
      );

      expect(tokenStore.token, isNull);
      expect(notifications, 1);
      expect(adapter.authorization, 'Bearer expired-token');
    },
  );

  test('bootstrap rejects an expired token and resolves signed out', () async {
    final tokenStore = _MemoryTokenStore()..token = 'expired-token';
    final adapter = _FakeAdapter(401, <String, Object?>{
      'ok': false,
      'error': <String, Object?>{
        'code': 'unauthorized',
        'message': 'token expired',
      },
    });
    final client = ApiClient(
      tokenStore: tokenStore,
      baseUrl: 'https://example.test/api/v1',
      dio: Dio()..httpClientAdapter = adapter,
    );
    final session = SessionCubit(api: PeoApi(client), tokenStore: tokenStore);

    await session.bootstrap();

    expect(tokenStore.token, isNull);
    expect(session.state.status, SessionStatus.signedOut);
    expect(session.state.error?.isUnauthorized, isTrue);
    expect(session.state.error?.message, 'token expired');
    expect(adapter.authorization, 'Bearer expired-token');
    await session.close();
  });
}
