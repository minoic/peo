import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:peo_web/api/api_client.dart';
import 'package:peo_web/api/api_exception.dart';
import 'package:peo_web/api/peo_api.dart';
import 'package:peo_web/api/token_store.dart';
import 'package:peo_web/models/documents.dart';
import 'package:peo_web/models/order.dart';
import 'package:peo_web/models/site.dart';
import 'package:peo_web/pages/user/console_page.dart';
import 'package:peo_web/pages/user/order_pages.dart';
import 'package:peo_web/state/session_cubit.dart';
import 'package:peo_web/theme/peo_theme.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('long server names fit at supported viewport widths', (
    tester,
  ) async {
    final api = _TestApi(
      serversResult: [
        const WareEntity(
          id: 'server-id',
          hostName: 'A very long Minecraft server name that should remain readable without overflowing',
          validDate: '2027-01-02T03:04:05Z',
        ),
      ],
      statusResult: const [
        ServerStatus(
          entityId: 'server-id',
          online: true,
          playerCount: 7,
          playerMax: 20,
          panelName: 'Paper Minecraft',
        ),
      ],
    );
    final app = _Harness(api: api, child: const ConsolePage());
    await tester.pumpWidget(app);
    await tester.pumpAndSettle();

    for (final width in [390, 768, 1024, 1440, 1920]) {
      tester.view.physicalSize = Size(width.toDouble(), 900);
      tester.view.devicePixelRatio = 1;
      await tester.pump();
      expect(tester.takeException(), isNull, reason: 'viewport width $width');
      expect(find.text('7/20'), findsOneWidget);
      expect(find.text('Open console'), findsOneWidget);
    }
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
  });

  testWidgets('empty server result has an explicit empty state', (
    tester,
  ) async {
    await tester.pumpWidget(
      _Harness(api: _TestApi(), child: const ConsolePage()),
    );
    await tester.pumpAndSettle();
    expect(find.text('You do not have any servers yet.'), findsOneWidget);
  });

  testWidgets('server list failure offers retry and recovers', (tester) async {
    final api = _TestApi(failServers: true);
    await tester.pumpWidget(_Harness(api: api, child: const ConsolePage()));
    await tester.pumpAndSettle();
    expect(find.text('Temporary server error'), findsOneWidget);

    api.failServers = false;
    await tester.tap(find.text('Retry'));
    await tester.pumpAndSettle();
    expect(find.text('You do not have any servers yet.'), findsOneWidget);
    expect(api.serverLoads, 2);
  });

  testWidgets('embedded management keeps renewal and danger actions grouped', (
    tester,
  ) async {
    final api = _TestApi();
    await tester.pumpWidget(
      _Harness(
        api: api,
        child: const ServerManagementPage(entityId: 'server-id'),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Renewal'), findsOneWidget);
    expect(find.text('Danger zone'), findsOneWidget);
    expect(find.text('Renew with key'), findsOneWidget);
    expect(find.text('Renew with balance'), findsOneWidget);
    expect(find.text('Reinstall template'), findsOneWidget);
    expect(find.text('Request deletion'), findsOneWidget);
    expect(find.text('Manage server'), findsNothing);

    await tester.enterText(find.byType(TextField), 'renew-key');
    await tester.tap(find.text('Renew with key'));
    await tester.pumpAndSettle();
    expect(api.renewedKeys, ['renew-key']);
    await tester.tap(find.text('Renew with balance'));
    await tester.pumpAndSettle();
    expect(api.balanceRenewals, 1);

    await tester.tap(find.byType(DropdownButtonFormField<int>));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Paper').last);
    await tester.pumpAndSettle();
    await tester.tap(find.text('Reinstall'));
    await tester.pumpAndSettle();
    expect(api.reinstalledEggs, [2]);

    await tester.tap(find.text('Request deletion'));
    await tester.pumpAndSettle();
    expect(find.byType(AlertDialog), findsOneWidget);
    await tester.tap(find.text('Request deletion').last);
    await tester.pumpAndSettle();
    expect(api.deleteRequests, 1);
  });
}

class _Harness extends StatelessWidget {
  const _Harness({required this.api, required this.child});

  final PeoApi api;
  final Widget child;

  @override
  Widget build(BuildContext context) => MultiRepositoryProvider(
    providers: [RepositoryProvider<PeoApi>.value(value: api)],
    child: BlocProvider(
      create: (_) => SessionCubit(api: api, tokenStore: TokenStore()),
      child: MaterialApp(
        theme: PeoTheme.light,
        home: Scaffold(body: SafeArea(child: child)),
      ),
    ),
  );
}

class _TestApi extends PeoApi {
  _TestApi({
    this.serversResult = const [],
    this.statusResult = const [],
    this.failServers = false,
  }) : super(ApiClient(tokenStore: TokenStore()));

  final List<WareEntity> serversResult;
  final List<ServerStatus> statusResult;
  bool failServers;
  int serverLoads = 0;
  final List<String> renewedKeys = [];
  int balanceRenewals = 0;
  final List<int> reinstalledEggs = [];
  int deleteRequests = 0;

  @override
  Future<List<Order>> orders() async => const [];

  @override
  Future<List<WareEntity>> servers() async {
    serverLoads++;
    if (failServers) {
      throw const ApiException(
        code: ApiErrorCode.networkError,
        message: 'Temporary server error',
      );
    }
    return serversResult;
  }

  @override
  Future<List<ServerStatus>> serverStatuses() async => statusResult;

  @override
  Future<WareEntity> server(String id) async => const WareEntity(
    id: 'server-id',
    specId: 'product-id',
    hostName: 'Test server',
  );

  @override
  Future<ProductDetail> product(String specId) async => const ProductDetail(
    product: ProductCard(egg: 2, allowedEggIds: [2]),
    pricing: Pricing(),
    eggs: [Egg(id: 2, name: 'Paper')],
  );

  @override
  Future<void> renewServer(String id, String key) async {
    renewedKeys.add(key);
  }

  @override
  Future<void> renewServerByBalance(String id) async {
    balanceRenewals++;
  }

  @override
  Future<void> reinstallServer(String id, int eggId) async {
    reinstalledEggs.add(eggId);
  }

  @override
  Future<void> requestServerDelete(String id) async {
    deleteRequests++;
  }
}
