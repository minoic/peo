/// Gallery, messages and work orders.
///
/// Mirrors `server/internal/api/dto/content.go` plus the service types it
/// embeds from `gallery_service.go` and `admin_service.go`.
library;

import 'package:freezed_annotation/freezed_annotation.dart';

part 'content.freezed.dart';
part 'content.g.dart';

/// One album entry, with the poster's name already resolved so the client does
/// not need a second request per card.
@freezed
abstract class GalleryCard with _$GalleryCard {
  const factory GalleryCard({
    @Default('') String id,
    @Default('') String itemName,
    @Default('') String itemDescription,
    @Default('') String imgSource,
    @Default(0) int likes,
    @Default(false) bool reviewPassed,
    @Default('') String userName,

    /// Formatted `yyyy-MM-dd HH:mm` by the server.
    @Default('') String createdAt,
  }) = _GalleryCard;

  factory GalleryCard.fromJson(Map<String, dynamic> json) =>
      _$GalleryCardFromJson(json);
}

/// The public gallery.
@freezed
abstract class GalleryListResponse with _$GalleryListResponse {
  const factory GalleryListResponse({
    @Default(<GalleryCard>[]) List<GalleryCard> items,
  }) = _GalleryListResponse;

  factory GalleryListResponse.fromJson(Map<String, dynamic> json) =>
      _$GalleryListResponseFromJson(json);
}

/// Posts a new album entry for review.
@freezed
abstract class GallerySubmitRequest with _$GallerySubmitRequest {
  const factory GallerySubmitRequest({
    required String itemName,
    @Default('') String itemDescription,
    required String imgSource,
  }) = _GallerySubmitRequest;

  factory GallerySubmitRequest.fromJson(Map<String, dynamic> json) =>
      _$GallerySubmitRequestFromJson(json);
}

/// One gallery entry; the like endpoint returns it with the fresh count so the
/// client does not need a second round trip.
@freezed
abstract class GalleryItemResponse with _$GalleryItemResponse {
  const factory GalleryItemResponse({required GalleryCard item}) =
      _GalleryItemResponse;

  factory GalleryItemResponse.fromJson(Map<String, dynamic> json) =>
      _$GalleryItemResponseFromJson(json);
}

/// The new number of likes.
@freezed
abstract class LikeResponse with _$LikeResponse {
  const factory LikeResponse({@Default(0) int likes}) = _LikeResponse;

  factory LikeResponse.fromJson(Map<String, dynamic> json) =>
      _$LikeResponseFromJson(json);
}

/// A message with a stable string id and timestamps.
@freezed
abstract class MessageItem with _$MessageItem {
  const factory MessageItem({
    @Default('') String id,
    @Default('') String senderName,
    @Default('') String text,
    @Default('') String timeText,
    @Default(false) bool haveRead,
    @Default('') String createdAt,
  }) = _MessageItem;

  factory MessageItem.fromJson(Map<String, dynamic> json) =>
      _$MessageItemFromJson(json);
}

/// The inbox.
@freezed
abstract class MessageListResponse with _$MessageListResponse {
  const factory MessageListResponse({
    @Default(<MessageItem>[]) List<MessageItem> messages,
  }) = _MessageListResponse;

  factory MessageListResponse.fromJson(Map<String, dynamic> json) =>
      _$MessageListResponseFromJson(json);
}

/// The unread counter polled by the navigation bar badge.
@freezed
abstract class UnreadResponse with _$UnreadResponse {
  const factory UnreadResponse({@Default(0) int unread}) = _UnreadResponse;

  factory UnreadResponse.fromJson(Map<String, dynamic> json) =>
      _$UnreadResponseFromJson(json);
}

/// A ticket as shown to the customer and to staff.
@freezed
abstract class WorkOrderItem with _$WorkOrderItem {
  const factory WorkOrderItem({
    @Default('') String id,
    @Default('') String userId,
    @Default('') String userName,
    @Default('') String orderTitle,
    @Default('') String orderText,
    @Default('') String createdAt,
    @Default(false) bool closed,
  }) = _WorkOrderItem;

  factory WorkOrderItem.fromJson(Map<String, dynamic> json) =>
      _$WorkOrderItemFromJson(json);
}

/// The customer's ticket list.
@freezed
abstract class WorkOrderListResponse with _$WorkOrderListResponse {
  const factory WorkOrderListResponse({
    @Default(<WorkOrderItem>[]) List<WorkOrderItem> orders,
  }) = _WorkOrderListResponse;

  factory WorkOrderListResponse.fromJson(Map<String, dynamic> json) =>
      _$WorkOrderListResponseFromJson(json);
}

/// Opens a ticket.
@freezed
abstract class CreateWorkOrderRequest with _$CreateWorkOrderRequest {
  const factory CreateWorkOrderRequest({
    required String title,
    required String text,
  }) = _CreateWorkOrderRequest;

  factory CreateWorkOrderRequest.fromJson(Map<String, dynamic> json) =>
      _$CreateWorkOrderRequestFromJson(json);
}

/// A single ticket. The server sends a value, not a pointer, so this is
/// required rather than nullable.
@freezed
abstract class WorkOrderResponse with _$WorkOrderResponse {
  const factory WorkOrderResponse({required WorkOrderItem order}) =
      _WorkOrderResponse;

  factory WorkOrderResponse.fromJson(Map<String, dynamic> json) =>
      _$WorkOrderResponseFromJson(json);
}

/// A bare human readable confirmation.
@freezed
abstract class MessageResponse with _$MessageResponse {
  const factory MessageResponse({@Default('') String message}) =
      _MessageResponse;

  factory MessageResponse.fromJson(Map<String, dynamic> json) =>
      _$MessageResponseFromJson(json);
}
