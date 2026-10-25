/// In-site messages and work orders.
library;

import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../api/api_exception.dart';
import '../api/peo_api.dart';
import '../models/content.dart';
import 'async_value.dart';

/// The inbox, with the unread count the shell badge shows.
///
/// The count is tracked beside the list rather than derived from it, because
/// the list is trimmed by the server and the badge must match the server's
/// number, not the client's.
@immutable
class MessagesState {
  const MessagesState({
    this.messages = const AsyncValue<List<MessageItem>>.idle(),
    this.unread = 0,
    this.action = const ActionState.idle(),
  });

  final AsyncValue<List<MessageItem>> messages;
  final int unread;
  final ActionState action;

  List<MessageItem> get list => messages.value ?? const [];

  MessagesState copyWith({
    AsyncValue<List<MessageItem>>? messages,
    int? unread,
    ActionState? action,
  }) => MessagesState(
    messages: messages ?? this.messages,
    unread: unread ?? this.unread,
    action: action ?? this.action,
  );
}

/// Owns the inbox.
class MessagesCubit extends Cubit<MessagesState> {
  MessagesCubit(this.api) : super(const MessagesState());

  final PeoApi api;

  Future<void> load() async {
    emit(
      state.copyWith(
        messages: state.messages.hasValue
            ? state.messages.refreshing()
            : const AsyncValue<List<MessageItem>>.loading(),
      ),
    );
    try {
      final messages = await api.messages();
      if (isClosed) return;
      emit(
        state.copyWith(
          messages: AsyncValue<List<MessageItem>>.ready(messages),
          unread: messages.where((m) => !m.haveRead).length,
        ),
      );
      await refreshUnread();
    } on ApiException catch (e) {
      if (isClosed) return;
      emit(state.copyWith(messages: AsyncValue<List<MessageItem>>.failure(e)));
    }
  }

  /// Refreshes only the badge, for the shell to call after a poll.
  Future<void> refreshUnread() async {
    try {
      final unread = await api.unreadCount();
      if (isClosed) return;
      emit(state.copyWith(unread: unread));
    } on ApiException {
      // Keep the previous count.
    }
  }

  /// Marks one message as read.
  Future<ActionState> markRead(String id) =>
      _mutate(() => api.markMessageRead(id), 'message marked as read');

  /// Marks every message as read.
  Future<ActionState> markAllRead() => _mutate(
    () => api.markAllMessagesRead(),
    'every message marked as read',
    unreadAfter: 0,
  );

  /// Deletes one message.
  ///
  /// The unread count is re-read rather than decremented, because deleting an
  /// unread message changes it and the server is the authority.
  Future<ActionState> delete(String id) =>
      _mutate(() => api.deleteMessage(id), 'message deleted');

  Future<ActionState> _mutate(
    Future<void> Function() call,
    String message, {
    int? unreadAfter,
  }) async {
    if (state.action.busy) return state.action;
    emit(state.copyWith(action: const ActionState.pending()));
    final result = await perform(() async {
      await call();
      return message;
    });
    if (isClosed) return result;
    if (!result.succeeded) {
      emit(state.copyWith(action: result));
      return result;
    }
    if (unreadAfter != null) {
      emit(state.copyWith(unread: unreadAfter));
    }
    await load();
    if (!isClosed) emit(state.copyWith(action: result));
    return result;
  }
}

/// The customer's support tickets.
class WorkOrdersCubit extends Cubit<ListState<WorkOrderItem>> {
  WorkOrdersCubit(this.api) : super(ListState<WorkOrderItem>());

  final PeoApi api;

  Future<void> load() async {
    emit(
      state.copyWith(
        items: state.items.hasValue
            ? state.items.refreshing()
            : const AsyncValue<List<WorkOrderItem>>.loading(),
      ),
    );
    try {
      final orders = await api.workOrders();
      if (isClosed) return;
      emit(
        state.copyWith(items: AsyncValue<List<WorkOrderItem>>.ready(orders)),
      );
    } on ApiException catch (e) {
      if (isClosed) return;
      emit(state.copyWith(items: AsyncValue<List<WorkOrderItem>>.failure(e)));
    }
  }

  /// Opens a ticket.
  ///
  /// The server rate limits this per user name, so a `rate_limited` answer is
  /// expected and surfaced as-is rather than retried.
  Future<ActionState> create({
    required String title,
    required String text,
  }) async {
    emit(state.copyWith(action: const ActionState.pending()));
    final result = await perform(() async {
      await api.createWorkOrder(
        CreateWorkOrderRequest(title: title, text: text),
      );
      return 'work order opened';
    });
    if (isClosed) return result;
    emit(state.copyWith(action: result));
    if (result.succeeded) await load();
    return result;
  }
}
