// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Dashboard _$DashboardFromJson(Map<String, dynamic> json) => _Dashboard(
  specAmount: (json['specAmount'] as num?)?.toInt() ?? 0,
  entityAmount: (json['entityAmount'] as num?)?.toInt() ?? 0,
  userAmount: (json['userAmount'] as num?)?.toInt() ?? 0,
  keyAmount: (json['keyAmount'] as num?)?.toInt() ?? 0,
  orderAmount: (json['orderAmount'] as num?)?.toInt() ?? 0,
  workOrderCount: (json['workOrderCount'] as num?)?.toInt() ?? 0,
  galleryCount: (json['galleryCount'] as num?)?.toInt() ?? 0,
  galleryItems:
      (json['galleryItems'] as List<dynamic>?)
          ?.map((e) => GalleryCard.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const <GalleryCard>[],
  workOrders:
      (json['workOrders'] as List<dynamic>?)
          ?.map((e) => WorkOrderItem.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const <WorkOrderItem>[],
  deleteConfirms:
      (json['deleteConfirms'] as List<dynamic>?)
          ?.map((e) => DeleteConfirmItem.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const <DeleteConfirmItem>[],
);

Map<String, dynamic> _$DashboardToJson(_Dashboard instance) =>
    <String, dynamic>{
      'specAmount': instance.specAmount,
      'entityAmount': instance.entityAmount,
      'userAmount': instance.userAmount,
      'keyAmount': instance.keyAmount,
      'orderAmount': instance.orderAmount,
      'workOrderCount': instance.workOrderCount,
      'galleryCount': instance.galleryCount,
      'galleryItems': instance.galleryItems,
      'workOrders': instance.workOrders,
      'deleteConfirms': instance.deleteConfirms,
    };

_DeleteConfirmItem _$DeleteConfirmItemFromJson(Map<String, dynamic> json) =>
    _DeleteConfirmItem(
      entityId: json['entityId'] as String? ?? '',
      confirmId: json['confirmId'] as String? ?? '',
      serverName: json['serverName'] as String? ?? '',
      consoleUrl: json['consoleUrl'] as String? ?? '',
      identifier: json['identifier'] as String? ?? '',
      owner: json['owner'] as String? ?? '',
      expire: json['expire'] as String? ?? '',
      hostName: json['hostName'] as String? ?? '',
    );

Map<String, dynamic> _$DeleteConfirmItemToJson(_DeleteConfirmItem instance) =>
    <String, dynamic>{
      'entityId': instance.entityId,
      'confirmId': instance.confirmId,
      'serverName': instance.serverName,
      'consoleUrl': instance.consoleUrl,
      'identifier': instance.identifier,
      'owner': instance.owner,
      'expire': instance.expire,
      'hostName': instance.hostName,
    };

_AdminUser _$AdminUserFromJson(Map<String, dynamic> json) => _AdminUser(
  id: json['id'] as String? ?? '',
  name: json['name'] as String? ?? '',
  email: json['email'] as String? ?? '',
  balance: (json['balance'] as num?)?.toInt() ?? 0,
  isAdmin: json['isAdmin'] as bool? ?? false,
  emailConfirmed: json['emailConfirmed'] as bool? ?? false,
  pteUserCreated: json['pteUserCreated'] as bool? ?? false,
  totalUpTime: (json['totalUpTime'] as num?)?.toInt() ?? 0,
  createdAt: json['createdAt'] as String? ?? '',
);

Map<String, dynamic> _$AdminUserToJson(_AdminUser instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'email': instance.email,
      'balance': instance.balance,
      'isAdmin': instance.isAdmin,
      'emailConfirmed': instance.emailConfirmed,
      'pteUserCreated': instance.pteUserCreated,
      'totalUpTime': instance.totalUpTime,
      'createdAt': instance.createdAt,
    };

_AdminOrder _$AdminOrderFromJson(Map<String, dynamic> json) => _AdminOrder(
  id: json['id'] as String? ?? '',
  userName: json['userName'] as String? ?? '',
  specName: json['specName'] as String? ?? '',
  specDays: (json['specDays'] as num?)?.toInt() ?? 0,
  finalPrice: (json['finalPrice'] as num?)?.toInt() ?? 0,
  createdAt: json['createdAt'] as String? ?? '',
);

Map<String, dynamic> _$AdminOrderToJson(_AdminOrder instance) =>
    <String, dynamic>{
      'id': instance.id,
      'userName': instance.userName,
      'specName': instance.specName,
      'specDays': instance.specDays,
      'finalPrice': instance.finalPrice,
      'createdAt': instance.createdAt,
    };

_AdminProduct _$AdminProductFromJson(Map<String, dynamic> json) =>
    _AdminProduct(
      specId: json['specId'] as String? ?? '',
      wareName: json['wareName'] as String? ?? '',
      wareDescription: json['wareDescription'] as String? ?? '',
      pricePerMonth: (json['pricePerMonth'] as num?)?.toInt() ?? 0,
      discount: (json['discount'] as num?)?.toInt() ?? 0,
      validDays: (json['validDays'] as num?)?.toInt() ?? 0,
      deleteDays: (json['deleteDays'] as num?)?.toInt() ?? 0,
      memory: (json['memory'] as num?)?.toInt() ?? 0,
      cpu: (json['cpu'] as num?)?.toInt() ?? 0,
      disk: (json['disk'] as num?)?.toInt() ?? 0,
      swap: (json['swap'] as num?)?.toInt() ?? 0,
      io: (json['io'] as num?)?.toInt() ?? 0,
      backups: (json['backups'] as num?)?.toInt() ?? 0,
      node: (json['node'] as num?)?.toInt() ?? 0,
      nest: (json['nest'] as num?)?.toInt() ?? 0,
      tagSlug: json['tagSlug'] as String? ?? '',
      egg: (json['egg'] as num?)?.toInt() ?? 0,
      allowedEggIds:
          (json['allowedEggIds'] as List<dynamic>?)
              ?.map((e) => (e as num).toInt())
              .toList() ??
          const <int>[],
      dockerImage: json['dockerImage'] as String? ?? '',
      oomDisabled: json['oomDisabled'] as bool? ?? false,
      startOnCompletion: json['startOnCompletion'] as bool? ?? false,
    );

Map<String, dynamic> _$AdminProductToJson(_AdminProduct instance) =>
    <String, dynamic>{
      'specId': instance.specId,
      'wareName': instance.wareName,
      'wareDescription': instance.wareDescription,
      'pricePerMonth': instance.pricePerMonth,
      'discount': instance.discount,
      'validDays': instance.validDays,
      'deleteDays': instance.deleteDays,
      'memory': instance.memory,
      'cpu': instance.cpu,
      'disk': instance.disk,
      'swap': instance.swap,
      'io': instance.io,
      'backups': instance.backups,
      'node': instance.node,
      'nest': instance.nest,
      'tagSlug': instance.tagSlug,
      'egg': instance.egg,
      'allowedEggIds': instance.allowedEggIds,
      'dockerImage': instance.dockerImage,
      'oomDisabled': instance.oomDisabled,
      'startOnCompletion': instance.startOnCompletion,
    };

_ProductInput _$ProductInputFromJson(Map<String, dynamic> json) =>
    _ProductInput(
      wareName: json['wareName'] as String? ?? '',
      wareDescription: json['wareDescription'] as String? ?? '',
      cpu: (json['cpu'] as num?)?.toInt() ?? 0,
      disk: (json['disk'] as num?)?.toInt() ?? 0,
      memory: (json['memory'] as num?)?.toInt() ?? 0,
      swap: (json['swap'] as num?)?.toInt() ?? 0,
      io: (json['io'] as num?)?.toInt() ?? 0,
      backups: (json['backups'] as num?)?.toInt() ?? 0,
      nodeId: (json['nodeId'] as num?)?.toInt() ?? 0,
      nestId: (json['nestId'] as num?)?.toInt() ?? 0,
      tagSlug: json['tagSlug'] as String? ?? '',
      eggId: (json['eggId'] as num?)?.toInt() ?? 0,
      allowedEggIds:
          (json['allowedEggIds'] as List<dynamic>?)
              ?.map((e) => (e as num).toInt())
              .toList() ??
          const <int>[],
      image: json['image'] as String? ?? '',
      deleteTime: (json['deleteTime'] as num?)?.toInt() ?? 0,
      price: (json['price'] as num?)?.toInt() ?? 0,
      discount0: (json['discount0'] as num?)?.toInt() ?? 0,
      discount1: (json['discount1'] as num?)?.toInt() ?? 0,
      discount2: (json['discount2'] as num?)?.toInt() ?? 0,
      discount: (json['discount'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$ProductInputToJson(_ProductInput instance) =>
    <String, dynamic>{
      'wareName': instance.wareName,
      'wareDescription': instance.wareDescription,
      'cpu': instance.cpu,
      'disk': instance.disk,
      'memory': instance.memory,
      'swap': instance.swap,
      'io': instance.io,
      'backups': instance.backups,
      'nodeId': instance.nodeId,
      'nestId': instance.nestId,
      'tagSlug': instance.tagSlug,
      'eggId': instance.eggId,
      'allowedEggIds': instance.allowedEggIds,
      'image': instance.image,
      'deleteTime': instance.deleteTime,
      'price': instance.price,
      'discount0': instance.discount0,
      'discount1': instance.discount1,
      'discount2': instance.discount2,
      'discount': instance.discount,
    };

_PanelTag _$PanelTagFromJson(Map<String, dynamic> json) => _PanelTag(
  id: (json['id'] as num?)?.toInt() ?? 0,
  name: json['name'] as String? ?? '',
  slug: json['slug'] as String? ?? '',
  legacyNestId: (json['legacyNestId'] as num?)?.toInt(),
);

Map<String, dynamic> _$PanelTagToJson(_PanelTag instance) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'slug': instance.slug,
  'legacyNestId': instance.legacyNestId,
};

_PanelTagListResponse _$PanelTagListResponseFromJson(
  Map<String, dynamic> json,
) => _PanelTagListResponse(
  items:
      (json['items'] as List<dynamic>?)
          ?.map((e) => PanelTag.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const <PanelTag>[],
);

Map<String, dynamic> _$PanelTagListResponseToJson(
  _PanelTagListResponse instance,
) => <String, dynamic>{'items': instance.items};

_UpdateProductRequest _$UpdateProductRequestFromJson(
  Map<String, dynamic> json,
) => _UpdateProductRequest(
  product: ProductInput.fromJson(json['product'] as Map<String, dynamic>),
);

Map<String, dynamic> _$UpdateProductRequestToJson(
  _UpdateProductRequest instance,
) => <String, dynamic>{'product': instance.product};

_FormField _$FormFieldFromJson(Map<String, dynamic> json) => _FormField(
  name: json['name'] as String? ?? '',
  label: json['label'] as String? ?? '',
  description: json['description'] as String? ?? '',
  type: json['type'] as String? ?? '',
  required: json['required'] as bool? ?? false,
  defaultValue: json['default'],
);

Map<String, dynamic> _$FormFieldToJson(_FormField instance) =>
    <String, dynamic>{
      'name': instance.name,
      'label': instance.label,
      'description': instance.description,
      'type': instance.type,
      'required': instance.required,
      'default': instance.defaultValue,
    };

_KeyTarget _$KeyTargetFromJson(Map<String, dynamic> json) => _KeyTarget(
  target: json['target'] as String? ?? '',
  name: json['name'] as String? ?? '',
  description: json['description'] as String? ?? '',
  validity: (json['validity'] as num?)?.toInt() ?? 0,
);

Map<String, dynamic> _$KeyTargetToJson(_KeyTarget instance) =>
    <String, dynamic>{
      'target': instance.target,
      'name': instance.name,
      'description': instance.description,
      'validity': instance.validity,
    };

_GenerateKeysRequest _$GenerateKeysRequestFromJson(Map<String, dynamic> json) =>
    _GenerateKeysRequest(
      target: json['target'] as String,
      amount: (json['amount'] as num?)?.toInt() ?? 0,
      validityDays: (json['validityDays'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$GenerateKeysRequestToJson(
  _GenerateKeysRequest instance,
) => <String, dynamic>{
  'target': instance.target,
  'amount': instance.amount,
  'validityDays': instance.validityDays,
};

_SettingField _$SettingFieldFromJson(Map<String, dynamic> json) =>
    _SettingField(
      key: json['key'] as String? ?? '',
      label: json['label'] as String? ?? '',
      description: json['description'] as String? ?? '',
      type: json['type'] as String? ?? 'text',
      value: json['value'] as String? ?? '',
      secret: json['secret'] as bool? ?? false,
      configured: json['configured'] as bool? ?? false,
    );

Map<String, dynamic> _$SettingFieldToJson(_SettingField instance) =>
    <String, dynamic>{
      'key': instance.key,
      'label': instance.label,
      'description': instance.description,
      'type': instance.type,
      'value': instance.value,
      'secret': instance.secret,
      'configured': instance.configured,
    };

_ComponentStatus _$ComponentStatusFromJson(Map<String, dynamic> json) =>
    _ComponentStatus(
      ok: json['ok'] as bool? ?? false,
      message: json['message'] as String? ?? '',
    );

Map<String, dynamic> _$ComponentStatusToJson(_ComponentStatus instance) =>
    <String, dynamic>{'ok': instance.ok, 'message': instance.message};

_Health _$HealthFromJson(Map<String, dynamic> json) => _Health(
  mongo: json['mongo'] == null
      ? const ComponentStatus()
      : ComponentStatus.fromJson(json['mongo'] as Map<String, dynamic>),
  redis: json['redis'] == null
      ? const ComponentStatus()
      : ComponentStatus.fromJson(json['redis'] as Map<String, dynamic>),
  pterodactyl: json['pterodactyl'] == null
      ? const ComponentStatus()
      : ComponentStatus.fromJson(json['pterodactyl'] as Map<String, dynamic>),
  version: json['version'] as String? ?? '',
  buildTime: json['buildTime'] as String? ?? '',
  goVersion: json['goVersion'] as String? ?? '',
);

Map<String, dynamic> _$HealthToJson(_Health instance) => <String, dynamic>{
  'mongo': instance.mongo,
  'redis': instance.redis,
  'pterodactyl': instance.pterodactyl,
  'version': instance.version,
  'buildTime': instance.buildTime,
  'goVersion': instance.goVersion,
};

_HealthResponse _$HealthResponseFromJson(Map<String, dynamic> json) =>
    _HealthResponse(
      health: Health.fromJson(json['health'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$HealthResponseToJson(_HealthResponse instance) =>
    <String, dynamic>{'health': instance.health};

_AdminSettingsResponse _$AdminSettingsResponseFromJson(
  Map<String, dynamic> json,
) => _AdminSettingsResponse(
  fields:
      (json['fields'] as List<dynamic>?)
          ?.map((e) => SettingField.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const <SettingField>[],
);

Map<String, dynamic> _$AdminSettingsResponseToJson(
  _AdminSettingsResponse instance,
) => <String, dynamic>{'fields': instance.fields};

_SaveSettingsRequest _$SaveSettingsRequestFromJson(Map<String, dynamic> json) =>
    _SaveSettingsRequest(
      values:
          (json['values'] as Map<String, dynamic>?)?.map(
            (k, e) => MapEntry(k, e as String),
          ) ??
          const <String, String>{},
    );

Map<String, dynamic> _$SaveSettingsRequestToJson(
  _SaveSettingsRequest instance,
) => <String, dynamic>{'values': instance.values};

_AdminDashboardResponse _$AdminDashboardResponseFromJson(
  Map<String, dynamic> json,
) => _AdminDashboardResponse(
  dashboard: Dashboard.fromJson(json['dashboard'] as Map<String, dynamic>),
);

Map<String, dynamic> _$AdminDashboardResponseToJson(
  _AdminDashboardResponse instance,
) => <String, dynamic>{'dashboard': instance.dashboard};

_AdminUserListResponse _$AdminUserListResponseFromJson(
  Map<String, dynamic> json,
) => _AdminUserListResponse(
  users:
      (json['users'] as List<dynamic>?)
          ?.map((e) => AdminUser.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const <AdminUser>[],
);

Map<String, dynamic> _$AdminUserListResponseToJson(
  _AdminUserListResponse instance,
) => <String, dynamic>{'users': instance.users};

_AdminOrderListResponse _$AdminOrderListResponseFromJson(
  Map<String, dynamic> json,
) => _AdminOrderListResponse(
  orders:
      (json['orders'] as List<dynamic>?)
          ?.map((e) => AdminOrder.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const <AdminOrder>[],
);

Map<String, dynamic> _$AdminOrderListResponseToJson(
  _AdminOrderListResponse instance,
) => <String, dynamic>{'orders': instance.orders};

_AdminProductListResponse _$AdminProductListResponseFromJson(
  Map<String, dynamic> json,
) => _AdminProductListResponse(
  products:
      (json['products'] as List<dynamic>?)
          ?.map((e) => AdminProduct.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const <AdminProduct>[],
);

Map<String, dynamic> _$AdminProductListResponseToJson(
  _AdminProductListResponse instance,
) => <String, dynamic>{'products': instance.products};

_AdminProductFormResponse _$AdminProductFormResponseFromJson(
  Map<String, dynamic> json,
) => _AdminProductFormResponse(
  fields:
      (json['fields'] as List<dynamic>?)
          ?.map((e) => FormField.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const <FormField>[],
);

Map<String, dynamic> _$AdminProductFormResponseToJson(
  _AdminProductFormResponse instance,
) => <String, dynamic>{'fields': instance.fields};

_AdminWorkOrderListResponse _$AdminWorkOrderListResponseFromJson(
  Map<String, dynamic> json,
) => _AdminWorkOrderListResponse(
  orders:
      (json['orders'] as List<dynamic>?)
          ?.map((e) => WorkOrderItem.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const <WorkOrderItem>[],
);

Map<String, dynamic> _$AdminWorkOrderListResponseToJson(
  _AdminWorkOrderListResponse instance,
) => <String, dynamic>{'orders': instance.orders};

_AdminDeleteConfirmListResponse _$AdminDeleteConfirmListResponseFromJson(
  Map<String, dynamic> json,
) => _AdminDeleteConfirmListResponse(
  confirms:
      (json['confirms'] as List<dynamic>?)
          ?.map((e) => DeleteConfirmItem.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const <DeleteConfirmItem>[],
);

Map<String, dynamic> _$AdminDeleteConfirmListResponseToJson(
  _AdminDeleteConfirmListResponse instance,
) => <String, dynamic>{'confirms': instance.confirms};

_CreateProductResponse _$CreateProductResponseFromJson(
  Map<String, dynamic> json,
) => _CreateProductResponse(
  specIds:
      (json['specIds'] as List<dynamic>?)?.map((e) => e as String).toList() ??
      const <String>[],
);

Map<String, dynamic> _$CreateProductResponseToJson(
  _CreateProductResponse instance,
) => <String, dynamic>{'specIds': instance.specIds};

_DeleteConfirmRequest _$DeleteConfirmRequestFromJson(
  Map<String, dynamic> json,
) => _DeleteConfirmRequest(approve: json['approve'] as bool? ?? false);

Map<String, dynamic> _$DeleteConfirmRequestToJson(
  _DeleteConfirmRequest instance,
) => <String, dynamic>{'approve': instance.approve};

_KeyTargetListResponse _$KeyTargetListResponseFromJson(
  Map<String, dynamic> json,
) => _KeyTargetListResponse(
  targets:
      (json['targets'] as List<dynamic>?)
          ?.map((e) => KeyTarget.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const <KeyTarget>[],
);

Map<String, dynamic> _$KeyTargetListResponseToJson(
  _KeyTargetListResponse instance,
) => <String, dynamic>{'targets': instance.targets};

_CloseWorkOrderRequest _$CloseWorkOrderRequestFromJson(
  Map<String, dynamic> json,
) => _CloseWorkOrderRequest(closeInfo: json['closeInfo'] as String? ?? '');

Map<String, dynamic> _$CloseWorkOrderRequestToJson(
  _CloseWorkOrderRequest instance,
) => <String, dynamic>{'closeInfo': instance.closeInfo};

_HealthzResponse _$HealthzResponseFromJson(Map<String, dynamic> json) =>
    _HealthzResponse(
      ok: json['ok'] as bool? ?? false,
      mongo: json['mongo'] as bool? ?? false,
      redis: json['redis'] as bool? ?? false,
      pterodactyl: json['pterodactyl'] as bool? ?? false,
      mongoError: json['mongo_error'] as String?,
      redisError: json['redis_error'] as String?,
      pterodactylError: json['pterodactyl_error'] as String?,
    );

Map<String, dynamic> _$HealthzResponseToJson(_HealthzResponse instance) =>
    <String, dynamic>{
      'ok': instance.ok,
      'mongo': instance.mongo,
      'redis': instance.redis,
      'pterodactyl': instance.pterodactyl,
      'mongo_error': instance.mongoError,
      'redis_error': instance.redisError,
      'pterodactyl_error': instance.pterodactylError,
    };
