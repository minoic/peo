/// The state primitives every cubit shares.
///
/// The whole app talks to one API, so every screen has the same three things to
/// say: what it is reading, whether a write is in flight, and what the server
/// last answered. Those three are modelled once here and reused, which is what
/// keeps the individual cubits down to a handful of lines each.
library;

import 'package:flutter/foundation.dart';

import '../api/api_exception.dart';

/// How far a read has got.
enum LoadStatus { idle, loading, ready, failure }

/// The result of one read.
@immutable
class AsyncValue<T> {
  const AsyncValue._({required this.status, this.value, this.error});

  /// Nothing has been requested yet.
  const AsyncValue.idle() : this._(status: LoadStatus.idle);

  /// A read is in flight and there is nothing to show yet.
  const AsyncValue.loading() : this._(status: LoadStatus.loading);

  /// The payload arrived.
  const AsyncValue.ready(T value)
    : this._(status: LoadStatus.ready, value: value);

  /// The read was rejected. [error] carries the code the UI switches on.
  const AsyncValue.failure(ApiException error)
    : this._(status: LoadStatus.failure, error: error);

  final LoadStatus status;

  /// The last successful payload. It is kept across a refresh so a list does not
  /// collapse to an empty state every time the next page is requested.
  final T? value;

  final ApiException? error;

  bool get isIdle => status == LoadStatus.idle;
  bool get isLoading => status == LoadStatus.loading;
  bool get isReady => status == LoadStatus.ready;
  bool get hasFailed => status == LoadStatus.failure;

  /// True while there is something to draw, even if a refresh is in flight.
  bool get hasValue => value != null;

  /// A refresh that keeps the previous payload available to the UI.
  AsyncValue<T> refreshing() =>
      AsyncValue<T>._(status: LoadStatus.loading, value: value);
}

/// The state of a write.
@immutable
class ActionState {
  const ActionState({this.busy = false, this.error, this.message});

  /// Nothing is happening.
  const ActionState.idle() : this();

  /// A write is in flight, so the form disables its submit button.
  const ActionState.pending() : this(busy: true);

  /// The write succeeded. [message] is the confirmation to surface, if any.
  const ActionState.done(String? message) : this(message: message);

  /// The write was rejected.
  const ActionState.failed(ApiException error) : this(error: error);

  final bool busy;
  final ApiException? error;
  final String? message;

  /// True once a write has completed and left something worth telling the user.
  bool get succeeded => !busy && error == null && message != null;

  /// True when the last write was rejected.
  bool get failed => error != null;
}

/// Runs a remote write and turns its outcome into an [ActionState].
///
/// Every mutating cubit method has the same shape — mark the form busy, call the
/// API, publish the result — so the middle step lives here. [body] returns the
/// confirmation to display, or `null` when there is nothing to say.
Future<ActionState> perform(Future<String?> Function() body) async {
  try {
    return ActionState.done(await body());
  } on ApiException catch (e) {
    return ActionState.failed(e);
  }
}

/// A cubit state that owns exactly one read.
@immutable
class ValueState<T> {
  ValueState({AsyncValue<T>? value, this.action = const ActionState.idle()})
    : value = value ?? AsyncValue<T>.idle();

  final AsyncValue<T> value;
  final ActionState action;

  ValueState<T> copyWith({AsyncValue<T>? value, ActionState? action}) =>
      ValueState<T>(value: value ?? this.value, action: action ?? this.action);
}

/// A cubit state that owns exactly one collection read.
@immutable
class ListState<T> {
  ListState({
    AsyncValue<List<T>>? items,
    this.action = const ActionState.idle(),
  }) : items = items ?? AsyncValue<List<T>>.idle();

  final AsyncValue<List<T>> items;
  final ActionState action;

  /// The rows currently on screen; empty before the first successful read.
  List<T> get list => items.value ?? const [];

  ListState<T> copyWith({AsyncValue<List<T>>? items, ActionState? action}) =>
      ListState<T>(items: items ?? this.items, action: action ?? this.action);
}
