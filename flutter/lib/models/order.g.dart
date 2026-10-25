// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'order.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_CreateOrderRequest _$CreateOrderRequestFromJson(Map<String, dynamic> json) =>
    _CreateOrderRequest(specId: json['specId'] as String);

Map<String, dynamic> _$CreateOrderRequestToJson(_CreateOrderRequest instance) =>
    <String, dynamic>{'specId': instance.specId};

_OrderResponse _$OrderResponseFromJson(Map<String, dynamic> json) =>
    _OrderResponse(
      order: Order.fromJson(json['order'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$OrderResponseToJson(_OrderResponse instance) =>
    <String, dynamic>{'order': instance.order};

_OrderListResponse _$OrderListResponseFromJson(Map<String, dynamic> json) =>
    _OrderListResponse(
      orders:
          (json['orders'] as List<dynamic>?)
              ?.map((e) => Order.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const <Order>[],
    );

Map<String, dynamic> _$OrderListResponseToJson(_OrderListResponse instance) =>
    <String, dynamic>{'orders': instance.orders};

_PayOrderRequest _$PayOrderRequestFromJson(Map<String, dynamic> json) =>
    _PayOrderRequest(
      allocationId: (json['allocationId'] as num?)?.toInt() ?? 0,
      hostName: json['hostName'] as String,
      key: json['key'] as String? ?? '',
    );

Map<String, dynamic> _$PayOrderRequestToJson(_PayOrderRequest instance) =>
    <String, dynamic>{
      'allocationId': instance.allocationId,
      'hostName': instance.hostName,
      'key': instance.key,
    };

_ServerListResponse _$ServerListResponseFromJson(Map<String, dynamic> json) =>
    _ServerListResponse(
      servers:
          (json['servers'] as List<dynamic>?)
              ?.map((e) => WareEntity.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const <WareEntity>[],
    );

Map<String, dynamic> _$ServerListResponseToJson(_ServerListResponse instance) =>
    <String, dynamic>{'servers': instance.servers};

_ServerDetailResponse _$ServerDetailResponseFromJson(
  Map<String, dynamic> json,
) => _ServerDetailResponse(
  server: WareEntity.fromJson(json['server'] as Map<String, dynamic>),
);

Map<String, dynamic> _$ServerDetailResponseToJson(
  _ServerDetailResponse instance,
) => <String, dynamic>{'server': instance.server};

_StatusListResponse _$StatusListResponseFromJson(Map<String, dynamic> json) =>
    _StatusListResponse(
      servers:
          (json['servers'] as List<dynamic>?)
              ?.map((e) => ServerStatus.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const <ServerStatus>[],
    );

Map<String, dynamic> _$StatusListResponseToJson(_StatusListResponse instance) =>
    <String, dynamic>{'servers': instance.servers};

_ServerStatus _$ServerStatusFromJson(Map<String, dynamic> json) =>
    _ServerStatus(
      entityId: json['entityId'] as String? ?? '',
      externalId: json['externalId'] as String? ?? '',
      hostName: json['hostName'] as String? ?? '',
      validDate: json['validDate'] as String? ?? '',
      deleteStatus: (json['deleteStatus'] as num?)?.toInt() ?? 0,
      suspended: json['suspended'] as bool? ?? false,
      identifier: json['identifier'] as String? ?? '',
      panelName: json['panelName'] as String? ?? '',
      online: json['online'] as bool? ?? false,
      version: json['version'] as String? ?? '',
      motd: json['motd'] as String? ?? '',
      playerCount: (json['playerCount'] as num?)?.toInt() ?? 0,
      playerMax: (json['playerMax'] as num?)?.toInt() ?? 0,
      probing: json['probing'] as bool? ?? false,
    );

Map<String, dynamic> _$ServerStatusToJson(_ServerStatus instance) =>
    <String, dynamic>{
      'entityId': instance.entityId,
      'externalId': instance.externalId,
      'hostName': instance.hostName,
      'validDate': instance.validDate,
      'deleteStatus': instance.deleteStatus,
      'suspended': instance.suspended,
      'identifier': instance.identifier,
      'panelName': instance.panelName,
      'online': instance.online,
      'version': instance.version,
      'motd': instance.motd,
      'playerCount': instance.playerCount,
      'playerMax': instance.playerMax,
      'probing': instance.probing,
    };

_RenewRequest _$RenewRequestFromJson(Map<String, dynamic> json) =>
    _RenewRequest(key: json['key'] as String);

Map<String, dynamic> _$RenewRequestToJson(_RenewRequest instance) =>
    <String, dynamic>{'key': instance.key};

_ReinstallRequest _$ReinstallRequestFromJson(Map<String, dynamic> json) =>
    _ReinstallRequest(eggId: (json['eggId'] as num?)?.toInt() ?? 0);

Map<String, dynamic> _$ReinstallRequestToJson(_ReinstallRequest instance) =>
    <String, dynamic>{'eggId': instance.eggId};

_Allocation _$AllocationFromJson(Map<String, dynamic> json) => _Allocation(
  id: (json['id'] as num?)?.toInt() ?? 0,
  address: json['address'] as String? ?? '',
);

Map<String, dynamic> _$AllocationToJson(_Allocation instance) =>
    <String, dynamic>{'id': instance.id, 'address': instance.address};

_AllocationListResponse _$AllocationListResponseFromJson(
  Map<String, dynamic> json,
) => _AllocationListResponse(
  allocations:
      (json['allocations'] as List<dynamic>?)
          ?.map((e) => Allocation.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const <Allocation>[],
);

Map<String, dynamic> _$AllocationListResponseToJson(
  _AllocationListResponse instance,
) => <String, dynamic>{'allocations': instance.allocations};
