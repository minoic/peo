import 'package:flutter_test/flutter_test.dart';
import 'package:peo_web/api/token_store.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test(
    'a new TokenStore reads the token written by the previous app run',
    () async {
      SharedPreferences.setMockInitialValues(<String, Object>{});

      await TokenStore().write('persisted-jwt');
      await (await SharedPreferences.getInstance()).reload();
      final reloadedStore = TokenStore();

      expect(await reloadedStore.read(), 'persisted-jwt');
    },
  );

  test('clearing a token removes it for the next app run', () async {
    SharedPreferences.setMockInitialValues(<String, Object>{});

    await TokenStore().write('persisted-jwt');
    await TokenStore().clear();

    expect(await TokenStore().read(), isNull);
  });
}
