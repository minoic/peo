import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:peo_web/api/api_client.dart';
import 'package:peo_web/api/api_exception.dart';
import 'package:peo_web/api/peo_api.dart';
import 'package:peo_web/api/token_store.dart';
import 'package:peo_web/models/documents.dart';
import 'package:peo_web/models/order.dart';
import 'package:peo_web/models/site.dart';
import 'package:peo_web/pages/user/order_pages.dart';
import 'package:peo_web/state/site_cubit.dart';
import 'package:peo_web/theme/peo_theme.dart';
import 'package:peo_web/widgets/formatting.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('history shows order information, hides id and navigates', (
    tester,
  ) async {
    final api = _OrderApi(ordersResult: [_order()]);
    final router = GoRouter(
      initialLocation: '/orders',
      routes: [
        GoRoute(path: '/orders', builder: (_, _) => const OrdersPage()),
        GoRoute(
          path: '/orders/:id',
          builder: (_, state) => Text('Opened ${state.pathParameters['id']}'),
        ),
      ],
    );
    await tester.pumpWidget(_Harness(api: api, router: router));
    await tester.pumpAndSettle();

    expect(
      find.text('A long term product label for order history'),
      findsOneWidget,
    );
    expect(find.text('Awaiting payment'), findsOneWidget);
    expect(
      find.text('Created ${readableDate('2026-10-01T12:30:00Z')}'),
      findsOneWidget,
    );
    expect(find.textContaining('order-private-id'), findsNothing);
    expect(find.text(money(900)), findsOneWidget);
    for (final width in [390, 768, 1280]) {
      tester.view.physicalSize = Size(width.toDouble(), 844);
      tester.view.devicePixelRatio = 1;
      await tester.pump();
      expect(
        find.text('A long term product label for order history'),
        findsOneWidget,
        reason: 'viewport width $width',
      );
      expect(tester.takeException(), isNull, reason: 'viewport width $width');
    }
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    await tester.tap(find.text('A long term product label for order history'));
    await tester.pumpAndSettle();
    expect(find.text('Opened order-private-id'), findsOneWidget);
    router.dispose();
  });

  testWidgets('paid orders show status and no payment form', (tester) async {
    await tester.pumpWidget(
      _Harness(
        api: _OrderApi(orderResult: _order(paid: true)),
        child: const OrderDetailPage(orderId: 'order-private-id'),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.text('Paid · provisioning'), findsOneWidget);
    expect(
      find.text('Payment received. Server provisioning is in progress.'),
      findsOneWidget,
    );
    expect(find.text('Pay with balance'), findsNothing);
    expect(find.text('Server address'), findsNothing);
  });

  testWidgets('confirmed orders show completion and no payment form', (
    tester,
  ) async {
    await tester.pumpWidget(
      _Harness(
        api: _OrderApi(orderResult: _order(paid: true, confirmed: true)),
        child: const OrderDetailPage(orderId: 'order-private-id'),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Completed'), findsOneWidget);
    expect(find.text('This order has been completed.'), findsOneWidget);
    expect(find.text('Pay with balance'), findsNothing);
    expect(find.text('Server address'), findsNothing);
  });

  testWidgets('closed orders show closure reason and no payment form', (
    tester,
  ) async {
    final api = _OrderApi(orderResult: _order(closed: true));
    await tester.pumpWidget(
      _Harness(
        api: api,
        child: const OrderDetailPage(orderId: 'order-private-id'),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.text('Closed · payment window expired'), findsOneWidget);
    expect(find.text('Order closed'), findsOneWidget);
    expect(find.textContaining('within 15 minutes'), findsOneWidget);
    expect(find.text('Pay with balance'), findsNothing);
    expect(find.text('Pay with key'), findsNothing);
  });

  testWidgets('pending detail fits narrow screen and submits entered values', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    final api = _OrderApi(orderResult: _order());
    await tester.pumpWidget(
      _Harness(
        api: api,
        child: const OrderDetailPage(orderId: 'order-private-id'),
      ),
    );
    await tester.pumpAndSettle();
    expect(
      find.text('Current specification: 2 vCPU · 8 GB RAM · 80 GB disk'),
      findsOneWidget,
    );
    expect(tester.takeException(), isNull);
    await tester.ensureVisible(find.widgetWithText(TextField, 'Server name'));
    await tester.enterText(
      find.widgetWithText(TextField, 'Server name'),
      'my server',
    );
    await tester.ensureVisible(
      find.widgetWithText(TextField, 'Product key (optional)'),
    );
    await tester.enterText(
      find.widgetWithText(TextField, 'Product key (optional)'),
      'activation-key',
    );
    await tester.ensureVisible(find.text('Server address'));
    await tester.tap(find.text('Server address'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('node.example:25565').last);
    await tester.pumpAndSettle();
    await tester.ensureVisible(find.text('Pay with key'));
    await tester.tap(find.text('Pay with key'));
    await tester.pumpAndSettle();
    expect(api.paidWithKey, isNotNull);
    expect(api.paidWithKey!.allocationId, 7);
    expect(api.paidWithKey!.hostName, 'my server');
    expect(api.paidWithKey!.key, 'activation-key');
    expect(tester.takeException(), isNull);
  });

  testWidgets('missing current product keeps order and payment available', (
    tester,
  ) async {
    await tester.pumpWidget(
      _Harness(
        api: _OrderApi(orderResult: _order(), failProduct: true),
        child: const OrderDetailPage(orderId: 'order-private-id'),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.text('Hosting product'), findsOneWidget);
    expect(
      find.text(
        'Current product details are unavailable. Order totals remain based on the original order.',
      ),
      findsOneWidget,
    );
    expect(find.text(money(900)), findsOneWidget);
    expect(find.text('Pay with balance'), findsOneWidget);
  });
}

Order _order({
  bool paid = false,
  bool confirmed = false,
  bool closed = false,
}) => Order(
  id: 'order-private-id',
  specId: 'spec-id',
  createdAt: '2026-10-01T12:30:00Z',
  originPrice: 1000,
  finalPrice: 900,
  paid: paid,
  confirmed: confirmed,
  closed: closed,
);

class _OrderApi extends PeoApi {
  _OrderApi({
    this.ordersResult = const [],
    this.orderResult,
    this.failProduct = false,
  }) : super(ApiClient(tokenStore: TokenStore()));

  final List<Order> ordersResult;
  final Order? orderResult;
  final bool failProduct;
  PayOrderRequest? paidWithKey;

  @override
  Future<List<Order>> orders() async => ordersResult;
  @override
  Future<Order> order(String id) async => orderResult ?? _order();
  @override
  Future<ProductDetail> product(String specId) async {
    if (failProduct) {
      throw const ApiException(
        code: ApiErrorCode.notFound,
        message: 'Product removed',
      );
    }
    return const ProductDetail(
      product: ProductCard(
        specId: 'spec-id',
        wareName: 'A long term product label for order history',
        cpu: 200,
        memory: 8192,
        disk: 81920,
        validDays: 30,
      ),
      pricing: Pricing(originPrice: 1000, finalPrice: 900),
    );
  }

  @override
  Future<Storefront> storefront() async => const Storefront(
    monthly: [
      ProductCard(
        specId: 'spec-id',
        wareName: 'A long term product label for order history',
        cpu: 200,
        memory: 8192,
        disk: 81920,
        validDays: 30,
      ),
    ],
  );
  @override
  Future<List<Allocation>> allocations(String orderId) async => const [
    Allocation(id: 7, address: 'node.example:25565'),
  ];
  @override
  Future<void> payOrder(String orderId, PayOrderRequest body) async {
    paidWithKey = body;
  }
}

class _Harness extends StatelessWidget {
  const _Harness({required this.api, this.child, this.router});
  final PeoApi api;
  final Widget? child;
  final GoRouter? router;

  @override
  Widget build(BuildContext context) => MultiRepositoryProvider(
    providers: [RepositoryProvider<PeoApi>.value(value: api)],
    child: BlocProvider(
      create: (_) => SiteCubit(api),
      child: router == null
          ? MaterialApp(
              theme: PeoTheme.light,
              home: Scaffold(body: child),
            )
          : MaterialApp.router(theme: PeoTheme.light, routerConfig: router),
    ),
  );
}
