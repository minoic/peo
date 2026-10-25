import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../api/peo_api.dart';
import '../../models/documents.dart';
import '../../models/order.dart';
import '../../state/order_cubits.dart';
import '../../state/session_cubit.dart';
import '../../widgets/async_view.dart';
import '../../widgets/cards.dart';
import '../../widgets/formatting.dart';
import '../../widgets/responsive.dart';
import '../../widgets/shell.dart';

class ConsolePage extends StatelessWidget {
  const ConsolePage({super.key});

  @override
  Widget build(BuildContext context) => MultiBlocProvider(
    providers: [
      BlocProvider(
        create: (ctx) => ServersCubit(ctx.read<PeoApi>())
          ..load()
          ..startPolling(),
      ),
      BlocProvider(create: (ctx) => OrdersCubit(ctx.read<PeoApi>())..load()),
    ],
    child: const _ConsoleView(),
  );
}

class _ConsoleView extends StatelessWidget {
  const _ConsoleView();

  @override
  Widget build(BuildContext context) {
    final state = context.watch<ServersCubit>().state;
    final orders = context.watch<OrdersCubit>().state.items.value ?? const [];
    final user = context.watch<SessionCubit>().state.user;
    final cubit = context.read<ServersCubit>();
    final theme = Theme.of(context);
    final width = MediaQuery.sizeOf(context).width;

    return ListView(
      padding: EdgeInsets.all(width < 1024 ? 16 : 24),
      children: [
        const PageHeader(title: 'Your console'),
        LayoutBuilder(
          builder: (context, constraints) {
            final columns = PeoBreakpoints.gridColumns(
              constraints.maxWidth,
              minTileWidth: 210,
              maxColumns: 4,
              spacing: 12,
            );
            final tileWidth =
                (constraints.maxWidth - (columns - 1) * 12) / columns;
            final onlinePlayers = state.statuses.values.fold<int>(
              0,
              (sum, status) => sum + (status.online ? status.playerCount : 0),
            );
            return Wrap(
              spacing: 12,
              runSpacing: 12,
              children: [
                SizedBox(
                  width: tileWidth,
                  child: StatTile(
                    label: 'Orders',
                    value: '${orders.length}',
                    icon: Icons.receipt_long_outlined,
                    colour: theme.colorScheme.primary,
                  ),
                ),
                SizedBox(
                  width: tileWidth,
                  child: StatTile(
                    label: 'Servers',
                    value: '${state.list.length}',
                    icon: Icons.dns_outlined,
                    colour: theme.colorScheme.secondary,
                  ),
                ),
                SizedBox(
                  width: tileWidth,
                  child: StatTile(
                    label: 'Online players',
                    value: '$onlinePlayers',
                    icon: Icons.people_outline,
                    colour: theme.colorScheme.tertiary,
                  ),
                ),
                SizedBox(
                  width: tileWidth,
                  child: StatTile(
                    label: 'Total uptime',
                    value: uptime(user?.totalUpTime ?? 0),
                    icon: Icons.schedule_outlined,
                    colour: theme.colorScheme.error,
                  ),
                ),
              ],
            );
          },
        ),
        const SizedBox(height: 28),
        Text('Your servers', style: theme.textTheme.titleLarge),
        const SizedBox(height: 12),
        AsyncView<List<WareEntity>>(
          value: state.servers,
          onRetry: cubit.load,
          empty: const EmptyPanel(
            message: 'You do not have any servers yet.',
            icon: Icons.dns_outlined,
          ),
          builder: (context, servers) => Column(
            children: [
              for (final server in servers)
                _ServerCard(
                  server: server,
                  status: server.id == null ? null : state.statusOf(server.id!),
                  onOpen: server.id == null
                      ? null
                      : () => context.go('/servers/${server.id}'),
                ),
            ],
          ),
        ),
      ],
    );
  }
}

class _ServerCard extends StatelessWidget {
  const _ServerCard({required this.server, required this.status, this.onOpen});

  final WareEntity server;
  final ServerStatus? status;
  final VoidCallback? onOpen;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final Color statusColor;
    final String statusText;
    final IconData statusIcon;
    if (status == null || status!.probing) {
      statusColor = scheme.outline;
      statusText = 'Checking status';
      statusIcon = Icons.more_horiz;
    } else if (status!.suspended) {
      statusColor = scheme.error;
      statusText = 'Suspended';
      statusIcon = Icons.pause_circle_outline;
    } else if (status!.online) {
      statusColor = const Color(0xFF1F8056);
      statusText = 'Online';
      statusIcon = Icons.check_circle_outline;
    } else {
      statusColor = scheme.outline;
      statusText = 'Offline';
      statusIcon = Icons.remove_circle_outline;
    }

    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onOpen,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: LayoutBuilder(
            builder: (context, constraints) {
              final narrow = constraints.maxWidth < 540;
              final nameAndStatus = Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: scheme.primaryContainer,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(Icons.dns_outlined, color: scheme.primary),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          server.hostName.isEmpty
                              ? 'Minecraft server'
                              : server.hostName,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: theme.textTheme.titleMedium,
                        ),
                        const SizedBox(height: 4),
                        Wrap(
                          crossAxisAlignment: WrapCrossAlignment.center,
                          spacing: 6,
                          children: [
                            if (status?.probing == true)
                              SizedBox(
                                width: 12,
                                height: 12,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: statusColor,
                                ),
                              )
                            else
                              Icon(statusIcon, size: 15, color: statusColor),
                            Text(
                              statusText,
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: statusColor,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            if (status != null &&
                                !status!.probing &&
                                status!.panelName.isNotEmpty)
                              Text(
                                status!.panelName,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: scheme.outline,
                                ),
                              ),
                          ],
                        ),
                        if (status?.motd.isNotEmpty == true)
                          Tooltip(
                            message: status!.motd,
                            child: Padding(
                              padding: const EdgeInsets.only(top: 4),
                              child: Text(
                                status!.motd,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: scheme.onSurfaceVariant,
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ],
              );
              final details = Wrap(
                spacing: 20,
                runSpacing: 8,
                children: [
                  if (status != null && !status!.probing)
                    _ServerMeta(
                      icon: Icons.people_outline,
                      label: 'Players',
                      value:
                          '${status!.online ? status!.playerCount : 0}/${status!.playerMax}',
                    ),
                  if (server.validDate.isNotEmpty)
                    _ServerMeta(
                      icon: Icons.event_outlined,
                      label: 'Expires',
                      value: readableDate(server.validDate),
                    ),
                ],
              );

              if (narrow) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    nameAndStatus,
                    if (status != null || server.validDate.isNotEmpty) ...[
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 14),
                        child: Divider(height: 1),
                      ),
                      details,
                    ],
                    const SizedBox(height: 14),
                    Align(
                      alignment: Alignment.centerRight,
                      child: FilledButton.tonalIcon(
                        onPressed: onOpen,
                        icon: const Icon(Icons.open_in_new, size: 18),
                        label: const Text('Open console'),
                      ),
                    ),
                  ],
                );
              }
              return Row(
                children: [
                  Expanded(flex: 4, child: nameAndStatus),
                  Expanded(flex: 3, child: details),
                  const SizedBox(width: 16),
                  FilledButton.tonalIcon(
                    onPressed: onOpen,
                    icon: const Icon(Icons.open_in_new, size: 18),
                    label: const Text('Open console'),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

class _ServerMeta extends StatelessWidget {
  const _ServerMeta({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 16, color: theme.colorScheme.outline),
        const SizedBox(width: 6),
        Text(
          '$label ',
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.outline,
          ),
        ),
        Flexible(
          child: Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: theme.textTheme.bodySmall?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }
}
