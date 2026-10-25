/// The public album.
library;

import 'package:flutter_bloc/flutter_bloc.dart';

import '../api/api_exception.dart';
import '../api/peo_api.dart';
import '../models/content.dart';
import 'async_value.dart';

/// Owns the album, both the public feed and the customer's own submissions.
class GalleryCubit extends Cubit<ListState<GalleryCard>> {
  GalleryCubit(this.api) : super(ListState<GalleryCard>());

  final PeoApi api;

  /// True when the page is showing the signed-in customer's own items.
  bool mine = false;

  /// Reads the album.
  ///
  /// [mine] switches between the public feed and `/gallery/mine`; leaving it
  /// null reloads whichever is currently shown.
  Future<void> load({bool? mine}) async {
    if (mine != null) this.mine = mine;
    final showingMine = this.mine;
    emit(
      state.copyWith(
        items: state.items.hasValue
            ? state.items.refreshing()
            : const AsyncValue<List<GalleryCard>>.loading(),
      ),
    );
    try {
      final items = showingMine ? await api.myGallery() : await api.gallery();
      if (isClosed) return;
      emit(state.copyWith(items: AsyncValue<List<GalleryCard>>.ready(items)));
    } on ApiException catch (e) {
      if (isClosed) return;
      emit(state.copyWith(items: AsyncValue<List<GalleryCard>>.failure(e)));
    }
  }

  /// Submits an item for review.
  ///
  /// A submitted item is not published until an administrator approves it, so
  /// the message says so rather than implying it is live.
  Future<ActionState> submit(GallerySubmitRequest body) async {
    emit(state.copyWith(action: const ActionState.pending()));
    final result = await perform(() async {
      await api.submitGallery(body);
      return 'submitted, an administrator will review it';
    });
    if (isClosed) return result;
    emit(state.copyWith(action: result));
    if (result.succeeded) await load();
    return result;
  }

  /// Adds one like and adopts the count the server returns.
  ///
  /// The endpoint is not idempotent, so the list is re-read instead of the count
  /// being incremented locally.
  Future<void> like(String id) async {
    try {
      await api.likeGallery(id);
      if (isClosed) return;
      await load();
    } on ApiException catch (e) {
      if (isClosed) return;
      emit(state.copyWith(action: ActionState.failed(e)));
    }
  }

  /// Deletes one of the signed-in customer's own items.
  Future<ActionState> delete(String id) async {
    emit(state.copyWith(action: const ActionState.pending()));
    final result = await perform(() async {
      await api.deleteGallery(id);
      return 'album item deleted';
    });
    if (isClosed) return result;
    emit(state.copyWith(action: result));
    if (result.succeeded) await load();
    return result;
  }
}
