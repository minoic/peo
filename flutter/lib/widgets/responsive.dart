import 'dart:math' as math;

import 'package:flutter/material.dart';

/// Breakpoints used by navigation, sidebars, and content grids.
abstract final class PeoBreakpoints {
  static const mobileMaxWidth = 640.0;
  static const desktopMinWidth = 1024.0;
  static const maxContentWidth = 1600.0;
  static const serverWorkspaceMaxWidth = maxContentWidth;

  static bool isMobile(double width) => width < mobileMaxWidth;
  static bool isDesktop(double width) => width >= desktopMinWidth;

  static int gridColumns(
    double width, {
    double minTileWidth = 280,
    int maxColumns = 4,
    double spacing = 16,
  }) {
    if (width <= 0) return 1;
    final count = ((width + spacing) / (minTileWidth + spacing)).floor();
    return count.clamp(1, maxColumns);
  }
}

/// Centers page content and prevents long desktop layouts from stretching.
class ResponsivePage extends StatelessWidget {
  const ResponsivePage({super.key, required this.child, this.padding});

  final Widget child;
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) => LayoutBuilder(
    builder: (context, constraints) {
      final width = math.min(
        constraints.maxWidth,
        PeoBreakpoints.maxContentWidth,
      );
      return Align(
        alignment: Alignment.topCenter,
        child: ConstrainedBox(
          constraints: BoxConstraints(minWidth: width, maxWidth: width),
          child: Padding(
            padding: padding ?? const EdgeInsets.all(24),
            child: child,
          ),
        ),
      );
    },
  );
}

/// A wrapping grid whose column count follows the available content width.
class AdaptiveGrid extends StatelessWidget {
  const AdaptiveGrid({
    super.key,
    required this.children,
    this.minTileWidth = 280,
    this.maxColumns = 4,
    this.spacing = 16,
    this.runSpacing = 16,
  });

  final List<Widget> children;
  final double minTileWidth;
  final int maxColumns;
  final double spacing;
  final double runSpacing;

  @override
  Widget build(BuildContext context) => LayoutBuilder(
    builder: (context, constraints) {
      final width = constraints.maxWidth;
      final columns = PeoBreakpoints.gridColumns(
        width,
        minTileWidth: minTileWidth,
        maxColumns: maxColumns,
        spacing: spacing,
      );
      final itemWidth = math
          .max(0, (width - spacing * (columns - 1)) / columns)
          .toDouble();
      return Wrap(
        spacing: spacing,
        runSpacing: runSpacing,
        children: [
          for (final child in children)
            SizedBox(width: itemWidth, child: child),
        ],
      );
    },
  );
}
