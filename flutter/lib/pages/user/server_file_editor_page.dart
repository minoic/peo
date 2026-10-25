import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../state/server_workspace_cubit.dart';
import '../../widgets/server_text_editor.dart';

class ServerFileEditorPage extends StatefulWidget {
  const ServerFileEditorPage({
    super.key,
    required this.serverId,
    required this.path,
    this.onDisposed,
  });

  final String serverId;
  final String path;
  final VoidCallback? onDisposed;

  @override
  ServerFileEditorPageState createState() => ServerFileEditorPageState();
}

class ServerFileEditorPageState extends State<ServerFileEditorPage> {
  late final ServerEditorController _controller;
  int _indentSize = 2;
  bool _useTabs = false;

  String get _indentText => _useTabs ? '\t' : ' ' * _indentSize;

  @override
  void initState() {
    super.initState();
    _controller = ServerEditorController(text: '', language: 'plain');
    _controller.addListener(_syncDraft);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      final cubit = context.read<ServerWorkspaceCubit>();
      final filename = widget.path.split('/').last;
      final file = cubit.state.files
          .where((item) => item.name == filename)
          .firstOrNull;
      cubit.loadEditorFile(widget.path, mimeType: file?.mimeType ?? '');
    });
  }

  void _syncDraft() {
    if (!mounted) return;
    final cubit = context.read<ServerWorkspaceCubit>();
    if (cubit.state.editorLoaded &&
        cubit.state.editorContent != _controller.text) {
      cubit.updateEditorContent(_controller.text);
    }
  }

  Future<bool> confirmExit() async {
    final cubit = context.read<ServerWorkspaceCubit>();
    if (!cubit.state.editorDirty) return true;
    final discard = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Discard unsaved changes?'),
        content: const Text('Your changes have not been saved.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Keep editing'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Discard'),
          ),
        ],
      ),
    );
    return discard == true;
  }

  @override
  void dispose() {
    _controller.removeListener(_syncDraft);
    _controller.dispose();
    widget.onDisposed?.call();
    super.dispose();
  }

  Future<void> _save() async {
    final cubit = context.read<ServerWorkspaceCubit>();
    final saved = await cubit.saveEditorFile();
    if (saved && mounted) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('File saved.')));
    }
  }

  void _changeIndent(int value) {
    setState(() {
      _useTabs = value == 0;
      if (value > 0) _indentSize = value;
    });
  }

  void _applyIndent({bool outdent = false}) {
    final selection = _controller.selection;
    if (outdent || !selection.isCollapsed) {
      indentEditorSelection(_controller, _indentText, outdent: outdent);
      return;
    }
    final offset = selection.baseOffset;
    _controller.value = _controller.value.copyWith(
      text: _controller.text.replaceRange(offset, offset, _indentText),
      selection: TextSelection.collapsed(offset: offset + _indentText.length),
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = context.watch<ServerWorkspaceCubit>().state;
    if (_controller.text != state.editorContent && !state.editorLoading) {
      _controller.value = TextEditingValue(
        text: state.editorContent,
        selection: TextSelection.collapsed(offset: state.editorContent.length),
      );
    }
    _controller.language = serverFileLanguage(
      widget.path,
      state.editorMimeType,
    );
    final largeFile = state.editorContent.length > 256 * 1024;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
          child: Wrap(
            spacing: 8,
            runSpacing: 8,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              IconButton(
                tooltip: 'Back to files',
                onPressed: () =>
                    context.go('/servers/${widget.serverId}/files'),
                icon: const Icon(Icons.arrow_back),
              ),
              ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 400),
                child: Text(
                  widget.path,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ),
              DropdownButton<int>(
                value: _useTabs ? 0 : _indentSize,
                items: const [
                  DropdownMenuItem(value: 0, child: Text('Tab')),
                  DropdownMenuItem(value: 2, child: Text('2 spaces')),
                  DropdownMenuItem(value: 4, child: Text('4 spaces')),
                  DropdownMenuItem(value: 8, child: Text('8 spaces')),
                ],
                onChanged: (value) {
                  if (value != null) _changeIndent(value);
                },
              ),
              FilledButton.icon(
                onPressed:
                    state.editorSaving ||
                        state.editorLoading ||
                        !state.editorDirty
                    ? null
                    : _save,
                icon: state.editorSaving
                    ? const SizedBox.square(
                        dimension: 16,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Icon(Icons.save_outlined),
                label: Text(state.editorSaving ? 'Saving' : 'Save'),
              ),
            ],
          ),
        ),
        if (state.editorError.isNotEmpty)
          MaterialBanner(
            content: Text(state.editorError),
            actions: [
              TextButton(
                onPressed: state.editorLoading
                    ? null
                    : state.editorLoadFailed
                    ? () => context.read<ServerWorkspaceCubit>().loadEditorFile(
                        widget.path,
                        mimeType: state.editorMimeType,
                      )
                    : _save,
                child: const Text('Retry'),
              ),
            ],
          ),
        if (largeFile)
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            child: Text('Syntax highlighting is disabled for large files.'),
          ),
        if (state.editorLoading) const LinearProgressIndicator(),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
            child: DecoratedBox(
              decoration: BoxDecoration(
                border: Border.all(color: Theme.of(context).dividerColor),
                borderRadius: BorderRadius.circular(4),
              ),
              child: state.editorLoading && state.editorContent.isEmpty
                  ? const Center(child: CircularProgressIndicator())
                  : CallbackShortcuts(
                      bindings: {
                        const SingleActivator(LogicalKeyboardKey.tab): () =>
                            _applyIndent(),
                        const SingleActivator(
                          LogicalKeyboardKey.tab,
                          shift: true,
                        ): () =>
                            _applyIndent(outdent: true),
                        const SingleActivator(
                          LogicalKeyboardKey.keyS,
                          control: true,
                        ): _save,
                        const SingleActivator(
                          LogicalKeyboardKey.keyS,
                          meta: true,
                        ): _save,
                      },
                      child: TextField(
                        controller: _controller,
                        enabled: state.editorLoaded && !state.editorSaving,
                        expands: true,
                        maxLines: null,
                        minLines: null,
                        keyboardType: TextInputType.multiline,
                        textAlignVertical: TextAlignVertical.top,
                        style: const TextStyle(
                          fontFamily: 'monospace',
                          fontSize: 14,
                          height: 1.5,
                        ),
                        inputFormatters: [
                          ServerIndentFormatter(
                            _indentText,
                            language: _controller.language,
                          ),
                        ],
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.all(16),
                          hoverColor: Colors.transparent,
                        ),
                      ),
                    ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 12),
          child: Text(
            '${utf8.encode(state.editorContent).length} bytes${state.editorDirty ? '  •  Unsaved changes' : ''}',
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ),
      ],
    );
  }
}
