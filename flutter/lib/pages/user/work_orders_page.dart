import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../api/peo_api.dart';
import '../../models/content.dart';
import '../../state/async_value.dart';
import '../../state/message_cubits.dart';
import '../../theme/peo_theme.dart';
import '../../widgets/async_view.dart';
import '../../widgets/formatting.dart';
import '../../widgets/responsive.dart';
import '../../widgets/shell.dart';

class WorkOrdersPage extends StatelessWidget {
  const WorkOrdersPage({super.key});

  @override
  Widget build(BuildContext c) => BlocProvider(
    create: (ctx) => WorkOrdersCubit(ctx.read<PeoApi>())..load(),
    child: const _WorkOrdersView(),
  );
}

class _WorkOrdersView extends StatefulWidget {
  const _WorkOrdersView();

  @override
  State<_WorkOrdersView> createState() => _WorkOrdersViewState();
}

class _WorkOrdersViewState extends State<_WorkOrdersView> {
  final title = TextEditingController();
  final text = TextEditingController();

  @override
  void dispose() {
    title.dispose();
    text.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cubit = context.watch<WorkOrdersCubit>();
    final form = _CreateTicketPanel(
      title: title,
      details: text,
      action: cubit.state.action,
      onCreate: () =>
          cubit.create(title: title.text.trim(), text: text.text.trim()),
    );
    final history = _TicketHistory(
      items: cubit.state.items,
      onRetry: cubit.load,
    );

    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          final wide = constraints.maxWidth >= 960;
          return ListView(
            padding: const EdgeInsets.all(PeoTokens.space5),
            children: [
              Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(
                    maxWidth: PeoBreakpoints.maxContentWidth,
                  ),
                  child: const SizedBox(
                    width: double.infinity,
                    child: PageHeader(
                      title: 'Work orders',
                      subtitle:
                          'Contact support and review your previous requests.',
                    ),
                  ),
                ),
              ),
              Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(
                    maxWidth: PeoBreakpoints.maxContentWidth,
                  ),
                  child: wide
                      ? Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(width: 360, child: form),
                            const SizedBox(width: PeoTokens.space4),
                            Expanded(child: history),
                          ],
                        )
                      : Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            form,
                            const SizedBox(height: PeoTokens.space4),
                            history,
                          ],
                        ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _CreateTicketPanel extends StatelessWidget {
  const _CreateTicketPanel({
    required this.title,
    required this.details,
    required this.action,
    required this.onCreate,
  });

  final TextEditingController title;
  final TextEditingController details;
  final ActionState action;
  final VoidCallback onCreate;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(PeoTokens.space4),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Icon(
                  Icons.add_comment_outlined,
                  color: theme.colorScheme.primary,
                ),
                const SizedBox(width: PeoTokens.space2),
                Expanded(
                  child: Text(
                    'New request',
                    style: theme.textTheme.titleMedium,
                  ),
                ),
              ],
            ),
            const SizedBox(height: PeoTokens.space2),
            Text(
              'Describe the issue and include any details that can help us understand it.',
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: PeoTokens.space4),
            TextField(
              controller: title,
              textCapitalization: TextCapitalization.sentences,
              decoration: const InputDecoration(
                labelText: 'Subject',
                hintText: 'What do you need help with?',
                prefixIcon: Icon(Icons.short_text),
              ),
            ),
            const SizedBox(height: PeoTokens.space3),
            TextField(
              controller: details,
              minLines: 5,
              maxLines: 9,
              textCapitalization: TextCapitalization.sentences,
              decoration: const InputDecoration(
                labelText: 'Details',
                hintText: 'Share the relevant information…',
                alignLabelWithHint: true,
              ),
            ),
            const SizedBox(height: PeoTokens.space3),
            ActionFeedback(action: action),
            FilledButton.icon(
              onPressed: action.busy ? null : onCreate,
              icon: action.busy
                  ? const SizedBox.square(
                      dimension: 18,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Icon(Icons.send_outlined),
              label: Text(action.busy ? 'Sending…' : 'Open ticket'),
            ),
          ],
        ),
      ),
    );
  }
}

class _TicketHistory extends StatelessWidget {
  const _TicketHistory({required this.items, required this.onRetry});

  final AsyncValue<List<WorkOrderItem>> items;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(4, 4, 4, PeoTokens.space3),
          child: Row(
            children: [
              Icon(
                Icons.forum_outlined,
                color: theme.colorScheme.primary,
                size: 20,
              ),
              const SizedBox(width: PeoTokens.space2),
              Expanded(
                child: Text(
                  'Request history',
                  style: theme.textTheme.titleMedium,
                ),
              ),
            ],
          ),
        ),
        AsyncView<List<WorkOrderItem>>(
          value: items,
          onRetry: onRetry,
          empty: const EmptyPanel(
            message: 'Your support requests will appear here.',
          ),
          builder: (context, orders) => Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [for (final order in orders) _TicketCard(order: order)],
          ),
        ),
      ],
    );
  }
}

class _TicketCard extends StatelessWidget {
  const _TicketCard({required this.order});

  final WorkOrderItem order;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    return Card(
      margin: const EdgeInsets.only(bottom: PeoTokens.space3),
      child: Padding(
        padding: const EdgeInsets.all(PeoTokens.space4),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Wrap(
              alignment: WrapAlignment.spaceBetween,
              crossAxisAlignment: WrapCrossAlignment.center,
              spacing: PeoTokens.space2,
              runSpacing: PeoTokens.space2,
              children: [
                ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 640),
                  child: Text(
                    order.orderTitle,
                    style: theme.textTheme.titleMedium,
                    softWrap: true,
                  ),
                ),
                StatusBadge(
                  label: order.closed ? 'Closed' : 'Open',
                  colour: order.closed ? scheme.outline : PeoTokens.success,
                ),
              ],
            ),
            if (order.createdAt.isNotEmpty) ...[
              const SizedBox(height: PeoTokens.space2),
              Row(
                children: [
                  Icon(
                    Icons.schedule_outlined,
                    size: 16,
                    color: scheme.outline,
                  ),
                  const SizedBox(width: PeoTokens.space1),
                  Expanded(
                    child: Text(
                      readableDate(order.createdAt),
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: scheme.outline,
                      ),
                      softWrap: true,
                    ),
                  ),
                ],
              ),
            ],
            const SizedBox(height: PeoTokens.space3),
            Text(
              order.orderText,
              style: theme.textTheme.bodyMedium,
              softWrap: true,
            ),
          ],
        ),
      ),
    );
  }
}
