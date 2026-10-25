import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../api/api_exception.dart';
import '../../api/peo_api.dart';
import '../../models/server_console.dart';
import '../../state/server_workspace_cubit.dart';
import '../../state/session_cubit.dart';
import 'order_pages.dart' show ServerManagementPage;
import '../../widgets/console_output.dart';
import '../../widgets/local_file.dart';
import '../../widgets/terminal_socket.dart';
import '../../widgets/server_resource_panel.dart';

class ServerWorkspacePage extends StatelessWidget {
  const ServerWorkspacePage({
    super.key,
    required this.serverId,
    required this.tab,
  });
  final String serverId;
  final String tab;

  static const tabs = <String>[
    'console',
    'files',
    'backups',
    'startup',
    'manage',
  ];

  @override
  Widget build(BuildContext context) =>
      _WorkspaceView(serverId: serverId, initialTab: tab);
}

class _WorkspaceView extends StatefulWidget {
  const _WorkspaceView({required this.serverId, required this.initialTab});
  final String serverId;
  final String initialTab;

  @override
  State<_WorkspaceView> createState() => _WorkspaceViewState();
}

class _WorkspaceViewState extends State<_WorkspaceView>
    with SingleTickerProviderStateMixin {
  late int _selectedIndex;
  bool _filesLoaded = false;
  late final AnimationController _contentTransition;
  late final Animation<double> _contentOffset;

  @override
  void initState() {
    super.initState();
    _contentTransition = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 180),
      value: 1,
    );
    _contentOffset = Tween<double>(
      begin: 6,
      end: 0,
    ).chain(CurveTween(curve: Curves.easeOutCubic)).animate(_contentTransition);
    final selected = ServerWorkspacePage.tabs.indexOf(widget.initialTab);
    _selectedIndex = selected < 0 ? 0 : selected;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted && _selectedIndex == 1) {
        _filesLoaded = true;
        context.read<ServerWorkspaceCubit>().loadFiles();
      }
    });
  }

  @override
  void didUpdateWidget(covariant _WorkspaceView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.initialTab == widget.initialTab) return;
    final selected = ServerWorkspacePage.tabs.indexOf(widget.initialTab);
    if (selected < 0 || selected == _selectedIndex) return;
    setState(() {
      _selectedIndex = selected;
    });
    if (MediaQuery.disableAnimationsOf(context)) {
      _contentTransition.value = 1;
    } else {
      _contentTransition.forward(from: 0);
    }
    if (selected == 1 && !_filesLoaded) {
      _filesLoaded = true;
      unawaited(context.read<ServerWorkspaceCubit>().loadFiles());
    }
  }

  @override
  void dispose() {
    _contentTransition.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = context.watch<ServerWorkspaceCubit>().state;
    final compact = MediaQuery.sizeOf(context).width < 600;
    final serverName = state.console?.server.name.isNotEmpty == true
        ? state.console!.server.name
        : 'Server';
    final status = state.console?.server.suspended == true
        ? 'suspended'
        : state.resources?.currentState ??
              state.console?.server.status ??
              'unknown';
    final normalizedStatus = status.toLowerCase();
    final (statusIcon, statusColor) = switch (normalizedStatus) {
      'running' || 'online' => (Icons.check_circle, Colors.green.shade700),
      'starting' ||
      'installing' => (Icons.hourglass_top, Colors.orange.shade800),
      'stopping' => (Icons.pause_circle_outline, Colors.orange.shade800),
      'offline' || 'stopped' => (Icons.power_off, Colors.red.shade700),
      'suspended' => (Icons.block, Colors.red.shade700),
      _ => (Icons.help_outline, Colors.blueGrey.shade600),
    };
    final currentTab = ServerWorkspacePage.tabs[_selectedIndex];
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.fromLTRB(
            compact ? 16 : 24,
            20,
            compact ? 16 : 24,
            8,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 40,
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextButton(
                        onPressed: () => context.go('/console'),
                        child: const Text('Server List'),
                      ),
                      const Icon(Icons.chevron_right, size: 18),
                      Tooltip(
                        message: serverName,
                        child: ConstrainedBox(
                          constraints: const BoxConstraints(maxWidth: 280),
                          child: Text(
                            serverName,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),
                      const Icon(Icons.chevron_right, size: 18),
                      Text(_workspaceLabel(currentTab)),
                    ],
                  ),
                ),
              ),
              Row(
                children: [
                  Expanded(
                    child: Tooltip(
                      message: serverName,
                      child: Text(
                        serverName,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                    ),
                  ),
                  Chip(
                    avatar: Icon(statusIcon, size: 16, color: statusColor),
                    backgroundColor: statusColor.withValues(alpha: .12),
                    label: Text(_prettyStatus(status)),
                  ),
                ],
              ),
            ],
          ),
        ),
        if (state.error.isNotEmpty)
          MaterialBanner(
            content: Text(state.error),
            actions: [
              TextButton(
                onPressed: () {
                  final cubit = context.read<ServerWorkspaceCubit>();
                  if (_selectedIndex == 1) {
                    unawaited(cubit.loadFiles());
                  } else if (_selectedIndex == 2) {
                    unawaited(cubit.loadBackups());
                  } else {
                    unawaited(cubit.load());
                  }
                },
                child: const Text('Retry'),
              ),
            ],
          ),
        Expanded(
          child: Stack(
            fit: StackFit.expand,
            children: [
              AnimatedBuilder(
                animation: _contentOffset,
                child: IndexedStack(
                  index: _selectedIndex,
                  children: [
                    _ConsoleTab(serverId: widget.serverId),
                    _FilesTab(serverId: widget.serverId),
                    _BackupsTab(serverId: widget.serverId),
                    _StartupTab(serverId: widget.serverId),
                    _ManageTab(serverId: widget.serverId),
                  ],
                ),
                builder: (context, child) => Transform.translate(
                  key: const ValueKey('server-workspace-content'),
                  offset: Offset(
                    0,
                    MediaQuery.disableAnimationsOf(context)
                        ? 0
                        : _contentOffset.value,
                  ),
                  child: child,
                ),
              ),
              if (state.console == null && state.loading)
                const Positioned.fill(child: _WorkspaceSkeleton()),
            ],
          ),
        ),
      ],
    );
  }
}

String _prettyStatus(String status) => status
    .replaceAll('_', ' ')
    .split(' ')
    .map(
      (part) =>
          part.isEmpty ? part : '${part[0].toUpperCase()}${part.substring(1)}',
    )
    .join(' ');

class _WorkspaceSkeleton extends StatelessWidget {
  const _WorkspaceSkeleton();

  @override
  Widget build(BuildContext context) => ColoredBox(
    color: Theme.of(context).scaffoldBackgroundColor,
    child: Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(
            height: 18,
            width: 220,
            child: LinearProgressIndicator(),
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              for (var i = 0; i < 3; i++) ...[
                Expanded(
                  child: Container(
                    height: 76,
                    decoration: BoxDecoration(
                      color: Theme.of(context)
                          .colorScheme
                          .surfaceContainerHighest,
                      borderRadius: BorderRadius.circular(6),
                    ),
                  ),
                ),
                if (i < 2) const SizedBox(width: 12),
              ],
            ],
          ),
          const SizedBox(height: 20),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: const Color(0xff101820),
                borderRadius: BorderRadius.circular(6),
              ),
            ),
          ),
        ],
      ),
    ),
  );
}

String _workspaceLabel(String tab) => switch (tab) {
  'console' => 'Console',
  'files' => 'Files',
  'backups' => 'Backups',
  'startup' => 'Startup',
  'manage' => 'Manage',
  _ => 'Console',
};

class _ConsoleTab extends StatefulWidget {
  const _ConsoleTab({required this.serverId});
  final String serverId;
  @override
  State<_ConsoleTab> createState() => _ConsoleTabState();
}

class _ConsoleTabState extends State<_ConsoleTab> {
  final _command = TextEditingController();
  final _scroll = ScrollController();
  final List<String> _lines = [];
  final List<String> _history = [];
  TerminalSocket? _socket;
  Timer? _retryTimer;
  int _retry = 0;
  int _historyIndex = 0;
  bool _connecting = false;
  bool _autoFollow = true;
  bool _hasNewOutput = false;
  bool _expanded = false;
  String _connectionError = '';
  late String _historyKey;
  String _currentLine = '';
  int _cursor = 0;

  @override
  void initState() {
    super.initState();
    final userId = context.read<SessionCubit>().state.user?.id ?? 'session';
    _historyKey = 'server.$userId.${widget.serverId}.commands';
    _scroll.addListener(_updateFollowState);
    unawaited(_loadHistory());
    unawaited(_connect());
  }

  Future<void> _loadHistory() async {
    final preferences = await SharedPreferences.getInstance();
    if (!mounted) return;
    _history.addAll(preferences.getStringList(_historyKey) ?? const []);
    _historyIndex = _history.length;
  }

  Future<void> _connect() async {
    if (!mounted || _connecting) return;
    setState(() {
      _connecting = true;
      _socketConnected = false;
      _connectionError = '';
    });
    try {
      final api = context.read<PeoApi>();
      final ticket = await api.serverTerminalTicket(widget.serverId);
      if (!mounted) return;
      final configured = Uri.parse(api.client.dio.options.baseUrl);
      final resolved = configured.hasAuthority
          ? configured
          : Uri.base.resolveUri(configured);
      final uri = Uri(
        scheme: resolved.scheme == 'https' ? 'wss' : 'ws',
        host: resolved.host,
        port: resolved.hasPort ? resolved.port : null,
        path: '${resolved.path}/servers/${widget.serverId}/terminal',
        queryParameters: {'ticket': ticket.ticket},
      );
      _socket = TerminalSocket(uri.toString(), _opened, _receive, _closed);
    } on ApiException catch (error) {
      if (mounted) {
        setState(() {
          _socketConnected = false;
          _connectionError = error.message;
        });
      }
      _scheduleReconnect();
    } catch (error) {
      if (mounted) {
        setState(() {
          _socketConnected = false;
          _connectionError = '$error';
        });
      }
      _scheduleReconnect();
    } finally {
      if (mounted) setState(() => _connecting = false);
    }
  }

  void _receive(String text) {
    if (!mounted) return;
    var output = '';
    try {
      final event = jsonDecode(text);
      if (event is Map &&
          event['event'] == 'console output' &&
          event['args'] is List) {
        output = consoleOutputText(event);
        if (output.isEmpty) return;
      } else if (event is Map && event['event'] == 'token expiring') {
        _socket?.close();
        return;
      } else {
        return;
      }
    } catch (_) {
      return;
    }
    setState(() {
      for (final char in output.split('')) {
        if (char == '\r') {
          _cursor = 0;
        } else if (char == '\n') {
          _lines.add(_currentLine);
          _currentLine = '';
          _cursor = 0;
          if (_lines.length > 500) _lines.removeAt(0);
        } else if (_cursor < _currentLine.length) {
          _currentLine =
              '${_currentLine.substring(0, _cursor)}$char${_currentLine.substring(_cursor + 1)}';
          _cursor++;
        } else {
          _currentLine += char;
          _cursor++;
        }
      }
      if (!_autoFollow) _hasNewOutput = true;
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_autoFollow && _scroll.hasClients) {
        _scroll.jumpTo(_scroll.position.maxScrollExtent);
      }
    });
  }

  void _updateFollowState() {
    if (!_scroll.hasClients) return;
    final atBottom =
        _scroll.position.maxScrollExtent - _scroll.position.pixels < 48;
    if (atBottom != _autoFollow || (atBottom && _hasNewOutput)) {
      setState(() {
        _autoFollow = atBottom;
        if (atBottom) _hasNewOutput = false;
      });
    }
  }

  void _opened() {
    if (!mounted) return;
    _retry = 0;
    setState(() {
      _connecting = false;
      _socketConnected = true;
      _connectionError = '';
    });
  }

  bool _socketConnected = false;

  void _closed() {
    if (!mounted) return;
    setState(() {
      _socketConnected = false;
      _connectionError = 'Connection closed';
    });
    _scheduleReconnect();
  }

  void _scheduleReconnect() {
    if (!mounted || _retryTimer != null) return;
    final seconds = (1 << _retry.clamp(0, 5)).clamp(1, 30);
    _retry++;
    _retryTimer = Timer(Duration(seconds: seconds), () {
      _retryTimer = null;
      unawaited(_connect());
    });
  }

  Future<void> _sendCommand() async {
    final command = _command.text.trim();
    if (command.isEmpty) return;
    final cubit = context.read<ServerWorkspaceCubit>();
    await cubit.run(
      () => context.read<PeoApi>().sendServerCommand(widget.serverId, command),
    );
    if (!mounted || cubit.state.error.isNotEmpty) return;
    _history.remove(command);
    _history.add(command);
    if (_history.length > 100) _history.removeAt(0);
    _historyIndex = _history.length;
    final preferences = await SharedPreferences.getInstance();
    await preferences.setStringList(_historyKey, _history);
    _command.clear();
  }

  @override
  void dispose() {
    _retryTimer?.cancel();
    _socket?.close();
    _scroll.removeListener(_updateFollowState);
    _command.dispose();
    _scroll.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final workspace = context.watch<ServerWorkspaceCubit>();
    final state = workspace.state;
    final console = state.console;
    final status =
        state.resources?.currentState ?? console?.server.status ?? 'unknown';
    final viewport = MediaQuery.sizeOf(context);
    final compact = viewport.width < 600;
    final logHeight = compact && !_expanded
        ? 320.0
        : _expanded
        ? (viewport.height - 330).clamp(compact ? 320.0 : 360.0, 640.0)
        : (viewport.height * .48).clamp(360.0, 640.0);
    final terminal = Container(
      height: logHeight + 136,
      decoration: BoxDecoration(
        color: const Color(0xff101820),
        borderRadius: BorderRadius.circular(6),
      ),
      padding: const EdgeInsets.all(12),
      child: Column(
        children: [
          Row(
            children: [
              const Icon(Icons.terminal, size: 18, color: Color(0xffd3dce5)),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  _socketConnected
                      ? 'Terminal connected'
                      : _connectionError.isNotEmpty
                      ? 'Reconnecting'
                      : 'Connecting',
                  style: const TextStyle(color: Color(0xffd3dce5)),
                ),
              ),
              IconButton(
                tooltip: 'Clear visible output',
                onPressed: () => setState(() {
                  _lines.clear();
                  _currentLine = '';
                }),
                icon: const Icon(
                  Icons.delete_sweep_outlined,
                  color: Color(0xffd3dce5),
                ),
              ),
              IconButton(
                tooltip: _expanded ? 'Restore layout' : 'Expand terminal',
                onPressed: () => setState(() => _expanded = !_expanded),
                icon: Icon(
                  _expanded ? Icons.close_fullscreen : Icons.open_in_full,
                  color: const Color(0xffd3dce5),
                ),
              ),
            ],
          ),
          if (_connectionError.isNotEmpty)
            Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 6),
                child: Text(
                  _connectionError,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Color(0xffffb4ab),
                    fontSize: 12,
                  ),
                ),
              ),
            ),
          Expanded(
            child: Stack(
              children: [
                SelectionArea(
                  child: ListView(
                    controller: _scroll,
                    children: [
                      for (final line in [..._lines, _currentLine])
                        RichText(
                          text: _ansi(line),
                          textScaler: const TextScaler.linear(0.9),
                          softWrap: true,
                        ),
                    ],
                  ),
                ),
                if (!_autoFollow)
                  Positioned(
                    right: 8,
                    bottom: 8,
                    child: FilledButton.tonalIcon(
                      onPressed: () {
                        if (_scroll.hasClients) {
                          _scroll.jumpTo(_scroll.position.maxScrollExtent);
                        }
                        setState(() {
                          _autoFollow = true;
                          _hasNewOutput = false;
                        });
                      },
                      icon: const Icon(Icons.arrow_downward),
                      label: Text(_hasNewOutput ? 'New output' : 'Latest'),
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: Shortcuts(
                  shortcuts: {
                    LogicalKeySet(LogicalKeyboardKey.arrowUp):
                        const _HistoryIntent(-1),
                    LogicalKeySet(LogicalKeyboardKey.arrowDown):
                        const _HistoryIntent(1),
                  },
                  child: Actions(
                    actions: {
                      _HistoryIntent: CallbackAction<_HistoryIntent>(
                        onInvoke: (intent) {
                          if (_history.isNotEmpty) {
                            _historyIndex = (_historyIndex + intent.delta)
                                .clamp(0, _history.length);
                            _command.text = _historyIndex == _history.length
                                ? ''
                                : _history[_historyIndex];
                          }
                          return null;
                        },
                      ),
                    },
                    child: TextField(
                      controller: _command,
                      onSubmitted: (_) => unawaited(_sendCommand()),
                      style: const TextStyle(color: Color(0xffeef3f7)),
                      decoration: const InputDecoration(
                        prefixText: '> ',
                        hintText: 'Enter a command',
                        filled: true,
                        fillColor: Color(0xff202b36),
                        hintStyle: TextStyle(color: Color(0xff9eacb9)),
                        border: OutlineInputBorder(borderSide: BorderSide.none),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              IconButton.filled(
                tooltip: 'Send command',
                onPressed: _sendCommand,
                icon: const Icon(Icons.send),
              ),
            ],
          ),
        ],
      ),
    );
    final resources = ServerResourcePanel(
      points: state.points,
      usage: state.resources?.resources,
      limits: console?.limits,
      updatedAt: workspace.state.resourceUpdatedAt,
      staleMessage: workspace.state.resourceError,
    );
    return LayoutBuilder(
      builder: (context, constraints) => ListView(
        padding: EdgeInsets.fromLTRB(
          compact ? 16 : 24,
          8,
          compact ? 16 : 24,
          24,
        ),
        children: [
          Wrap(
            spacing: 10,
            runSpacing: 8,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              if (console?.server.suspended == true)
                const Chip(label: Text('Suspended')),
              if (console?.server.installing == true)
                const Chip(label: Text('Installing')),
              for (final signal in ['start', 'stop', 'restart'])
                FilledButton.tonal(
                  onPressed: state.busy ? null : () => _power(signal),
                  child: Text(signal.toUpperCase()),
                ),
              PopupMenuButton<String>(
                tooltip: 'More server actions',
                onSelected: _power,
                itemBuilder: (_) => const [
                  PopupMenuItem(value: 'kill', child: Text('Force stop')),
                ],
                icon: const Icon(Icons.more_vert),
              ),
            ],
          ),
          const SizedBox(height: 12),
          if (_expanded)
            terminal
          else if (constraints.maxWidth >= 960) ...[
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(child: terminal),
                const SizedBox(width: 16),
                SizedBox(
                  width: 220,
                  child: ServerResourcePanel(
                    points: state.points,
                    usage: state.resources?.resources,
                    limits: console?.limits,
                    updatedAt: workspace.state.resourceUpdatedAt,
                    staleMessage: workspace.state.resourceError,
                    showSummary: true,
                    showCharts: false,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            ServerResourcePanel(
              points: state.points,
              usage: state.resources?.resources,
              limits: console?.limits,
              updatedAt: workspace.state.resourceUpdatedAt,
              staleMessage: workspace.state.resourceError,
              showSummary: false,
              showCharts: true,
            ),
          ] else ...[
            terminal,
            const SizedBox(height: 12),
            resources,
          ],
          if (state.error.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Text(
                state.error,
                style: TextStyle(color: Theme.of(context).colorScheme.error),
              ),
            ),
          if (status == 'offline' && console?.server.installing == true)
            const Text(
              'The server is being installed; panel actions may be unavailable.',
            ),
        ],
      ),
    );
  }

  Future<void> _power(String signal) async {
    if (signal != 'start') {
      final accepted = await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(
            '${signal == 'kill' ? 'Force stop' : signal[0].toUpperCase() + signal.substring(1)} server?',
          ),
          content: Text(
            signal == 'kill'
                ? 'This immediately terminates the server process.'
                : 'Confirm sending the $signal signal to this server.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text('Confirm'),
            ),
          ],
        ),
      );
      if (accepted != true || !mounted) return;
    }
    final cubit = context.read<ServerWorkspaceCubit>();
    final api = context.read<PeoApi>();
    await cubit.run(() => api.serverPower(widget.serverId, signal));
    if (mounted) await cubit.refreshResources();
  }
}

class _HistoryIntent extends Intent {
  const _HistoryIntent(this.delta);
  final int delta;
}

TextSpan _ansi(String input) {
  final spans = <TextSpan>[];
  final pattern = RegExp(r'\x1B\[([0-9;]*)m');
  var cursor = 0;
  var color = const Color(0xffd3dce5);
  var bold = false;
  for (final match in pattern.allMatches(input)) {
    if (match.start > cursor) {
      spans.add(
        TextSpan(
          text: input.substring(cursor, match.start),
          style: TextStyle(
            color: color,
            fontWeight: bold ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      );
    }
    final codes = (match.group(1) ?? '')
        .split(';')
        .map((value) => int.tryParse(value) ?? 0);
    for (final code in codes) {
      if (code == 0) {
        color = const Color(0xffd3dce5);
        bold = false;
      } else if (code == 1) {
        bold = true;
      } else if (code >= 30 && code <= 37) {
        color = _ansiColors[code - 30];
      } else if (code >= 90 && code <= 97) {
        color = _ansiColors[code - 90].withValues(alpha: .7);
      }
    }
    cursor = match.end;
  }
  if (cursor < input.length) {
    spans.add(
      TextSpan(
        text: input.substring(cursor),
        style: TextStyle(
          color: color,
          fontWeight: bold ? FontWeight.bold : FontWeight.normal,
        ),
      ),
    );
  }
  return TextSpan(children: spans);
}

const _ansiColors = <Color>[
  Color(0xff263238),
  Color(0xffef5350),
  Color(0xff66bb6a),
  Color(0xffffca28),
  Color(0xff42a5f5),
  Color(0xffab47bc),
  Color(0xff26a69a),
  Color(0xffeceff1),
];

String _bytes(int value) {
  if (value < 1024) return '$value B';
  if (value < 1024 * 1024) return '${(value / 1024).toStringAsFixed(1)} KiB';
  if (value < 1024 * 1024 * 1024) {
    return '${(value / 1024 / 1024).toStringAsFixed(1)} MiB';
  }
  return '${(value / 1024 / 1024 / 1024).toStringAsFixed(1)} GiB';
}

class _FilesTab extends StatefulWidget {
  const _FilesTab({required this.serverId});
  final String serverId;
  @override
  State<_FilesTab> createState() => _FilesTabState();
}

class _FilesTabState extends State<_FilesTab> {
  @override
  Widget build(BuildContext context) {
    final cubit = context.read<ServerWorkspaceCubit>();
    final state = context.watch<ServerWorkspaceCubit>().state;
    final parent = state.directory == '/'
        ? null
        : state.directory
              .replaceFirst(RegExp(r'/?[^/]+/?$'), '')
              .replaceAll(RegExp(r'/$'), '');
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(
              height: 40,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: _directoryBreadcrumbs(state.directory),
                ),
              ),
            ),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                IconButton(
                  tooltip: 'Refresh files',
                  onPressed: () => cubit.loadFiles(),
                  icon: const Icon(Icons.refresh),
                ),
                OutlinedButton.icon(
                  onPressed: state.busy ? null : _upload,
                  icon: const Icon(Icons.upload_file),
                  label: const Text('Upload'),
                ),
                OutlinedButton.icon(
                  onPressed: () => _newItem(isDirectory: true),
                  icon: const Icon(Icons.create_new_folder_outlined),
                  label: const Text('New folder'),
                ),
                OutlinedButton.icon(
                  onPressed: () => _newItem(isDirectory: false),
                  icon: const Icon(Icons.note_add_outlined),
                  label: const Text('New text file'),
                ),
              ],
            ),
          ],
        ),
        if (state.transferProgress != null)
          _TransferProgress(
            label: state.transferLabel,
            progress: state.transferProgress!,
            onCancel: cubit.cancelTransfer,
          ),
        if (state.loading) const LinearProgressIndicator(),
        if (parent != null)
          ListTile(
            leading: const Icon(Icons.arrow_upward),
            title: const Text('Parent directory'),
            onTap: () => cubit.loadFiles(parent.isEmpty ? '/' : parent),
          ),
        LayoutBuilder(
          builder: (context, constraints) => constraints.maxWidth < 680
              ? const SizedBox.shrink()
              : Container(
                  height: 40,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(
                    color: Theme.of(context)
                        .colorScheme
                        .surfaceContainerHighest,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: const Row(
                    children: [
                      Expanded(flex: 5, child: Text('Name')),
                      Expanded(flex: 2, child: Text('Size')),
                      Expanded(flex: 3, child: Text('Modified')),
                      SizedBox(width: 48),
                    ],
                  ),
                ),
        ),
        for (final file in state.files)
          LayoutBuilder(
            builder: (context, constraints) => constraints.maxWidth < 680
                ? ListTile(
                    leading: Icon(
                      file.isFile
                          ? Icons.insert_drive_file_outlined
                          : Icons.folder_outlined,
                    ),
                    title: Text(file.name),
                    subtitle: Text(
                      '${file.mode} · ${file.isFile ? _bytes(file.size) : 'Directory'} · ${file.modifiedAt}',
                    ),
                    onTap: file.isEditable && file.isFile
                        ? () => _openEditor(file)
                        : file.isFile
                        ? null
                        : () => cubit.loadFiles(
                            _joinPath(state.directory, file.name),
                          ),
                    trailing: PopupMenuButton<String>(
                      tooltip: 'File actions',
                      onSelected: (action) => _fileAction(file, action),
                      itemBuilder: (_) => [
                        if (file.isFile)
                          const PopupMenuItem(
                            value: 'download',
                            child: Text('Download'),
                          ),
                        if (file.isEditable && file.isFile)
                          const PopupMenuItem(
                            value: 'edit',
                            child: Text('Edit text'),
                          ),
                        const PopupMenuItem(
                          value: 'rename',
                          child: Text('Move or rename'),
                        ),
                        if (file.isFile)
                          const PopupMenuItem(
                            value: 'copy',
                            child: Text('Copy'),
                          ),
                        if (file.isFile)
                          const PopupMenuItem(
                            value: 'compress',
                            child: Text('Compress'),
                          ),
                        const PopupMenuItem(
                          value: 'decompress',
                          child: Text('Extract archive'),
                        ),
                        const PopupMenuItem(
                          value: 'chmod',
                          child: Text('Change permissions'),
                        ),
                        const PopupMenuItem(
                          value: 'delete',
                          child: Text('Delete'),
                        ),
                      ],
                    ),
                  )
                : Container(
                    constraints: const BoxConstraints(minHeight: 48),
                    padding: const EdgeInsets.only(left: 16, right: 4),
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                          color: Theme.of(context).dividerColor,
                        ),
                      ),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          flex: 5,
                          child: InkWell(
                            onTap: file.isEditable && file.isFile
                                ? () => _openEditor(file)
                                : file.isFile
                                ? null
                                : () => cubit.loadFiles(
                                    _joinPath(state.directory, file.name),
                                  ),
                            child: Row(
                              children: [
                                Icon(
                                  file.isFile
                                      ? Icons.insert_drive_file_outlined
                                      : Icons.folder_outlined,
                                  size: 20,
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Text(
                                    file.name,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 2,
                          child: Text(file.isFile ? _bytes(file.size) : '—'),
                        ),
                        Expanded(
                          flex: 3,
                          child: Text(
                            file.modifiedAt,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        SizedBox(
                          width: 48,
                          child: PopupMenuButton<String>(
                            tooltip: 'File actions',
                            onSelected: (action) => _fileAction(file, action),
                            itemBuilder: (_) => _fileActionItems(file),
                          ),
                        ),
                      ],
                    ),
                  ),
          ),
      ],
    );
  }

  List<PopupMenuEntry<String>> _fileActionItems(ServerFile file) => [
    if (file.isFile)
      const PopupMenuItem(value: 'download', child: Text('Download')),
    if (file.isEditable && file.isFile)
      const PopupMenuItem(value: 'edit', child: Text('Edit text')),
    const PopupMenuItem(value: 'rename', child: Text('Move or rename')),
    if (file.isFile) const PopupMenuItem(value: 'copy', child: Text('Copy')),
    if (file.isFile)
      const PopupMenuItem(value: 'compress', child: Text('Compress')),
    const PopupMenuItem(value: 'decompress', child: Text('Extract archive')),
    const PopupMenuItem(value: 'chmod', child: Text('Change permissions')),
    const PopupMenuItem(value: 'delete', child: Text('Delete')),
  ];

  Future<void> _upload() async {
    (String, Uint8List)? picked;
    try {
      picked = await pickLocalFile();
    } catch (error) {
      if (mounted) {
        context.read<ServerWorkspaceCubit>().reportError('$error');
      }
      return;
    }
    if (picked == null || !mounted) return;
    final (name, bytes) = picked;
    final cubit = context.read<ServerWorkspaceCubit>();
    await cubit.transfer(
      label: 'Uploading $name',
      upload: (token, progress) => cubit.api.uploadServerFile(
        widget.serverId,
        cubit.state.directory,
        name,
        bytes,
        cancelToken: token,
        onProgress: progress,
      ),
    );
    if (mounted && cubit.state.error.isEmpty) await cubit.loadFiles();
  }

  List<Widget> _directoryBreadcrumbs(String directory) {
    final segments = directory
        .split('/')
        .where((part) => part.isNotEmpty)
        .toList();
    final result = <Widget>[
      TextButton(
        onPressed: () => context.read<ServerWorkspaceCubit>().loadFiles('/'),
        child: const Text('/'),
      ),
    ];
    var path = '';
    for (var i = 0; i < segments.length; i++) {
      path = '$path/${segments[i]}';
      result.add(const Icon(Icons.chevron_right, size: 18));
      final target = path;
      result.add(
        TextButton(
          onPressed: () =>
              context.read<ServerWorkspaceCubit>().loadFiles(target),
          child: Text(
            segments[i],
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      );
    }
    return result;
  }

  Future<void> _newItem({required bool isDirectory}) async {
    final name = await _textPrompt(isDirectory ? 'Folder name' : 'File name');
    if (name == null || name.trim().isEmpty || !mounted) return;
    final cubit = context.read<ServerWorkspaceCubit>();
    final directory = cubit.state.directory;
    if (isDirectory) {
      await cubit.run(
        () => cubit.api.serverFileOperation(widget.serverId, 'mkdir', {
          'root': directory,
          'name': name.trim(),
        }),
        reloadFiles: true,
      );
    } else {
      await cubit.run(
        () => cubit.api.writeServerFile(
          widget.serverId,
          _joinPath(directory, name.trim()),
          '',
        ),
        reloadFiles: true,
      );
      if (mounted && cubit.state.error.isEmpty) {
        _openEditorPath(_joinPath(directory, name.trim()));
      }
    }
  }

  Future<void> _fileAction(ServerFile file, String action) async {
    final cubit = context.read<ServerWorkspaceCubit>();
    final root = cubit.state.directory;
    final path = _joinPath(root, file.name);
    if (action == 'edit') return _openEditor(file);
    if (action == 'download') {
      await cubit.transfer(
        label: 'Downloading ${file.name}',
        upload: null,
        download: (token, progress) => cubit.api.downloadServerFile(
          widget.serverId,
          path,
          cancelToken: token,
          onProgress: progress,
        ),
      );
      return;
    }
    if (action == 'rename') {
      final destination = await _textPrompt(
        'New absolute server path',
        initial: path,
      );
      if (destination == null || destination.trim().isEmpty || !mounted) return;
      if (!destination.trim().startsWith('/')) {
        cubit.reportError('Enter an absolute server path starting with /.');
        return;
      }
      await _confirm(
        'Move ${file.name}?',
        'Move it to ${destination.trim()}?',
        () => cubit.run(
          () => cubit.api.serverFileOperation(widget.serverId, 'rename', {
            'root': '/',
            'files': [
              {'from': path, 'to': destination.trim()},
            ],
          }),
          reloadFiles: true,
        ),
      );
      return;
    }
    if (action == 'copy') {
      await _confirm(
        'Copy ${file.name}?',
        'Create a copy of $path in the current directory?',
        () => cubit.run(
          () => cubit.api.serverFileOperation(widget.serverId, 'copy', {
            'location': path,
          }),
          reloadFiles: true,
        ),
      );
      return;
    }
    if (action == 'compress') {
      await _confirm(
        'Compress ${file.name}?',
        'Create an archive from this file?',
        () => cubit.run(
          () => cubit.api.serverFileOperation(widget.serverId, 'compress', {
            'root': root,
            'files': [file.name],
          }),
          reloadFiles: true,
        ),
      );
      return;
    }
    if (action == 'decompress') {
      await _confirm(
        'Extract ${file.name}?',
        'Extract archive contents into $root?',
        () => cubit.run(
          () => cubit.api.serverFileOperation(widget.serverId, 'decompress', {
            'root': root,
            'file': file.name,
          }),
          reloadFiles: true,
        ),
      );
      return;
    }
    if (action == 'chmod') {
      final mode = await _textPrompt(
        'Permissions (octal)',
        initial: file.modeBits,
      );
      if (mode == null || int.tryParse(mode, radix: 8) == null || !mounted) {
        return;
      }
      await cubit.run(
        () => cubit.api.serverFileOperation(widget.serverId, 'chmod', {
          'root': root,
          'files': [
            {'file': file.name, 'mode': mode.trim().padLeft(4, '0')},
          ],
        }),
        reloadFiles: true,
      );
      return;
    }
    if (action == 'delete') {
      await _confirm(
        'Delete ${file.name}?',
        'This permanently removes ${file.name}.',
        () => cubit.run(
          () => cubit.api.serverFileOperation(widget.serverId, 'delete', {
            'root': root,
            'files': [file.name],
          }),
          reloadFiles: true,
        ),
      );
    }
  }

  void _openEditor(ServerFile file) {
    final cubit = context.read<ServerWorkspaceCubit>();
    if (!file.isEditable || !file.isFile) return;
    if (file.size > 2 * 1024 * 1024) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('This file exceeds the 2 MiB editor limit.'),
        ),
      );
      return;
    }
    _openEditorPath(_joinPath(cubit.state.directory, file.name));
  }

  void _openEditorPath(String path) {
    context.go(
      Uri(
        path: '/servers/${widget.serverId}/editor',
        queryParameters: {'path': path},
      ).toString(),
    );
  }

  Future<String?> _textPrompt(String title, {String initial = ''}) async {
    final controller = TextEditingController(text: initial);
    final value = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: TextField(controller: controller, autofocus: true),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, controller.text),
            child: const Text('Continue'),
          ),
        ],
      ),
    );
    controller.dispose();
    return value;
  }

  Future<void> _confirm(
    String title,
    String message,
    Future<void> Function() action,
  ) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Confirm'),
          ),
        ],
      ),
    );
    if (result == true && mounted) await action();
  }
}

String _joinPath(String directory, String name) =>
    directory == '/' ? '/$name' : '$directory/$name';

class _BackupsTab extends StatelessWidget {
  const _BackupsTab({required this.serverId});
  final String serverId;
  @override
  Widget build(BuildContext context) {
    final cubit = context.read<ServerWorkspaceCubit>();
    final state = context.watch<ServerWorkspaceCubit>().state;
    final limit = state.console?.limits.backups ?? 0;
    final active = state.backups.where(backupIsActive).length;
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        Wrap(
          spacing: 10,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            Text(
              '${state.backups.length}${limit > 0 ? ' / $limit' : ''} backups',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            FilledButton.icon(
              onPressed:
                  state.busy || (limit >= 0 && state.backups.length >= limit)
                  ? null
                  : () => cubit.run(
                      () => cubit.api.createServerBackup(serverId),
                      reloadBackups: true,
                    ),
              icon: const Icon(Icons.add),
              label: const Text('Create backup'),
            ),
            IconButton(
              tooltip: 'Refresh backups',
              onPressed: cubit.loadBackups,
              icon: const Icon(Icons.refresh),
            ),
          ],
        ),
        if (active > 0) const LinearProgressIndicator(),
        if (state.transferProgress != null)
          _TransferProgress(
            label: state.transferLabel,
            progress: state.transferProgress!,
            onCancel: cubit.cancelTransfer,
          ),
        for (final backup in state.backups)
          LayoutBuilder(
            builder: (context, constraints) {
              final actions = _backupActions(context, cubit, state, backup);
              final backupStatus = _backupStatus(backup);
              final statusIcon = backupIsActive(backup)
                  ? Icons.sync
                  : backupStatus == 'Completed'
                  ? Icons.check_circle_outline
                  : Icons.error_outline;
              final statusColor = backupIsActive(backup)
                  ? Colors.orange.shade800
                  : backupStatus == 'Completed'
                  ? Colors.green.shade700
                  : Colors.red.shade700;
              final details = Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '$backupStatus · ${_bytes(backup.bytes)} · ${_backupDate(backup.createdAt)}',
                  ),
                  if (backup.checksum.isNotEmpty)
                    Text(
                      backup.checksum,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  if (backupIsActive(backup))
                    LinearProgressIndicator(
                      value: backup.progress > 0
                          ? (backup.progress / 100).clamp(0, 1)
                          : null,
                    ),
                ],
              );
              final title = backup.name.isNotEmpty ? backup.name : backup.uuid;
              if (constraints.maxWidth < 600) {
                return Card(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(16, 12, 8, 4),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(right: 12, top: 2),
                              child: Icon(statusIcon, color: statusColor),
                            ),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(title, softWrap: true),
                                  const SizedBox(height: 4),
                                  details,
                                ],
                              ),
                            ),
                          ],
                        ),
                        Align(alignment: Alignment.centerRight, child: actions),
                      ],
                    ),
                  ),
                );
              }
              return Card(
                child: ListTile(
                  leading: Icon(statusIcon, color: statusColor),
                  title: Text(title),
                  subtitle: details,
                  isThreeLine: backup.checksum.isNotEmpty,
                  trailing: actions,
                ),
              );
            },
          ),
      ],
    );
  }

  Widget _backupActions(
    BuildContext context,
    ServerWorkspaceCubit cubit,
    ServerWorkspaceState state,
    ServerBackup backup,
  ) => Wrap(
    spacing: 0,
    children: [
      IconButton(
        tooltip: 'Download backup',
        onPressed: !backup.completed || state.busy
            ? null
            : () => cubit.transfer(
                label: 'Downloading ${backup.name}',
                upload: null,
                download: (token, progress) => cubit.api.downloadServerBackup(
                  serverId,
                  backup.uuid,
                  cancelToken: token,
                  onProgress: progress,
                ),
              ),
        icon: const Icon(Icons.download_outlined),
      ),
      IconButton(
        tooltip: backup.locked ? 'Unlock backup' : 'Lock backup',
        onPressed: state.busy
            ? null
            : () => cubit.run(
                () => cubit.api.lockServerBackup(
                  serverId,
                  backup.uuid,
                  !backup.locked,
                ),
                reloadBackups: true,
              ),
        icon: Icon(backup.locked ? Icons.lock : Icons.lock_open),
      ),
      IconButton(
        tooltip: 'Restore backup',
        onPressed: !backup.completed || state.busy
            ? null
            : () => _restore(context, cubit, backup),
        icon: const Icon(Icons.settings_backup_restore),
      ),
      IconButton(
        tooltip: 'Delete backup',
        onPressed: state.busy || backup.locked
            ? null
            : () => _delete(context, cubit, backup),
        icon: const Icon(Icons.delete_outline),
      ),
    ],
  );

  String _backupDate(String value) {
    final date = DateTime.tryParse(value)?.toLocal();
    if (date == null) return value;
    final month = date.month.toString().padLeft(2, '0');
    final day = date.day.toString().padLeft(2, '0');
    final hour = date.hour.toString().padLeft(2, '0');
    final minute = date.minute.toString().padLeft(2, '0');
    return '${date.year}-$month-$day $hour:$minute';
  }

  Future<void> _restore(
    BuildContext context,
    ServerWorkspaceCubit cubit,
    ServerBackup backup,
  ) async {
    final stop = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Stop server and restore?'),
        content: Text(
          'Restore ${backup.name} into this server. The server must be stopped; current files may be replaced.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Stop and restore'),
          ),
        ],
      ),
    );
    if (stop != true || !context.mounted) return;
    await cubit.run(() async {
      var resources = await cubit.api.serverResources(serverId);
      if (resources.currentState != 'offline') {
        await cubit.api.serverPower(serverId, 'stop');
        for (var attempt = 0; attempt < 20; attempt++) {
          if (cubit.isClosed) {
            throw StateError(
              'Restore cancelled because the server view closed.',
            );
          }
          await Future<void>.delayed(const Duration(seconds: 1));
          resources = await cubit.api.serverResources(serverId);
          if (resources.currentState == 'offline') break;
        }
      }
      if (resources.currentState != 'offline') {
        throw StateError(
          'The server did not stop within 20 seconds. Retry after checking its state.',
        );
      }
      await cubit.api.restoreServerBackup(
        serverId,
        backup.uuid,
        truncate: true,
      );
    }, reloadBackups: true);
  }

  Future<void> _delete(
    BuildContext context,
    ServerWorkspaceCubit cubit,
    ServerBackup backup,
  ) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Delete ${backup.name}?'),
        content: const Text('This permanently removes the backup.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Delete backup'),
          ),
        ],
      ),
    );
    if (confirmed == true && context.mounted) {
      await cubit.run(
        () => cubit.api.deleteServerBackup(serverId, backup.uuid),
        reloadBackups: true,
      );
    }
  }
}

String _backupStatus(ServerBackup backup) {
  if (backupIsActive(backup)) return 'In progress';
  final status = backup.status.trim().toLowerCase();
  if (backup.completed || status == 'complete' || status == 'completed') {
    return 'Completed';
  }
  return 'Failed';
}

class _StartupTab extends StatefulWidget {
  const _StartupTab({required this.serverId});
  final String serverId;
  @override
  State<_StartupTab> createState() => _StartupTabState();
}

class _StartupTabState extends State<_StartupTab> {
  final Map<String, TextEditingController> _values = {};
  @override
  void dispose() {
    for (final value in _values.values) {
      value.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<ServerWorkspaceCubit>();
    final state = context.watch<ServerWorkspaceCubit>().state;
    final startup = state.startup;
    if (startup == null) {
      return const Center(child: CircularProgressIndicator());
    }
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Startup command',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 8),
                SelectableText(startup.command),
              ],
            ),
          ),
        ),
        const SizedBox(height: 18),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Variables',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 12),
                for (final variable in startup.variables) ...[
                  TextField(
                    controller: _values.putIfAbsent(
                      variable.key,
                      () => TextEditingController(text: variable.value),
                    ),
                    readOnly: !variable.isEditable,
                    decoration: InputDecoration(
                      labelText: variable.name.isEmpty
                          ? variable.key
                          : variable.name,
                      helperText:
                          '${variable.description.isEmpty ? variable.rules : variable.description}${variable.isEditable ? '' : ' · Read only'}',
                    ),
                  ),
                  if (variable.isEditable)
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton.icon(
                        onPressed: state.busy
                            ? null
                            : () => cubit.run(() async {
                                await cubit.api.updateServerVariable(
                                  widget.serverId,
                                  variable.key,
                                  _values[variable.key]!.text,
                                );
                                await cubit.load();
                              }),
                        icon: const Icon(Icons.save_outlined),
                        label: const Text('Save variable'),
                      ),
                    ),
                ],
              ],
            ),
          ),
        ),
        const Divider(),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Runtime image',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                Text('Available images are provided by this server template.'),
                if (startup.dockerImage.isNotEmpty)
                  ListTile(
                    dense: true,
                    title: const Text('Current image'),
                    subtitle: SelectableText(startup.dockerImage),
                  ),
                for (final image in startup.dockerImages.entries)
                  ListTile(
                    title: Text(image.value),
                    subtitle: SelectableText(image.key),
                    trailing: IconButton(
                      tooltip: image.key == startup.dockerImage
                          ? 'Selected image'
                          : 'Select image',
                      onPressed: image.key == startup.dockerImage || state.busy
                          ? null
                          : () => cubit.run(() async {
                              await cubit.api.updateServerImage(
                                widget.serverId,
                                image.key,
                              );
                              await cubit.load();
                            }),
                      icon: Icon(
                        image.key == startup.dockerImage
                            ? Icons.check_circle
                            : Icons.check_circle_outline,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _ManageTab extends StatelessWidget {
  const _ManageTab({required this.serverId});
  final String serverId;
  @override
  Widget build(BuildContext context) =>
      ServerManagementPage(entityId: serverId);
}

class _TransferProgress extends StatelessWidget {
  const _TransferProgress({
    required this.label,
    required this.progress,
    required this.onCancel,
  });
  final String label;
  final double progress;
  final VoidCallback onCancel;
  @override
  Widget build(BuildContext context) => Row(
    children: [
      Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label),
            LinearProgressIndicator(value: progress.clamp(0, 1)),
          ],
        ),
      ),
      IconButton(
        tooltip: 'Cancel transfer',
        onPressed: onCancel,
        icon: const Icon(Icons.close),
      ),
    ],
  );
}
