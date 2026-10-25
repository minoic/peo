/// Recharge: the history list, a balance code, and the Alipay flows.
///
/// Two ways to top up are kept exactly as the legacy pages had them: a
/// pre-generated balance key, and an Alipay face-to-face QR code that the client
/// polls until the payment lands.
library;

import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../api/api_exception.dart';
import '../api/peo_api.dart';
import '../models/documents.dart';
import 'async_value.dart';

/// The statuses the Alipay endpoint reports while an order is open.
///
/// The server stores these as data; the badge is the client's business.
abstract final class PayStatus {
  /// The order was created and is waiting for the customer to scan.
  static const String pending = RechargeStatus.pending;

  /// The payment landed and the balance was credited.
  static const String success = RechargeStatus.success;

  /// The order expired or the payment was refused.
  static const String failed = RechargeStatus.failed;

  /// The order is not known to the server.
  static const String invalid = RechargeStatus.invalid;

  /// The client stopped polling before the order settled.
  static const String timeout = 'timeout';
}

/// The open Alipay order, if there is one.
@immutable
class AlipayOrder {
  const AlipayOrder({
    required this.outTradeNo,
    required this.qrCodeBase64,
    this.status = PayStatus.pending,
  });

  /// The merchant trade number; the handle the status endpoint is polled with.
  final String outTradeNo;

  /// The QR code as a base64 PNG, ready to draw.
  final String qrCodeBase64;

  final String status;

  bool get isSettled =>
      status == PayStatus.success ||
      status == PayStatus.failed ||
      status == PayStatus.invalid ||
      status == PayStatus.timeout;

  bool get isPaid => status == PayStatus.success;
}

/// The recharge history plus the open Alipay order.
@immutable
class RechargeState {
  const RechargeState({
    this.logs = const AsyncValue<List<RechargeLog>>.idle(),
    this.order,
    this.action = const ActionState.idle(),
  });

  final AsyncValue<List<RechargeLog>> logs;

  /// Present while a QR code is on screen.
  final AlipayOrder? order;

  final ActionState action;

  RechargeState copyWith({
    AsyncValue<List<RechargeLog>>? logs,
    AlipayOrder? order,
    ActionState? action,
    bool clearOrder = false,
  }) => RechargeState(
    logs: logs ?? this.logs,
    order: clearOrder ? null : (order ?? this.order),
    action: action ?? this.action,
  );
}

/// Owns the recharge page.
class RechargeCubit extends Cubit<RechargeState> {
  RechargeCubit(this.api) : super(const RechargeState());

  final PeoApi api;

  Timer? _poll;

  /// How long to wait between status reads. The legacy page polled at the same
  /// cadence.
  static const Duration pollInterval = Duration(seconds: 3);

  Future<void> load() async {
    emit(
      state.copyWith(
        logs: state.logs.hasValue
            ? state.logs.refreshing()
            : const AsyncValue<List<RechargeLog>>.loading(),
      ),
    );
    try {
      final logs = await api.rechargeLogs();
      if (isClosed) return;
      emit(state.copyWith(logs: AsyncValue<List<RechargeLog>>.ready(logs)));
    } on ApiException catch (e) {
      if (isClosed) return;
      emit(state.copyWith(logs: AsyncValue<List<RechargeLog>>.failure(e)));
    }
  }

  /// Redeems a balance key.
  Future<ActionState> redeemKey(String key) async {
    emit(state.copyWith(action: const ActionState.pending()));
    final result = await perform(() async {
      await api.rechargeByKey(key);
      return 'the balance has been topped up';
    });
    if (isClosed) return result;
    emit(state.copyWith(action: result));
    if (result.succeeded) await load();
    return result;
  }

  /// Creates an Alipay order and starts polling it.
  Future<ActionState> startAlipay(int amount) async {
    emit(state.copyWith(action: const ActionState.pending(), clearOrder: true));
    final result = await perform(() async {
      final created = await api.preCreateRecharge(amount);
      if (isClosed) return null;
      emit(
        state.copyWith(
          order: AlipayOrder(
            outTradeNo: created.outTradeNo,
            qrCodeBase64: created.qrCodeBase64,
          ),
        ),
      );
      _startPolling(created.outTradeNo);
      return 'scan the code to pay';
    });
    if (isClosed) return result;
    emit(state.copyWith(action: result));
    return result;
  }

  void _startPolling(String outTradeNo) {
    _poll?.cancel();
    _poll = Timer.periodic(pollInterval, (_) => unawaited(_check(outTradeNo)));
  }

  Future<void> _check(String outTradeNo) async {
    try {
      final status = await api.rechargeStatus(outTradeNo);
      if (isClosed) return;
      final current = state.order;
      // A late reply for a superseded order must not overwrite the live one.
      if (current == null || current.outTradeNo != outTradeNo) return;
      emit(
        state.copyWith(
          order: AlipayOrder(
            outTradeNo: current.outTradeNo,
            qrCodeBase64: current.qrCodeBase64,
            status: status,
          ),
        ),
      );
      if (status == PayStatus.success) {
        stopPolling();
        await load();
      } else if (status == PayStatus.failed || status == PayStatus.invalid) {
        stopPolling();
      }
    } on ApiException catch (e) {
      if (isClosed) return;
      // A `404` means the order is unknown, which is as final as a refusal.
      if (e.isNotFound) {
        stopPolling();
        final current = state.order;
        if (current == null) return;
        emit(
          state.copyWith(
            order: AlipayOrder(
              outTradeNo: current.outTradeNo,
              qrCodeBase64: current.qrCodeBase64,
              status: PayStatus.invalid,
            ),
          ),
        );
      }
    }
  }

  void stopPolling() {
    _poll?.cancel();
    _poll = null;
  }

  /// Gives up on the open order so the amount form comes back.
  void cancelOrder() {
    stopPolling();
    emit(state.copyWith(clearOrder: true));
  }

  @override
  Future<void> close() {
    stopPolling();
    return super.close();
  }
}
