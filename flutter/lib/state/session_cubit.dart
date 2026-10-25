/// The signed-in session.
///
/// One cubit owns "who is asking". It is the authority the router guards read,
/// and it is the sole place the access token is written and cleared, so every
/// other cubit can assume that a call it makes is either authenticated or will
/// be rejected with a `401` that lands back here.
library;

import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../api/api_exception.dart';
import '../api/peo_api.dart';
import '../api/token_store.dart';
import '../models/auth.dart';
import '../models/documents.dart';
import 'async_value.dart';

/// How far the session has been resolved.
enum SessionStatus {
  /// The stored token has not been examined yet, so the guards must wait rather
  /// than bounce an authenticated deep link to the login page.
  unknown,

  /// No usable token.
  signedOut,

  /// The token verified and the account document still exists.
  signedIn,
}

/// Who is signed in.
@immutable
class SessionState {
  const SessionState({
    this.status = SessionStatus.unknown,
    this.user,
    this.error,
  });

  const SessionState.signedOut() : this(status: SessionStatus.signedOut);

  final SessionStatus status;

  /// The account document, refreshed by [SessionCubit.refresh].
  final User? user;

  /// Set when session restoration or a sign-in action reports an error.
  final ApiException? error;

  bool get isUnknown => status == SessionStatus.unknown;
  bool get isSignedIn => status == SessionStatus.signedIn;
  bool get isAdmin => user?.isAdmin ?? false;
  String get userName => user?.name ?? '';
  int get balance => user?.balance ?? 0;

  SessionState copyWith({
    SessionStatus? status,
    User? user,
    ApiException? error,
    bool clearUser = false,
    bool clearError = false,
  }) => SessionState(
    status: status ?? this.status,
    user: clearUser ? null : (user ?? this.user),
    error: clearError ? null : (error ?? this.error),
  );
}

/// Owns the access token and the account it points at.
class SessionCubit extends Cubit<SessionState> {
  SessionCubit({required this.api, required this.tokenStore})
    : super(const SessionState()) {
    // Installed here rather than in the app so the client always has exactly one
    // listener: a rejected token drops the session, and the router guard does
    // the navigating.
    api.client.onUnauthorized = handleUnauthorized;
  }

  final PeoApi api;
  final TokenStore tokenStore;

  String? _selectedServerId;

  /// The last server opened during this in-memory signed-in session.
  String? get selectedServerId => _selectedServerId;

  void rememberServer(String serverId) {
    if (serverId.isNotEmpty && state.isSignedIn) _selectedServerId = serverId;
  }

  void _clearSelectedServer() => _selectedServerId = null;

  /// Resolves the stored token, if any, before the first route is decided.
  ///
  /// A token that verifies but points at a deleted account is rejected here as
  /// well, because [PeoApi.me] fails with `401` in that case — the legacy
  /// `session.Logged()` semantics, kept intact.
  Future<void> bootstrap() async {
    final token = await tokenStore.read();
    if (token == null || token.isEmpty) {
      _clearSelectedServer();
      emit(const SessionState.signedOut());
      return;
    }
    try {
      final user = await api.me();
      emit(SessionState(status: SessionStatus.signedIn, user: user));
    } on ApiException catch (e) {
      if (e.isUnauthorized) {
        await tokenStore.clear();
        _clearSelectedServer();
        emit(SessionState(status: SessionStatus.signedOut, error: e));
      } else {
        // A server or network failure does not prove the token is invalid.
        // Keep it for the next authenticated request and let the router remain
        // in its resolving state instead of forcing the user to sign in again.
        emit(SessionState(error: e));
      }
    }
  }

  /// Called by [ApiClient] after it has cleared a token the server rejected.
  Future<void> handleUnauthorized() async {
    if (isClosed) return;
    _clearSelectedServer();
    emit(const SessionState.signedOut());
  }

  /// Signs in and stores the issued token.
  Future<ActionState> signIn(LoginRequest request) async {
    _clearSelectedServer();
    emit(state.copyWith(status: SessionStatus.unknown, clearError: true));
    try {
      final session = await api.login(request);
      await tokenStore.write(session.accessToken);
      emit(SessionState(status: SessionStatus.signedIn, user: session.user));
      return const ActionState.done(null);
    } on ApiException catch (e) {
      emit(SessionState(status: SessionStatus.signedOut, error: e));
      return ActionState.failed(e);
    }
  }

  /// Registers and stores the issued token.
  ///
  /// The account starts unconfirmed; the caller decides whether to show the
  /// "check your mail" screen, based on [SessionCubit.state]'s user.
  Future<ActionState> register(RegisterRequest request) async {
    _clearSelectedServer();
    emit(state.copyWith(status: SessionStatus.unknown, clearError: true));
    try {
      final session = await api.register(request);
      await tokenStore.write(session.accessToken);
      emit(SessionState(status: SessionStatus.signedIn, user: session.user));
      return const ActionState.done(null);
    } on ApiException catch (e) {
      emit(SessionState(status: SessionStatus.signedOut, error: e));
      return ActionState.failed(e);
    }
  }

  /// Re-reads the account, for example after a balance top-up or a password
  /// change, so the navigation bar's balance and the admin flag stay true.
  Future<void> refresh() async {
    if (!state.isSignedIn) return;
    try {
      final user = await api.me();
      if (isClosed) return;
      emit(state.copyWith(user: user, clearError: true));
    } on ApiException catch (e) {
      if (isClosed) return;
      if (e.isUnauthorized) {
        _clearSelectedServer();
        emit(const SessionState.signedOut());
      } else {
        emit(state.copyWith(error: e));
      }
    }
  }

  /// Blacklists the token, then forgets it locally.
  ///
  /// The blacklist call is best effort: if the server cannot be reached the
  /// local token is still dropped, because leaving the user signed in on a
  /// machine they asked to leave is the worse failure.
  Future<void> signOut() async {
    try {
      await api.logout();
    } on ApiException {
      // Nothing to do: the local token is cleared below either way.
    }
    await tokenStore.clear();
    if (isClosed) return;
    _clearSelectedServer();
    emit(const SessionState.signedOut());
  }

  /// Forgets a failed attempt so the form stops showing its error.
  void dismissError() {
    if (state.error == null) return;
    emit(state.copyWith(clearError: true));
  }
}
