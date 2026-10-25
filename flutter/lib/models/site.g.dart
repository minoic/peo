// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'site.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_SiteConfig _$SiteConfigFromJson(Map<String, dynamic> json) => _SiteConfig(
  applicationName: json['applicationName'] as String? ?? '',
  description: json['description'] as String? ?? '',
  hostName: json['hostName'] as String? ?? '',
  adminAddress: json['adminAddress'] as String? ?? '',
  albumEnabled: json['albumEnabled'] as bool? ?? false,
  rechargeMode: json['rechargeMode'] as bool? ?? false,
  alipayEnabled: json['alipayEnabled'] as bool? ?? false,
  totalDiscount: json['totalDiscount'] as bool? ?? false,
  socialLink: json['socialLink'] as String? ?? '',
  socialLinkTitle: json['socialLinkTitle'] as String? ?? '',
  emailNotice: json['emailNotice'] as bool? ?? false,
  loggedIn: json['loggedIn'] as bool? ?? false,
  isAdmin: json['isAdmin'] as bool? ?? false,
  unread: (json['unread'] as num?)?.toInt() ?? 0,
);

Map<String, dynamic> _$SiteConfigToJson(_SiteConfig instance) =>
    <String, dynamic>{
      'applicationName': instance.applicationName,
      'description': instance.description,
      'hostName': instance.hostName,
      'adminAddress': instance.adminAddress,
      'albumEnabled': instance.albumEnabled,
      'rechargeMode': instance.rechargeMode,
      'alipayEnabled': instance.alipayEnabled,
      'totalDiscount': instance.totalDiscount,
      'socialLink': instance.socialLink,
      'socialLinkTitle': instance.socialLinkTitle,
      'emailNotice': instance.emailNotice,
      'loggedIn': instance.loggedIn,
      'isAdmin': instance.isAdmin,
      'unread': instance.unread,
    };

_Intro _$IntroFromJson(Map<String, dynamic> json) => _Intro(
  key: json['key'] as String? ?? '',
  value: json['value'] as String? ?? '',
  label: json['label'] as String? ?? '',
  hint: json['hint'] as bool? ?? false,
);

Map<String, dynamic> _$IntroToJson(_Intro instance) => <String, dynamic>{
  'key': instance.key,
  'value': instance.value,
  'label': instance.label,
  'hint': instance.hint,
};

_ProductCard _$ProductCardFromJson(Map<String, dynamic> json) => _ProductCard(
  specId: json['specId'] as String? ?? '',
  wareName: json['wareName'] as String? ?? '',
  discount: (json['discount'] as num?)?.toInt() ?? 0,
  intros:
      (json['intros'] as List<dynamic>?)
          ?.map((e) => Intro.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const <Intro>[],
  price: (json['price'] as num?)?.toInt() ?? 0,
  monthPrice: (json['monthPrice'] as num?)?.toInt() ?? 0,
  validDays: (json['validDays'] as num?)?.toInt() ?? 0,
  deleteDays: (json['deleteDays'] as num?)?.toInt() ?? 0,
  memory: (json['memory'] as num?)?.toInt() ?? 0,
  cpu: (json['cpu'] as num?)?.toInt() ?? 0,
  disk: (json['disk'] as num?)?.toInt() ?? 0,
  backups: (json['backups'] as num?)?.toInt() ?? 0,
  nest: (json['nest'] as num?)?.toInt() ?? 0,
  egg: (json['egg'] as num?)?.toInt() ?? 0,
  allowedEggIds:
      (json['allowedEggIds'] as List<dynamic>?)
          ?.map((e) => (e as num).toInt())
          .toList() ??
      const <int>[],
);

Map<String, dynamic> _$ProductCardToJson(_ProductCard instance) =>
    <String, dynamic>{
      'specId': instance.specId,
      'wareName': instance.wareName,
      'discount': instance.discount,
      'intros': instance.intros,
      'price': instance.price,
      'monthPrice': instance.monthPrice,
      'validDays': instance.validDays,
      'deleteDays': instance.deleteDays,
      'memory': instance.memory,
      'cpu': instance.cpu,
      'disk': instance.disk,
      'backups': instance.backups,
      'nest': instance.nest,
      'egg': instance.egg,
      'allowedEggIds': instance.allowedEggIds,
    };

_Storefront _$StorefrontFromJson(Map<String, dynamic> json) => _Storefront(
  monthly:
      (json['monthly'] as List<dynamic>?)
          ?.map((e) => ProductCard.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const <ProductCard>[],
  quarterly:
      (json['quarterly'] as List<dynamic>?)
          ?.map((e) => ProductCard.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const <ProductCard>[],
  yearly:
      (json['yearly'] as List<dynamic>?)
          ?.map((e) => ProductCard.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const <ProductCard>[],
  emailNotice: json['emailNotice'] as bool? ?? false,
);

Map<String, dynamic> _$StorefrontToJson(_Storefront instance) =>
    <String, dynamic>{
      'monthly': instance.monthly,
      'quarterly': instance.quarterly,
      'yearly': instance.yearly,
      'emailNotice': instance.emailNotice,
    };

_Pricing _$PricingFromJson(Map<String, dynamic> json) => _Pricing(
  originPrice: (json['originPrice'] as num?)?.toInt() ?? 0,
  finalPrice: (json['finalPrice'] as num?)?.toInt() ?? 0,
);

Map<String, dynamic> _$PricingToJson(_Pricing instance) => <String, dynamic>{
  'originPrice': instance.originPrice,
  'finalPrice': instance.finalPrice,
};

_Egg _$EggFromJson(Map<String, dynamic> json) => _Egg(
  id: (json['id'] as num?)?.toInt() ?? 0,
  name: json['name'] as String? ?? '',
);

Map<String, dynamic> _$EggToJson(_Egg instance) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
};

_ProductDetail _$ProductDetailFromJson(Map<String, dynamic> json) =>
    _ProductDetail(
      product: ProductCard.fromJson(json['product'] as Map<String, dynamic>),
      pricing: Pricing.fromJson(json['pricing'] as Map<String, dynamic>),
      nestName: json['nestName'] as String? ?? '',
      eggName: json['eggName'] as String? ?? '',
      eggs:
          (json['eggs'] as List<dynamic>?)
              ?.map((e) => Egg.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const <Egg>[],
    );

Map<String, dynamic> _$ProductDetailToJson(_ProductDetail instance) =>
    <String, dynamic>{
      'product': instance.product,
      'pricing': instance.pricing,
      'nestName': instance.nestName,
      'eggName': instance.eggName,
      'eggs': instance.eggs,
    };

_ProductListResponse _$ProductListResponseFromJson(Map<String, dynamic> json) =>
    _ProductListResponse(
      products:
          (json['products'] as List<dynamic>?)
              ?.map((e) => WareSpec.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const <WareSpec>[],
    );

Map<String, dynamic> _$ProductListResponseToJson(
  _ProductListResponse instance,
) => <String, dynamic>{'products': instance.products};

_EggListResponse _$EggListResponseFromJson(Map<String, dynamic> json) =>
    _EggListResponse(
      eggs:
          (json['eggs'] as List<dynamic>?)
              ?.map((e) => Egg.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const <Egg>[],
    );

Map<String, dynamic> _$EggListResponseToJson(_EggListResponse instance) =>
    <String, dynamic>{'eggs': instance.eggs};

_StorefrontResponse _$StorefrontResponseFromJson(Map<String, dynamic> json) =>
    _StorefrontResponse(
      monthly:
          (json['monthly'] as List<dynamic>?)
              ?.map((e) => ProductCard.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const <ProductCard>[],
      quarterly:
          (json['quarterly'] as List<dynamic>?)
              ?.map((e) => ProductCard.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const <ProductCard>[],
      yearly:
          (json['yearly'] as List<dynamic>?)
              ?.map((e) => ProductCard.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const <ProductCard>[],
      emailNotice: json['emailNotice'] as bool? ?? false,
    );

Map<String, dynamic> _$StorefrontResponseToJson(_StorefrontResponse instance) =>
    <String, dynamic>{
      'monthly': instance.monthly,
      'quarterly': instance.quarterly,
      'yearly': instance.yearly,
      'emailNotice': instance.emailNotice,
    };
