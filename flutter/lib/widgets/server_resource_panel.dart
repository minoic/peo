import 'package:flutter/material.dart';

import '../models/server_console.dart';
import '../state/server_workspace_cubit.dart';
import 'server_resource_charts.dart';

class ServerResourcePanel extends StatelessWidget {
  const ServerResourcePanel({
    super.key,
    required this.points,
    required this.usage,
    required this.limits,
    required this.updatedAt,
    required this.staleMessage,
    this.showSummary = true,
    this.showCharts = true,
  });

  final List<ResourcePoint> points;
  final ResourceUsage? usage;
  final ConsoleLimits? limits;
  final DateTime? updatedAt;
  final String staleMessage;
  final bool showSummary;
  final bool showCharts;

  @override
  Widget build(BuildContext context) {
    final currentUsage = usage;
    final currentLimits = limits;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (showSummary)
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _UsageTile(
                label: 'CPU',
                value: currentUsage == null
                    ? '—'
                    : '${currentUsage.cpuAbsolute.toStringAsFixed(1)}%',
                limit: currentLimits == null ? null : '${currentLimits.cpu}%',
                icon: Icons.developer_board,
                colour: const Color(0xff168f91),
                height: 104,
              ),
              const SizedBox(height: 8),
              _UsageTile(
                label: 'Memory',
                value: currentUsage == null
                    ? '—'
                    : '${(currentUsage.memoryBytes / 1048576).toStringAsFixed(0)} MiB',
                limit: currentLimits == null
                    ? null
                    : '${currentLimits.memory} MiB',
                icon: Icons.memory,
                colour: const Color(0xff3977d5),
                height: 104,
              ),
              const SizedBox(height: 8),
              _UsageTile(
                label: 'Disk',
                value: currentUsage == null
                    ? '—'
                    : _bytes(currentUsage.diskBytes),
                limit: currentLimits == null
                    ? null
                    : '${currentLimits.disk} MiB',
                icon: Icons.storage,
                colour: const Color(0xff9a6a18),
                height: 80,
              ),
              const SizedBox(height: 8),
              _UsageTile(
                label: 'Uptime',
                value: currentUsage == null
                    ? '—'
                    : formatServerUptime(currentUsage.uptime),
                icon: Icons.schedule,
                colour: const Color(0xff7654a6),
                height: 80,
              ),
              const SizedBox(height: 8),
              _UsageTile(
                label: 'Network total',
                value: currentUsage == null
                    ? '—'
                    : '↓${_bytes(currentUsage.networkRxBytes)}  ↑${_bytes(currentUsage.networkTxBytes)}',
                icon: Icons.swap_vert,
                colour: const Color(0xff287a52),
                height: 80,
              ),
            ],
          ),
        if (showCharts && showSummary) const SizedBox(height: 10),
        if (showCharts)
          ServerResourceCharts(
            points: points,
            cpuMaximum: (limits?.cpu ?? 100).toDouble(),
            memoryMaximum: (limits?.memory ?? 1024).toDouble(),
          ),
        if (showCharts)
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Text(
              '${staleMessage.isEmpty ? 'Updated' : 'Stale'} ${updatedAt?.toLocal().toString() ?? 'Waiting for first sample'}${staleMessage.isEmpty ? '' : ' · $staleMessage'}',
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ),
      ],
    );
  }
}

class _UsageTile extends StatelessWidget {
  const _UsageTile({
    required this.label,
    required this.value,
    required this.icon,
    required this.colour,
    required this.height,
    this.limit,
  });
  final String label;
  final String value;
  final IconData icon;
  final Color colour;
  final double height;
  final String? limit;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return SizedBox(
      height: height,
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Color.alphaBlend(
            colour.withValues(alpha: 0.06),
            scheme.surface,
          ),
          border: Border.all(color: colour.withValues(alpha: 0.24)),
          borderRadius: BorderRadius.circular(6),
        ),
        child: FittedBox(
          fit: BoxFit.scaleDown,
          alignment: Alignment.centerLeft,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                children: [
                  Icon(icon, size: 16, color: colour),
                  const SizedBox(width: 6),
                  Text(label, style: Theme.of(context).textTheme.labelMedium),
                ],
              ),
              const SizedBox(height: 4),
              Tooltip(
                message: value,
                child: Text(
                  value,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.titleSmall
                      ?.copyWith(color: colour, fontWeight: FontWeight.w600),
                ),
              ),
              if (limit != null)
                Text('of $limit', style: Theme.of(context).textTheme.bodySmall),
            ],
          ),
        ),
      ),
    );
  }
}

String _bytes(int value) {
  if (value < 1024) return '$value B';
  if (value < 1024 * 1024) return '${(value / 1024).toStringAsFixed(1)} KiB';
  if (value < 1024 * 1024 * 1024) {
    return '${(value / 1024 / 1024).toStringAsFixed(1)} MiB';
  }
  return '${(value / 1024 / 1024 / 1024).toStringAsFixed(1)} GiB';
}
