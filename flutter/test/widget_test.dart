import 'package:flutter_test/flutter_test.dart';
import 'package:peo_web/api/api_client.dart';
import 'package:peo_web/api/peo_api.dart';
import 'package:peo_web/api/token_store.dart';
import 'package:peo_web/main.dart';
import 'package:peo_web/models/site.dart';

class _TestApi extends PeoApi {
  _TestApi(super.client);

  @override
  Future<SiteConfig> siteConfig() async =>
      const SiteConfig(applicationName: 'Test');

  @override
  Future<Storefront> storefront() async => const Storefront();
}

class _TestTokenStore extends TokenStore {
  @override
  Future<String?> read() async => null;
}

void main() {
  testWidgets('bootstraps the Peo application', (tester) async {
    final tokens = _TestTokenStore();
    final api = _TestApi(
      ApiClient(tokenStore: tokens, baseUrl: 'https://example.test/api/v1'),
    );
    await tester.pumpWidget(PeoApp(api: api, tokenStore: tokens));
    await tester.pumpAndSettle();
    expect(find.byType(PeoApp), findsOneWidget);
    expect(find.text('Test'), findsOneWidget);
    expect(find.text('Products'), findsOneWidget);
  });
}
