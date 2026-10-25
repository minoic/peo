/// The documents the API hands back verbatim.
///
/// These mirror `server/internal/models` field for field. Two conventions are
/// worth remembering while reading them:
///
/// * `id` and `updatedAt` are declared `omitempty` on the server, so a document
///   that was never touched omits them. Both are therefore nullable here.
/// * Durations (`totalUpTime`, `validDuration`, `deleteDuration`) travel as
///   integer nanoseconds, exactly as they are stored. Use the `*Duration`
///   getters to turn them into a [Duration].
library;

import 'package:freezed_annotation/freezed_annotation.dart';

part 'documents.freezed.dart';
part 'documents.g.dart';

/// A site account. The password hash is never serialized.
@freezed
abstract class User with _$User {
  const User._();

  const factory User({
    String? id,
    String? createdAt,
    String? updatedAt,
    required String name,
    required String email,
    @Default(0) int balance,
    @Default(false) bool isAdmin,
    @Default(false) bool emailConfirmed,
    @Default(false) bool pteUserCreated,
    @Default(0) int totalUpTime,
    @Default('') String uuid,
  }) = _User;

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);

  /// Accumulated server uptime, carried as nanoseconds.
  Duration get uptime => Duration(microseconds: totalUpTime ~/ 1000);
}

/// A purchasable product definition.
@freezed
abstract class WareSpec with _$WareSpec {
  const WareSpec._();

  const factory WareSpec({
    String? id,
    String? createdAt,
    String? updatedAt,
    @Default(0) int pricePerMonth,
    @Default('') String wareName,
    @Default('') String wareDescription,
    @Default(0) int node,
    @Default(0) int memory,
    @Default(0) int cpu,
    @Default(0) int swap,
    @Default(0) int disk,
    @Default(0) int io,
    @Default(0) int backups,
    @Default(0) int nest,
    @Default('') String tagSlug,
    @Default(0) int egg,
    @Default(<int>[]) List<int> allowedEggIds,
    @Default(0) int discount,
    @Default(false) bool startOnCompletion,
    @Default(false) bool oomDisabled,
    @Default('') String dockerImage,
    @Default(0) int validDuration,
    @Default(0) int deleteDuration,
  }) = _WareSpec;

  factory WareSpec.fromJson(Map<String, dynamic> json) =>
      _$WareSpecFromJson(json);

  /// How long a purchase of this product stays valid.
  Duration get validity => Duration(microseconds: validDuration ~/ 1000);

  /// The grace period between expiry and deletion.
  Duration get deleteGrace => Duration(microseconds: deleteDuration ~/ 1000);
}

/// A purchased, provisioned server.
@freezed
abstract class WareEntity with _$WareEntity {
  const WareEntity._();

  const factory WareEntity({
    String? id,
    String? createdAt,
    String? updatedAt,
    @Default('') String userId,
    @Default('') String specId,
    @Default('') String serverExternalId,
    @Default('') String userExternalId,
    @Default('') String hostName,
    @Default(0) int deleteStatus,
    @Default('') String validDate,
  }) = _WareEntity;

  factory WareEntity.fromJson(Map<String, dynamic> json) =>
      _$WareEntityFromJson(json);

  /// Parsed [validDate]. The server sends RFC 3339; a malformed value reads as
  /// `null` rather than throwing, because this field is rendered on the console
  /// and must never break the whole list.
  DateTime? get validUntil => DateTime.tryParse(validDate)?.toLocal();

  /// True once the record has been flagged for deletion but not yet confirmed.
  bool get isPendingDeletion => deleteStatus > 0;
}

/// An activation code that can be redeemed for a product.
@freezed
abstract class WareKey with _$WareKey {
  const factory WareKey({
    String? id,
    String? createdAt,
    String? updatedAt,
    @Default('') String specId,
    @Default('') String keyString,
    @Default('') String exp,
  }) = _WareKey;

  factory WareKey.fromJson(Map<String, dynamic> json) =>
      _$WareKeyFromJson(json);
}

/// An activation code that tops up a balance.
@freezed
abstract class RechargeKey with _$RechargeKey {
  const factory RechargeKey({
    String? id,
    String? createdAt,
    String? updatedAt,
    @Default('') String keyString,
    @Default(0) int balance,
    @Default('') String exp,
  }) = _RechargeKey;

  factory RechargeKey.fromJson(Map<String, dynamic> json) =>
      _$RechargeKeyFromJson(json);
}

/// A purchase intent. `confirmed` implies `paid`.
@freezed
abstract class Order with _$Order {
  const Order._();

  const factory Order({
    String? id,
    String? createdAt,
    String? updatedAt,
    @Default('') String specId,
    @Default('') String userId,
    @Default(0) int allocationId,
    @Default(0) int originPrice,
    @Default(0) int finalPrice,
    @Default(false) bool paid,
    @Default(false) bool confirmed,
    @Default(false) bool closed,
  }) = _Order;

  factory Order.fromJson(Map<String, dynamic> json) => _$OrderFromJson(json);

  /// The single status word the order screens switch on.
  String get status {
    if (confirmed) return OrderStatus.confirmed;
    if (paid) return OrderStatus.paid;
    if (closed) return OrderStatus.closed;
    return OrderStatus.pending;
  }
}

/// The order statuses, matching `models.OrderStatus*`.
abstract final class OrderStatus {
  static const String pending = 'pending';
  static const String paid = 'paid';
  static const String confirmed = 'confirmed';
  static const String closed = 'closed';
}

/// An internal mail between the site and a user.
@freezed
abstract class Message with _$Message {
  const factory Message({
    String? id,
    String? createdAt,
    String? updatedAt,
    @Default('') String senderName,
    @Default('') String receiverId,
    @Default('') String text,
    @Default('') String timeText,
    @Default(false) bool haveRead,
  }) = _Message;

  factory Message.fromJson(Map<String, dynamic> json) =>
      _$MessageFromJson(json);
}

/// A user submitted screenshot.
@freezed
abstract class GalleryItem with _$GalleryItem {
  const factory GalleryItem({
    String? id,
    String? createdAt,
    String? updatedAt,
    @Default('') String userId,
    @Default('') String itemName,
    @Default('') String itemDescription,
    @Default(0) int likes,
    @Default(false) bool reviewPassed,
    @Default('') String imgSource,
  }) = _GalleryItem;

  factory GalleryItem.fromJson(Map<String, dynamic> json) =>
      _$GalleryItemFromJson(json);
}

/// A support ticket.
@freezed
abstract class WorkOrder with _$WorkOrder {
  const factory WorkOrder({
    String? id,
    String? createdAt,
    String? updatedAt,
    @Default('') String userId,
    @Default('') String userName,
    @Default('') String orderTitle,
    @Default('') String orderText,
    @Default(false) bool closed,
  }) = _WorkOrder;

  factory WorkOrder.fromJson(Map<String, dynamic> json) =>
      _$WorkOrderFromJson(json);
}

/// A single balance top-up attempt.
@freezed
abstract class RechargeLog with _$RechargeLog {
  const factory RechargeLog({
    String? id,
    String? createdAt,
    String? updatedAt,
    @Default('') String userId,
    @Default('') String code,
    @Default('') String method,
    @Default(0) int balance,
    @Default('') String time,
    @Default('') String outTradeNo,
    @Default(RechargeStatus.pending) String status,
  }) = _RechargeLog;

  factory RechargeLog.fromJson(Map<String, dynamic> json) =>
      _$RechargeLogFromJson(json);
}

/// The four recharge statuses. The legacy column stored a rendered Bootstrap
/// badge; the server now sends the bare word and the UI renders the badge.
abstract final class RechargeStatus {
  static const String pending = 'pending';
  static const String success = 'success';
  static const String failed = 'failed';
  static const String invalid = 'invalid';
}
