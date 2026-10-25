// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'server_console.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ServerConsole _$ServerConsoleFromJson(Map<String, dynamic> json) =>
    _ServerConsole(
      server: json['server'] == null
          ? const ConsoleServer()
          : ConsoleServer.fromJson(json['server'] as Map<String, dynamic>),
      limits: json['limits'] == null
          ? const ConsoleLimits()
          : ConsoleLimits.fromJson(json['limits'] as Map<String, dynamic>),
      startup: json['startup'] == null
          ? const ServerStartup()
          : ServerStartup.fromJson(json['startup'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$ServerConsoleToJson(_ServerConsole instance) =>
    <String, dynamic>{
      'server': instance.server,
      'limits': instance.limits,
      'startup': instance.startup,
    };

_ConsoleServer _$ConsoleServerFromJson(Map<String, dynamic> json) =>
    _ConsoleServer(
      id: json['id'] as String? ?? '',
      identifier: json['identifier'] as String? ?? '',
      name: json['name'] as String? ?? '',
      status: json['status'] as String? ?? '',
      suspended: json['suspended'] as bool? ?? false,
      installing: json['installing'] as bool? ?? false,
    );

Map<String, dynamic> _$ConsoleServerToJson(_ConsoleServer instance) =>
    <String, dynamic>{
      'id': instance.id,
      'identifier': instance.identifier,
      'name': instance.name,
      'status': instance.status,
      'suspended': instance.suspended,
      'installing': instance.installing,
    };

_ConsoleLimits _$ConsoleLimitsFromJson(Map<String, dynamic> json) =>
    _ConsoleLimits(
      memory: (json['memory'] as num?)?.toInt() ?? 0,
      disk: (json['disk'] as num?)?.toInt() ?? 0,
      cpu: (json['cpu'] as num?)?.toInt() ?? 0,
      io: (json['io'] as num?)?.toInt() ?? 0,
      swap: (json['swap'] as num?)?.toInt() ?? 0,
      threads: json['threads'] as String? ?? '',
      backups: (json['backups'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$ConsoleLimitsToJson(_ConsoleLimits instance) =>
    <String, dynamic>{
      'memory': instance.memory,
      'disk': instance.disk,
      'cpu': instance.cpu,
      'io': instance.io,
      'swap': instance.swap,
      'threads': instance.threads,
      'backups': instance.backups,
    };

_ServerStartup _$ServerStartupFromJson(Map<String, dynamic> json) =>
    _ServerStartup(
      command: json['command'] as String? ?? '',
      variables:
          (json['variables'] as List<dynamic>?)
              ?.map((e) => StartupVariable.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const <StartupVariable>[],
      dockerImages:
          (json['dockerImages'] as Map<String, dynamic>?)?.map(
            (k, e) => MapEntry(k, e as String),
          ) ??
          const <String, String>{},
      dockerImage: json['dockerImage'] as String? ?? '',
    );

Map<String, dynamic> _$ServerStartupToJson(_ServerStartup instance) =>
    <String, dynamic>{
      'command': instance.command,
      'variables': instance.variables,
      'dockerImages': instance.dockerImages,
      'dockerImage': instance.dockerImage,
    };

_StartupVariable _$StartupVariableFromJson(Map<String, dynamic> json) =>
    _StartupVariable(
      key: json['key'] as String? ?? '',
      name: json['name'] as String? ?? '',
      description: json['description'] as String? ?? '',
      value: json['value'] as String? ?? '',
      defaultValue: json['defaultValue'] as String? ?? '',
      isEditable: json['isEditable'] as bool? ?? false,
      rules: json['rules'] as String? ?? '',
    );

Map<String, dynamic> _$StartupVariableToJson(_StartupVariable instance) =>
    <String, dynamic>{
      'key': instance.key,
      'name': instance.name,
      'description': instance.description,
      'value': instance.value,
      'defaultValue': instance.defaultValue,
      'isEditable': instance.isEditable,
      'rules': instance.rules,
    };

_ServerResources _$ServerResourcesFromJson(Map<String, dynamic> json) =>
    _ServerResources(
      currentState: json['currentState'] as String? ?? '',
      isSuspended: json['isSuspended'] as bool? ?? false,
      resources: json['resources'] == null
          ? const ResourceUsage()
          : ResourceUsage.fromJson(json['resources'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$ServerResourcesToJson(_ServerResources instance) =>
    <String, dynamic>{
      'currentState': instance.currentState,
      'isSuspended': instance.isSuspended,
      'resources': instance.resources,
    };

_ResourceUsage _$ResourceUsageFromJson(Map<String, dynamic> json) =>
    _ResourceUsage(
      memoryBytes: (json['memoryBytes'] as num?)?.toInt() ?? 0,
      cpuAbsolute: (json['cpuAbsolute'] as num?)?.toDouble() ?? 0,
      diskBytes: (json['diskBytes'] as num?)?.toInt() ?? 0,
      networkRxBytes: (json['networkRxBytes'] as num?)?.toInt() ?? 0,
      networkTxBytes: (json['networkTxBytes'] as num?)?.toInt() ?? 0,
      uptime: (json['uptime'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$ResourceUsageToJson(_ResourceUsage instance) =>
    <String, dynamic>{
      'memoryBytes': instance.memoryBytes,
      'cpuAbsolute': instance.cpuAbsolute,
      'diskBytes': instance.diskBytes,
      'networkRxBytes': instance.networkRxBytes,
      'networkTxBytes': instance.networkTxBytes,
      'uptime': instance.uptime,
    };

_TerminalTicket _$TerminalTicketFromJson(Map<String, dynamic> json) =>
    _TerminalTicket(
      ticket: json['ticket'] as String? ?? '',
      expiresAt: json['expiresAt'] as String? ?? '',
    );

Map<String, dynamic> _$TerminalTicketToJson(_TerminalTicket instance) =>
    <String, dynamic>{
      'ticket': instance.ticket,
      'expiresAt': instance.expiresAt,
    };

_ServerFile _$ServerFileFromJson(Map<String, dynamic> json) => _ServerFile(
  name: json['name'] as String? ?? '',
  mode: json['mode'] as String? ?? '',
  modeBits: json['modeBits'] as String? ?? '',
  size: (json['size'] as num?)?.toInt() ?? 0,
  isFile: json['isFile'] as bool? ?? false,
  isSymlink: json['isSymlink'] as bool? ?? false,
  isEditable: json['isEditable'] as bool? ?? false,
  mimeType: json['mimeType'] as String? ?? '',
  createdAt: json['createdAt'] as String? ?? '',
  modifiedAt: json['modifiedAt'] as String? ?? '',
);

Map<String, dynamic> _$ServerFileToJson(_ServerFile instance) =>
    <String, dynamic>{
      'name': instance.name,
      'mode': instance.mode,
      'modeBits': instance.modeBits,
      'size': instance.size,
      'isFile': instance.isFile,
      'isSymlink': instance.isSymlink,
      'isEditable': instance.isEditable,
      'mimeType': instance.mimeType,
      'createdAt': instance.createdAt,
      'modifiedAt': instance.modifiedAt,
    };

_ServerFileList _$ServerFileListFromJson(Map<String, dynamic> json) =>
    _ServerFileList(
      items:
          (json['items'] as List<dynamic>?)
              ?.map((e) => ServerFile.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const <ServerFile>[],
    );

Map<String, dynamic> _$ServerFileListToJson(_ServerFileList instance) =>
    <String, dynamic>{'items': instance.items};

_FileContent _$FileContentFromJson(Map<String, dynamic> json) =>
    _FileContent(content: json['content'] as String? ?? '');

Map<String, dynamic> _$FileContentToJson(_FileContent instance) =>
    <String, dynamic>{'content': instance.content};

_ServerBackup _$ServerBackupFromJson(Map<String, dynamic> json) =>
    _ServerBackup(
      uuid: json['uuid'] as String? ?? '',
      name: json['name'] as String? ?? '',
      bytes: (json['bytes'] as num?)?.toInt() ?? 0,
      completed: json['completed'] as bool? ?? false,
      locked: json['locked'] as bool? ?? false,
      createdAt: json['createdAt'] as String? ?? '',
      checksum: json['checksum'] as String? ?? '',
      status: json['status'] as String? ?? '',
      progress: (json['progress'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$ServerBackupToJson(_ServerBackup instance) =>
    <String, dynamic>{
      'uuid': instance.uuid,
      'name': instance.name,
      'bytes': instance.bytes,
      'completed': instance.completed,
      'locked': instance.locked,
      'createdAt': instance.createdAt,
      'checksum': instance.checksum,
      'status': instance.status,
      'progress': instance.progress,
    };

_ServerBackupList _$ServerBackupListFromJson(Map<String, dynamic> json) =>
    _ServerBackupList(
      items:
          (json['items'] as List<dynamic>?)
              ?.map((e) => ServerBackup.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const <ServerBackup>[],
    );

Map<String, dynamic> _$ServerBackupListToJson(_ServerBackupList instance) =>
    <String, dynamic>{'items': instance.items};
