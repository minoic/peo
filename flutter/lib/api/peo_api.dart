/// The typed endpoint facade.
///
/// [ApiClient] knows about the envelope; it does not know what any endpoint
/// means. This class is the other half: one method per route, with the path and
/// the decoder for that route in exactly one place. Cubits therefore never
/// concatenate a URL or guess at a wrapper type, which is what makes the
/// response shapes in `docs/API.md` a compile-time contract rather than a
/// convention someone has to remember.
///
/// Two routes are deliberately not here. `/healthz` is not enveloped and lives
/// on [ApiClient.health]; `/alipay/notify` is called by Alipay, not by this app.
library;

import 'package:dio/dio.dart';

import '../models/admin.dart';
import '../models/auth.dart';
import '../models/content.dart';
import '../models/documents.dart';
import '../models/order.dart';
import '../models/recharge.dart';
import '../models/site.dart';
import '../models/server_console.dart';
import 'api_client.dart';

/// The peo REST API, one method per route.
class PeoApi {
  PeoApi(this.client);

  final ApiClient client;

  // ---------------------------------------------------------------------------
  // Public site
  // ---------------------------------------------------------------------------

  /// The app-wide bootstrap payload. It is flat, and it carries `loggedIn`,
  /// `isAdmin` and `unread` when a token was presented, so the shell can build
  /// the whole navigation bar from this one request.
  Future<SiteConfig> siteConfig() =>
      client.getObject('/site/config', SiteConfig.fromJson);

  /// The shop landing page, bucketed by billing cycle.
  Future<Storefront> storefront() =>
      client.getObject('/site/storefront', Storefront.fromJson);

  /// One product with live pricing and its node's eggs.
  Future<ProductDetail> product(String specId) =>
      client.getObject('/products/$specId', ProductDetail.fromJson);

  /// The eggs of one nest. Used by the reinstall picker.
  Future<List<Egg>> eggs(int nestId) async {
    final res = await client.getObject(
      '/nests/$nestId/eggs',
      EggListResponse.fromJson,
    );
    return res.eggs;
  }

  // ---------------------------------------------------------------------------
  // Authentication
  // ---------------------------------------------------------------------------

  /// Signs in and returns the freshly issued token.
  Future<SessionResponse> login(LoginRequest body) => client.writeObject(
    'POST',
    '/auth/login',
    SessionResponse.fromJson,
    body: body.toJson(),
    anonymous: true,
  );

  /// Creates an account. The server answers `201`.
  Future<SessionResponse> register(RegisterRequest body) => client.writeObject(
    'POST',
    '/auth/register',
    SessionResponse.fromJson,
    body: body.toJson(),
    anonymous: true,
  );

  /// Follows the activation link mailed at registration. The key travels in the
  /// path, which is why the mailed URL is shareable.
  Future<void> confirmEmail(String key) =>
      client.write('GET', '/auth/confirm-email/$key', body: null);

  /// Requests a reset code.
  ///
  /// The server always reports success, whether or not the address is
  /// registered, so the UI must never present this as proof the account exists.
  Future<void> forgetPassword(ForgetPasswordRequest body) =>
      client.write('POST', '/auth/forget-password', body: body.toJson());

  /// Completes a reset with the mailed code.
  Future<void> resetPassword(ResetPasswordRequest body) =>
      client.write('POST', '/auth/reset-password', body: body.toJson());

  /// Invalidates the current token by recording it in the Redis blacklist.
  Future<void> logout() => client.write('POST', '/auth/logout', body: null);

  /// The signed-in account.
  Future<User> me() async {
    final res = await client.getObject('/auth/me', UserResponse.fromJson);
    return res.user;
  }

  // ---------------------------------------------------------------------------
  // Account
  // ---------------------------------------------------------------------------
  /// Rotates the password, on the site and, when the panel account exists, on
  /// the panel too.
  Future<void> changePassword(ChangePasswordRequest body) =>
      client.write('PUT', '/user/password', body: body.toJson());

  /// Mails a confirmation code to a new address.
  Future<void> requestEmailChange(ChangeEmailRequest body) =>
      client.write('PUT', '/user/email', body: body.toJson());

  /// Applies a pending e-mail change with the mailed code.
  Future<void> confirmEmailChange(ConfirmEmailRequest body) =>
      client.write('POST', '/user/email/confirm', body: body.toJson());

  // ---------------------------------------------------------------------------
  // Orders
  // ---------------------------------------------------------------------------

  /// Records a purchase intent. The allocation is chosen later, at payment.
  /// The server answers `201`.
  Future<Order> createOrder(String specId) async {
    final res = await client.writeObject(
      'POST',
      '/orders',
      OrderResponse.fromJson,
      body: CreateOrderRequest(specId: specId).toJson(),
    );
    return res.order;
  }

  /// The caller's order history.
  Future<List<Order>> orders() async {
    final res = await client.getObject('/orders', OrderListResponse.fromJson);
    return res.orders;
  }

  /// One order, used by the payment screen.
  Future<Order> order(String id) async {
    final res = await client.getObject('/orders/$id', OrderResponse.fromJson);
    return res.order;
  }

  /// The free ports on the order's product node.
  Future<List<Allocation>> allocations(String orderId) async {
    final res = await client.getObject(
      '/orders/$orderId/allocations',
      AllocationListResponse.fromJson,
    );
    return res.allocations;
  }

  /// Pays with a product key. The key is a required field, so an empty one is
  /// rejected by the handler before it reaches the service.
  Future<void> payOrder(String orderId, PayOrderRequest body) =>
      client.write('POST', '/orders/$orderId/pay', body: body.toJson());

  /// Pays from the balance. The allocation is still required; the key is not.
  Future<void> payOrderByBalance(String orderId, PayOrderRequest body) => client
      .write('POST', '/orders/$orderId/pay-by-balance', body: body.toJson());

  // ---------------------------------------------------------------------------
  // Servers
  // ---------------------------------------------------------------------------

  /// The customer console list.
  Future<List<WareEntity>> servers() async {
    final res = await client.getObject('/servers', ServerListResponse.fromJson);
    return res.servers;
  }

  /// The live status of every server, one Minecraft ping per server. Polled
  /// rather than pushed, because the legacy console polled it too.
  Future<List<ServerStatus>> serverStatuses() async {
    final res = await client.getObject(
      '/servers/status',
      StatusListResponse.fromJson,
    );
    return res.servers;
  }

  /// One server record.
  Future<WareEntity> server(String id) async {
    final res = await client.getObject(
      '/servers/$id',
      ServerDetailResponse.fromJson,
    );
    return res.server;
  }

  Future<ServerConsole> serverConsole(String id) =>
      client.getObject('/servers/$id/console', ServerConsole.fromJson);

  Future<ServerResources> serverResources(String id) =>
      client.getObject('/servers/$id/resources', ServerResources.fromJson);

  Future<void> serverPower(String id, String signal) =>
      client.write('POST', '/servers/$id/power', body: {'signal': signal});

  Future<void> sendServerCommand(String id, String command) =>
      client.write('POST', '/servers/$id/command', body: {'command': command});

  Future<TerminalTicket> serverTerminalTicket(String id) => client.writeObject(
    'POST',
    '/servers/$id/terminal-ticket',
    TerminalTicket.fromJson,
    body: const <String, dynamic>{},
  );

  Future<List<ServerFile>> serverFiles(String id, String directory) async =>
      (await client.getObject(
        '/servers/$id/files',
        ServerFileList.fromJson,
        query: {'directory': directory},
      )).items;

  Future<String> readServerFile(String id, String file) async =>
      (await client.writeObject(
        'POST',
        '/servers/$id/files/read',
        FileContent.fromJson,
        body: {'file': file},
      )).content;

  Future<void> writeServerFile(String id, String file, String content) =>
      client.write(
        'PUT',
        '/servers/$id/files/write',
        body: {'file': file, 'content': content},
      );

  Future<void> serverFileOperation(
    String id,
    String operation,
    Map<String, dynamic> body,
  ) => client.write('POST', '/servers/$id/files/$operation', body: body);

  Future<List<ServerBackup>> serverBackups(String id) async =>
      (await client.getObject(
        '/servers/$id/backups',
        ServerBackupList.fromJson,
      )).items;

  Future<void> createServerBackup(String id) =>
      client.write('POST', '/servers/$id/backups');

  Future<void> lockServerBackup(String id, String backupId, bool locked) =>
      client.write(
        'POST',
        '/servers/$id/backups/$backupId/lock',
        body: {'locked': locked},
      );

  Future<void> deleteServerBackup(String id, String backupId) =>
      client.write('DELETE', '/servers/$id/backups/$backupId');

  Future<void> restoreServerBackup(
    String id,
    String backupId, {
    bool truncate = false,
  }) => client.write(
    'POST',
    '/servers/$id/backups/$backupId/restore',
    body: {'truncate': truncate},
  );

  Future<ServerStartup> serverStartup(String id) =>
      client.getObject('/servers/$id/startup', ServerStartup.fromJson);

  Future<void> updateServerVariable(String id, String key, String value) =>
      client.write(
        'PUT',
        '/servers/$id/startup/variable',
        body: {'key': key, 'value': value},
      );

  Future<void> updateServerImage(String id, String image) =>
      client.write('PUT', '/servers/$id/startup/image', body: {'image': image});

  Future<DownloadedFile> downloadServerFile(
    String id,
    String file, {
    required CancelToken cancelToken,
    required ProgressCallback onProgress,
  }) => client.downloadBytes(
    '/servers/$id/files/download',
    {'file': file},
    cancelToken: cancelToken,
    onProgress: onProgress,
  );

  Future<DownloadedFile> downloadServerBackup(
    String id,
    String backupId, {
    required CancelToken cancelToken,
    required ProgressCallback onProgress,
  }) => client.downloadBytes(
    '/servers/$id/backups/$backupId/download',
    const {},
    cancelToken: cancelToken,
    onProgress: onProgress,
  );

  Future<void> uploadServerFile(
    String id,
    String directory,
    String filename,
    List<int> bytes, {
    required CancelToken cancelToken,
    required ProgressCallback onProgress,
  }) => client.uploadBytes(
    '/servers/$id/files/upload',
    {'directory': directory, 'filename': filename},
    bytes,
    cancelToken: cancelToken,
    onProgress: onProgress,
  );

  /// Renews with a product key.
  Future<void> renewServer(String id, String key) => client.write(
    'POST',
    '/servers/$id/renew',
    body: RenewRequest(key: key).toJson(),
  );

  /// Renews from the balance. Takes no body.
  Future<void> renewServerByBalance(String id) =>
      client.write('POST', '/servers/$id/renew-by-balance', body: null);

  /// Asks the panel to reinstall the server with a different egg.
  Future<void> reinstallServer(String id, int eggId) => client.write(
    'POST',
    '/servers/$id/reinstall',
    body: ReinstallRequest(eggId: eggId).toJson(),
  );

  /// Starts the deletion state machine. Takes no body; the grace period and the
  /// confirmation mail are the server's business.
  Future<void> requestServerDelete(String id) =>
      client.write('POST', '/servers/$id/delete', body: null);

  // ---------------------------------------------------------------------------
  // Gallery
  // ---------------------------------------------------------------------------

  /// Every published entry.
  Future<List<GalleryCard>> gallery() async {
    final res = await client.getObject(
      '/gallery',
      GalleryListResponse.fromJson,
    );
    return res.items;
  }

  /// The caller's own entries, including the ones still awaiting review.
  Future<List<GalleryCard>> myGallery() async {
    final res = await client.getObject(
      '/gallery/mine',
      GalleryListResponse.fromJson,
    );
    return res.items;
  }

  /// Submits an entry for review. The server answers `201`.
  ///
  /// The returned card has an empty `userName` and a formatted `createdAt`,
  /// because it is built from the new document alone; it is not the same shape
  /// as a listed card.
  Future<GalleryCard> submitGallery(GallerySubmitRequest body) async {
    final res = await client.writeObject(
      'POST',
      '/gallery',
      GalleryItemResponse.fromJson,
      body: body.toJson(),
    );
    return res.item;
  }

  /// Likes an entry and returns the new total.
  Future<int> likeGallery(String id) async {
    final res = await client.writeObject(
      'POST',
      '/gallery/$id/like',
      LikeResponse.fromJson,
    );
    return res.likes;
  }

  /// Removes one of the caller's own entries.
  Future<void> deleteGallery(String id) =>
      client.write('DELETE', '/gallery/$id');

  // ---------------------------------------------------------------------------
  // Messages
  // ---------------------------------------------------------------------------

  /// The inbox. This payload is wrapped as `{messages}`.
  Future<List<MessageItem>> messages() async {
    final res = await client.getObject(
      '/messages',
      MessageListResponse.fromJson,
    );
    return res.messages;
  }

  /// The unread counter behind the navigation badge.
  Future<int> unreadCount() async {
    final res = await client.getObject(
      '/messages/unread',
      UnreadResponse.fromJson,
    );
    return res.unread;
  }

  /// Marks one message as read.
  Future<void> markMessageRead(String id) =>
      client.write('POST', '/messages/$id/read', body: null);

  /// Marks everything as read.
  Future<void> markAllMessagesRead() =>
      client.write('POST', '/messages/read-all', body: null);

  /// Deletes one message.
  Future<void> deleteMessage(String id) =>
      client.write('DELETE', '/messages/$id');

  // ---------------------------------------------------------------------------
  // Work orders
  // ---------------------------------------------------------------------------

  /// The caller's tickets.
  Future<List<WorkOrderItem>> workOrders() async {
    final res = await client.getObject(
      '/work-orders',
      WorkOrderListResponse.fromJson,
    );
    return res.orders;
  }

  /// Opens a ticket. The server answers `201`.
  Future<WorkOrderItem> createWorkOrder(CreateWorkOrderRequest body) async {
    final res = await client.writeObject(
      'POST',
      '/work-orders',
      WorkOrderResponse.fromJson,
      body: body.toJson(),
    );
    return res.order;
  }

  // ---------------------------------------------------------------------------
  // Recharge
  // ---------------------------------------------------------------------------

  /// The top-up history, both key redemptions and Alipay orders.
  Future<List<RechargeLog>> rechargeLogs() async {
    final res = await client.getObject(
      '/recharge/logs',
      RechargeLogResponse.fromJson,
    );
    return res.logs;
  }

  /// Redeems a balance code.
  Future<void> rechargeByKey(String key) => client.write(
    'POST',
    '/recharge/key',
    body: RechargeByKeyRequest(key: key).toJson(),
  );

  /// Starts a face-to-face Alipay payment. The server answers `201`.
  Future<PreCreateResponse> preCreateRecharge(int amount) => client.writeObject(
    'POST',
    '/recharge/alipay',
    PreCreateResponse.fromJson,
    body: PreCreateRequest(amount: amount).toJson(),
  );

  /// Polls one Alipay order. The answer is one of [RechargeStatus].
  Future<String> rechargeStatus(String outTradeNo) async {
    final res = await client.getObject(
      '/recharge/alipay/$outTradeNo',
      RechargeStatusResponse.fromJson,
    );
    return res.status;
  }

  // ---------------------------------------------------------------------------
  // Administration
  // ---------------------------------------------------------------------------

  /// The back-office landing aggregate.
  Future<Dashboard> adminDashboard() async {
    final res = await client.getObject(
      '/admin/dashboard',
      AdminDashboardResponse.fromJson,
    );
    return res.dashboard;
  }

  /// Every account.
  Future<List<AdminUser>> adminUsers() async {
    final res = await client.getObject(
      '/admin/users',
      AdminUserListResponse.fromJson,
    );
    return res.users;
  }

  /// Every order.
  Future<List<AdminOrder>> adminOrders() async {
    final res = await client.getObject(
      '/admin/orders',
      AdminOrderListResponse.fromJson,
    );
    return res.orders;
  }

  /// Every product, in the table shape.
  Future<List<AdminProduct>> adminProducts() async {
    final res = await client.getObject(
      '/admin/products',
      AdminProductListResponse.fromJson,
    );
    return res.products;
  }

  Future<List<PanelTag>> adminPanelTags() async => (await client.getObject(
    '/admin/panel/tags',
    PanelTagListResponse.fromJson,
  )).items;

  Future<List<Egg>> adminTagEggs(String tagSlug) async =>
      (await client.getObject(
        '/admin/panel/tags/$tagSlug/eggs',
        EggListResponse.fromJson,
      )).eggs;

  /// Every product as a raw document, for the editor's initial values.
  Future<List<WareSpec>> adminRawProducts() async {
    final res = await client.getObject(
      '/admin/products/raw',
      ProductListResponse.fromJson,
    );
    return res.products;
  }

  /// The 17 field definitions the product editor renders.
  Future<List<FormField>> adminProductForm() async {
    final res = await client.getObject(
      '/admin/products/form',
      AdminProductFormResponse.fromJson,
    );
    return res.fields;
  }

  /// Creates a product; one submission yields one document per enabled cycle,
  /// hence a list of ids. The server answers `201`.
  Future<List<String>> adminCreateProduct(ProductInput body) async {
    final res = await client.writeObject(
      'POST',
      '/admin/products',
      CreateProductResponse.fromJson,
      body: UpdateProductRequest(product: body).toJson(),
    );
    return res.specIds;
  }

  /// Updates one product.
  Future<void> adminUpdateProduct(String specId, ProductInput body) =>
      client.write(
        'PUT',
        '/admin/products/$specId',
        body: UpdateProductRequest(product: body).toJson(),
      );

  /// Removes one product.
  Future<void> adminDeleteProduct(String specId) =>
      client.write('DELETE', '/admin/products/$specId');

  /// Everything a key can be generated for.
  Future<List<KeyTarget>> adminKeyTargets() async {
    final res = await client.getObject(
      '/admin/key-targets',
      KeyTargetListResponse.fromJson,
    );
    return res.targets;
  }

  /// Mints keys.
  ///
  /// The answer carries no keys on purpose: the legacy flow showed them in a
  /// page and the new one hands over the archive instead. Call [adminExportKeys]
  /// afterwards.
  Future<void> adminGenerateKeys(GenerateKeysRequest body) =>
      client.write('POST', '/admin/keys', body: body.toJson());

  /// Downloads the freshly minted activation codes as a zip.
  Future<List<int>> adminExportKeys() =>
      client.downloadZip('/admin/keys/export');

  /// Servers waiting for a deletion decision.
  Future<List<DeleteConfirmItem>> adminDeleteConfirms() async {
    final res = await client.getObject(
      '/admin/delete-confirms',
      AdminDeleteConfirmListResponse.fromJson,
    );
    return res.confirms;
  }

  /// Approves or cancels one pending deletion.
  Future<void> adminResolveDeleteConfirm(String entityId, bool approve) =>
      client.write(
        'POST',
        '/admin/delete-confirms/$entityId',
        body: DeleteConfirmRequest(approve: approve).toJson(),
      );

  /// Every ticket, closed ones included, so staff can audit.
  Future<List<WorkOrderItem>> adminWorkOrders() async {
    final res = await client.getObject(
      '/admin/work-orders',
      AdminWorkOrderListResponse.fromJson,
    );
    return res.orders;
  }

  /// Closes a ticket with an optional public reply.
  Future<void> adminCloseWorkOrder(String id, String closeInfo) => client.write(
    'POST',
    '/admin/work-orders/$id/close',
    body: CloseWorkOrderRequest(closeInfo: closeInfo).toJson(),
  );

  /// Publishes or removes a gallery submission.
  ///
  /// Both outcomes share one route; [action] is `pass` for anything else to
  /// mean deletion, mirroring the legacy `if pass ... else delete`.
  Future<void> adminReviewGallery(String id, {required bool approve}) =>
      client.write('POST', '/admin/gallery/$id/${approve ? 'pass' : 'delete'}');

  /// The 29 entry settings schema with current values.
  Future<List<SettingField>> adminSettings() async {
    final res = await client.getObject(
      '/admin/settings',
      AdminSettingsResponse.fromJson,
    );
    return res.fields;
  }

  /// Writes the submitted settings back to the TOML file. Every value travels as
  /// a string regardless of the field type; the server parses it.
  Future<void> adminSaveSettings(Map<String, String> values) => client.write(
    'PUT',
    '/admin/settings',
    body: SaveSettingsRequest(values: values).toJson(),
  );

  /// The admin diagnostics panel, which reports the reason a component is down.
  Future<Health> adminHealth() async {
    final res = await client.getObject(
      '/admin/health',
      HealthResponse.fromJson,
    );
    return res.health;
  }

  /// The liveness probe. Unlike [adminHealth] this one is not enveloped and
  /// answers `503` when a component is down, so the status code is ignored and
  /// the component booleans are read instead.
  Future<HealthzResponse> healthz() async {
    final raw = await client.health();
    return HealthzResponse.fromJson(raw);
  }
}
