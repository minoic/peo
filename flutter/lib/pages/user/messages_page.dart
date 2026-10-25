import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../api/peo_api.dart';
import '../../models/content.dart';
import '../../state/message_cubits.dart';
import '../../state/site_cubit.dart';
import '../../widgets/async_view.dart';

/// Opens the inbox without changing the page currently shown by the shell.
Future<void> showMessagesDialog(BuildContext context) =>
    showDialog<void>(context: context, builder: (_) => const MessagesDialog());

/// Compatibility entry point for old `/messages` links.
class MessagesPage extends StatefulWidget {
  const MessagesPage({super.key});

  @override
  State<MessagesPage> createState() => _MessagesPageState();
}

class _MessagesPageState extends State<MessagesPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (!mounted) return;
      await showMessagesDialog(context);
      if (mounted) context.go('/console');
    });
  }

  @override
  Widget build(BuildContext context) => const Scaffold();
}

class MessagesDialog extends StatelessWidget {
  const MessagesDialog({super.key});

  @override
  Widget build(BuildContext context) => BlocProvider(
    create: (ctx) => MessagesCubit(ctx.read<PeoApi>())..load(),
    child: const _MessagesDialogView(),
  );
}

class _MessagesDialogView extends StatelessWidget {
  const _MessagesDialogView();

  @override
  Widget build(BuildContext context) =>
      BlocListener<MessagesCubit, MessagesState>(
        listenWhen: (previous, current) =>
            previous.unread != current.unread ||
            (!previous.messages.isReady && current.messages.isReady),
        listener: (context, state) {
          if (state.messages.isReady) {
            context.read<SiteCubit>().setUnread(state.unread);
          }
        },
        child: Dialog(
          insetPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 24,
          ),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 760, maxHeight: 720),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _DialogHeader(),
                  const SizedBox(height: 12),
                  Expanded(child: _MessageList()),
                ],
              ),
            ),
          ),
        ),
      );
}

class _DialogHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final cubit = context.watch<MessagesCubit>();
    final messages = cubit.state.list;
    final unread = cubit.state.unread;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            const Icon(Icons.mail_outline),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Messages',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  Text('${messages.length} messages · $unread unread'),
                ],
              ),
            ),
          ],
        ),
        Align(
          alignment: Alignment.centerRight,
          child: Wrap(
            crossAxisAlignment: WrapCrossAlignment.center,
            spacing: 4,
            children: [
              if (unread > 0)
                TextButton.icon(
                  onPressed: cubit.state.action.busy ? null : cubit.markAllRead,
                  icon: cubit.state.action.busy
                      ? const SizedBox.square(
                          dimension: 16,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Icon(Icons.done_all),
                  label: const Text('Mark all read'),
                ),
              IconButton(
                tooltip: 'Close messages',
                onPressed: () => Navigator.of(context).pop(),
                icon: const Icon(Icons.close),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _MessageList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final cubit = context.watch<MessagesCubit>();
    final state = cubit.state;
    return Column(
      children: [
        if (state.action.error != null)
          _ActionError(message: state.action.error!.message),
        Expanded(
          child: AsyncView<List<MessageItem>>(
            value: state.messages,
            onRetry: cubit.load,
            empty: const Center(child: Text('No messages yet')),
            builder: (context, messages) => ListView.separated(
              padding: const EdgeInsets.only(bottom: 4),
              itemCount: messages.length,
              separatorBuilder: (_, _) => const SizedBox(height: 8),
              itemBuilder: (context, index) => _MessageTile(
                message: messages[index],
                busy: state.action.busy,
                onMarkRead: () => cubit.markRead(messages[index].id),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _MessageTile extends StatelessWidget {
  const _MessageTile({
    required this.message,
    required this.busy,
    required this.onMarkRead,
  });

  final MessageItem message;
  final bool busy;
  final Future<Object?> Function() onMarkRead;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final unread = !message.haveRead;
    return Card(
      margin: EdgeInsets.zero,
      color: unread
          ? scheme.primaryContainer.withValues(alpha: 0.32)
          : scheme.surface,
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  children: [
                    Icon(
                      unread
                          ? Icons.mark_email_unread_outlined
                          : Icons.drafts_outlined,
                      size: 19,
                      color: unread ? scheme.primary : scheme.outline,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        message.senderName,
                        softWrap: true,
                        style: Theme.of(context).textTheme.titleSmall,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Wrap(
                  alignment: WrapAlignment.spaceBetween,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  spacing: 8,
                  runSpacing: 4,
                  children: [
                    ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 180),
                      child: Text(
                        message.timeText.isNotEmpty
                            ? message.timeText
                            : message.createdAt,
                        softWrap: true,
                      ),
                    ),
                    _ReadStatus(unread: unread),
                    if (unread)
                      TextButton.icon(
                        onPressed: busy ? null : onMarkRead,
                        icon: const Icon(Icons.done, size: 18),
                        label: const Text('Mark read'),
                      ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 10),
            SelectableText(message.text),
          ],
        ),
      ),
    );
  }
}

class _ReadStatus extends StatelessWidget {
  const _ReadStatus({required this.unread});

  final bool unread;

  @override
  Widget build(BuildContext context) {
    final color = unread
        ? Theme.of(context).colorScheme.primary
        : Theme.of(context).colorScheme.outline;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          unread ? Icons.circle : Icons.check_circle_outline,
          size: 13,
          color: color,
        ),
        const SizedBox(width: 5),
        Text(
          unread ? 'Unread' : 'Read',
          style: TextStyle(color: color, fontWeight: FontWeight.w600),
        ),
      ],
    );
  }
}

class _ActionError extends StatelessWidget {
  const _ActionError({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(bottom: 10),
    child: Material(
      color: Theme.of(context).colorScheme.errorContainer,
      borderRadius: BorderRadius.circular(6),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            Icon(
              Icons.error_outline,
              color: Theme.of(context).colorScheme.onErrorContainer,
            ),
            const SizedBox(width: 8),
            Expanded(child: Text(message)),
          ],
        ),
      ),
    ),
  );
}
