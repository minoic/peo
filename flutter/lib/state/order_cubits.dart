/// The customer console: the server list, one server's detail, order payment,
/// renewal and reinstallation.
///
/// The live status of a server comes from a Minecraft TCP ping, so it is polled
/// and kept beside the server list rather than inside it: a failed ping must
/// never hide a server the customer owns.
library;

import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../api/api_exception.dart';
import '../api/peo_api.dart';
import '../models/documents.dart';
import '../models/order.dart';
import '../models/site.dart';
import 'async_value.dart';

/// The customer's order history.
class OrdersCubit extends Cubit<ListState<Order>> {
  OrdersCubit(this.api, {this.loadProductCatalog = false})
    : super(ListState<Order>());

  final PeoApi api;
  final bool loadProductCatalog;
  Map<String, ProductCard> products = const {};

  Future<void> load() async {
    emit(
      state.copyWith(
        items: state.items.hasValue
            ? state.items.refreshing()
            : const AsyncValue<List<Order>>.loading(),
      ),
    );
    try {
      final orders = await api.orders();
      if (isClosed) return;
      emit(state.copyWith(items: AsyncValue<List<Order>>.ready(orders)));
      if (!loadProductCatalog) return;
      try {
        final storefront = await api.storefront();
        if (isClosed) return;
        products = {
          for (final product in [
            ...storefront.monthly,
            ...storefront.quarterly,
            ...storefront.yearly,
          ])
            product.specId: product,
        };
        emit(state.copyWith(items: AsyncValue<List<Order>>.ready(orders)));
      } on ApiException {
        // Product metadata is optional; order history remains available.
      }
    } on ApiException catch (e) {
      if (isClosed) return;
      emit(state.copyWith(items: AsyncValue<List<Order>>.failure(e)));
    }
  }
}

/// One order, the free ports of its node, and the state of the payment form.
@immutable
class OrderDetailState {
  const OrderDetailState({
    this.order = const AsyncValue<Order>.idle(),
    this.allocations = const AsyncValue<List<Allocation>>.idle(),
    this.action = const ActionState.idle(),
    this.allocationRejected = false,
    this.product,
  });

  final AsyncValue<Order> order;
  final AsyncValue<List<Allocation>> allocations;
  final ActionState action;

  /// True when the customer submitted without picking an address. Kept apart
  /// from [action] so the message lands under the address picker rather than
  /// under the key field.
  final bool allocationRejected;
  final ProductDetail? product;

  OrderDetailState copyWith({
    AsyncValue<Order>? order,
    AsyncValue<List<Allocation>>? allocations,
    ActionState? action,
    bool? allocationRejected,
    ProductDetail? product,
  }) => OrderDetailState(
    order: order ?? this.order,
    allocations: allocations ?? this.allocations,
    action: action ?? this.action,
    allocationRejected: allocationRejected ?? this.allocationRejected,
    product: product ?? this.product,
  );
}

/// Owns one order and everything needed to pay for it.
class OrderDetailCubit extends Cubit<OrderDetailState> {
  OrderDetailCubit(this.api, this.orderId) : super(const OrderDetailState());

  final PeoApi api;
  final String orderId;

  /// Reads the order and then its allocations.
  Future<void> load() async {
    emit(
      state.copyWith(
        order: state.order.hasValue
            ? state.order.refreshing()
            : const AsyncValue<Order>.loading(),
      ),
    );
    try {
      final order = await api.order(orderId);
      if (isClosed) return;
      emit(state.copyWith(order: AsyncValue<Order>.ready(order)));
      unawaited(_loadProduct(order.specId));
    } on ApiException catch (e) {
      if (isClosed) return;
      emit(state.copyWith(order: AsyncValue<Order>.failure(e)));
      return;
    }
    if (state.order.value?.status == OrderStatus.pending) {
      await loadAllocations();
    }
  }

  Future<void> _loadProduct(String specId) async {
    try {
      final product = await api.product(specId);
      if (!isClosed) emit(state.copyWith(product: product));
    } on ApiException {
      // A removed product must not prevent an existing order from being paid.
    }
  }

  /// Refreshes only the address picker, so a failed order read does not hide a
  /// working one.
  Future<void> loadAllocations() async {
    emit(
      state.copyWith(
        allocations: state.allocations.hasValue
            ? state.allocations.refreshing()
            : const AsyncValue<List<Allocation>>.loading(),
      ),
    );
    try {
      final list = await api.allocations(orderId);
      if (isClosed) return;
      emit(
        state.copyWith(allocations: AsyncValue<List<Allocation>>.ready(list)),
      );
    } on ApiException catch (e) {
      if (isClosed) return;
      emit(
        state.copyWith(allocations: AsyncValue<List<Allocation>>.failure(e)),
      );
    }
  }

  /// Pays with a product key.
  ///
  /// The address is checked here as well as on the server because a missing
  /// address is the customer's own oversight and belongs beside the picker,
  /// not in a round trip.
  Future<ActionState> payWithKey({
    required int allocationId,
    required String hostName,
    required String key,
  }) {
    if (allocationId <= 0) return _rejectAddress();
    return _pay(
      () => api.payOrder(
        orderId,
        PayOrderRequest(
          allocationId: allocationId,
          hostName: hostName,
          key: key,
        ),
      ),
    );
  }

  /// Pays from the balance.
  Future<ActionState> payWithBalance({
    required int allocationId,
    required String hostName,
  }) {
    if (allocationId <= 0) return _rejectAddress();
    return _pay(
      () => api.payOrderByBalance(
        orderId,
        PayOrderRequest(allocationId: allocationId, hostName: hostName),
      ),
    );
  }

  Future<ActionState> _rejectAddress() async {
    const failure = ActionState.failed(
      ApiException(
        code: ApiErrorCode.validationFailed,
        message: 'Pick a server address first.',
      ),
    );
    emit(state.copyWith(action: failure, allocationRejected: true));
    return failure;
  }

  Future<ActionState> _pay(Future<void> Function() call) async {
    emit(
      state.copyWith(
        action: const ActionState.pending(),
        allocationRejected: false,
      ),
    );
    final result = await perform(() async {
      await call();
      return 'order paid, the server is being created';
    });
    if (isClosed) return result;
    emit(state.copyWith(action: result));
    if (result.succeeded) await load();
    if (result.error?.code == ApiErrorCode.conflict) await load();
    return result;
  }
}

/// The customer's servers plus the last status snapshot.
@immutable
class ServersState {
  const ServersState({
    this.servers = const AsyncValue<List<WareEntity>>.idle(),
    this.statuses = const <String, ServerStatus>{},
  });

  final AsyncValue<List<WareEntity>> servers;

  /// The last snapshot, keyed by entity id. An absent entry means the status
  /// could not be read and the row should render as unknown.
  final Map<String, ServerStatus> statuses;

  List<WareEntity> get list => servers.value ?? const [];

  ServerStatus? statusOf(String entityId) => statuses[entityId];

  ServersState copyWith({
    AsyncValue<List<WareEntity>>? servers,
    Map<String, ServerStatus>? statuses,
  }) => ServersState(
    servers: servers ?? this.servers,
    statuses: statuses ?? this.statuses,
  );
}

/// Owns the console list and polls the live status.
class ServersCubit extends Cubit<ServersState> {
  ServersCubit(this.api) : super(const ServersState());

  final PeoApi api;

  Timer? _poll;

  Future<void> load() async {
    emit(
      state.copyWith(
        servers: state.servers.hasValue
            ? state.servers.refreshing()
            : const AsyncValue<List<WareEntity>>.loading(),
      ),
    );
    try {
      final servers = await api.servers();
      if (isClosed) return;
      emit(
        state.copyWith(servers: AsyncValue<List<WareEntity>>.ready(servers)),
      );
    } on ApiException catch (e) {
      if (isClosed) return;
      emit(state.copyWith(servers: AsyncValue<List<WareEntity>>.failure(e)));
    }
  }

  /// Reads the live status of every server.
  ///
  /// A failed ping is swallowed on purpose: losing the panel connection must
  /// not turn the console into an error page.
  Future<void> refreshStatuses() async {
    try {
      final list = await api.serverStatuses();
      if (isClosed) return;
      emit(state.copyWith(statuses: {for (final s in list) s.entityId: s}));
    } on ApiException {
      // Keep the previous snapshot.
    }
  }

  /// Starts polling until [stopPolling].
  ///
  /// The panel offers no push channel and the online flag is a TCP ping, so a
  /// timer is the same mechanism the legacy console used, kept at its interval
  /// rather than inventing a new one.
  void startPolling({Duration interval = const Duration(seconds: 20)}) {
    _poll?.cancel();
    unawaited(refreshStatuses());
    _poll = Timer.periodic(interval, (_) => unawaited(refreshStatuses()));
  }

  void stopPolling() {
    _poll?.cancel();
    _poll = null;
  }

  @override
  Future<void> close() {
    stopPolling();
    return super.close();
  }
}

/// One server, its live status, and the state of the manage actions.
@immutable
class ServerDetailState {
  const ServerDetailState({
    this.server = const AsyncValue<WareEntity>.idle(),
    this.eggs = const AsyncValue<List<Egg>>.idle(),
    this.status,
    this.action = const ActionState.idle(),
  });

  final AsyncValue<WareEntity> server;
  final AsyncValue<List<Egg>> eggs;
  final ServerStatus? status;
  final ActionState action;

  ServerDetailState copyWith({
    AsyncValue<WareEntity>? server,
    AsyncValue<List<Egg>>? eggs,
    ServerStatus? status,
    ActionState? action,
  }) => ServerDetailState(
    server: server ?? this.server,
    eggs: eggs ?? this.eggs,
    status: status ?? this.status,
    action: action ?? this.action,
  );
}

/// Owns one server and its manage actions.
class ServerDetailCubit extends Cubit<ServerDetailState> {
  ServerDetailCubit(this.api, this.id) : super(const ServerDetailState());

  final PeoApi api;
  final String id;

  Future<void> load() async {
    emit(
      state.copyWith(
        server: state.server.hasValue
            ? state.server.refreshing()
            : const AsyncValue<WareEntity>.loading(),
      ),
    );
    try {
      final entity = await api.server(id);
      if (isClosed) return;
      emit(state.copyWith(server: AsyncValue<WareEntity>.ready(entity)));
      if (entity.specId.isNotEmpty) {
        emit(
          state.copyWith(
            eggs: state.eggs.hasValue
                ? state.eggs.refreshing()
                : const AsyncValue<List<Egg>>.loading(),
          ),
        );
        try {
          final product = await api.product(entity.specId);
          if (isClosed) return;
          final allowedEggIds = {
            ...product.product.allowedEggIds,
            product.product.egg,
          };
          emit(
            state.copyWith(
              eggs: AsyncValue<List<Egg>>.ready(
                product.eggs
                    .where((egg) => allowedEggIds.contains(egg.id))
                    .toList(),
              ),
            ),
          );
        } on ApiException catch (e) {
          if (isClosed) return;
          emit(state.copyWith(eggs: AsyncValue<List<Egg>>.failure(e)));
        }
      }
    } on ApiException catch (e) {
      if (isClosed) return;
      emit(state.copyWith(server: AsyncValue<WareEntity>.failure(e)));
      return;
    }
    await refreshStatus();
  }

  /// Finds this server in the status list.
  ///
  /// The list endpoint is the only place the panel identity and the ping result
  /// are published, so a single-server status read is not available to ask for.
  Future<void> refreshStatus() async {
    try {
      final list = await api.serverStatuses();
      if (isClosed) return;
      final match = list.where((s) => s.entityId == id).firstOrNull;
      emit(state.copyWith(status: match));
    } on ApiException {
      // Keep the previous snapshot.
    }
  }

  /// Renews with a product key.
  ///
  /// The key is a required body field on the server, so an empty one is
  /// rejected here rather than as a generic validation error.
  Future<ActionState> renew(String key) {
    if (key.trim().isEmpty) {
      return Future.value(
        _report(
          const ActionState.failed(
            ApiException(
              code: ApiErrorCode.invalidKey,
              message: 'An activation code is required.',
            ),
          ),
        ),
      );
    }
    return _mutate(() => api.renewServer(id, key), 'server renewed');
  }

  /// Renews from the balance. No key is involved.
  Future<ActionState> renewByBalance() =>
      _mutate(() => api.renewServerByBalance(id), 'server renewed');

  /// Asks the panel to reinstall with another egg.
  Future<ActionState> reinstall(int eggId) =>
      _mutate(() => api.reinstallServer(id, eggId), 'reinstall started');

  /// Starts the deletion state machine.
  ///
  /// Suspension, the grace period and the confirmation mail are all the
  /// server's business; the client only asks.
  Future<ActionState> requestDelete() =>
      _mutate(() => api.requestServerDelete(id), 'deletion requested');

  Future<ActionState> _mutate(
    Future<void> Function() call,
    String message,
  ) async {
    emit(state.copyWith(action: const ActionState.pending()));
    final result = await perform(() async {
      await call();
      return message;
    });
    if (isClosed) return result;
    emit(state.copyWith(action: result));
    if (result.succeeded) await load();
    return result;
  }

  ActionState _report(ActionState action) {
    emit(state.copyWith(action: action));
    return action;
  }
}
