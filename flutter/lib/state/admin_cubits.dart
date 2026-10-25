/// The back office.
///
/// One cubit per table, plus the dashboard aggregate, the generic settings form
/// and the diagnostics panel.
library;

import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../api/api_exception.dart';
import '../api/peo_api.dart';
import '../models/admin.dart';
import '../models/content.dart';
import '../models/documents.dart';
import '../models/site.dart';
import 'async_value.dart';

/// The administration landing page.
///
/// The aggregate carries the open tickets, the pending server deletions and the
/// gallery submissions awaiting review, so this single read feeds the dashboard,
/// the review queue and the deletion queue. Reading it also prunes deletion rows
/// whose server has since gone, which is why the page re-reads it after every
/// decision rather than editing the list in place.
class DashboardCubit extends Cubit<ValueState<Dashboard>> {
  DashboardCubit(this.api) : super(ValueState<Dashboard>());

  final PeoApi api;

  /// Every album entry, approved or not; the review queue filters on
  /// [GalleryCard.reviewPassed].
  List<GalleryCard> get galleryItems =>
      state.value.value?.galleryItems ?? const [];

  /// The submissions still waiting for a decision.
  List<GalleryCard> get pendingGallery =>
      galleryItems.where((g) => !g.reviewPassed).toList(growable: false);

  List<WorkOrderItem> get openWorkOrders =>
      state.value.value?.workOrders ?? const [];

  List<DeleteConfirmItem> get deleteConfirms =>
      state.value.value?.deleteConfirms ?? const [];

  Future<void> load() async {
    emit(
      state.copyWith(
        value: state.value.hasValue
            ? state.value.refreshing()
            : const AsyncValue<Dashboard>.loading(),
      ),
    );
    try {
      final dashboard = await api.adminDashboard();
      if (isClosed) return;
      emit(state.copyWith(value: AsyncValue<Dashboard>.ready(dashboard)));
    } on ApiException catch (e) {
      if (isClosed) return;
      emit(state.copyWith(value: AsyncValue<Dashboard>.failure(e)));
    }
  }

  /// Publishes or removes one album submission, then re-reads the aggregate so
  /// the review queue reflects the decision.
  Future<ActionState> reviewGallery(String id, {required bool approve}) =>
      _decide(
        () => api.adminReviewGallery(id, approve: approve),
        approve ? 'album item published' : 'album item deleted',
      );

  /// Approves or cancels one pending server deletion.
  Future<ActionState> resolveDeleteConfirm(String entityId, bool approve) =>
      _decide(
        () => api.adminResolveDeleteConfirm(entityId, approve),
        approve ? 'server deleted' : 'deletion cancelled',
      );

  /// Closes a ticket with an optional public reply.
  Future<ActionState> closeWorkOrder(String id, String closeInfo) => _decide(
    () => api.adminCloseWorkOrder(id, closeInfo),
    'work order closed',
  );

  Future<ActionState> _decide(
    Future<void> Function() call,
    String message,
  ) async {
    emit(state.copyWith(action: const ActionState.pending()));
    final result = await perform(() async {
      await call();
      return message;
    });
    if (isClosed) return result;
    emit(state.copyWith(action: result));
    if (result.succeeded) await load();
    return result;
  }
}

/// Every account.
class AdminUsersCubit extends Cubit<ListState<AdminUser>> {
  AdminUsersCubit(this.api) : super(ListState<AdminUser>());

  final PeoApi api;

  Future<void> load() async {
    emit(
      state.copyWith(
        items: state.items.hasValue
            ? state.items.refreshing()
            : const AsyncValue<List<AdminUser>>.loading(),
      ),
    );
    try {
      final users = await api.adminUsers();
      if (isClosed) return;
      emit(state.copyWith(items: AsyncValue<List<AdminUser>>.ready(users)));
    } on ApiException catch (e) {
      if (isClosed) return;
      emit(state.copyWith(items: AsyncValue<List<AdminUser>>.failure(e)));
    }
  }
}

/// Every order.
class AdminOrdersCubit extends Cubit<ListState<AdminOrder>> {
  AdminOrdersCubit(this.api) : super(ListState<AdminOrder>());

  final PeoApi api;

  Future<void> load() async {
    emit(
      state.copyWith(
        items: state.items.hasValue
            ? state.items.refreshing()
            : const AsyncValue<List<AdminOrder>>.loading(),
      ),
    );
    try {
      final orders = await api.adminOrders();
      if (isClosed) return;
      emit(state.copyWith(items: AsyncValue<List<AdminOrder>>.ready(orders)));
    } on ApiException catch (e) {
      if (isClosed) return;
      emit(state.copyWith(items: AsyncValue<List<AdminOrder>>.failure(e)));
    }
  }
}

/// Every work order, including closed tickets.
class AdminWorkOrdersCubit extends Cubit<ListState<WorkOrderItem>> {
  AdminWorkOrdersCubit(this.api) : super(ListState<WorkOrderItem>());

  final PeoApi api;

  Future<void> load() async {
    emit(
      state.copyWith(
        items: state.items.hasValue
            ? state.items.refreshing()
            : const AsyncValue<List<WorkOrderItem>>.loading(),
      ),
    );
    try {
      final orders = await api.adminWorkOrders();
      if (isClosed) return;
      emit(
        state.copyWith(items: AsyncValue<List<WorkOrderItem>>.ready(orders)),
      );
    } on ApiException catch (e) {
      if (isClosed) return;
      emit(state.copyWith(items: AsyncValue<List<WorkOrderItem>>.failure(e)));
    }
  }

  Future<ActionState> closeTicket(String id, String reply) async {
    emit(state.copyWith(action: const ActionState.pending()));
    final result = await perform(() async {
      await api.adminCloseWorkOrder(id, reply);
      return 'work order closed';
    });
    if (isClosed) return result;
    emit(state.copyWith(action: result));
    if (result.succeeded) await load();
    return result;
  }
}

/// The product table, the raw documents the editor seeds itself from, and the
/// field schema it renders.
@immutable
class AdminProductsState {
  const AdminProductsState({
    this.products = const AsyncValue<List<AdminProduct>>.idle(),
    this.raw = const AsyncValue<List<WareSpec>>.idle(),
    this.fields = const AsyncValue<List<FormField>>.idle(),
    this.tags = const AsyncValue<List<PanelTag>>.idle(),
    this.tagEggs = const AsyncValue<List<Egg>>.idle(),
    this.action = const ActionState.idle(),
  });

  final AsyncValue<List<AdminProduct>> products;

  /// The documents behind the table rows, keyed by spec id when editing.
  final AsyncValue<List<WareSpec>> raw;

  /// The 17 inputs of the generated editor form.
  final AsyncValue<List<FormField>> fields;
  final AsyncValue<List<PanelTag>> tags;
  final AsyncValue<List<Egg>> tagEggs;

  final ActionState action;

  AdminProductsState copyWith({
    AsyncValue<List<AdminProduct>>? products,
    AsyncValue<List<WareSpec>>? raw,
    AsyncValue<List<FormField>>? fields,
    AsyncValue<List<PanelTag>>? tags,
    AsyncValue<List<Egg>>? tagEggs,
    ActionState? action,
  }) => AdminProductsState(
    products: products ?? this.products,
    raw: raw ?? this.raw,
    fields: fields ?? this.fields,
    tags: tags ?? this.tags,
    tagEggs: tagEggs ?? this.tagEggs,
    action: action ?? this.action,
  );
}

/// Owns the product catalogue's back-office view.
class AdminProductsCubit extends Cubit<AdminProductsState> {
  AdminProductsCubit(this.api) : super(const AdminProductsState());

  final PeoApi api;

  /// Reads the table.
  Future<void> load() async {
    emit(
      state.copyWith(
        products: state.products.hasValue
            ? state.products.refreshing()
            : const AsyncValue<List<AdminProduct>>.loading(),
      ),
    );
    try {
      final products = await api.adminProducts();
      if (isClosed) return;
      emit(
        state.copyWith(
          products: AsyncValue<List<AdminProduct>>.ready(products),
        ),
      );
    } on ApiException catch (e) {
      if (isClosed) return;
      emit(state.copyWith(products: AsyncValue<List<AdminProduct>>.failure(e)));
    }
  }

  /// Reads the field schema and the raw documents the editor needs.
  ///
  /// The documents are needed even when creating, because the editor opens with
  /// the schema's defaults; they are also what a row is edited from.
  Future<void> loadEditor() async {
    emit(
      state.copyWith(
        fields: const AsyncValue<List<FormField>>.loading(),
        raw: const AsyncValue<List<WareSpec>>.loading(),
        tags: const AsyncValue<List<PanelTag>>.loading(),
      ),
    );
    try {
      final fields = await api.adminProductForm();
      if (isClosed) return;
      emit(state.copyWith(fields: AsyncValue<List<FormField>>.ready(fields)));
    } on ApiException catch (e) {
      if (isClosed) return;
      emit(state.copyWith(fields: AsyncValue<List<FormField>>.failure(e)));
    }
    try {
      final raw = await api.adminRawProducts();
      if (isClosed) return;
      emit(state.copyWith(raw: AsyncValue<List<WareSpec>>.ready(raw)));
    } on ApiException catch (e) {
      if (isClosed) return;
      emit(state.copyWith(raw: AsyncValue<List<WareSpec>>.failure(e)));
    }
    try {
      final tags = await api.adminPanelTags();
      if (isClosed) return;
      emit(state.copyWith(tags: AsyncValue<List<PanelTag>>.ready(tags)));
    } on ApiException catch (e) {
      if (isClosed) return;
      emit(state.copyWith(tags: AsyncValue<List<PanelTag>>.failure(e)));
    }
  }

  Future<void> loadTagEggs(String tagSlug) async {
    if (tagSlug.isEmpty) {
      emit(state.copyWith(tagEggs: const AsyncValue<List<Egg>>.ready([])));
      return;
    }
    emit(state.copyWith(tagEggs: const AsyncValue<List<Egg>>.loading()));
    try {
      final eggs = await api.adminTagEggs(tagSlug);
      if (!isClosed) {
        emit(state.copyWith(tagEggs: AsyncValue<List<Egg>>.ready(eggs)));
      }
    } on ApiException catch (e) {
      if (!isClosed) {
        emit(state.copyWith(tagEggs: AsyncValue<List<Egg>>.failure(e)));
      }
    }
  }

  /// The document behind one table row, or null when it is not loaded.
  WareSpec? specOf(String specId) =>
      state.raw.value?.where((s) => s.id == specId).firstOrNull;

  /// Creates a product.
  ///
  /// One submission yields one document per enabled billing cycle, so the
  /// server answers with a list of ids. They are reported back so the caller can
  /// say how many were created.
  Future<ActionState> create(ProductInput body) async {
    emit(state.copyWith(action: const ActionState.pending()));
    final result = await perform(() async {
      final ids = await api.adminCreateProduct(body);
      if (ids.isEmpty) return 'product saved';
      return ids.length == 1
          ? '1 product created'
          : '${ids.length} products created';
    });
    if (isClosed) return result;
    emit(state.copyWith(action: result));
    if (result.succeeded) await load();
    return result;
  }

  /// Updates one product.
  Future<ActionState> update(String specId, ProductInput body) =>
      _mutate(() => api.adminUpdateProduct(specId, body), 'product saved');

  /// Removes one product.
  Future<ActionState> delete(String specId) =>
      _mutate(() => api.adminDeleteProduct(specId), 'product deleted');

  Future<ActionState> _mutate(
    Future<void> Function() call,
    String message,
  ) async {
    emit(state.copyWith(action: const ActionState.pending()));
    final result = await perform(() async {
      await call();
      return message;
    });
    if (isClosed) return result;
    emit(state.copyWith(action: result));
    if (result.succeeded) await load();
    return result;
  }
}

/// The key generator.
///
/// Two steps on purpose: the server mints the keys and reports success without
/// returning them, then the archive is fetched. The bytes are handed to the
/// caller so the page can save them to disk, which is what replaces the legacy
/// results page.
@immutable
class AdminKeysState {
  const AdminKeysState({
    this.targets = const AsyncValue<List<KeyTarget>>.idle(),
    this.action = const ActionState.idle(),
  });

  final AsyncValue<List<KeyTarget>> targets;
  final ActionState action;

  AdminKeysState copyWith({
    AsyncValue<List<KeyTarget>>? targets,
    ActionState? action,
  }) => AdminKeysState(
    targets: targets ?? this.targets,
    action: action ?? this.action,
  );
}

/// Owns the key generator page.
class AdminKeysCubit extends Cubit<AdminKeysState> {
  AdminKeysCubit(this.api) : super(const AdminKeysState());

  final PeoApi api;

  Future<void> load() async {
    emit(
      state.copyWith(
        targets: state.targets.hasValue
            ? state.targets.refreshing()
            : const AsyncValue<List<KeyTarget>>.loading(),
      ),
    );
    try {
      final targets = await api.adminKeyTargets();
      if (isClosed) return;
      emit(state.copyWith(targets: AsyncValue<List<KeyTarget>>.ready(targets)));
    } on ApiException catch (e) {
      if (isClosed) return;
      emit(state.copyWith(targets: AsyncValue<List<KeyTarget>>.failure(e)));
    }
  }

  /// Mints keys and hands back the archive bytes.
  ///
  /// Returns `null` when minting failed, so the caller downloads nothing rather
  /// than an archive of the previous run.
  Future<List<int>?> generate(GenerateKeysRequest request) async {
    emit(state.copyWith(action: const ActionState.pending()));
    try {
      await api.adminGenerateKeys(request);
      final bytes = await api.adminExportKeys();
      if (isClosed) return null;
      emit(
        state.copyWith(
          action: const ActionState.done('activation codes created'),
        ),
      );
      return bytes;
    } on ApiException catch (e) {
      if (isClosed) return null;
      emit(state.copyWith(action: ActionState.failed(e)));
      return null;
    }
  }
}

/// The generic settings form.
@immutable
class AdminSettingsState {
  const AdminSettingsState({
    this.fields = const AsyncValue<List<SettingField>>.idle(),
    this.action = const ActionState.idle(),

    /// Edits the administrator has made but not saved, keyed by setting key.
    this.edits = const <String, String>{},
  });

  final AsyncValue<List<SettingField>> fields;
  final ActionState action;

  /// Pending edits. Kept beside the schema so the form shows the saved value
  /// until the administrator touches that input.
  final Map<String, String> edits;

  /// The value to display for one field.
  String valueOf(SettingField field) => edits[field.key] ?? field.value;

  bool get isDirty => edits.isNotEmpty;

  AdminSettingsState copyWith({
    AsyncValue<List<SettingField>>? fields,
    ActionState? action,
    Map<String, String>? edits,
  }) => AdminSettingsState(
    fields: fields ?? this.fields,
    action: action ?? this.action,
    edits: edits ?? this.edits,
  );
}

/// Owns the settings page.
class AdminSettingsCubit extends Cubit<AdminSettingsState> {
  AdminSettingsCubit(this.api) : super(const AdminSettingsState());

  final PeoApi api;

  Future<void> load() async {
    emit(
      state.copyWith(
        fields: state.fields.hasValue
            ? state.fields.refreshing()
            : const AsyncValue<List<SettingField>>.loading(),
      ),
    );
    try {
      final fields = await api.adminSettings();
      if (isClosed) return;
      emit(
        state.copyWith(
          fields: AsyncValue<List<SettingField>>.ready(fields),
          edits: const {},
        ),
      );
    } on ApiException catch (e) {
      if (isClosed) return;
      emit(state.copyWith(fields: AsyncValue<List<SettingField>>.failure(e)));
    }
  }

  /// Records one input's new value.
  void edit(String key, String value) {
    emit(state.copyWith(edits: {...state.edits, key: value}));
  }

  /// Saves the pending edits.
  ///
  /// Only the changed keys are sent: the server treats the body as a patch, so
  /// sending the whole form would risk writing a stale value back over a change
  /// made from another tab.
  Future<ActionState> save() async {
    if (state.edits.isEmpty) {
      return const ActionState.done('nothing to save');
    }
    final payload = Map<String, String>.from(state.edits);
    emit(state.copyWith(action: const ActionState.pending()));
    final result = await perform(() async {
      await api.adminSaveSettings(payload);
      return 'settings saved';
    });
    if (isClosed) return result;
    emit(state.copyWith(action: result));
    if (result.succeeded) await load();
    return result;
  }

  /// Throws away the pending edits.
  void discard() => emit(state.copyWith(edits: const {}));
}

/// The diagnostics panel.
class AdminHealthCubit extends Cubit<AsyncValue<Health>> {
  AdminHealthCubit(this.api) : super(const AsyncValue<Health>.idle());

  final PeoApi api;

  Future<void> load() async {
    emit(
      state.hasValue ? state.refreshing() : const AsyncValue<Health>.loading(),
    );
    try {
      final health = await api.adminHealth();
      if (isClosed) return;
      emit(AsyncValue<Health>.ready(health));
    } on ApiException catch (e) {
      if (isClosed) return;
      emit(AsyncValue<Health>.failure(e));
    }
  }
}
