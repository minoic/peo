/// Balance top-up shapes.
///
/// Mirrors `server/internal/api/dto/recharge.go`.
library;

import 'package:freezed_annotation/freezed_annotation.dart';

import 'documents.dart';

part 'recharge.freezed.dart';
part 'recharge.g.dart';

/// Redeems a balance code.
@freezed
abstract class RechargeByKeyRequest with _$RechargeByKeyRequest {
  const factory RechargeByKeyRequest({required String key}) =
      _RechargeByKeyRequest;

  factory RechargeByKeyRequest.fromJson(Map<String, dynamic> json) =>
      _$RechargeByKeyRequestFromJson(json);
}

/// Starts an Alipay face-to-face payment for an amount.
@freezed
abstract class PreCreateRequest with _$PreCreateRequest {
  const factory PreCreateRequest({required int amount}) = _PreCreateRequest;

  factory PreCreateRequest.fromJson(Map<String, dynamic> json) =>
      _$PreCreateRequestFromJson(json);
}

/// The QR code and the trade number the client polls.
@freezed
abstract class PreCreateResponse with _$PreCreateResponse {
  const factory PreCreateResponse({
    @Default('') String qrCodeBase64,
    @Default('') String outTradeNo,
  }) = _PreCreateResponse;

  factory PreCreateResponse.fromJson(Map<String, dynamic> json) =>
      _$PreCreateResponseFromJson(json);
}

/// The state of one Alipay order: one of [RechargeStatus].
@freezed
abstract class RechargeStatusResponse with _$RechargeStatusResponse {
  const factory RechargeStatusResponse({@Default('') String status}) =
      _RechargeStatusResponse;

  factory RechargeStatusResponse.fromJson(Map<String, dynamic> json) =>
      _$RechargeStatusResponseFromJson(json);
}

/// The recharge history.
@freezed
abstract class RechargeLogResponse with _$RechargeLogResponse {
  const factory RechargeLogResponse({
    @Default(<RechargeLog>[]) List<RechargeLog> logs,
  }) = _RechargeLogResponse;

  factory RechargeLogResponse.fromJson(Map<String, dynamic> json) =>
      _$RechargeLogResponseFromJson(json);
}
