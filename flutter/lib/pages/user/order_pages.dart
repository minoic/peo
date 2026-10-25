import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../api/peo_api.dart';
import '../../models/documents.dart';
import '../../models/order.dart';
import '../../models/site.dart';
import '../../state/order_cubits.dart';
import '../../state/site_cubit.dart';
import '../../widgets/async_view.dart';
import '../../widgets/formatting.dart';
import '../../widgets/responsive.dart';
import '../../widgets/shell.dart';
import '../../theme/peo_theme.dart';

class OrdersPage extends StatelessWidget {
  const OrdersPage({super.key});
  @override
  Widget build(BuildContext c) => BlocProvider(
    create: (ctx) =>
        OrdersCubit(ctx.read<PeoApi>(), loadProductCatalog: true)..load(),
    child: const _OrdersView(),
  );
}

class _OrdersView extends StatelessWidget {
  const _OrdersView();
  @override
  Widget build(BuildContext c) {
    final cubit = c.watch<OrdersCubit>();
    return Scaffold(
      body: AsyncView(
        value: cubit.state.items,
        onRetry: cubit.load,
        builder: (ctx, orders) => ListView(
          padding: const EdgeInsets.symmetric(vertical: 20),
          children: [
            ResponsivePage(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const PageHeader(title: 'Order history'),
                  if (orders.isEmpty)
                    const EmptyPanel(message: 'No orders yet.')
                  else
                    for (final order in orders)
                      _OrderHistoryTile(
                        order: order,
                        product: c.read<OrdersCubit>().products[order.specId],
                        onTap: () => ctx.go('/orders/${order.id}'),
                      ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _OrderHistoryTile extends StatelessWidget {
  const _OrderHistoryTile({
    required this.order,
    required this.product,
    required this.onTap,
  });
  final Order order;
  final ProductCard? product;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 42,
                height: 42,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: theme.colorScheme.primaryContainer,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  Icons.dns_outlined,
                  color: theme.colorScheme.primary,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      product?.wareName.isNotEmpty == true
                          ? product!.wareName
                          : 'Hosting product',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                      softWrap: true,
                    ),
                    const SizedBox(height: 7),
                    _OrderStatusBadge(status: order.status),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 18,
                      runSpacing: 8,
                      children: [
                        if (product != null) ...[
                          Text(
                            '${_cpuLabel(product!.cpu)} · ${resourceSize(product!.memory)} RAM · ${resourceSize(product!.disk)} disk',
                          ),
                          if (product!.validDays > 0)
                            Text('${product!.validDays}-day term'),
                        ],
                        if (order.createdAt?.isNotEmpty == true)
                          Text('Created ${readableDate(order.createdAt!)}'),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    money(order.finalPrice),
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  if (order.originPrice != order.finalPrice)
                    Text(
                      money(order.originPrice),
                      style: theme.textTheme.bodySmall?.copyWith(
                        decoration: TextDecoration.lineThrough,
                      ),
                    ),
                  const SizedBox(height: 8),
                  const Icon(Icons.chevron_right),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _OrderStatusBadge extends StatelessWidget {
  const _OrderStatusBadge({required this.status});
  final String status;

  @override
  Widget build(BuildContext context) => StatusBadge(
    label: _orderStatusLabel(status),
    colour: switch (status) {
      OrderStatus.confirmed => PeoTokens.success,
      OrderStatus.paid => Theme.of(context).colorScheme.primary,
      OrderStatus.pending => PeoTokens.warning,
      OrderStatus.closed => Theme.of(context).colorScheme.outline,
      _ => Theme.of(context).colorScheme.outline,
    },
  );
}

String _orderStatusLabel(String status) => switch (status) {
  OrderStatus.pending => 'Awaiting payment',
  OrderStatus.paid => 'Paid · provisioning',
  OrderStatus.confirmed => 'Completed',
  OrderStatus.closed => 'Closed · payment window expired',
  _ => 'Status unavailable',
};

String _cpuLabel(int cpu) {
  final cores = cpu / 100;
  final formatted = cores == cores.roundToDouble()
      ? cores.toStringAsFixed(0)
      : cores
            .toStringAsFixed(2)
            .replaceFirst(RegExp(r'0+$'), '')
            .replaceFirst(RegExp(r'\.$'), '');
  return '$formatted vCPU';
}

class OrderDetailPage extends StatelessWidget {
  const OrderDetailPage({
    super.key,
    required this.orderId,
    this.paymentMethod = 'balance',
  });

  final String orderId;
  final String paymentMethod;

  @override
  Widget build(BuildContext c) => BlocProvider(
    create: (ctx) => OrderDetailCubit(ctx.read<PeoApi>(), orderId)..load(),
    child: _OrderDetailView(paymentMethod: paymentMethod),
  );
}

class _OrderDetailView extends StatefulWidget {
  const _OrderDetailView({required this.paymentMethod});
  final String paymentMethod;
  @override
  State<_OrderDetailView> createState() => _OrderDetailViewState();
}

class _OrderDetailViewState extends State<_OrderDetailView> {
  final host = TextEditingController(), keyText = TextEditingController();
  int? allocationId;
  @override
  void dispose() {
    host.dispose();
    keyText.dispose();
    super.dispose();
  }

  Widget _paymentButton({
    required bool highlighted,
    required bool busy,
    required IconData icon,
    required String label,
    required VoidCallback onPressed,
  }) => highlighted
      ? FilledButton.icon(
          onPressed: busy ? null : onPressed,
          icon: Icon(icon),
          label: Text(label),
        )
      : OutlinedButton.icon(
          onPressed: busy ? null : onPressed,
          icon: Icon(icon),
          label: Text(label),
        );

  @override
  Widget build(BuildContext c) {
    final cubit = context.watch<OrderDetailCubit>();
    final site = context.watch<SiteCubit>().config;
    return Scaffold(
      body: ListView(
        padding: const EdgeInsets.symmetric(vertical: 20),
        children: [
          ResponsivePage(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                PageHeader(
                  title: 'Order details',
                  actions: [
                    TextButton.icon(
                      onPressed: () => context.go('/orders'),
                      icon: const Icon(Icons.arrow_back),
                      label: const Text('Order history'),
                    ),
                  ],
                ),
                AsyncView(
                  value: cubit.state.order,
                  onRetry: cubit.load,
                  builder: (ctx, order) {
                    final product = cubit.state.product?.product;
                    final pending = order.status == OrderStatus.pending;
                    final title = product?.wareName.isNotEmpty == true
                        ? product!.wareName
                        : 'Hosting product';
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        SectionCard(
                          title: 'Purchase summary',
                          icon: Icons.receipt_long_outlined,
                          trailing: _OrderStatusBadge(status: order.status),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                title,
                                style: Theme.of(ctx).textTheme.titleLarge
                                    ?.copyWith(fontWeight: FontWeight.w700),
                                softWrap: true,
                              ),
                              if (product != null) ...[
                                const SizedBox(height: 8),
                                Text(
                                  'Current specification: ${_cpuLabel(product.cpu)} · ${resourceSize(product.memory)} RAM · ${resourceSize(product.disk)} disk',
                                  style: Theme.of(ctx).textTheme.bodyMedium,
                                ),
                                if (product.validDays > 0)
                                  Text(
                                    'Term: ${product.validDays} days',
                                    style: Theme.of(ctx).textTheme.bodyMedium,
                                  ),
                              ] else
                                Padding(
                                  padding: const EdgeInsets.only(top: 8),
                                  child: Text(
                                    'Current product details are unavailable. Order totals remain based on the original order.',
                                    style: TextStyle(
                                      color: Theme.of(ctx).colorScheme.outline,
                                    ),
                                  ),
                                ),
                              const Divider(height: 28),
                              if (order.createdAt?.isNotEmpty == true)
                                DetailRow(
                                  label: 'Created',
                                  value: readableDate(order.createdAt!),
                                ),
                              const Divider(height: 28),
                              if (order.originPrice != order.finalPrice)
                                DetailRow(
                                  label: 'Original price',
                                  value: money(order.originPrice),
                                ),
                              DetailRow(
                                label: 'Order total',
                                value: money(order.finalPrice),
                              ),
                              if (order.originPrice > order.finalPrice)
                                DetailRow(
                                  label: 'Discount',
                                  value:
                                      '-${money(order.originPrice - order.finalPrice)}',
                                ),
                              if (order.id?.isNotEmpty == true)
                                Row(
                                  children: [
                                    Expanded(
                                      child: SelectableText(
                                        'Order number: ${order.id}',
                                      ),
                                    ),
                                    IconButton(
                                      tooltip: 'Copy order number',
                                      onPressed: () => Clipboard.setData(
                                        ClipboardData(text: order.id!),
                                      ),
                                      icon: const Icon(Icons.copy_outlined),
                                    ),
                                  ],
                                ),
                            ],
                          ),
                        ),
                        if (pending) ...[
                          SectionCard(
                            title: 'Server configuration',
                            icon: Icons.tune_outlined,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                AsyncView<List<Allocation>>(
                                  value: cubit.state.allocations,
                                  onRetry: cubit.loadAllocations,
                                  empty: const Text(
                                    'No free server addresses are available.',
                                  ),
                                  builder: (ctx, allocations) =>
                                      DropdownButtonFormField<int>(
                                        isExpanded: true,
                                        initialValue:
                                            allocations.any(
                                              (a) => a.id == allocationId,
                                            )
                                            ? allocationId
                                            : null,
                                        decoration: InputDecoration(
                                          labelText: 'Server address',
                                          errorText:
                                              cubit.state.allocationRejected
                                              ? 'Choose a server address.'
                                              : null,
                                        ),
                                        items: [
                                          for (final a in allocations)
                                            DropdownMenuItem<int>(
                                              value: a.id,
                                              child: Text(a.address),
                                            ),
                                        ],
                                        onChanged: (value) => setState(
                                          () => allocationId = value,
                                        ),
                                      ),
                                ),
                                const SizedBox(height: 14),
                                TextField(
                                  controller: host,
                                  decoration: const InputDecoration(
                                    labelText: 'Server name',
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SectionCard(
                            title: 'Payment',
                            icon: Icons.lock_outline,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Text(
                                  'Choose how to pay ${money(order.finalPrice)}.',
                                ),
                                if (site.emailNotice)
                                  const Padding(
                                    padding: EdgeInsets.only(top: 8),
                                    child: Text(
                                      'We will email you before an idle server is removed.',
                                    ),
                                  ),
                                const SizedBox(height: 14),
                                TextField(
                                  controller: keyText,
                                  decoration: const InputDecoration(
                                    labelText: 'Product key (optional)',
                                  ),
                                ),
                                ActionFeedback(action: cubit.state.action),
                                const SizedBox(height: 12),
                                Wrap(
                                  spacing: 12,
                                  runSpacing: 12,
                                  children: widget.paymentMethod == 'key'
                                      ? [
                                          _paymentButton(
                                            highlighted: true,
                                            busy: cubit.state.action.busy,
                                            icon: Icons.key_outlined,
                                            label: 'Pay with key',
                                            onPressed: () => cubit.payWithKey(
                                              allocationId: allocationId ?? 0,
                                              hostName: host.text,
                                              key: keyText.text,
                                            ),
                                          ),
                                          _paymentButton(
                                            highlighted: false,
                                            busy: cubit.state.action.busy,
                                            icon: Icons
                                                .account_balance_wallet_outlined,
                                            label: 'Pay with balance',
                                            onPressed: () =>
                                                cubit.payWithBalance(
                                                  allocationId:
                                                      allocationId ?? 0,
                                                  hostName: host.text,
                                                ),
                                          ),
                                        ]
                                      : [
                                          _paymentButton(
                                            highlighted: true,
                                            busy: cubit.state.action.busy,
                                            icon: Icons
                                                .account_balance_wallet_outlined,
                                            label: 'Pay with balance',
                                            onPressed: () =>
                                                cubit.payWithBalance(
                                                  allocationId:
                                                      allocationId ?? 0,
                                                  hostName: host.text,
                                                ),
                                          ),
                                          _paymentButton(
                                            highlighted: false,
                                            busy: cubit.state.action.busy,
                                            icon: Icons.key_outlined,
                                            label: 'Pay with key',
                                            onPressed: () => cubit.payWithKey(
                                              allocationId: allocationId ?? 0,
                                              hostName: host.text,
                                              key: keyText.text,
                                            ),
                                          ),
                                        ],
                                ),
                              ],
                            ),
                          ),
                        ] else
                          SectionCard(
                            title: order.status == OrderStatus.closed
                                ? 'Order closed'
                                : 'Payment status',
                            icon: order.status == OrderStatus.closed
                                ? Icons.lock_clock_outlined
                                : Icons.verified_outlined,
                            child: Text(
                              order.status == OrderStatus.closed
                                  ? 'This order was closed because payment was not completed within 15 minutes.'
                                  : order.status == OrderStatus.confirmed
                                  ? 'This order has been completed.'
                                  : order.status == OrderStatus.paid
                                  ? 'Payment received. Server provisioning is in progress.'
                                  : 'Payment is unavailable for this order status.',
                            ),
                          ),
                      ],
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ServerManagementPage extends StatelessWidget {
  const ServerManagementPage({super.key, required this.entityId});
  final String entityId;
  @override
  Widget build(BuildContext c) => BlocProvider(
    create: (ctx) => ServerDetailCubit(ctx.read<PeoApi>(), entityId)..load(),
    child: const _ServerDetailView(),
  );
}

class _ServerDetailView extends StatefulWidget {
  const _ServerDetailView();

  @override
  State<_ServerDetailView> createState() => _ServerDetailViewState();
}

class _ServerDetailViewState extends State<_ServerDetailView> {
  final key = TextEditingController();
  int? eggId;

  @override
  void dispose() {
    key.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext c) {
    final cubit = c.watch<ServerDetailCubit>();
    final width = MediaQuery.sizeOf(c).width;
    return AsyncView(
      value: cubit.state.server,
      onRetry: cubit.load,
      builder: (ctx, server) => ListView(
        padding: EdgeInsets.fromLTRB(
          width < 1024 ? 16 : 24,
          0,
          width < 1024 ? 16 : 24,
          24,
        ),
        children: [
          if (cubit.state.status != null)
            _ManagementStatus(status: cubit.state.status!),
          if (server.isPendingDeletion)
            Card(
              color: Theme.of(ctx).colorScheme.errorContainer,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.delete_outline,
                      color: Theme.of(ctx).colorScheme.onErrorContainer,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Deletion has been requested for this server.',
                        style: TextStyle(
                          color: Theme.of(ctx).colorScheme.onErrorContainer,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ActionFeedback(action: cubit.state.action),
          SectionCard(
            title: 'Renewal',
            icon: Icons.autorenew,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (server.validDate.isNotEmpty) ...[
                  Row(
                    children: [
                      Icon(
                        Icons.event_outlined,
                        size: 18,
                        color: Theme.of(ctx).colorScheme.outline,
                      ),
                      const SizedBox(width: 8),
                      Text('Expires ${readableDate(server.validDate)}'),
                    ],
                  ),
                  const SizedBox(height: 12),
                ],
                TextField(
                  controller: key,
                  decoration: const InputDecoration(labelText: 'Renewal key'),
                ),
                const SizedBox(height: 14),
                Wrap(
                  spacing: 12,
                  runSpacing: 12,
                  children: [
                    FilledButton.icon(
                      onPressed: cubit.state.action.busy
                          ? null
                          : () => cubit.renew(key.text.trim()),
                      icon: const Icon(Icons.key_outlined),
                      label: const Text('Renew with key'),
                    ),
                    OutlinedButton.icon(
                      onPressed: cubit.state.action.busy
                          ? null
                          : () => cubit.renewByBalance(),
                      icon: const Icon(Icons.account_balance_wallet_outlined),
                      label: const Text('Renew with balance'),
                    ),
                  ],
                ),
              ],
            ),
          ),
          SectionCard(
            title: 'Danger zone',
            icon: Icons.warning_amber_outlined,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'Reinstalling may replace the server files. Requesting deletion starts the configured grace period.',
                  style: Theme.of(ctx).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(ctx).colorScheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 16),
                AsyncView<List<Egg>>(
                  value: cubit.state.eggs,
                  onRetry: cubit.load,
                  empty: const EmptyPanel(
                    message: 'No alternate templates are available.',
                  ),
                  builder: (ctx, eggs) => DropdownButtonFormField<int>(
                    initialValue: eggs.any((egg) => egg.id == eggId)
                        ? eggId
                        : null,
                    decoration: const InputDecoration(
                      labelText: 'Reinstall template',
                    ),
                    items: [
                      for (final egg in eggs)
                        DropdownMenuItem<int>(
                          value: egg.id,
                          child: Text(egg.name),
                        ),
                    ],
                    onChanged: (value) => setState(() => eggId = value),
                  ),
                ),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 12,
                  runSpacing: 12,
                  children: [
                    FilledButton.icon(
                      onPressed: cubit.state.action.busy || eggId == null
                          ? null
                          : () => cubit.reinstall(eggId!),
                      icon: const Icon(Icons.restart_alt),
                      label: const Text('Reinstall'),
                    ),
                    OutlinedButton.icon(
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Theme.of(ctx).colorScheme.error,
                      ),
                      onPressed: cubit.state.action.busy
                          ? null
                          : () async {
                              final accepted = await showDialog<bool>(
                                context: ctx,
                                builder: (dialogContext) => AlertDialog(
                                  title: const Text('Request server deletion?'),
                                  content: const Text(
                                    'The server will enter the configured deletion grace period.',
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: () =>
                                          Navigator.pop(dialogContext, false),
                                      child: const Text('Cancel'),
                                    ),
                                    FilledButton(
                                      onPressed: () =>
                                          Navigator.pop(dialogContext, true),
                                      child: const Text('Request deletion'),
                                    ),
                                  ],
                                ),
                              );
                              if (accepted == true && ctx.mounted) {
                                await cubit.requestDelete();
                              }
                            },
                      icon: const Icon(Icons.delete_outline),
                      label: const Text('Request deletion'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ManagementStatus extends StatelessWidget {
  const _ManagementStatus({required this.status});

  final ServerStatus status;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final color = status.suspended
        ? scheme.error
        : status.online
        ? const Color(0xFF1F8056)
        : scheme.outline;
    final label = status.suspended
        ? 'Suspended'
        : status.online
        ? 'Online'
        : 'Offline';
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          Icon(
            status.suspended ? Icons.pause_circle_outline : Icons.circle,
            size: 16,
            color: color,
          ),
          const SizedBox(width: 8),
          Text(
            label,
            style: TextStyle(color: color, fontWeight: FontWeight.w600),
          ),
          if (status.motd.isNotEmpty) ...[
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                status.motd,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(color: scheme.onSurfaceVariant),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
