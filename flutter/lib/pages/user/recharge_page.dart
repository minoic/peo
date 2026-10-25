import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../api/peo_api.dart';
import '../../models/documents.dart';
import '../../state/recharge_cubit.dart';
import '../../state/site_cubit.dart';
import '../../theme/peo_theme.dart';
import '../../widgets/async_view.dart';
import '../../widgets/shell.dart';

class RechargePage extends StatelessWidget {
  const RechargePage({super.key});
  @override
  Widget build(BuildContext c) => BlocProvider(
    create: (ctx) => RechargeCubit(ctx.read<PeoApi>())..load(),
    child: const _RechargeView(),
  );
}

class _RechargeView extends StatefulWidget {
  const _RechargeView();
  @override
  State<_RechargeView> createState() => _RechargeViewState();
}

class _RechargeViewState extends State<_RechargeView> {
  final keyText = TextEditingController(), amount = TextEditingController();
  @override
  void dispose() {
    keyText.dispose();
    amount.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext c) {
    final cubit = context.watch<RechargeCubit>();
    final site = context.watch<SiteCubit>();
    final siteState = site.state;
    final config = site.config;
    final actionBusy = cubit.state.action.busy;
    final order = cubit.state.order;
    return Scaffold(
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          const PageHeader(title: 'Recharge'),
          if (!siteState.hasValue && siteState.hasFailed)
            ErrorPanel(error: siteState.error!, onRetry: site.load)
          else if (!siteState.hasValue)
            const Padding(
              padding: EdgeInsets.all(24),
              child: Center(child: CircularProgressIndicator()),
            )
          else if (!config.rechargeMode)
            const _RechargeUnavailable(
              message: 'Balance recharges are currently unavailable.',
            )
          else ...[
            _KeyRechargeForm(
              controller: keyText,
              busy: actionBusy,
              onChanged: () => setState(() {}),
              onRedeem: () => cubit.redeemKey(keyText.text.trim()),
            ),
            if (config.alipayEnabled)
              _AlipayRechargeForm(
                controller: amount,
                busy: actionBusy,
                onChanged: () => setState(() {}),
                onPay: (value) => cubit.startAlipay(value),
              ),
            if (config.alipayEnabled && order != null)
              _AlipayOrderCard(order: order, onDismiss: cubit.cancelOrder),
            if (order == null) ActionFeedback(action: cubit.state.action),
          ],
          AsyncView(
            value: cubit.state.logs,
            onRetry: cubit.load,
            empty: const EmptyPanel(message: 'No recharge history yet.'),
            builder: (ctx, logs) => Card(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Text(
                      'Recharge history',
                      style: Theme.of(ctx).textTheme.titleLarge,
                    ),
                  ),
                  const Divider(height: 1),
                  ...logs.map(
                    (log) => ListTile(
                      title: Text('${log.method} · ${log.balance}'),
                      subtitle: Text('${log.code}\n${log.time}'),
                      isThreeLine: true,
                      trailing: _RechargeStatusBadge(status: log.status),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _RechargeUnavailable extends StatelessWidget {
  const _RechargeUnavailable({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) => Card(
    child: Padding(
      padding: const EdgeInsets.all(16),
      child: Text(
        message,
        style: TextStyle(color: Theme.of(context).colorScheme.outline),
      ),
    ),
  );
}

class _KeyRechargeForm extends StatelessWidget {
  const _KeyRechargeForm({
    required this.controller,
    required this.busy,
    required this.onChanged,
    required this.onRedeem,
  });

  final TextEditingController controller;
  final bool busy;
  final VoidCallback onChanged;
  final VoidCallback onRedeem;

  @override
  Widget build(BuildContext context) => Card(
    child: Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Recharge with a key',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 12),
          TextField(
            controller: controller,
            enabled: !busy,
            decoration: const InputDecoration(labelText: 'Recharge key'),
            onChanged: (_) => onChanged(),
          ),
          const SizedBox(height: 12),
          FilledButton(
            onPressed: busy || controller.text.trim().isEmpty ? null : onRedeem,
            child: const Text('Redeem key'),
          ),
        ],
      ),
    ),
  );
}

class _AlipayRechargeForm extends StatelessWidget {
  const _AlipayRechargeForm({
    required this.controller,
    required this.busy,
    required this.onChanged,
    required this.onPay,
  });

  final TextEditingController controller;
  final bool busy;
  final VoidCallback onChanged;
  final ValueChanged<int> onPay;

  @override
  Widget build(BuildContext context) {
    final value = int.tryParse(controller.text.trim());
    final amountIsValid = value != null && value > 0 && value <= 100000;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Recharge with Alipay',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 12),
            TextField(
              controller: controller,
              enabled: !busy,
              decoration: const InputDecoration(labelText: 'Amount'),
              keyboardType: TextInputType.number,
              onChanged: (_) => onChanged(),
            ),
            const SizedBox(height: 12),
            FilledButton(
              onPressed: busy || !amountIsValid ? null : () => onPay(value),
              child: const Text('Pay with Alipay'),
            ),
            const SizedBox(height: 8),
            Text(
              'Enter an amount from 1 to 100000.',
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ),
      ),
    );
  }
}

class _AlipayOrderCard extends StatelessWidget {
  const _AlipayOrderCard({required this.order, required this.onDismiss});

  final AlipayOrder order;
  final VoidCallback onDismiss;

  @override
  Widget build(BuildContext context) {
    final qrBytes = _decodeQrCode(order.qrCodeBase64);
    final statusMessage = switch (order.status) {
      PayStatus.pending => 'Scan the QR code with Alipay. Payment status is checked automatically every 3 seconds.',
      PayStatus.success => 'Payment received. Your balance has been credited.',
      PayStatus.failed =>
        'Payment failed or expired. You can start a new payment.',
      PayStatus.invalid =>
        'This payment order was not found. You can start a new payment.',
      PayStatus.timeout => 'Automatic status checks stopped before payment was confirmed. Check your balance before trying again.',
      _ => 'Payment status: ${order.status}',
    };
    final settled = order.isSettled;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    'Alipay payment',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                ),
                _RechargeStatusBadge(status: order.status),
              ],
            ),
            const SizedBox(height: 12),
            Text(statusMessage),
            const SizedBox(height: 12),
            if (!settled && qrBytes != null)
              Center(
                child: Image.memory(
                  qrBytes,
                  width: 256,
                  height: 256,
                  fit: BoxFit.contain,
                  errorBuilder: (_, _, _) =>
                      const Text('The payment QR code could not be displayed.'),
                ),
              )
            else if (!settled)
              const _RechargeUnavailable(
                message: 'The payment QR code could not be decoded. Please create a new payment.',
              ),
            const SizedBox(height: 8),
            SelectableText('Trade number: ${order.outTradeNo}'),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: onDismiss,
                child: Text(settled ? 'Done' : 'Cancel payment'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Uint8List? _decodeQrCode(String value) {
  final trimmed = value.trim();
  if (trimmed.isEmpty) return null;
  final comma = trimmed.startsWith('data:') ? trimmed.indexOf(',') : -1;
  final encoded = (comma >= 0 ? trimmed.substring(comma + 1) : trimmed)
      .replaceAll(RegExp(r'\s'), '');
  try {
    return base64Decode(encoded);
  } on FormatException {
    return null;
  }
}

class _RechargeStatusBadge extends StatelessWidget {
  const _RechargeStatusBadge({required this.status});

  final String status;

  @override
  Widget build(BuildContext context) {
    final colour = switch (status) {
      RechargeStatus.success => PeoTokens.success,
      RechargeStatus.failed ||
      RechargeStatus.invalid => Theme.of(context).colorScheme.error,
      RechargeStatus.pending => PeoTokens.warning,
      PayStatus.timeout => Theme.of(context).colorScheme.outline,
      _ => Theme.of(context).colorScheme.primary,
    };
    return StatusBadge(label: status, colour: colour);
  }
}
