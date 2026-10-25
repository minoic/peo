/// DTOs for the Pterodactyl-backed server console API.
library;

import 'package:freezed_annotation/freezed_annotation.dart';

part 'server_console.freezed.dart';
part 'server_console.g.dart';

@freezed
abstract class ServerConsole with _$ServerConsole {
  const factory ServerConsole({
    @Default(ConsoleServer()) ConsoleServer server,
    @Default(ConsoleLimits()) ConsoleLimits limits,
    @Default(ServerStartup()) ServerStartup startup,
  }) = _ServerConsole;

  factory ServerConsole.fromJson(Map<String, dynamic> json) =>
      _$ServerConsoleFromJson(json);
}

@freezed
abstract class ConsoleServer with _$ConsoleServer {
  const factory ConsoleServer({
    @Default('') String id,
    @Default('') String identifier,
    @Default('') String name,
    @Default('') String status,
    @Default(false) bool suspended,
    @Default(false) bool installing,
  }) = _ConsoleServer;

  factory ConsoleServer.fromJson(Map<String, dynamic> json) =>
      _$ConsoleServerFromJson(json);
}

@freezed
abstract class ConsoleLimits with _$ConsoleLimits {
  const factory ConsoleLimits({
    @Default(0) int memory,
    @Default(0) int disk,
    @Default(0) int cpu,
    @Default(0) int io,
    @Default(0) int swap,
    @Default('') String threads,
    @Default(0) int backups,
  }) = _ConsoleLimits;

  factory ConsoleLimits.fromJson(Map<String, dynamic> json) =>
      _$ConsoleLimitsFromJson(json);
}

@freezed
abstract class ServerStartup with _$ServerStartup {
  const factory ServerStartup({
    @Default('') String command,
    @Default(<StartupVariable>[]) List<StartupVariable> variables,
    @Default(<String, String>{}) Map<String, String> dockerImages,
    @Default('') String dockerImage,
  }) = _ServerStartup;

  factory ServerStartup.fromJson(Map<String, dynamic> json) =>
      _$ServerStartupFromJson(json);
}

@freezed
abstract class StartupVariable with _$StartupVariable {
  const factory StartupVariable({
    @Default('') String key,
    @Default('') String name,
    @Default('') String description,
    @Default('') String value,
    @Default('') String defaultValue,
    @Default(false) bool isEditable,
    @Default('') String rules,
  }) = _StartupVariable;

  factory StartupVariable.fromJson(Map<String, dynamic> json) =>
      _$StartupVariableFromJson(json);
}

@freezed
abstract class ServerResources with _$ServerResources {
  const factory ServerResources({
    @Default('') String currentState,
    @Default(false) bool isSuspended,
    @Default(ResourceUsage()) ResourceUsage resources,
  }) = _ServerResources;

  factory ServerResources.fromJson(Map<String, dynamic> json) =>
      _$ServerResourcesFromJson(json);
}

@freezed
abstract class ResourceUsage with _$ResourceUsage {
  const factory ResourceUsage({
    @Default(0) int memoryBytes,
    @Default(0) double cpuAbsolute,
    @Default(0) int diskBytes,
    @Default(0) int networkRxBytes,
    @Default(0) int networkTxBytes,
    @Default(0) int uptime,
  }) = _ResourceUsage;

  factory ResourceUsage.fromJson(Map<String, dynamic> json) =>
      _$ResourceUsageFromJson(json);
}

@freezed
abstract class TerminalTicket with _$TerminalTicket {
  const factory TerminalTicket({
    @Default('') String ticket,
    @Default('') String expiresAt,
  }) = _TerminalTicket;

  factory TerminalTicket.fromJson(Map<String, dynamic> json) =>
      _$TerminalTicketFromJson(json);
}

@freezed
abstract class ServerFile with _$ServerFile {
  const factory ServerFile({
    @Default('') String name,
    @Default('') String mode,
    @Default('') String modeBits,
    @Default(0) int size,
    @Default(false) bool isFile,
    @Default(false) bool isSymlink,
    @Default(false) bool isEditable,
    @Default('') String mimeType,
    @Default('') String createdAt,
    @Default('') String modifiedAt,
  }) = _ServerFile;

  factory ServerFile.fromJson(Map<String, dynamic> json) =>
      _$ServerFileFromJson(json);
}

@freezed
abstract class ServerFileList with _$ServerFileList {
  const factory ServerFileList({
    @Default(<ServerFile>[]) List<ServerFile> items,
  }) = _ServerFileList;

  factory ServerFileList.fromJson(Map<String, dynamic> json) =>
      _$ServerFileListFromJson(json);
}

@freezed
abstract class FileContent with _$FileContent {
  const factory FileContent({@Default('') String content}) = _FileContent;

  factory FileContent.fromJson(Map<String, dynamic> json) =>
      _$FileContentFromJson(json);
}

@freezed
abstract class ServerBackup with _$ServerBackup {
  const factory ServerBackup({
    @Default('') String uuid,
    @Default('') String name,
    @Default(0) int bytes,
    @Default(false) bool completed,
    @Default(false) bool locked,
    @Default('') String createdAt,
    @Default('') String checksum,
    @Default('') String status,
    @Default(0) int progress,
  }) = _ServerBackup;

  factory ServerBackup.fromJson(Map<String, dynamic> json) =>
      _$ServerBackupFromJson(json);
}

@freezed
abstract class ServerBackupList with _$ServerBackupList {
  const factory ServerBackupList({
    @Default(<ServerBackup>[]) List<ServerBackup> items,
  }) = _ServerBackupList;

  factory ServerBackupList.fromJson(Map<String, dynamic> json) =>
      _$ServerBackupListFromJson(json);
}
