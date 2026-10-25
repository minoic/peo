/// The back-office contract.
///
/// Mirrors `server/internal/api/dto/admin.go` plus every service type it embeds
/// from `server/internal/service/admin_service.go`.
library;

import 'package:freezed_annotation/freezed_annotation.dart';

import 'content.dart';

part 'admin.freezed.dart';
part 'admin.g.dart';

/// The landing payload of the administration console.
@freezed
abstract class Dashboard with _$Dashboard {
  const factory Dashboard({
    @Default(0) int specAmount,
    @Default(0) int entityAmount,
    @Default(0) int userAmount,
    @Default(0) int keyAmount,
    @Default(0) int orderAmount,
    @Default(0) int workOrderCount,
    @Default(0) int galleryCount,
    @Default(<GalleryCard>[]) List<GalleryCard> galleryItems,
    @Default(<WorkOrderItem>[]) List<WorkOrderItem> workOrders,
    @Default(<DeleteConfirmItem>[]) List<DeleteConfirmItem> deleteConfirms,
  }) = _Dashboard;

  factory Dashboard.fromJson(Map<String, dynamic> json) =>
      _$DashboardFromJson(json);
}

/// One server waiting for an administrator to confirm its removal.
@freezed
abstract class DeleteConfirmItem with _$DeleteConfirmItem {
  const factory DeleteConfirmItem({
    @Default('') String entityId,
    @Default('') String confirmId,
    @Default('') String serverName,
    @Default('') String consoleUrl,
    @Default('') String identifier,
    @Default('') String owner,

    /// Formatted `yyyy-MM-dd HH:mm` by the server.
    @Default('') String expire,
    @Default('') String hostName,
  }) = _DeleteConfirmItem;

  factory DeleteConfirmItem.fromJson(Map<String, dynamic> json) =>
      _$DeleteConfirmItemFromJson(json);
}

/// One row of the back-office user table.
///
/// A projection: the legacy template received the raw model and therefore
/// shipped the password hash to the browser, which this shape makes impossible.
@freezed
abstract class AdminUser with _$AdminUser {
  const AdminUser._();

  const factory AdminUser({
    @Default('') String id,
    @Default('') String name,
    @Default('') String email,
    @Default(0) int balance,
    @Default(false) bool isAdmin,
    @Default(false) bool emailConfirmed,
    @Default(false) bool pteUserCreated,

    /// Nanoseconds, as stored.
    @Default(0) int totalUpTime,

    /// Formatted `yyyy-MM-dd HH:mm` by the server.
    @Default('') String createdAt,
  }) = _AdminUser;

  factory AdminUser.fromJson(Map<String, dynamic> json) =>
      _$AdminUserFromJson(json);

  Duration get uptime => Duration(microseconds: totalUpTime ~/ 1000);
}

/// One row of the back-office order table, with the customer and product names
/// joined in so the client needs a single request.
@freezed
abstract class AdminOrder with _$AdminOrder {
  const factory AdminOrder({
    @Default('') String id,
    @Default('') String userName,
    @Default('') String specName,
    @Default(0) int specDays,
    @Default(0) int finalPrice,
    @Default('') String createdAt,
  }) = _AdminOrder;

  factory AdminOrder.fromJson(Map<String, dynamic> json) =>
      _$AdminOrderFromJson(json);
}

/// One row of the back-office product table.
@freezed
abstract class AdminProduct with _$AdminProduct {
  const factory AdminProduct({
    @Default('') String specId,
    @Default('') String wareName,
    @Default('') String wareDescription,
    @Default(0) int pricePerMonth,
    @Default(0) int discount,
    @Default(0) int validDays,
    @Default(0) int deleteDays,
    @Default(0) int memory,
    @Default(0) int cpu,
    @Default(0) int disk,
    @Default(0) int swap,
    @Default(0) int io,
    @Default(0) int backups,
    @Default(0) int node,
    @Default(0) int nest,
    @Default('') String tagSlug,
    @Default(0) int egg,
    @Default(<int>[]) List<int> allowedEggIds,
    @Default('') String dockerImage,
    @Default(false) bool oomDisabled,
    @Default(false) bool startOnCompletion,
  }) = _AdminProduct;

  factory AdminProduct.fromJson(Map<String, dynamic> json) =>
      _$AdminProductFromJson(json);
}

/// The payload of the back-office product editor.
///
/// The names are camelCase, unlike the snake_case names in the form schema:
/// [FormField.name] mirrors the legacy HTML form, this mirrors the JSON body.
@freezed
abstract class ProductInput with _$ProductInput {
  const factory ProductInput({
    @Default('') String wareName,
    @Default('') String wareDescription,
    @Default(0) int cpu,
    @Default(0) int disk,
    @Default(0) int memory,
    @Default(0) int swap,
    @Default(0) int io,
    @Default(0) int backups,
    @Default(0) int nodeId,
    @Default(0) int nestId,
    @Default('') String tagSlug,
    @Default(0) int eggId,
    @Default(<int>[]) List<int> allowedEggIds,
    @Default('') String image,
    @Default(0) int deleteTime,
    @Default(0) int price,
    @Default(0) int discount0,
    @Default(0) int discount1,
    @Default(0) int discount2,

    /// Used by the single-cycle update path only; creation derives the
    /// per-cycle discounts from discount0/1/2.
    @Default(0) int discount,
  }) = _ProductInput;

  factory ProductInput.fromJson(Map<String, dynamic> json) =>
      _$ProductInputFromJson(json);
}

@freezed
abstract class PanelTag with _$PanelTag {
  const factory PanelTag({
    @Default(0) int id,
    @Default('') String name,
    @Default('') String slug,
    int? legacyNestId,
  }) = _PanelTag;

  factory PanelTag.fromJson(Map<String, dynamic> json) =>
      _$PanelTagFromJson(json);
}

@freezed
abstract class PanelTagListResponse with _$PanelTagListResponse {
  const factory PanelTagListResponse({
    @Default(<PanelTag>[]) List<PanelTag> items,
  }) = _PanelTagListResponse;

  factory PanelTagListResponse.fromJson(Map<String, dynamic> json) =>
      _$PanelTagListResponseFromJson(json);
}

/// The product editor payload. Used by both `POST` and `PUT`.
@freezed
abstract class UpdateProductRequest with _$UpdateProductRequest {
  const factory UpdateProductRequest({required ProductInput product}) =
      _UpdateProductRequest;

  factory UpdateProductRequest.fromJson(Map<String, dynamic> json) =>
      _$UpdateProductRequestFromJson(json);
}

/// Describes one input of a generated form. The server ships a schema instead of
/// HTML, so the client renders it.
@freezed
abstract class FormField with _$FormField {
  const factory FormField({
    /// snake_case, mirroring the legacy HTML form (`ware_name`, `node_id`, ...).
    @Default('') String name,
    @Default('') String label,
    @Default('') String description,
    @Default('') String type,
    @Default(false) bool required,

    /// `int`, `String` or `null` depending on [type].
    @JsonKey(name: 'default') Object? defaultValue,
  }) = _FormField;

  factory FormField.fromJson(Map<String, dynamic> json) =>
      _$FormFieldFromJson(json);
}

/// One entry of the key generator's target picker.
@freezed
abstract class KeyTarget with _$KeyTarget {
  const factory KeyTarget({
    /// `all`, `balance:all`, `spec:<hex>` or `balance:<amount>`.
    @Default('') String target,
    @Default('') String name,
    @Default('') String description,

    /// The product's lifetime in days. Zero means a balance code; -1 means the
    /// target stands for every product at once.
    @Default(0) int validity,
  }) = _KeyTarget;

  factory KeyTarget.fromJson(Map<String, dynamic> json) =>
      _$KeyTargetFromJson(json);
}

/// Mints product or balance keys.
@freezed
abstract class GenerateKeysRequest with _$GenerateKeysRequest {
  const factory GenerateKeysRequest({
    required String target,
    @Default(0) int amount,
    @Default(0) int validityDays,
  }) = _GenerateKeysRequest;

  factory GenerateKeysRequest.fromJson(Map<String, dynamic> json) =>
      _$GenerateKeysRequestFromJson(json);
}

/// One editable setting: its key, its label and the input to render.
@freezed
abstract class SettingField with _$SettingField {
  const factory SettingField({
    @Default('') String key,
    @Default('') String label,
    @Default('') String description,

    /// One of `text`, `number`, `bool`.
    @Default('text') String type,

    /// Always a string regardless of [type]; the server parses it.
    @Default('') String value,
    @Default(false) bool secret,
    @Default(false) bool configured,
  }) = _SettingField;

  factory SettingField.fromJson(Map<String, dynamic> json) =>
      _$SettingFieldFromJson(json);
}

/// The result of one connectivity probe.
@freezed
abstract class ComponentStatus with _$ComponentStatus {
  const factory ComponentStatus({
    @Default(false) bool ok,
    @Default('') String message,
  }) = _ComponentStatus;

  factory ComponentStatus.fromJson(Map<String, dynamic> json) =>
      _$ComponentStatusFromJson(json);
}

/// The diagnostics panel of the settings page.
@freezed
abstract class Health with _$Health {
  const factory Health({
    @Default(ComponentStatus()) ComponentStatus mongo,
    @Default(ComponentStatus()) ComponentStatus redis,
    @Default(ComponentStatus()) ComponentStatus pterodactyl,
    @Default('') String version,
    @Default('') String buildTime,
    @Default('') String goVersion,
  }) = _Health;

  factory Health.fromJson(Map<String, dynamic> json) => _$HealthFromJson(json);
}

/// The whole `GET /admin/health` payload.
@freezed
abstract class HealthResponse with _$HealthResponse {
  const factory HealthResponse({required Health health}) = _HealthResponse;

  factory HealthResponse.fromJson(Map<String, dynamic> json) =>
      _$HealthResponseFromJson(json);
}

/// The whole `GET /admin/settings` payload.
@freezed
abstract class AdminSettingsResponse with _$AdminSettingsResponse {
  const factory AdminSettingsResponse({
    @Default(<SettingField>[]) List<SettingField> fields,
  }) = _AdminSettingsResponse;

  factory AdminSettingsResponse.fromJson(Map<String, dynamic> json) =>
      _$AdminSettingsResponseFromJson(json);
}

/// Writes a subset of settings back to the TOML file.
@freezed
abstract class SaveSettingsRequest with _$SaveSettingsRequest {
  const factory SaveSettingsRequest({
    @Default(<String, String>{}) Map<String, String> values,
  }) = _SaveSettingsRequest;

  factory SaveSettingsRequest.fromJson(Map<String, dynamic> json) =>
      _$SaveSettingsRequestFromJson(json);
}

/// The administration landing page aggregate.
@freezed
abstract class AdminDashboardResponse with _$AdminDashboardResponse {
  const factory AdminDashboardResponse({required Dashboard dashboard}) =
      _AdminDashboardResponse;

  factory AdminDashboardResponse.fromJson(Map<String, dynamic> json) =>
      _$AdminDashboardResponseFromJson(json);
}

/// Every account.
@freezed
abstract class AdminUserListResponse with _$AdminUserListResponse {
  const factory AdminUserListResponse({
    @Default(<AdminUser>[]) List<AdminUser> users,
  }) = _AdminUserListResponse;

  factory AdminUserListResponse.fromJson(Map<String, dynamic> json) =>
      _$AdminUserListResponseFromJson(json);
}

/// Every order.
@freezed
abstract class AdminOrderListResponse with _$AdminOrderListResponse {
  const factory AdminOrderListResponse({
    @Default(<AdminOrder>[]) List<AdminOrder> orders,
  }) = _AdminOrderListResponse;

  factory AdminOrderListResponse.fromJson(Map<String, dynamic> json) =>
      _$AdminOrderListResponseFromJson(json);
}

/// Every specification.
@freezed
abstract class AdminProductListResponse with _$AdminProductListResponse {
  const factory AdminProductListResponse({
    @Default(<AdminProduct>[]) List<AdminProduct> products,
  }) = _AdminProductListResponse;

  factory AdminProductListResponse.fromJson(Map<String, dynamic> json) =>
      _$AdminProductListResponseFromJson(json);
}

/// The fields the product editor renders.
@freezed
abstract class AdminProductFormResponse with _$AdminProductFormResponse {
  const factory AdminProductFormResponse({
    @Default(<FormField>[]) List<FormField> fields,
  }) = _AdminProductFormResponse;

  factory AdminProductFormResponse.fromJson(Map<String, dynamic> json) =>
      _$AdminProductFormResponseFromJson(json);
}

/// Open tickets.
@freezed
abstract class AdminWorkOrderListResponse with _$AdminWorkOrderListResponse {
  const factory AdminWorkOrderListResponse({
    @Default(<WorkOrderItem>[]) List<WorkOrderItem> orders,
  }) = _AdminWorkOrderListResponse;

  factory AdminWorkOrderListResponse.fromJson(Map<String, dynamic> json) =>
      _$AdminWorkOrderListResponseFromJson(json);
}

/// Servers awaiting deletion approval.
@freezed
abstract class AdminDeleteConfirmListResponse
    with _$AdminDeleteConfirmListResponse {
  const factory AdminDeleteConfirmListResponse({
    @Default(<DeleteConfirmItem>[]) List<DeleteConfirmItem> confirms,
  }) = _AdminDeleteConfirmListResponse;

  factory AdminDeleteConfirmListResponse.fromJson(Map<String, dynamic> json) =>
      _$AdminDeleteConfirmListResponseFromJson(json);
}

/// The specification ids created by one submission. A single submission
/// produces one document per enabled billing cycle, so this is a list.
@freezed
abstract class CreateProductResponse with _$CreateProductResponse {
  const factory CreateProductResponse({
    @Default(<String>[]) List<String> specIds,
  }) = _CreateProductResponse;

  factory CreateProductResponse.fromJson(Map<String, dynamic> json) =>
      _$CreateProductResponseFromJson(json);
}

/// Approves or rejects a pending server deletion.
@freezed
abstract class DeleteConfirmRequest with _$DeleteConfirmRequest {
  const factory DeleteConfirmRequest({
    /// `true` removes the server; `false` cancels the deletion.
    @Default(false) bool approve,
  }) = _DeleteConfirmRequest;

  factory DeleteConfirmRequest.fromJson(Map<String, dynamic> json) =>
      _$DeleteConfirmRequestFromJson(json);
}

/// Everything a key can be generated for.
@freezed
abstract class KeyTargetListResponse with _$KeyTargetListResponse {
  const factory KeyTargetListResponse({
    @Default(<KeyTarget>[]) List<KeyTarget> targets,
  }) = _KeyTargetListResponse;

  factory KeyTargetListResponse.fromJson(Map<String, dynamic> json) =>
      _$KeyTargetListResponseFromJson(json);
}

/// Closes a ticket with an optional public reply.
@freezed
abstract class CloseWorkOrderRequest with _$CloseWorkOrderRequest {
  const factory CloseWorkOrderRequest({@Default('') String closeInfo}) =
      _CloseWorkOrderRequest;

  factory CloseWorkOrderRequest.fromJson(Map<String, dynamic> json) =>
      _$CloseWorkOrderRequestFromJson(json);
}

/// The bootstrap result of `GET /healthz`, which is **not** enveloped.
///
/// It answers `{ok, mongo, redis, pterodactyl}` with `503` when a component is
/// down, and adds `<name>_error` keys on failure. Unlike the admin `Health`
/// endpoint, each component here is a plain boolean; the explanation lives in a
/// separate `mongo_error` style key.
@freezed
abstract class HealthzResponse with _$HealthzResponse {
  const factory HealthzResponse({
    @Default(false) bool ok,
    @Default(false) bool mongo,
    @Default(false) bool redis,
    @Default(false) bool pterodactyl,
    @JsonKey(name: 'mongo_error') String? mongoError,
    @JsonKey(name: 'redis_error') String? redisError,
    @JsonKey(name: 'pterodactyl_error') String? pterodactylError,
  }) = _HealthzResponse;

  factory HealthzResponse.fromJson(Map<String, dynamic> json) =>
      _$HealthzResponseFromJson(json);
}
