/// The public site configuration.
///
/// `GET /site/config` is the app-wide bootstrap call: site identity, the feature
/// switches the shell branches on, and — for a signed-in visitor — the admin
/// flag and the unread badge. The shell therefore fetches it once and listens,
/// instead of every page asking for the bits it needs.
library;

import 'package:flutter_bloc/flutter_bloc.dart';

import '../api/api_exception.dart';
import '../api/peo_api.dart';
import '../models/site.dart';
import 'async_value.dart';

/// Holds the site configuration, plus the unread badge the shell shows.
class SiteCubit extends Cubit<AsyncValue<SiteConfig>> {
  SiteCubit(this.api) : super(const AsyncValue<SiteConfig>.idle());

  final PeoApi api;

  /// The configuration in force.
  ///
  /// Falls back to [SiteConfig.empty] so the shell can draw an empty frame while
  /// the first fetch is in flight rather than showing a spinner over nothing.
  SiteConfig get config => state.value ?? SiteConfig.empty;

  /// Fetches the configuration, keeping the previous one visible while it is
  /// refreshed so a reload does not blank the navigation bar.
  Future<void> load() async {
    emit(
      state.hasValue
          ? state.refreshing()
          : const AsyncValue<SiteConfig>.loading(),
    );
    try {
      final config = await api.siteConfig();
      if (isClosed) return;
      emit(AsyncValue<SiteConfig>.ready(config));
    } on ApiException catch (e) {
      if (isClosed) return;
      emit(AsyncValue<SiteConfig>.failure(e));
    }
  }

  /// Publishes a new unread count locally, so marking a message as read updates
  /// the badge without a second round trip.
  void setUnread(int unread) {
    final current = state.value;
    if (current == null || current.unread == unread) return;
    emit(AsyncValue<SiteConfig>.ready(current.copyWith(unread: unread)));
  }

  /// Publishes the signed-in flags after a login or a logout, so the shell can
  /// switch its navigation without refetching the whole configuration.
  void setSession({required bool loggedIn, required bool isAdmin}) {
    final current = state.value;
    if (current == null) return;
    emit(
      AsyncValue<SiteConfig>.ready(
        current.copyWith(loggedIn: loggedIn, isAdmin: isAdmin),
      ),
    );
  }
}
