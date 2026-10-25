import 'package:flutter/material.dart';

import '../theme/peo_theme.dart';

/// A short page entrance that respects the operating system's reduced-motion
/// preference.
class PageEntrance extends StatefulWidget {
  const PageEntrance({super.key, required this.child});

  final Widget child;

  @override
  State<PageEntrance> createState() => _PageEntranceState();
}

class _PageEntranceState extends State<PageEntrance>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: PeoTokens.motionStandard,
  )..forward();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (MediaQuery.disableAnimationsOf(context)) {
      _controller.value = 1;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (MediaQuery.disableAnimationsOf(context)) return widget.child;
    final animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutCubic,
    );
    return FadeTransition(
      opacity: animation,
      child: SlideTransition(
        position: Tween<Offset>(
          begin: const Offset(0, 0.012),
          end: Offset.zero,
        ).animate(animation),
        child: widget.child,
      ),
    );
  }
}

/// Adds a quiet hover border and lift to a surface that has a primary action.
class HoverCard extends StatefulWidget {
  const HoverCard({super.key, required this.child});

  final Widget child;

  @override
  State<HoverCard> createState() => _HoverCardState();
}

class _HoverCardState extends State<HoverCard> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final reducedMotion = MediaQuery.disableAnimationsOf(context);
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: AnimatedContainer(
        duration: reducedMotion ? Duration.zero : PeoTokens.motionFast,
        transform: Matrix4.translationValues(
          0,
          _hovered ? -PeoTokens.hoverLift : 0,
          0,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(PeoTokens.radiusMedium),
          boxShadow: _hovered && !reducedMotion
              ? const [
                  BoxShadow(
                    color: PeoTokens.hoverGlow,
                    blurRadius: PeoTokens.hoverBlur,
                    spreadRadius: 1,
                  ),
                ]
              : const [],
        ),
        child: widget.child,
      ),
    );
  }
}
