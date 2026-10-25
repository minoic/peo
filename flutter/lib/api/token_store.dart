/// Persistent storage for the session token.
///
/// Browser builds use `localStorage` directly so tokens survive full page
/// reloads in both JavaScript and WebAssembly builds. Other targets use
/// `shared_preferences`.
library;

import 'token_persistence_stub.dart'
    if (dart.library.js_interop) 'token_persistence_web.dart'
    as persistence;

/// A [TokenStore] keeps the bearer token across page reloads.
///
/// The token is read on every request by the Dio interceptor, so it is cached
/// in memory after the first load and only written through on change.
class TokenStore {
  TokenStore({this.storageKey = 'peo.accessToken'});

  /// The `localStorage` key. Namespaced because Web shares one origin with any
  /// other application served from the same host.
  final String storageKey;

  String? _cached;
  bool _loaded = false;
  int _revision = 0;

  /// Returns the stored token, loading it from disk on first use.
  Future<String?> read() async {
    if (_loaded) return _cached;
    final revision = _revision;
    final token = await persistence.read(storageKey);
    // A login or logout may have changed storage while this read was pending.
    if (revision != _revision) return _cached;
    _cached = token;
    _loaded = true;
    return _cached;
  }

  /// The last known token without touching storage. Returns `null` before the
  /// first [read] or [write], which is why it is only used on the request path
  /// after the interceptor has awaited [read].
  String? get current => _cached;

  /// Persists a freshly issued token.
  Future<void> write(String token) async {
    _revision++;
    _cached = token;
    _loaded = true;
    await persistence.write(storageKey, token);
  }

  /// Forgets the token. Called on logout and whenever the server answers `401`,
  /// so a blacklisted token is never retried.
  Future<void> clear() async {
    _revision++;
    _cached = null;
    _loaded = true;
    await persistence.remove(storageKey);
  }
}
