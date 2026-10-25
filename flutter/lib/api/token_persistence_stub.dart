import 'package:shared_preferences/shared_preferences.dart';

/// Non-web fallback for tests and other Flutter targets.
Future<String?> read(String key) async {
  final preferences = await SharedPreferences.getInstance();
  return preferences.getString(key);
}

Future<void> write(String key, String token) async {
  final preferences = await SharedPreferences.getInstance();
  await preferences.setString(key, token);
}

Future<void> remove(String key) async {
  final preferences = await SharedPreferences.getInstance();
  await preferences.remove(key);
}
