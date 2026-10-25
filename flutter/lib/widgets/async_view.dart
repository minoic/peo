/// The shared rendering of a read.
///
/// Every screen has the same three states — nothing yet, a failure, or a
/// payload — so the plumbing lives here rather than being repeated twenty
/// times. [AsyncView] also keeps the previous payload on screen while a refresh
/// is in flight, which is what stops a polled list from flickering.
library;

import 'package:flutter/material.dart';

import '../api/api_exception.dart';
import '../state/async_value.dart';
import '../theme/peo_theme.dart';

/// Renders an [AsyncValue] without the caller having to branch on its status.
class AsyncView<T> extends StatelessWidget {
  const AsyncView({
    super.key,
    required this.value,
    required this.builder,
    this.onRetry,
    this.empty,
  });

  final AsyncValue<T> value;

  /// Draws the payload. Called for a ready value and for a refresh that has a
  /// previous value to keep showing.
  final Widget Function(BuildContext context, T data) builder;

  /// Shown on a failure; when null no retry button is offered.
  final VoidCallback? onRetry;

  /// Shown when a ready payload is itself empty.
  final Widget? empty;

  @override
  Widget build(BuildContext context) {
    final reduceMotion = MediaQuery.disableAnimationsOf(context);
    final duration = reduceMotion ? Duration.zero : PeoTokens.motionFast;
    final data = value.value;
    if (data != null) {
      if (value.isReady && empty != null && _isEmpty(data)) {
        return _transition(empty!, duration);
      }
      return _transition(builder(context, data), duration);
    }
    if (value.hasFailed) {
      return _transition(
        ErrorPanel(error: value.error!, onRetry: onRetry),
        duration,
      );
    }
    if (value.isLoading) {
      return _transition(
        const Padding(
          padding: EdgeInsets.symmetric(vertical: 48),
          child: Center(child: CircularProgressIndicator()),
        ),
        duration,
      );
    }
    return _transition(empty ?? const SizedBox.shrink(), duration);
  }

  Widget _transition(Widget child, Duration duration) => AnimatedSwitcher(
    duration: duration,
    switchInCurve: Curves.easeOutCubic,
    switchOutCurve: Curves.easeInCubic,
    // Flutter's default transition derives its key from child.key. AsyncView
    // children are commonly unkeyed, so overlapping outgoing transitions can
    // otherwise receive the same ValueKey(null).
    transitionBuilder: (child, animation) =>
        FadeTransition(opacity: animation, child: child),
    child: child,
  );

  bool _isEmpty(T data) => data is List && data.isEmpty;
}

/// The standard failure box, with the server's message and an optional retry.
class ErrorPanel extends StatelessWidget {
  const ErrorPanel({super.key, required this.error, this.onRetry});

  final ApiException error;
  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Card(
      color: scheme.errorContainer,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(Icons.error_outline, color: scheme.onErrorContainer),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                error.message,
                style: TextStyle(color: scheme.onErrorContainer),
              ),
            ),
            if (onRetry != null) ...[
              const SizedBox(width: 12),
              TextButton(onPressed: onRetry, child: const Text('Retry')),
            ],
          ],
        ),
      ),
    );
  }
}

/// The standard "there is nothing here" box.
class EmptyPanel extends StatelessWidget {
  const EmptyPanel({
    super.key,
    required this.message,
    this.icon = Icons.inbox_outlined,
  });

  final String message;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 36),
      decoration: BoxDecoration(
        color: scheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: scheme.outlineVariant),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 40, color: scheme.outline),
          const SizedBox(height: 12),
          Text(message, style: TextStyle(color: scheme.onSurfaceVariant)),
        ],
      ),
    );
  }
}

/// A titled panel, mirroring the Bootstrap `.panel` the legacy pages used.
class SectionCard extends StatelessWidget {
  const SectionCard({
    super.key,
    required this.title,
    required this.child,
    this.trailing,
    this.icon,
  });

  final String title;
  final Widget child;
  final Widget? trailing;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 8, 12),
            child: Row(
              children: [
                if (icon != null) ...[
                  Icon(icon, size: 18),
                  const SizedBox(width: 8),
                ],
                Expanded(
                  child: Text(
                    title,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ),
                ?trailing,
              ],
            ),
          ),
          const Divider(height: 1),
          Padding(padding: const EdgeInsets.all(16), child: child),
        ],
      ),
    );
  }
}

/// Renders an inline success or failure message produced by a form submit.
///
/// A rejected write says why; a successful one usually says nothing, so nothing
/// is drawn in that case.
class ActionFeedback extends StatelessWidget {
  const ActionFeedback({super.key, required this.action});

  final ActionState action;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    if (action.error != null) {
      return Padding(
        padding: const EdgeInsets.only(bottom: 12),
        child: Text(
          action.error!.message,
          style: TextStyle(color: scheme.error),
        ),
      );
    }
    if (action.message != null) {
      return Padding(
        padding: const EdgeInsets.only(bottom: 12),
        child: Text(
          action.message!,
          style: const TextStyle(color: PeoTokens.success),
        ),
      );
    }
    return const SizedBox.shrink();
  }
}

/// A submit button that shows a spinner while its write is in flight.
///
/// Used everywhere a form has exactly one action, so the disabled state and the
/// progress indicator cannot drift between pages.
class SubmitButton extends StatelessWidget {
  const SubmitButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.busy = false,
    this.icon,
  });

  final String label;
  final VoidCallback? onPressed;
  final bool busy;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    return FilledButton.icon(
      onPressed: busy ? null : onPressed,
      icon: busy
          ? const SizedBox(
              width: 16,
              height: 16,
              child: CircularProgressIndicator(strokeWidth: 2),
            )
          : Icon(icon ?? Icons.check),
      label: Text(label),
    );
  }
}

/// A one-line label/value pair, as used by every detail table.
class DetailRow extends StatelessWidget {
  const DetailRow({super.key, required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 160,
            child: Text(label, style: TextStyle(color: scheme.outline)),
          ),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }
}

/// The Bootstrap-style status badge, used for orders and recharges.
class StatusBadge extends StatelessWidget {
  const StatusBadge({super.key, required this.label, required this.colour});

  final String label;
  final Color colour;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: colour.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: colour.withValues(alpha: 0.3)),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: colour,
          fontSize: 12,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.1,
        ),
      ),
    );
  }
}
