// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'recharge.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_RechargeByKeyRequest _$RechargeByKeyRequestFromJson(
  Map<String, dynamic> json,
) => _RechargeByKeyRequest(key: json['key'] as String);

Map<String, dynamic> _$RechargeByKeyRequestToJson(
  _RechargeByKeyRequest instance,
) => <String, dynamic>{'key': instance.key};

_PreCreateRequest _$PreCreateRequestFromJson(Map<String, dynamic> json) =>
    _PreCreateRequest(amount: (json['amount'] as num).toInt());

Map<String, dynamic> _$PreCreateRequestToJson(_PreCreateRequest instance) =>
    <String, dynamic>{'amount': instance.amount};

_PreCreateResponse _$PreCreateResponseFromJson(Map<String, dynamic> json) =>
    _PreCreateResponse(
      qrCodeBase64: json['qrCodeBase64'] as String? ?? '',
      outTradeNo: json['outTradeNo'] as String? ?? '',
    );

Map<String, dynamic> _$PreCreateResponseToJson(_PreCreateResponse instance) =>
    <String, dynamic>{
      'qrCodeBase64': instance.qrCodeBase64,
      'outTradeNo': instance.outTradeNo,
    };

_RechargeStatusResponse _$RechargeStatusResponseFromJson(
  Map<String, dynamic> json,
) => _RechargeStatusResponse(status: json['status'] as String? ?? '');

Map<String, dynamic> _$RechargeStatusResponseToJson(
  _RechargeStatusResponse instance,
) => <String, dynamic>{'status': instance.status};

_RechargeLogResponse _$RechargeLogResponseFromJson(Map<String, dynamic> json) =>
    _RechargeLogResponse(
      logs:
          (json['logs'] as List<dynamic>?)
              ?.map((e) => RechargeLog.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const <RechargeLog>[],
    );

Map<String, dynamic> _$RechargeLogResponseToJson(
  _RechargeLogResponse instance,
) => <String, dynamic>{'logs': instance.logs};
