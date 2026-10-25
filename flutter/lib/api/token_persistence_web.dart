import 'dart:convert';

import 'package:web/web.dart' as web;

/// Reads the token directly from browser localStorage so it survives a full
/// page reload in both JavaScript and WebAssembly builds.
Future<String?> read(String key) async {
  final storage = web.window.localStorage;
  final token = storage.getItem(key);
  if (token != null) return token;

  // SharedPreferences JSON-encodes strings under a `flutter.` key. Migrate
  // existing sessions to the direct key without logging the user out.
  final legacy = storage.getItem('flutter.$key');
  if (legacy == null) return null;
  try {
    final decoded = jsonDecode(legacy);
    if (decoded is! String) return null;
    storage
      ..setItem(key, decoded)
      ..removeItem('flutter.$key');
    return decoded;
  } on FormatException {
    return null;
  }
}

/// Writes the token synchronously to browser storage before login completes.
Future<void> write(String key, String token) async {
  final storage = web.window.localStorage;
  storage.setItem(key, token);
  storage.removeItem('flutter.$key');
}

/// Removes both the current and legacy token keys.
Future<void> remove(String key) async {
  final storage = web.window.localStorage;
  storage.removeItem(key);
  storage.removeItem('flutter.$key');
}
