import 'dart:async';
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../api/api_client.dart';
import '../api/api_exception.dart';
import '../api/peo_api.dart';
import '../models/server_console.dart';
import '../widgets/browser.dart';

class ResourcePoint {
  const ResourcePoint(this.time, this.memory, this.cpu);
  final DateTime time;

  /// Memory in MiB and CPU in absolute percent, matching the API sample.
  final double memory;
  final double cpu;
}

bool backupIsActive(ServerBackup backup) {
  if (backup.completed) return false;
  final status = backup.status.trim().toLowerCase();
  if (const {
    'failed',
    'error',
    'cancelled',
    'canceled',
    'complete',
    'completed',
  }.contains(status)) {
    return false;
  }
  return status.isEmpty ||
      const {
        'pending',
        'processing',
        'queued',
        'creating',
        'restoring',
        'in progress',
      }.contains(status);
}

String formatServerUptime(int milliseconds) {
  final duration = Duration(milliseconds: milliseconds);
  final days = duration.inDays;
  final hours = duration.inHours.remainder(24);
  final minutes = duration.inMinutes.remainder(60);
  return days > 0 ? '${days}d ${hours}h' : '${hours}h ${minutes}m';
}

class ServerWorkspaceState {
  const ServerWorkspaceState({
    this.console,
    this.resources,
    this.points = const [],
    this.files = const [],
    this.directory = '/',
    this.backups = const [],
    this.startup,
    this.loading = false,
    this.busy = false,
    this.error = '',
    this.transferProgress,
    this.transferLabel = '',
    this.resourceUpdatedAt,
    this.resourceError = '',
    this.editorPath = '',
    this.editorMimeType = '',
    this.editorContent = '',
    this.editorOriginalContent = '',
    this.editorLoading = false,
    this.editorLoaded = false,
    this.editorLoadFailed = false,
    this.editorSaving = false,
    this.editorError = '',
  });

  final ServerConsole? console;
  final ServerResources? resources;
  final List<ResourcePoint> points;
  final List<ServerFile> files;
  final String directory;
  final List<ServerBackup> backups;
  final ServerStartup? startup;
  final bool loading;
  final bool busy;
  final String error;
  final double? transferProgress;
  final String transferLabel;
  final DateTime? resourceUpdatedAt;
  final String resourceError;
  final String editorPath;
  final String editorMimeType;
  final String editorContent;
  final String editorOriginalContent;
  final bool editorLoading;
  final bool editorLoaded;
  final bool editorLoadFailed;
  final bool editorSaving;
  final String editorError;

  bool get editorDirty => editorContent != editorOriginalContent;

  ServerWorkspaceState copyWith({
    ServerConsole? console,
    ServerResources? resources,
    List<ResourcePoint>? points,
    List<ServerFile>? files,
    String? directory,
    List<ServerBackup>? backups,
    ServerStartup? startup,
    bool? loading,
    bool? busy,
    String? error,
    double? transferProgress,
    String? transferLabel,
    bool clearTransfer = false,
    DateTime? resourceUpdatedAt,
    String? resourceError,
    String? editorPath,
    String? editorMimeType,
    String? editorContent,
    String? editorOriginalContent,
    bool? editorLoading,
    bool? editorLoaded,
    bool? editorLoadFailed,
    bool? editorSaving,
    String? editorError,
  }) => ServerWorkspaceState(
    console: console ?? this.console,
    resources: resources ?? this.resources,
    points: points ?? this.points,
    files: files ?? this.files,
    directory: directory ?? this.directory,
    backups: backups ?? this.backups,
    startup: startup ?? this.startup,
    loading: loading ?? this.loading,
    busy: busy ?? this.busy,
    error: error ?? this.error,
    transferProgress: clearTransfer
        ? null
        : transferProgress ?? this.transferProgress,
    transferLabel: clearTransfer ? '' : transferLabel ?? this.transferLabel,
    resourceUpdatedAt: resourceUpdatedAt ?? this.resourceUpdatedAt,
    resourceError: resourceError ?? this.resourceError,
    editorPath: editorPath ?? this.editorPath,
    editorMimeType: editorMimeType ?? this.editorMimeType,
    editorContent: editorContent ?? this.editorContent,
    editorOriginalContent: editorOriginalContent ?? this.editorOriginalContent,
    editorLoading: editorLoading ?? this.editorLoading,
    editorLoaded: editorLoaded ?? this.editorLoaded,
    editorLoadFailed: editorLoadFailed ?? this.editorLoadFailed,
    editorSaving: editorSaving ?? this.editorSaving,
    editorError: editorError ?? this.editorError,
  );
}

class ServerWorkspaceCubit extends Cubit<ServerWorkspaceState> {
  ServerWorkspaceCubit(this.api, this.serverId)
    : super(const ServerWorkspaceState());
  final PeoApi api;
  final String serverId;
  Timer? _resourceTimer;
  Timer? _backupTimer;
  CancelToken? _transfer;

  Future<void> load() async {
    emit(state.copyWith(loading: true, error: ''));
    try {
      final console = await api.serverConsole(serverId);
      if (isClosed) return;
      emit(
        state.copyWith(
          console: console,
          startup: console.startup,
          loading: false,
        ),
      );
      await loadBackups();
    } on ApiException catch (error) {
      if (!isClosed) emit(state.copyWith(loading: false, error: error.message));
    }
  }

  Future<void> refreshResources() async {
    try {
      final resources = await api.serverResources(serverId);
      if (isClosed) return;
      final memory = resources.resources.memoryBytes / (1024 * 1024);
      final cpu = resources.resources.cpuAbsolute;
      final now = DateTime.now();
      final points = [
        ...state.points.where(
          (point) => now.difference(point.time) <= const Duration(minutes: 5),
        ),
        ResourcePoint(now, memory, cpu),
      ];
      emit(
        state.copyWith(
          resources: resources,
          points: points,
          resourceUpdatedAt: now,
          resourceError: '',
        ),
      );
    } on ApiException catch (error) {
      if (!isClosed) emit(state.copyWith(resourceError: error.message));
    }
  }

  void startResourcePolling() {
    _resourceTimer?.cancel();
    unawaited(refreshResources());
    _resourceTimer = Timer.periodic(
      const Duration(seconds: 5),
      (_) => unawaited(refreshResources()),
    );
  }

  Future<void> loadFiles([String? path]) async {
    final directory = path ?? state.directory;
    emit(state.copyWith(loading: true, error: ''));
    try {
      final files = await api.serverFiles(serverId, directory);
      if (!isClosed) {
        emit(
          state.copyWith(files: files, directory: directory, loading: false),
        );
      }
    } on ApiException catch (error) {
      if (!isClosed) emit(state.copyWith(loading: false, error: error.message));
    }
  }

  Future<void> loadEditorFile(String path, {String mimeType = ''}) async {
    emit(
      state.copyWith(
        editorPath: path,
        editorMimeType: mimeType,
        editorLoading: true,
        editorLoaded: false,
        editorLoadFailed: false,
        editorError: '',
        editorSaving: false,
        editorContent: '',
        editorOriginalContent: '',
      ),
    );
    try {
      final content = await api.readServerFile(serverId, path);
      if (!isClosed && state.editorPath == path) {
        if (utf8.encode(content).length > 2 * 1024 * 1024) {
          throw const FormatException('Text files are limited to 2 MiB.');
        }
        emit(
          state.copyWith(
            editorContent: content,
            editorOriginalContent: content,
            editorLoading: false,
            editorLoaded: true,
            editorLoadFailed: false,
            editorError: '',
          ),
        );
      }
    } on ApiException catch (error) {
      if (!isClosed && state.editorPath == path) {
        emit(
          state.copyWith(
            editorLoading: false,
            editorLoaded: false,
            editorLoadFailed: true,
            editorError: error.message,
          ),
        );
      }
    } catch (error) {
      if (!isClosed && state.editorPath == path) {
        emit(
          state.copyWith(
            editorLoading: false,
            editorLoaded: false,
            editorLoadFailed: true,
            editorError: '$error',
          ),
        );
      }
    }
  }

  void updateEditorContent(String content) {
    if (!isClosed && state.editorLoaded) {
      emit(state.copyWith(editorContent: content));
    }
  }

  Future<bool> saveEditorFile() async {
    final path = state.editorPath;
    final content = state.editorContent;
    if (path.isEmpty ||
        !state.editorLoaded ||
        state.editorSaving ||
        state.editorLoading) {
      return false;
    }
    if (utf8.encode(content).length > 2 * 1024 * 1024) {
      emit(state.copyWith(editorError: 'Text files are limited to 2 MiB.'));
      return false;
    }
    emit(state.copyWith(editorSaving: true, editorError: ''));
    try {
      await api.writeServerFile(serverId, path, content);
      if (isClosed || state.editorPath != path) return false;
      emit(
        state.copyWith(
          editorOriginalContent: content,
          editorSaving: false,
          editorError: '',
        ),
      );
      await loadFiles();
      return true;
    } on ApiException catch (error) {
      if (!isClosed) {
        emit(
          state.copyWith(
            editorSaving: false,
            editorLoadFailed: false,
            editorError: error.message,
          ),
        );
      }
    } catch (error) {
      if (!isClosed) {
        emit(
          state.copyWith(
            editorSaving: false,
            editorLoadFailed: false,
            editorError: '$error',
          ),
        );
      }
    }
    return false;
  }

  Future<void> loadBackups() async {
    try {
      final backups = await api.serverBackups(serverId);
      if (isClosed) return;
      emit(state.copyWith(backups: backups));
      if (backups.any(backupIsActive)) {
        _backupTimer ??= Timer.periodic(
          const Duration(seconds: 3),
          (_) => unawaited(loadBackups()),
        );
      } else {
        _backupTimer?.cancel();
        _backupTimer = null;
      }
    } on ApiException catch (error) {
      if (!isClosed) emit(state.copyWith(error: error.message));
    }
  }

  Future<void> run(
    Future<void> Function() action, {
    bool reloadFiles = false,
    bool reloadBackups = false,
  }) async {
    emit(state.copyWith(busy: true, error: ''));
    try {
      await action();
      if (isClosed) return;
      emit(state.copyWith(busy: false));
      if (reloadFiles) await loadFiles();
      if (reloadBackups) await loadBackups();
    } on ApiException catch (error) {
      if (!isClosed) emit(state.copyWith(busy: false, error: error.message));
    } catch (error) {
      if (!isClosed) emit(state.copyWith(busy: false, error: '$error'));
    }
  }

  Future<void> transfer({
    required String label,
    Future<DownloadedFile> Function(CancelToken, ProgressCallback)? download,
    Future<void> Function(CancelToken, ProgressCallback)? upload,
  }) async {
    final token = CancelToken();
    _transfer = token;
    emit(
      state.copyWith(
        busy: true,
        transferLabel: label,
        transferProgress: 0,
        error: '',
      ),
    );
    try {
      if (download != null) {
        final file = await download(token, (received, total) {
          if (!isClosed && total > 0) {
            emit(state.copyWith(transferProgress: received / total));
          }
        });
        if (!isClosed) {
          saveBytes(file.bytes, file.filename, mimeType: file.mimeType);
        }
      } else if (upload != null) {
        await upload(token, (sent, total) {
          if (!isClosed && total > 0) {
            emit(state.copyWith(transferProgress: sent / total));
          }
        });
      }
    } on DioException catch (error) {
      if (!CancelToken.isCancel(error) && !isClosed) {
        emit(state.copyWith(error: error.message ?? 'Transfer failed.'));
      }
    } on ApiException catch (error) {
      if (!isClosed) emit(state.copyWith(error: error.message));
    } catch (error) {
      if (!isClosed) emit(state.copyWith(error: '$error'));
    } finally {
      _transfer = null;
      if (!isClosed) emit(state.copyWith(busy: false, clearTransfer: true));
    }
  }

  void cancelTransfer() => _transfer?.cancel('Cancelled by user');

  void reportError(String message) {
    if (!isClosed) emit(state.copyWith(error: message));
  }

  @override
  Future<void> close() {
    _resourceTimer?.cancel();
    _backupTimer?.cancel();
    _transfer?.cancel('Server view closed');
    return super.close();
  }
}
