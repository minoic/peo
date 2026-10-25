// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'documents.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_User _$UserFromJson(Map<String, dynamic> json) => _User(
  id: json['id'] as String?,
  createdAt: json['createdAt'] as String?,
  updatedAt: json['updatedAt'] as String?,
  name: json['name'] as String,
  email: json['email'] as String,
  balance: (json['balance'] as num?)?.toInt() ?? 0,
  isAdmin: json['isAdmin'] as bool? ?? false,
  emailConfirmed: json['emailConfirmed'] as bool? ?? false,
  pteUserCreated: json['pteUserCreated'] as bool? ?? false,
  totalUpTime: (json['totalUpTime'] as num?)?.toInt() ?? 0,
  uuid: json['uuid'] as String? ?? '',
);

Map<String, dynamic> _$UserToJson(_User instance) => <String, dynamic>{
  'id': instance.id,
  'createdAt': instance.createdAt,
  'updatedAt': instance.updatedAt,
  'name': instance.name,
  'email': instance.email,
  'balance': instance.balance,
  'isAdmin': instance.isAdmin,
  'emailConfirmed': instance.emailConfirmed,
  'pteUserCreated': instance.pteUserCreated,
  'totalUpTime': instance.totalUpTime,
  'uuid': instance.uuid,
};

_WareSpec _$WareSpecFromJson(Map<String, dynamic> json) => _WareSpec(
  id: json['id'] as String?,
  createdAt: json['createdAt'] as String?,
  updatedAt: json['updatedAt'] as String?,
  pricePerMonth: (json['pricePerMonth'] as num?)?.toInt() ?? 0,
  wareName: json['wareName'] as String? ?? '',
  wareDescription: json['wareDescription'] as String? ?? '',
  node: (json['node'] as num?)?.toInt() ?? 0,
  memory: (json['memory'] as num?)?.toInt() ?? 0,
  cpu: (json['cpu'] as num?)?.toInt() ?? 0,
  swap: (json['swap'] as num?)?.toInt() ?? 0,
  disk: (json['disk'] as num?)?.toInt() ?? 0,
  io: (json['io'] as num?)?.toInt() ?? 0,
  backups: (json['backups'] as num?)?.toInt() ?? 0,
  nest: (json['nest'] as num?)?.toInt() ?? 0,
  tagSlug: json['tagSlug'] as String? ?? '',
  egg: (json['egg'] as num?)?.toInt() ?? 0,
  allowedEggIds:
      (json['allowedEggIds'] as List<dynamic>?)
          ?.map((e) => (e as num).toInt())
          .toList() ??
      const <int>[],
  discount: (json['discount'] as num?)?.toInt() ?? 0,
  startOnCompletion: json['startOnCompletion'] as bool? ?? false,
  oomDisabled: json['oomDisabled'] as bool? ?? false,
  dockerImage: json['dockerImage'] as String? ?? '',
  validDuration: (json['validDuration'] as num?)?.toInt() ?? 0,
  deleteDuration: (json['deleteDuration'] as num?)?.toInt() ?? 0,
);

Map<String, dynamic> _$WareSpecToJson(_WareSpec instance) => <String, dynamic>{
  'id': instance.id,
  'createdAt': instance.createdAt,
  'updatedAt': instance.updatedAt,
  'pricePerMonth': instance.pricePerMonth,
  'wareName': instance.wareName,
  'wareDescription': instance.wareDescription,
  'node': instance.node,
  'memory': instance.memory,
  'cpu': instance.cpu,
  'swap': instance.swap,
  'disk': instance.disk,
  'io': instance.io,
  'backups': instance.backups,
  'nest': instance.nest,
  'tagSlug': instance.tagSlug,
  'egg': instance.egg,
  'allowedEggIds': instance.allowedEggIds,
  'discount': instance.discount,
  'startOnCompletion': instance.startOnCompletion,
  'oomDisabled': instance.oomDisabled,
  'dockerImage': instance.dockerImage,
  'validDuration': instance.validDuration,
  'deleteDuration': instance.deleteDuration,
};

_WareEntity _$WareEntityFromJson(Map<String, dynamic> json) => _WareEntity(
  id: json['id'] as String?,
  createdAt: json['createdAt'] as String?,
  updatedAt: json['updatedAt'] as String?,
  userId: json['userId'] as String? ?? '',
  specId: json['specId'] as String? ?? '',
  serverExternalId: json['serverExternalId'] as String? ?? '',
  userExternalId: json['userExternalId'] as String? ?? '',
  hostName: json['hostName'] as String? ?? '',
  deleteStatus: (json['deleteStatus'] as num?)?.toInt() ?? 0,
  validDate: json['validDate'] as String? ?? '',
);

Map<String, dynamic> _$WareEntityToJson(_WareEntity instance) =>
    <String, dynamic>{
      'id': instance.id,
      'createdAt': instance.createdAt,
      'updatedAt': instance.updatedAt,
      'userId': instance.userId,
      'specId': instance.specId,
      'serverExternalId': instance.serverExternalId,
      'userExternalId': instance.userExternalId,
      'hostName': instance.hostName,
      'deleteStatus': instance.deleteStatus,
      'validDate': instance.validDate,
    };

_WareKey _$WareKeyFromJson(Map<String, dynamic> json) => _WareKey(
  id: json['id'] as String?,
  createdAt: json['createdAt'] as String?,
  updatedAt: json['updatedAt'] as String?,
  specId: json['specId'] as String? ?? '',
  keyString: json['keyString'] as String? ?? '',
  exp: json['exp'] as String? ?? '',
);

Map<String, dynamic> _$WareKeyToJson(_WareKey instance) => <String, dynamic>{
  'id': instance.id,
  'createdAt': instance.createdAt,
  'updatedAt': instance.updatedAt,
  'specId': instance.specId,
  'keyString': instance.keyString,
  'exp': instance.exp,
};

_RechargeKey _$RechargeKeyFromJson(Map<String, dynamic> json) => _RechargeKey(
  id: json['id'] as String?,
  createdAt: json['createdAt'] as String?,
  updatedAt: json['updatedAt'] as String?,
  keyString: json['keyString'] as String? ?? '',
  balance: (json['balance'] as num?)?.toInt() ?? 0,
  exp: json['exp'] as String? ?? '',
);

Map<String, dynamic> _$RechargeKeyToJson(_RechargeKey instance) =>
    <String, dynamic>{
      'id': instance.id,
      'createdAt': instance.createdAt,
      'updatedAt': instance.updatedAt,
      'keyString': instance.keyString,
      'balance': instance.balance,
      'exp': instance.exp,
    };

_Order _$OrderFromJson(Map<String, dynamic> json) => _Order(
  id: json['id'] as String?,
  createdAt: json['createdAt'] as String?,
  updatedAt: json['updatedAt'] as String?,
  specId: json['specId'] as String? ?? '',
  userId: json['userId'] as String? ?? '',
  allocationId: (json['allocationId'] as num?)?.toInt() ?? 0,
  originPrice: (json['originPrice'] as num?)?.toInt() ?? 0,
  finalPrice: (json['finalPrice'] as num?)?.toInt() ?? 0,
  paid: json['paid'] as bool? ?? false,
  confirmed: json['confirmed'] as bool? ?? false,
);

Map<String, dynamic> _$OrderToJson(_Order instance) => <String, dynamic>{
  'id': instance.id,
  'createdAt': instance.createdAt,
  'updatedAt': instance.updatedAt,
  'specId': instance.specId,
  'userId': instance.userId,
  'allocationId': instance.allocationId,
  'originPrice': instance.originPrice,
  'finalPrice': instance.finalPrice,
  'paid': instance.paid,
  'confirmed': instance.confirmed,
};

_Message _$MessageFromJson(Map<String, dynamic> json) => _Message(
  id: json['id'] as String?,
  createdAt: json['createdAt'] as String?,
  updatedAt: json['updatedAt'] as String?,
  senderName: json['senderName'] as String? ?? '',
  receiverId: json['receiverId'] as String? ?? '',
  text: json['text'] as String? ?? '',
  timeText: json['timeText'] as String? ?? '',
  haveRead: json['haveRead'] as bool? ?? false,
);

Map<String, dynamic> _$MessageToJson(_Message instance) => <String, dynamic>{
  'id': instance.id,
  'createdAt': instance.createdAt,
  'updatedAt': instance.updatedAt,
  'senderName': instance.senderName,
  'receiverId': instance.receiverId,
  'text': instance.text,
  'timeText': instance.timeText,
  'haveRead': instance.haveRead,
};

_GalleryItem _$GalleryItemFromJson(Map<String, dynamic> json) => _GalleryItem(
  id: json['id'] as String?,
  createdAt: json['createdAt'] as String?,
  updatedAt: json['updatedAt'] as String?,
  userId: json['userId'] as String? ?? '',
  itemName: json['itemName'] as String? ?? '',
  itemDescription: json['itemDescription'] as String? ?? '',
  likes: (json['likes'] as num?)?.toInt() ?? 0,
  reviewPassed: json['reviewPassed'] as bool? ?? false,
  imgSource: json['imgSource'] as String? ?? '',
);

Map<String, dynamic> _$GalleryItemToJson(_GalleryItem instance) =>
    <String, dynamic>{
      'id': instance.id,
      'createdAt': instance.createdAt,
      'updatedAt': instance.updatedAt,
      'userId': instance.userId,
      'itemName': instance.itemName,
      'itemDescription': instance.itemDescription,
      'likes': instance.likes,
      'reviewPassed': instance.reviewPassed,
      'imgSource': instance.imgSource,
    };

_WorkOrder _$WorkOrderFromJson(Map<String, dynamic> json) => _WorkOrder(
  id: json['id'] as String?,
  createdAt: json['createdAt'] as String?,
  updatedAt: json['updatedAt'] as String?,
  userId: json['userId'] as String? ?? '',
  userName: json['userName'] as String? ?? '',
  orderTitle: json['orderTitle'] as String? ?? '',
  orderText: json['orderText'] as String? ?? '',
  closed: json['closed'] as bool? ?? false,
);

Map<String, dynamic> _$WorkOrderToJson(_WorkOrder instance) =>
    <String, dynamic>{
      'id': instance.id,
      'createdAt': instance.createdAt,
      'updatedAt': instance.updatedAt,
      'userId': instance.userId,
      'userName': instance.userName,
      'orderTitle': instance.orderTitle,
      'orderText': instance.orderText,
      'closed': instance.closed,
    };

_RechargeLog _$RechargeLogFromJson(Map<String, dynamic> json) => _RechargeLog(
  id: json['id'] as String?,
  createdAt: json['createdAt'] as String?,
  updatedAt: json['updatedAt'] as String?,
  userId: json['userId'] as String? ?? '',
  code: json['code'] as String? ?? '',
  method: json['method'] as String? ?? '',
  balance: (json['balance'] as num?)?.toInt() ?? 0,
  time: json['time'] as String? ?? '',
  outTradeNo: json['outTradeNo'] as String? ?? '',
  status: json['status'] as String? ?? RechargeStatus.pending,
);

Map<String, dynamic> _$RechargeLogToJson(_RechargeLog instance) =>
    <String, dynamic>{
      'id': instance.id,
      'createdAt': instance.createdAt,
      'updatedAt': instance.updatedAt,
      'userId': instance.userId,
      'code': instance.code,
      'method': instance.method,
      'balance': instance.balance,
      'time': instance.time,
      'outTradeNo': instance.outTradeNo,
      'status': instance.status,
    };
