/// Orders, servers, renewals and reinstallations.
///
/// Mirrors `server/internal/api/dto/order.go` plus `service.Status` from
/// `server/internal/service/server_service.go`.
library;

import 'package:freezed_annotation/freezed_annotation.dart';

import 'documents.dart';

part 'order.freezed.dart';
part 'order.g.dart';

/// Names the specification the customer wants to buy.
///
/// The allocation is picked on the payment screen, so it is not part of
/// creation.
@freezed
abstract class CreateOrderRequest with _$CreateOrderRequest {
  const factory CreateOrderRequest({required String specId}) =
      _CreateOrderRequest;

  factory CreateOrderRequest.fromJson(Map<String, dynamic> json) =>
      _$CreateOrderRequestFromJson(json);
}

/// A plain order document.
@freezed
abstract class OrderResponse with _$OrderResponse {
  const factory OrderResponse({required Order order}) = _OrderResponse;

  factory OrderResponse.fromJson(Map<String, dynamic> json) =>
      _$OrderResponseFromJson(json);
}

/// The customer's order history.
@freezed
abstract class OrderListResponse with _$OrderListResponse {
  const factory OrderListResponse({@Default(<Order>[]) List<Order> orders}) =
      _OrderListResponse;

  factory OrderListResponse.fromJson(Map<String, dynamic> json) =>
      _$OrderListResponseFromJson(json);
}

/// Carries the allocation, the desired host name and, for the key flow, the
/// product key. Used by both pay endpoints.
@freezed
abstract class PayOrderRequest with _$PayOrderRequest {
  const factory PayOrderRequest({
    /// The Pterodactyl allocation the server should bind to.
    @Default(0) int allocationId,

    /// The label the customer chose for the server.
    required String hostName,

    /// Optional; when empty the balance flow is used.
    @Default('') String key,
  }) = _PayOrderRequest;

  factory PayOrderRequest.fromJson(Map<String, dynamic> json) =>
      _$PayOrderRequestFromJson(json);
}

/// The customer console list.
@freezed
abstract class ServerListResponse with _$ServerListResponse {
  const factory ServerListResponse({
    @Default(<WareEntity>[]) List<WareEntity> servers,
  }) = _ServerListResponse;

  factory ServerListResponse.fromJson(Map<String, dynamic> json) =>
      _$ServerListResponseFromJson(json);
}

/// One managed server record.
@freezed
abstract class ServerDetailResponse with _$ServerDetailResponse {
  const factory ServerDetailResponse({required WareEntity server}) =
      _ServerDetailResponse;

  factory ServerDetailResponse.fromJson(Map<String, dynamic> json) =>
      _$ServerDetailResponseFromJson(json);
}

/// The polled live status list.
@freezed
abstract class StatusListResponse with _$StatusListResponse {
  const factory StatusListResponse({
    @Default(<ServerStatus>[]) List<ServerStatus> servers,
  }) = _StatusListResponse;

  factory StatusListResponse.fromJson(Map<String, dynamic> json) =>
      _$StatusListResponseFromJson(json);
}

/// One server's live state, as measured by the Minecraft ping and the panel.
@freezed
abstract class ServerStatus with _$ServerStatus {
  const ServerStatus._();

  const factory ServerStatus({
    @Default('') String entityId,
    @Default('') String externalId,
    @Default('') String hostName,
    @Default('') String validDate,
    @Default(0) int deleteStatus,
    @Default(false) bool suspended,
    @Default('') String identifier,
    @Default('') String panelName,
    @Default(false) bool online,
    @Default('') String version,
    @Default('') String motd,
    @Default(0) int playerCount,
    @Default(0) int playerMax,

    /// True while the ping is still in flight, so the row can show a spinner
    /// instead of claiming the server is offline.
    @Default(false) bool probing,
  }) = _ServerStatus;

  factory ServerStatus.fromJson(Map<String, dynamic> json) =>
      _$ServerStatusFromJson(json);

  /// True when the status could not be read at all and the row should be
  /// rendered as unknown rather than offline.
  bool get hasDetail => panelName.isNotEmpty || identifier.isNotEmpty;
}

/// Renews with a product key.
@freezed
abstract class RenewRequest with _$RenewRequest {
  const factory RenewRequest({
    /// The product key; the legacy URL carried it as a path segment.
    required String key,
  }) = _RenewRequest;

  factory RenewRequest.fromJson(Map<String, dynamic> json) =>
      _$RenewRequestFromJson(json);
}

/// Picks the egg to reinstall with.
@freezed
abstract class ReinstallRequest with _$ReinstallRequest {
  const factory ReinstallRequest({@Default(0) int eggId}) = _ReinstallRequest;

  factory ReinstallRequest.fromJson(Map<String, dynamic> json) =>
      _$ReinstallRequestFromJson(json);
}

/// One free port on the node the ordered product is pinned to.
@freezed
abstract class Allocation with _$Allocation {
  const factory Allocation({
    @Default(0) int id,

    /// The `alias:port` label the customer picks from.
    @Default('') String address,
  }) = _Allocation;

  factory Allocation.fromJson(Map<String, dynamic> json) =>
      _$AllocationFromJson(json);
}

/// The free allocations of the product's node, for the address picker.
@freezed
abstract class AllocationListResponse with _$AllocationListResponse {
  const factory AllocationListResponse({
    @Default(<Allocation>[]) List<Allocation> allocations,
  }) = _AllocationListResponse;

  factory AllocationListResponse.fromJson(Map<String, dynamic> json) =>
      _$AllocationListResponseFromJson(json);
}
