import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:peo_web/api/api_client.dart';
import 'package:peo_web/api/peo_api.dart';
import 'package:peo_web/api/token_store.dart';
import 'package:peo_web/models/admin.dart';
import 'package:peo_web/models/content.dart';
import 'package:peo_web/models/documents.dart';
import 'package:peo_web/models/site.dart';
import 'package:peo_web/models/order.dart';
import 'package:peo_web/models/server_console.dart';
import 'package:peo_web/pages/user/order_pages.dart';
import 'package:peo_web/router/app_router.dart';
import 'package:peo_web/state/session_cubit.dart';
import 'package:peo_web/state/site_cubit.dart';
import 'package:peo_web/theme/peo_theme.dart';
import 'package:peo_web/widgets/shell.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('public shop route renders from the storefront API', (
    tester,
  ) async {
    final app = await _TestApp.create();
    await tester.pumpWidget(app.widget);
    await tester.pumpAndSettle();
    expect(find.text('Products'), findsOneWidget);
    await app.dispose(tester);
  });

  testWidgets('signed-out visitors are redirected from user routes', (
    tester,
  ) async {
    final app = await _TestApp.create();
    await tester.pumpWidget(app.widget);
    await tester.pumpAndSettle();
    app.router.go('/orders');
    await tester.pumpAndSettle();
    expect(app.router.routeInformationProvider.value.uri.path, '/login');
    expect(find.text('Sign in'), findsAtLeastNWidgets(1));
    await app.dispose(tester);
  });

  testWidgets('a signed-in non-admin is kept out of admin routes', (
    tester,
  ) async {
    final app = await _TestApp.create(user: _user(isAdmin: false));
    await tester.pumpWidget(app.widget);
    await tester.pumpAndSettle();
    app.router.go('/admin');
    await tester.pumpAndSettle();
    expect(app.router.routeInformationProvider.value.uri.path, '/');
    expect(find.text('Administration'), findsNothing);
    await app.dispose(tester);
  });

  testWidgets('signed-in users are redirected away from the login page', (
    tester,
  ) async {
    final app = await _TestApp.create(user: _user());
    await tester.pumpWidget(app.widget);
    await tester.pumpAndSettle();
    app.router.go('/login');
    await tester.pumpAndSettle();
    expect(app.router.routeInformationProvider.value.uri.path, '/');
    expect(find.text('Products'), findsOneWidget);
    await app.dispose(tester);
  });

  testWidgets('an administrator can open the admin dashboard', (tester) async {
    final app = await _TestApp.create(user: _user(isAdmin: true));
    await tester.pumpWidget(app.widget);
    await tester.pumpAndSettle();
    app.router.go('/admin');
    await tester.pumpAndSettle();
    expect(find.text('Administration'), findsOneWidget);
    expect(find.text('Open tickets'), findsOneWidget);
    await app.dispose(tester);
  });

  testWidgets('nested admin pages use distinct transition routes', (
    tester,
  ) async {
    final app = await _TestApp.create(user: _user(isAdmin: true));
    await tester.pumpWidget(app.widget);
    await tester.pumpAndSettle();
    app.router.go('/admin/products');
    await tester.pumpAndSettle();
    expect(
      app.router.routeInformationProvider.value.uri.path,
      '/admin/products',
    );
    expect(tester.takeException(), isNull);
    app.router.go('/admin/settings');
    await tester.pumpAndSettle();
    expect(
      app.router.routeInformationProvider.value.uri.path,
      '/admin/settings',
    );
    expect(tester.takeException(), isNull);
    await app.dispose(tester);
  });

  testWidgets('buying a product creates an order and loads allocations', (
    tester,
  ) async {
    final app = await _TestApp.create(user: _user());
    await tester.pumpWidget(app.widget);
    await tester.pumpAndSettle();
    app.router.go('/product/product-id');
    await tester.pumpAndSettle();
    await tester.tap(find.text('Continue with balance'));
    await tester.pumpAndSettle();
    expect(
      app.router.routeInformationProvider.value.uri.path,
      '/orders/order-id',
    );
    expect(find.text('Server address'), findsOneWidget);
    final allocations = find.byType(DropdownButtonFormField<int>);
    await tester.drag(
      find
          .descendant(
            of: find.byType(OrderDetailPage),
            matching: find.byType(ListView),
          )
          .first,
      const Offset(0, -300),
    );
    await tester.pumpAndSettle();
    await tester.tap(allocations);
    await tester.pumpAndSettle();
    expect(find.text('127.0.0.1:25565'), findsOneWidget);
    await app.dispose(tester);
  });

  testWidgets('server detail offers key renewal and product egg selection', (
    tester,
  ) async {
    final app = await _TestApp.create(user: _user());
    try {
      await tester.pumpWidget(app.widget);
      await tester.pumpAndSettle();
      app.router.go('/servers/server-id/manage');
      await tester.pumpAndSettle();
      expect(find.text('Renewal key'), findsOneWidget);
      expect(find.text('Renew with key'), findsOneWidget);
      final managePage = find.byType(ServerManagementPage);
      expect(managePage, findsOneWidget);
      final manageScrollable = find
          .descendant(of: managePage, matching: find.byType(ListView))
          .first;
      for (
        var attempt = 0;
        attempt < 8 && find.text('Reinstall template').evaluate().isEmpty;
        attempt++
      ) {
        await tester.drag(manageScrollable, const Offset(0, -400));
        await tester.pumpAndSettle();
      }
      expect(find.text('Reinstall template'), findsOneWidget);
      final templatePicker = find.byType(DropdownButtonFormField<int>).last;
      await tester.ensureVisible(templatePicker);
      await tester.tap(templatePicker);
      await tester.pumpAndSettle();
      expect(find.text('Paper'), findsOneWidget);
    } finally {
      await app.dispose(tester);
    }
  });

  testWidgets('signed-in users can open the server console', (tester) async {
    final app = await _TestApp.create(user: _user());
    await tester.pumpWidget(app.widget);
    await tester.pumpAndSettle();
    app.router.go('/console');
    await tester.pumpAndSettle();
    expect(find.text('Your servers'), findsOneWidget);
    await app.dispose(tester);
  });

  testWidgets('message navigation opens a dialog without changing page', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(1280, 900);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    final app = await _TestApp.create(user: _user());
    await tester.pumpWidget(app.widget);
    await tester.pumpAndSettle();
    app.router.go('/console');
    await tester.pumpAndSettle();

    await tester.tap(find.text('Message'));
    await tester.pumpAndSettle();
    expect(app.router.routeInformationProvider.value.uri.path, '/console');
    expect(find.byType(Dialog), findsOneWidget);
    expect(find.text('Unread'), findsOneWidget);
    expect(
      find.text('A complete message body\nwith a second line.'),
      findsOneWidget,
    );

    await tester.tap(find.text('Mark read'));
    await tester.pumpAndSettle();
    expect(app.site.config.unread, 0);
    expect(find.text('Read'), findsOneWidget);

    await tester.tap(find.byTooltip('Close messages'));
    await tester.pumpAndSettle();
    expect(app.router.routeInformationProvider.value.uri.path, '/console');
    expect(find.byType(Dialog), findsNothing);
    await app.dispose(tester);
  });

  testWidgets('legacy messages route opens the inbox as a dialog', (
    tester,
  ) async {
    final app = await _TestApp.create(user: _user());
    await tester.pumpWidget(app.widget);
    await tester.pumpAndSettle();
    app.router.go('/messages');
    await tester.pumpAndSettle();
    expect(find.byType(Dialog), findsOneWidget);
    await tester.tap(find.byTooltip('Close messages'));
    await tester.pumpAndSettle();
    expect(app.router.routeInformationProvider.value.uri.path, '/console');
    await app.dispose(tester);
  });

  testWidgets('empty message inbox clears the navigation unread badge', (
    tester,
  ) async {
    final app = await _TestApp.create(user: _user());
    app.api.emptyMessages = true;
    app.site.setUnread(4);
    await tester.pumpWidget(app.widget);
    await tester.pumpAndSettle();
    await tester.tap(find.byTooltip('Message'));
    await tester.pumpAndSettle();
    expect(app.site.config.unread, 0);
    expect(find.text('No messages yet'), findsOneWidget);
    await tester.tap(find.byTooltip('Close messages'));
    await tester.pumpAndSettle();
    await app.dispose(tester);
  });

  testWidgets(
    'mobile drawer message entry leaves the current page underneath',
    (tester) async {
      tester.view.physicalSize = const Size(320, 844);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      final app = await _TestApp.create(user: _user());
      await tester.pumpWidget(app.widget);
      await tester.pumpAndSettle();
      app.router.go('/console');
      await tester.pumpAndSettle();

      await tester.tap(find.byTooltip('Open navigation'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Message'));
      await tester.pumpAndSettle();
      expect(app.router.routeInformationProvider.value.uri.path, '/console');
      expect(find.byType(Dialog), findsOneWidget);
      expect(find.byType(Drawer), findsNothing);
      expect(tester.takeException(), isNull);
      await tester.tap(find.byTooltip('Close messages'));
      await tester.pumpAndSettle();
      await app.dispose(tester);
    },
  );

  testWidgets('store, login, user, and admin layouts fit target widths', (
    tester,
  ) async {
    for (final width in [390.0, 768.0, 1280.0]) {
      tester.view.physicalSize = Size(width, 900);
      tester.view.devicePixelRatio = 1;

      final signedIn = await _TestApp.create(user: _user(isAdmin: true));
      await tester.pumpWidget(signedIn.widget);
      await tester.pumpAndSettle();
      final shell = tester.widgetList<Scaffold>(find.byType(Scaffold)).first;
      expect(shell.drawer != null, width < 1024 ? isTrue : isFalse);
      expect(tester.takeException(), isNull, reason: 'store at $width');

      signedIn.router.go('/console');
      await tester.pumpAndSettle();
      expect(
        find.byType(UserSidebar),
        width >= 1024 ? findsOneWidget : findsNothing,
      );
      expect(tester.takeException(), isNull, reason: 'user area at $width');

      signedIn.router.go('/admin');
      await tester.pumpAndSettle();
      expect(find.text('Administration'), findsOneWidget);
      expect(tester.takeException(), isNull, reason: 'admin area at $width');
      await signedIn.dispose(tester);

      final guest = await _TestApp.create();
      await tester.pumpWidget(guest.widget);
      await tester.pumpAndSettle();
      guest.router.go('/login');
      await tester.pumpAndSettle();
      expect(find.text('Sign in'), findsAtLeastNWidgets(1));
      expect(tester.takeException(), isNull, reason: 'login at $width');
      await guest.dispose(tester);
    }
    tester.view.resetPhysicalSize();
    tester.view.resetDevicePixelRatio();
  });
}

User _user({bool isAdmin = false}) =>
    User(name: 'alice', email: 'alice@example.test', isAdmin: isAdmin);

class _MemoryTokenStore extends TokenStore {
  _MemoryTokenStore({this.token});
  String? token;
  @override
  Future<String?> read() async => token;
  @override
  Future<void> write(String value) async => token = value;
  @override
  Future<void> clear() async => token = null;
}

class _FakeApi extends PeoApi {
  _FakeApi(super.client, this.user);
  final User user;
  bool messageRead = false;
  bool emptyMessages = false;
  final List<Completer<TerminalTicket>> _terminalTickets = [];

  void completeTerminalTickets() {
    for (final ticket in _terminalTickets) {
      if (!ticket.isCompleted) {
        ticket.complete(const TerminalTicket(ticket: 'test-ticket'));
      }
    }
  }

  @override
  Future<List<MessageItem>> messages() async => emptyMessages
      ? []
      : [
          MessageItem(
            id: 'message-id',
            senderName: 'Support Team with a deliberately long sender name',
            text: 'A complete message body\nwith a second line.',
            timeText: '2026-10-17 12:00 · 11 minutes ago',
            haveRead: messageRead,
          ),
        ];
  @override
  Future<int> unreadCount() async => emptyMessages || messageRead ? 0 : 1;
  @override
  Future<void> markMessageRead(String id) async => messageRead = true;

  @override
  Future<User> me() async => user;
  @override
  Future<SiteConfig> siteConfig() async => SiteConfig(
    applicationName: 'Test Peo',
    loggedIn: true,
    isAdmin: user.isAdmin,
  );
  @override
  Future<Storefront> storefront() async => const Storefront(
    monthly: [
      ProductCard(
        specId: 'product-id',
        wareName: 'Small server',
        price: 100,
        memory: 2048,
        cpu: 100,
        disk: 4096,
      ),
      ProductCard(
        specId: 'medium-server',
        wareName: 'Medium server',
        price: 180,
        memory: 4096,
        cpu: 200,
        disk: 8192,
      ),
      ProductCard(
        specId: 'large-server',
        wareName: 'Large server',
        price: 320,
        memory: 8192,
        cpu: 300,
        disk: 16384,
      ),
    ],
  );
  @override
  Future<ProductDetail> product(String specId) async => ProductDetail(
    product: ProductCard(
      specId: specId,
      wareName: 'Small server',
      egg: 1,
      allowedEggIds: const [1],
    ),
    pricing: const Pricing(originPrice: 100, finalPrice: 100),
    eggs: const [Egg(id: 1, name: 'Paper')],
  );
  @override
  Future<Order> createOrder(String specId) async =>
      const Order(id: 'order-id', specId: 'product-id', finalPrice: 100);
  @override
  Future<Order> order(String id) async =>
      const Order(id: 'order-id', specId: 'product-id', finalPrice: 100);
  @override
  Future<List<Allocation>> allocations(String orderId) async => const [
    Allocation(id: 12, address: '127.0.0.1:25565'),
  ];
  @override
  Future<Dashboard> adminDashboard() async =>
      const Dashboard(userAmount: 1, workOrderCount: 0);
  @override
  Future<List<WareEntity>> servers() async => const [];
  @override
  Future<List<Order>> orders() async => const [];
  @override
  Future<WareEntity> server(String id) async => const WareEntity(
    id: 'server-id',
    specId: 'product-id',
    hostName: 'My server',
    validDate: '2030-01-01T00:00:00Z',
  );
  @override
  Future<List<ServerStatus>> serverStatuses() async => const [];

  @override
  Future<ServerConsole> serverConsole(String id) async => const ServerConsole(
    server: ConsoleServer(
      id: 'server-id',
      name: 'My server',
      status: 'running',
    ),
    startup: ServerStartup(
      command: 'java -jar server.jar',
      variables: [StartupVariable(key: 'MOTD', name: 'Message of the day')],
    ),
  );

  @override
  Future<ServerResources> serverResources(String id) async =>
      const ServerResources(
        currentState: 'running',
        resources: ResourceUsage(memoryBytes: 1048576, cpuAbsolute: 10),
      );

  @override
  Future<TerminalTicket> serverTerminalTicket(String id) {
    final ticket = Completer<TerminalTicket>();
    _terminalTickets.add(ticket);
    return ticket.future;
  }

  @override
  Future<List<ServerBackup>> serverBackups(String id) async => const [];
}

class _TestApp {
  _TestApp._(this.api, this.session, this.site, this.refresh, this.router);
  final _FakeApi api;
  final SessionCubit session;
  final SiteCubit site;
  final SessionRefresh refresh;
  final GoRouter router;

  static Future<_TestApp> create({User? user}) async {
    final tokens = _MemoryTokenStore(
      token: user == null ? null : 'valid-token',
    );
    final api = _FakeApi(
      ApiClient(tokenStore: tokens, baseUrl: 'https://example.test/api/v1'),
      user ?? _user(),
    );
    final session = SessionCubit(api: api, tokenStore: tokens);
    final site = SiteCubit(api);
    final refresh = SessionRefresh(session.stream);
    final router = buildRouter(session: session, refresh: refresh);
    await session.bootstrap();
    await site.load();
    return _TestApp._(api, session, site, refresh, router);
  }

  Widget get widget => MultiRepositoryProvider(
    providers: [RepositoryProvider<PeoApi>.value(value: api)],
    child: MultiBlocProvider(
      providers: [
        BlocProvider<SessionCubit>.value(value: session),
        BlocProvider<SiteCubit>.value(value: site),
      ],
      child: MaterialApp.router(theme: PeoTheme.light, routerConfig: router),
    ),
  );

  Future<void> dispose(WidgetTester tester) async {
    await tester.pumpWidget(const SizedBox.shrink());
    api.completeTerminalTickets();
    await tester.pump();
    router.dispose();
    refresh.dispose();
    await session.close();
    await site.close();
  }
}
