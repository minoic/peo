/// The storefront and product catalogue shapes.
///
/// Mirrors `server/internal/api/dto/site.go` plus the service types it embeds
/// from `server/internal/service/product_service.go`.
library;

import 'package:freezed_annotation/freezed_annotation.dart';

import 'documents.dart';

part 'site.freezed.dart';
part 'site.g.dart';

/// The public bootstrap payload the shell fetches before it draws anything.
///
/// Site identity, feature switches, socials and — for a signed-in visitor — the
/// three pieces of state the legacy navigation bar rendered on every page.
@freezed
abstract class SiteConfig with _$SiteConfig {
  const factory SiteConfig({
    @Default('') String applicationName,
    @Default('') String description,
    @Default('') String hostName,
    @Default('') String adminAddress,
    @Default(false) bool albumEnabled,
    @Default(false) bool rechargeMode,
    @Default(false) bool alipayEnabled,
    @Default(false) bool totalDiscount,
    @Default('') String socialLink,
    @Default('') String socialLinkTitle,
    @Default(false) bool emailNotice,

    /// Always present, so the shell can build the navigation bar from one
    /// request. False and zero for an anonymous visitor.
    @Default(false) bool loggedIn,
    @Default(false) bool isAdmin,
    @Default(0) int unread,
  }) = _SiteConfig;

  factory SiteConfig.fromJson(Map<String, dynamic> json) =>
      _$SiteConfigFromJson(json);

  /// A configuration with nothing switched on, used before the first fetch
  /// resolves so the shell renders an empty frame instead of blocking.
  static const SiteConfig empty = SiteConfig();
}

/// One bullet on a product card.
///
/// The wording is owned by the client: it translates [key] and appends [value],
/// so the server never ships prose. [label] carries a free-form name (the nest
/// description, a product note) that has no translation.
@freezed
abstract class Intro with _$Intro {
  const factory Intro({
    @Default('') String key,
    @Default('') String value,
    @Default('') String label,

    /// Marks a bullet that carries an extra explanation; used for the retention
    /// bullet when the site sends expiry mail.
    @Default(false) bool hint,
  }) = _Intro;

  factory Intro.fromJson(Map<String, dynamic> json) => _$IntroFromJson(json);
}

/// One purchasable product as shown on the storefront.
@freezed
abstract class ProductCard with _$ProductCard {
  const ProductCard._();

  const factory ProductCard({
    @Default('') String specId,
    @Default('') String wareName,
    @Default(0) int discount,
    @Default(<Intro>[]) List<Intro> intros,

    /// The total for the billing cycle of the bucket this card sits in.
    @Default(0) int price,

    /// The monthly list price before the discount.
    @Default(0) int monthPrice,
    @Default(0) int validDays,
    @Default(0) int deleteDays,
    @Default(0) int memory,
    @Default(0) int cpu,
    @Default(0) int disk,
    @Default(0) int backups,
    @Default(0) int nest,
    @Default(0) int egg,
    @Default(<int>[]) List<int> allowedEggIds,
  }) = _ProductCard;

  factory ProductCard.fromJson(Map<String, dynamic> json) =>
      _$ProductCardFromJson(json);
}

/// The shop landing page: one bucket per billing cycle.
@freezed
abstract class Storefront with _$Storefront {
  const factory Storefront({
    @Default(<ProductCard>[]) List<ProductCard> monthly,
    @Default(<ProductCard>[]) List<ProductCard> quarterly,
    @Default(<ProductCard>[]) List<ProductCard> yearly,
    @Default(false) bool emailNotice,
  }) = _Storefront;

  factory Storefront.fromJson(Map<String, dynamic> json) =>
      _$StorefrontFromJson(json);
}

/// Origin and discounted price for a product.
@freezed
abstract class Pricing with _$Pricing {
  const factory Pricing({
    @Default(0) int originPrice,
    @Default(0) int finalPrice,
  }) = _Pricing;

  factory Pricing.fromJson(Map<String, dynamic> json) =>
      _$PricingFromJson(json);
}

/// One selectable server template for a product.
@freezed
abstract class Egg with _$Egg {
  const factory Egg({
    /// The JSON key is lowercase `id`, unlike every other identifier on the API.
    @Default(0) int id,
    @Default('') String name,
  }) = _Egg;

  factory Egg.fromJson(Map<String, dynamic> json) => _$EggFromJson(json);
}

/// A single product with live pricing.
@freezed
abstract class ProductDetail with _$ProductDetail {
  const factory ProductDetail({
    required ProductCard product,
    required Pricing pricing,
    @Default('') String nestName,
    @Default('') String eggName,
    @Default(<Egg>[]) List<Egg> eggs,
  }) = _ProductDetail;

  factory ProductDetail.fromJson(Map<String, dynamic> json) =>
      _$ProductDetailFromJson(json);
}

/// The raw specification list, used by the admin product editor.
@freezed
abstract class ProductListResponse with _$ProductListResponse {
  const factory ProductListResponse({
    @Default(<WareSpec>[]) List<WareSpec> products,
  }) = _ProductListResponse;

  factory ProductListResponse.fromJson(Map<String, dynamic> json) =>
      _$ProductListResponseFromJson(json);
}

/// The eggs a nest offers, for the reinstall picker.
@freezed
abstract class EggListResponse with _$EggListResponse {
  const factory EggListResponse({@Default(<Egg>[]) List<Egg> eggs}) =
      _EggListResponse;

  factory EggListResponse.fromJson(Map<String, dynamic> json) =>
      _$EggListResponseFromJson(json);
}

/// The storefront payload as the API sends it.
@freezed
abstract class StorefrontResponse with _$StorefrontResponse {
  const factory StorefrontResponse({
    @Default(<ProductCard>[]) List<ProductCard> monthly,
    @Default(<ProductCard>[]) List<ProductCard> quarterly,
    @Default(<ProductCard>[]) List<ProductCard> yearly,
    @Default(false) bool emailNotice,
  }) = _StorefrontResponse;

  factory StorefrontResponse.fromJson(Map<String, dynamic> json) =>
      _$StorefrontResponseFromJson(json);
}
