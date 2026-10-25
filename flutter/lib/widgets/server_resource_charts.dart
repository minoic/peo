import 'package:flutter/material.dart';

import '../state/server_workspace_cubit.dart';

class ServerResourceCharts extends StatelessWidget {
  const ServerResourceCharts({
    super.key,
    required this.points,
    required this.cpuMaximum,
    required this.memoryMaximum,
  });

  final List<ResourcePoint> points;
  final double cpuMaximum;
  final double memoryMaximum;

  @override
  Widget build(BuildContext context) => Row(
    children: [
      Expanded(
        child: _MetricChart(
          title: 'CPU (%)',
          points: points,
          memory: false,
          colour: const Color(0xff168f91),
          maximum: cpuMaximum,
          suffix: '%',
        ),
      ),
      const SizedBox(width: 10),
      Expanded(
        child: _MetricChart(
          title: 'Memory (MiB)',
          points: points,
          memory: true,
          colour: const Color(0xff3977d5),
          maximum: memoryMaximum,
          suffix: ' MiB',
        ),
      ),
    ],
  );
}

class _MetricChart extends StatefulWidget {
  const _MetricChart({
    required this.title,
    required this.points,
    required this.memory,
    required this.colour,
    required this.maximum,
    required this.suffix,
  });
  final String title;
  final List<ResourcePoint> points;
  final bool memory;
  final Color colour;
  final double maximum;
  final String suffix;
  @override
  State<_MetricChart> createState() => _MetricChartState();
}

class _MetricChartState extends State<_MetricChart> {
  int? _hover;

  @override
  void didUpdateWidget(covariant _MetricChart oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (_hover != null && _hover! >= widget.points.length) {
      _hover = widget.points.isEmpty ? null : widget.points.length - 1;
    }
  }

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.fromLTRB(10, 8, 10, 6),
    decoration: BoxDecoration(
      color: Theme.of(context).colorScheme.surface,
      border: Border.all(color: Theme.of(context).dividerColor),
      borderRadius: BorderRadius.circular(6),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Wrap(
          alignment: WrapAlignment.spaceBetween,
          children: [
            Text(widget.title, style: Theme.of(context).textTheme.titleSmall),
            if (_hover != null && widget.points.isNotEmpty)
              Text(
                '${_value(widget.points[_hover!]).toStringAsFixed(1)}${widget.suffix} · ${_time(context, widget.points[_hover!].time)}',
                style: Theme.of(context).textTheme.labelMedium,
              ),
          ],
        ),
        SizedBox(
          height: 96,
          child: LayoutBuilder(
            builder: (context, size) => MouseRegion(
              onExit: (_) => setState(() => _hover = null),
              onHover: (event) {
                if (widget.points.length < 2 || size.maxWidth <= 0) return;
                final start = widget.points.last.time.subtract(
                  const Duration(minutes: 5),
                );
                final ratio = (event.localPosition.dx / size.maxWidth).clamp(
                  0.0,
                  1.0,
                );
                final target = start.add(
                  Duration(
                    milliseconds:
                        (ratio * const Duration(minutes: 5).inMilliseconds)
                            .round(),
                  ),
                );
                var nearest = 0;
                for (var i = 1; i < widget.points.length; i++) {
                  if (widget.points[i].time
                          .difference(target)
                          .inMilliseconds
                          .abs() <
                      widget.points[nearest].time
                          .difference(target)
                          .inMilliseconds
                          .abs()) {
                    nearest = i;
                  }
                }
                setState(() => _hover = nearest);
              },
              child: CustomPaint(
                painter: _ResourcePainter(
                  widget.points,
                  memory: widget.memory,
                  colour: widget.colour,
                  hover: _hover,
                  maximum: widget.maximum,
                ),
                child: const SizedBox.expand(),
              ),
            ),
          ),
        ),
        Row(
          children: [
            Expanded(
              child: Text(
                widget.points.isEmpty
                    ? '—'
                    : _time(
                        context,
                        widget.points.last.time.subtract(
                          const Duration(minutes: 5),
                        ),
                      ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Expanded(
              child: Text(
                widget.points.isEmpty
                    ? '—'
                    : _time(context, widget.points.last.time),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.end,
              ),
            ),
          ],
        ),
      ],
    ),
  );

  double _value(ResourcePoint point) =>
      widget.memory ? point.memory : point.cpu;

  String _time(BuildContext context, DateTime time) =>
      TimeOfDay.fromDateTime(time.toLocal()).format(context);
}

class _ResourcePainter extends CustomPainter {
  _ResourcePainter(
    this.points, {
    required this.memory,
    required this.colour,
    required this.hover,
    required this.maximum,
  });
  final List<ResourcePoint> points;
  final bool memory;
  final Color colour;
  final int? hover;
  final double maximum;

  @override
  void paint(Canvas canvas, Size size) {
    final grid = Paint()
      ..color = const Color(0x223c566d)
      ..strokeWidth = 1;
    for (var i = 0; i <= 4; i++) {
      canvas.drawLine(
        Offset(0, size.height * i / 4),
        Offset(size.width, size.height * i / 4),
        grid,
      );
    }
    if (points.length < 2) return;

    final start = points.last.time.subtract(const Duration(minutes: 5));
    final path = Path();
    for (var i = 0; i < points.length; i++) {
      final point = points[i];
      final x =
          point.time.difference(start).inMilliseconds /
          const Duration(minutes: 5).inMilliseconds;
      final offset = Offset(
        size.width * x.clamp(0.0, 1.0),
        size.height * (1 - (_value(point) / _chartMaximum).clamp(0.0, 1.0)),
      );
      if (i == 0) {
        path.moveTo(offset.dx, offset.dy);
      } else {
        path.lineTo(offset.dx, offset.dy);
      }
    }
    canvas.drawPath(
      path,
      Paint()
        ..color = colour
        ..strokeWidth = 2
        ..style = PaintingStyle.stroke,
    );
    if (hover != null && hover! < points.length) {
      final x =
          size.width *
          (points[hover!].time.difference(start).inMilliseconds /
                  const Duration(minutes: 5).inMilliseconds)
              .clamp(0.0, 1.0);
      canvas.drawLine(
        Offset(x, 0),
        Offset(x, size.height),
        Paint()
          ..color = colour.withValues(alpha: .5)
          ..strokeWidth = 1,
      );
    }
  }

  double _value(ResourcePoint point) => memory ? point.memory : point.cpu;

  double get _chartMaximum {
    final peak = points.fold<double>(0, (current, point) {
      final value = _value(point);
      return value > current ? value : current;
    });
    final base = maximum > peak ? maximum : peak;
    return base <= 0 ? 1 : base;
  }

  @override
  bool shouldRepaint(covariant _ResourcePainter oldDelegate) =>
      oldDelegate.points != points ||
      oldDelegate.hover != hover ||
      oldDelegate.memory != memory ||
      oldDelegate.maximum != maximum;
}
