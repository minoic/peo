import 'dart:convert';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:peo_web/api/api_client.dart';
import 'package:peo_web/api/peo_api.dart';
import 'package:peo_web/api/token_store.dart';
import 'package:peo_web/models/admin.dart';
import 'package:peo_web/models/server_console.dart';
import 'package:peo_web/models/site.dart';
import 'package:peo_web/router/app_router.dart';
import 'package:peo_web/state/server_workspace_cubit.dart';

class _TokenStore extends TokenStore {
  @override
  Future<String?> read() async => 'user-token';
  @override
  Future<void> write(String value) async {}
  @override
  Future<void> clear() async {}
}

class _RequestCapture {
  _RequestCapture(this.options, this.bytes);
  final RequestOptions options;
  final Uint8List bytes;
}

class _ContractAdapter implements HttpClientAdapter {
  final requests = <_RequestCapture>[];
  var nextBytes = Uint8List(0);
  var nextHeaders = <String, List<String>>{};

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) async {
    final bytes = requestStream == null
        ? Uint8List(0)
        : Uint8List.fromList(
            await requestStream.expand((chunk) => chunk).toList(),
          );
    requests.add(_RequestCapture(options, bytes));
    if (nextBytes.isNotEmpty) {
      final response = ResponseBody.fromBytes(
        nextBytes,
        200,
        headers: nextHeaders,
      );
      nextBytes = Uint8List(0);
      nextHeaders = {};
      return response;
    }
    return ResponseBody.fromString(
      jsonEncode({'ok': true, 'data': null}),
      200,
      headers: {
        Headers.contentTypeHeader: ['application/json'],
      },
    );
  }

  @override
  void close({bool force = false}) {}
}

void main() {
  test(
    'decodes the camelCase console, resource, files and backup contract',
    () {
      final console = ServerConsole.fromJson({
        'server': {
          'id': 'entity-id',
          'identifier': 'srv-01',
          'name': 'World',
          'status': 'running',
          'suspended': false,
          'installing': false,
        },
        'limits': {
          'memory': 4096,
          'disk': 8192,
          'cpu': 200,
          'io': 500,
          'swap': 0,
          'threads': '',
          'backups': 3,
        },
        'startup': {
          'command': 'java -jar server.jar',
          'variables': [
            {
              'key': 'VERSION',
              'name': 'Version',
              'description': 'Runtime version',
              'value': '1.21',
              'defaultValue': 'latest',
              'isEditable': true,
              'rules': 'required|string',
            },
          ],
          'dockerImages': {'ghcr.io/example/java:21': 'Java 21'},
          'dockerImage': 'ghcr.io/example/java:21',
        },
      });
      final resources = ServerResources.fromJson({
        'currentState': 'running',
        'isSuspended': false,
        'resources': {
          'memoryBytes': 1024,
          'cpuAbsolute': 12.5,
          'diskBytes': 2048,
          'networkRxBytes': 30,
          'networkTxBytes': 40,
          'uptime': 60,
        },
      });
      final file = ServerFile.fromJson({
        'name': 'server.jar',
        'mode': '0644',
        'modeBits': '0644',
        'size': 2048,
        'isFile': true,
        'isSymlink': false,
        'isEditable': false,
        'mimeType': 'application/java-archive',
        'createdAt': '2026-10-17T00:00:00Z',
        'modifiedAt': '2026-10-17T00:00:00Z',
      });
      final backup = ServerBackup.fromJson({
        'uuid': 'backup-id',
        'name': 'nightly',
        'bytes': 4096,
        'completed': true,
        'locked': true,
        'createdAt': '2026-10-17T00:00:00Z',
        'checksum': 'abc',
        'status': '',
        'progress': 0,
      });

      expect(console.server.identifier, 'srv-01');
      expect(console.limits.backups, 3);
      expect(console.startup.variables.single.defaultValue, 'latest');
      expect(console.startup.variables.single.isEditable, isTrue);
      expect(
        console.startup.dockerImages['ghcr.io/example/java:21'],
        'Java 21',
      );
      expect(console.startup.dockerImage, 'ghcr.io/example/java:21');
      expect(resources.resources.memoryBytes, 1024);
      expect(resources.currentState, 'running');
      expect(file.modeBits, '0644');
      expect(file.isEditable, isFalse);
      expect(backup.locked, isTrue);
    },
  );

  test(
    'admin product input carries Tag slug and legacy Nest migration value',
    () {
      final input = ProductInput.fromJson({
        'wareName': 'Survival',
        'nodeId': 2,
        'nestId': 9,
        'tagSlug': 'minecraft',
        'eggId': 17,
        'allowedEggIds': [17, 25],
      });
      expect(input.toJson()['tagSlug'], 'minecraft');
      expect(input.toJson()['nestId'], 9);
      expect(input.toJson()['eggId'], 17);
      expect(input.toJson()['allowedEggIds'], [17, 25]);
      expect(
        PanelTag.fromJson({
          'id': 4,
          'name': 'Minecraft',
          'slug': 'minecraft',
          'legacyNestId': 9,
        }).legacyNestId,
        9,
      );
      final tokenField = SettingField.fromJson({
        'key': 'PterodactylToken',
        'label': 'Panel token',
        'type': 'text',
        'value': '',
        'secret': true,
        'configured': true,
      });
      expect(tokenField.value, isEmpty);
      expect(tokenField.secret, isTrue);
      expect(tokenField.configured, isTrue);
      final product = ProductCard.fromJson({
        'specId': 'product-id',
        'egg': 17,
        'allowedEggIds': [17, 25],
      });
      expect(product.allowedEggIds, [17, 25]);
    },
  );

  test(
    'backup polling follows active statuses and stops for terminal failures',
    () {
      ServerBackup backup({required bool completed, required String status}) =>
          ServerBackup(uuid: 'backup', completed: completed, status: status);

      expect(
        backupIsActive(backup(completed: false, status: 'processing')),
        isTrue,
      );
      expect(
        backupIsActive(backup(completed: false, status: 'pending')),
        isTrue,
      );
      expect(
        backupIsActive(backup(completed: false, status: 'failed')),
        isFalse,
      );
      expect(
        backupIsActive(backup(completed: true, status: 'completed')),
        isFalse,
      );
    },
  );

  test('resource uptime milliseconds format to days and hours', () {
    expect(formatServerUptime(93600000), '1d 2h');
    expect(formatServerUptime(300000), '0h 5m');
  });

  test('deep-linked server tabs remain behind the signed-in route guard', () {
    expect(needsSession('/servers/entity-id/console'), isTrue);
    expect(needsSession('/servers/entity-id/files'), isTrue);
    expect(needsSession('/servers/entity-id/backups'), isTrue);
    expect(needsSession('/servers/entity-id/startup'), isTrue);
  });

  test('unknown workspace tabs normalize to the console route', () {
    expect(
      normalizeServerWorkspacePath('/servers/entity-id/typo'),
      '/servers/entity-id/console',
    );
    expect(normalizeServerWorkspacePath('/servers/entity-id/files'), isNull);
    expect(normalizeServerWorkspacePath('/servers/entity-id'), isNull);
  });

  test(
    'file operation and raw upload requests preserve the Go contract',
    () async {
      final adapter = _ContractAdapter();
      final client = ApiClient(
        tokenStore: _TokenStore(),
        baseUrl: 'https://peo.example/api/v1',
        dio: Dio()..httpClientAdapter = adapter,
      );
      final api = PeoApi(client);

      await api.serverFileOperation('entity-id', 'mkdir', {
        'root': '/world',
        'name': 'new',
      });
      await api.serverFileOperation('entity-id', 'chmod', {
        'root': '/world',
        'files': [
          {'file': 'server.jar', 'mode': '755'},
        ],
      });
      await api.serverFileOperation('entity-id', 'copy', {
        'location': '/world/server.jar',
      });
      await api.serverFileOperation('entity-id', 'rename', {
        'root': '/',
        'files': [
          {'from': '/world/server.jar', 'to': '/archive/server.jar'},
        ],
      });
      await api.uploadServerFile(
        'entity-id',
        '/world',
        'map.zip',
        [1, 2, 3],
        cancelToken: CancelToken(),
        onProgress: (_, _) {},
      );

      expect(adapter.requests[0].options.method, 'POST');
      expect(
        adapter.requests[0].options.uri.path,
        '/api/v1/servers/entity-id/files/mkdir',
      );
      expect(jsonDecode(utf8.decode(adapter.requests[0].bytes)), {
        'root': '/world',
        'name': 'new',
      });
      expect(jsonDecode(utf8.decode(adapter.requests[1].bytes)), {
        'root': '/world',
        'files': [
          {'file': 'server.jar', 'mode': '755'},
        ],
      });
      expect(jsonDecode(utf8.decode(adapter.requests[2].bytes)), {
        'location': '/world/server.jar',
      });
      expect(
        adapter.requests[3].options.uri.path,
        '/api/v1/servers/entity-id/files/rename',
      );
      expect(jsonDecode(utf8.decode(adapter.requests[3].bytes)), {
        'root': '/',
        'files': [
          {'from': '/world/server.jar', 'to': '/archive/server.jar'},
        ],
      });
      expect(adapter.requests[4].options.method, 'PUT');
      expect(adapter.requests[4].options.uri.queryParameters, {
        'directory': '/world',
        'filename': 'map.zip',
      });
      expect(adapter.requests[4].bytes, [1, 2, 3]);
    },
  );
}
