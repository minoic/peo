import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:peo_web/api/api_client.dart';
import 'package:peo_web/api/api_exception.dart';
import 'package:peo_web/api/peo_api.dart';
import 'package:peo_web/api/token_store.dart';
import 'package:peo_web/models/content.dart';
import 'package:peo_web/models/documents.dart';
import 'package:peo_web/models/order.dart';
import 'package:peo_web/models/server_console.dart';
import 'package:peo_web/models/site.dart';
import 'package:peo_web/pages/user/order_pages.dart';
import 'package:peo_web/pages/user/server_workspace_page.dart';
import 'package:peo_web/pages/user/server_file_editor_page.dart';
import 'package:peo_web/router/app_router.dart';
import 'package:peo_web/state/server_workspace_cubit.dart';
import 'package:peo_web/state/session_cubit.dart';
import 'package:peo_web/state/site_cubit.dart';
import 'package:peo_web/theme/peo_theme.dart';
import 'package:peo_web/widgets/shell.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('server picker keeps workspace tab when switching servers', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(1920, 1000);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    SharedPreferences.setMockInitialValues({});
    final app = await _WorkspaceApp.create();
    addTearDown(() => app.dispose(tester));
    await tester.pumpWidget(app.widget);
    await tester.pumpAndSettle();
    expect(_has1600pxContentFrame(tester), isTrue);
    app.router.go('/servers/server-a/files');
    await _pumpWorkspace(tester);
    expect(_has1600pxContentFrame(tester), isTrue);
    expect(find.text('Server List'), findsWidgets);
    expect(find.text('Server server-a'), findsWidgets);
    final serverTitle = find
        .descendant(
          of: find.byType(ServerSwitcher),
          matching: find.text('Server server-a'),
        )
        .first;
    final filesTitle = find.descendant(
      of: find.byType(ServerSwitcher),
      matching: find.text('Files'),
    );
    expect(
      tester.getTopLeft(serverTitle).dy,
      lessThan(tester.getTopLeft(filesTitle).dy),
    );
    final first = _workspaceCubit(tester);

    await tester.tap(find.byTooltip('Choose server').first);
    await tester.pumpAndSettle();
    expect(find.text('Server server-b'), findsOneWidget);
    expect(
      tester
          .widgetList<CheckedPopupMenuItem<Object?>>(
            find.byWidgetPredicate((widget) => widget is CheckedPopupMenuItem),
          )
          .any((item) => item.checked),
      isTrue,
    );
    await tester.tap(
      find.ancestor(
        of: find.text('Server server-b'),
        matching: find.byWidgetPredicate(
          (widget) => widget is CheckedPopupMenuItem,
        ),
      ),
    );
    await _pumpWorkspace(tester);

    expect(
      app.router.routeInformationProvider.value.uri.path,
      '/servers/server-b/files',
    );
    expect(
      find.descendant(
        of: find.byType(ServerSwitcher),
        matching: find.text('Server server-b'),
      ),
      findsOneWidget,
    );
    expect(_workspaceCubit(tester), isNot(same(first)));
    expect(first.isClosed, isTrue);
    expect(app.api.consoleCalls, contains('server-b'));
    expect(_selectedSidebarTile(tester, 'Files').selected, isTrue);
    expect(_selectedSidebarTile(tester, 'Order history').selected, isFalse);
    expect(tester.takeException(), isNull);
  });

  testWidgets('mobile drawer server picker switches without overflow', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    SharedPreferences.setMockInitialValues({});
    final app = await _WorkspaceApp.create();
    addTearDown(() => app.dispose(tester));
    await tester.pumpWidget(app.widget);
    await tester.pumpAndSettle();
    app.router.go('/account');
    await tester.pumpAndSettle();
    await tester.tap(find.byTooltip('Open navigation'));
    await tester.pumpAndSettle();
    await tester.tap(find.byTooltip('Choose server'));
    await tester.pumpAndSettle();
    expect(find.text('Server server-b'), findsOneWidget);
    await tester.tap(
      find.ancestor(
        of: find.text('Server server-b'),
        matching: find.byWidgetPredicate(
          (widget) => widget is CheckedPopupMenuItem,
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(
      app.router.routeInformationProvider.value.uri.path,
      '/servers/server-b/console',
    );
    expect(tester.takeException(), isNull);
  });

  testWidgets('server list failure keeps account and workspace navigation', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(1280, 900);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    SharedPreferences.setMockInitialValues({});
    final app = await _WorkspaceApp.create();
    app.api.failServers = true;
    addTearDown(() => app.dispose(tester));
    await tester.pumpWidget(app.widget);
    await tester.pumpAndSettle();
    app.router.go('/account');
    await tester.pumpAndSettle();

    expect(find.text('Account Settings'), findsOneWidget);
    await tester.tap(find.byTooltip('Choose server'));
    await tester.pumpAndSettle();
    expect(find.text('Could not load servers'), findsOneWidget);
    app.router.go('/servers/server-a/files');
    await _pumpWorkspace(tester);
    expect(_selectedSidebarTile(tester, 'Files').selected, isTrue);
    expect(_selectedSidebarTile(tester, 'Order history').selected, isFalse);
    expect(tester.takeException(), isNull);
  });

  testWidgets('selected server stays expanded across signed-in pages', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(1280, 900);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    SharedPreferences.setMockInitialValues({});
    final app = await _WorkspaceApp.create();
    addTearDown(() => app.dispose(tester));
    await tester.pumpWidget(app.widget);
    await tester.pumpAndSettle();

    app.router.go('/servers/server-a/files');
    await _pumpWorkspace(tester);
    expect(_selectedSidebarTile(tester, 'Files').selected, isTrue);

    app.router.go('/account');
    await tester.pumpAndSettle();
    expect(find.text('Account Settings'), findsOneWidget);
    expect(find.text('Server server-a'), findsWidgets);
    for (final label in ['Console', 'Files', 'Backups', 'Startup', 'Manage']) {
      expect(find.text(label), findsWidgets);
    }
    expect(_selectedSidebarTile(tester, 'Account Settings').selected, isTrue);
    expect(_selectedSidebarTile(tester, 'Files').selected, isFalse);

    await tester.tap(
      find
          .ancestor(of: find.text('Backups'), matching: find.byType(ListTile))
          .first,
    );
    await _pumpWorkspace(tester);
    expect(
      app.router.routeInformationProvider.value.uri.path,
      '/servers/server-a/backups',
    );
    expect(_selectedSidebarTile(tester, 'Backups').selected, isTrue);
    expect(tester.takeException(), isNull);
  });

  testWidgets('mobile drawer shows server selected on a direct route', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    SharedPreferences.setMockInitialValues({});
    final app = await _WorkspaceApp.create();
    addTearDown(() => app.dispose(tester));
    await tester.pumpWidget(app.widget);
    await tester.pumpAndSettle();

    app.router.go('/servers/server-a/files');
    await _pumpWorkspace(tester);
    expect(app.session.selectedServerId, 'server-a');

    app.router.go('/account');
    await tester.pumpAndSettle();
    await tester.tap(find.byTooltip('Open navigation'));
    await tester.pumpAndSettle();
    expect(find.text('Server server-a'), findsOneWidget);
    for (final label in ['Console', 'Files', 'Backups', 'Startup', 'Manage']) {
      expect(find.text(label), findsOneWidget);
    }
    expect(tester.takeException(), isNull);
  });

  test('session invalidation clears the remembered server', () async {
    SharedPreferences.setMockInitialValues({});
    final app = await _WorkspaceApp.create();
    app.session.rememberServer('server-a');
    expect(app.session.selectedServerId, 'server-a');

    await app.session.handleUnauthorized();

    expect(app.session.selectedServerId, isNull);
    app.router.dispose();
    app.refresh.dispose();
    await app.session.close();
    await app.site.close();
  });

  testWidgets('user route changes preserve the sidebar and server request', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(1280, 900);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    SharedPreferences.setMockInitialValues({});
    final app = await _WorkspaceApp.create();
    addTearDown(() => app.dispose(tester));
    await tester.pumpWidget(app.widget);
    await tester.pumpAndSettle();
    app.router.go('/account');
    await tester.pumpAndSettle();

    final sidebarState = tester.state(find.byType(UserSidebar));
    final serverCalls = app.api.serversCalls;
    app.router.go('/orders');
    await _pumpUntilCondition(
      tester,
      () => find.byType(OrdersPage).evaluate().isNotEmpty,
    );

    expect(find.text('Order history'), findsAtLeastNWidgets(1));
    expect(
      find.byWidgetPredicate(
        (widget) =>
            widget is FadeTransition &&
            widget.opacity.value >= 0.95 &&
            widget.opacity.value < 1,
      ),
      findsAtLeastNWidgets(1),
      reason: 'the entering page stays visible throughout its transition',
    );
    await tester.pumpAndSettle();
    expect(tester.state(find.byType(UserSidebar)), same(sidebarState));
    expect(app.api.serversCalls, serverCalls);

    app.router.go('/orders?refresh=1');
    await _pumpUntilCondition(
      tester,
      () =>
          app.router.routerDelegate.currentConfiguration.uri.query ==
          'refresh=1',
    );
    await tester.pump(Duration.zero);
    expect(tester.state(find.byType(UserSidebar)), same(sidebarState));
    expect(app.api.serversCalls, serverCalls);
    expect(
      find.byWidgetPredicate(
        (widget) =>
            widget is FadeTransition &&
            widget.opacity.value >= 0.95 &&
            widget.opacity.value < 1,
      ),
      findsNothing,
      reason: 'a query-only update must not restart the route transition',
    );

    app.router.go('/account');
    app.router.go('/orders');
    await tester.pump();
    expect(find.text('Order history'), findsAtLeastNWidgets(1));
    expect(tester.takeException(), isNull);
  });

  testWidgets('route changes honor reduced motion', (tester) async {
    tester.platformDispatcher.accessibilityFeaturesTestValue =
        const FakeAccessibilityFeatures(disableAnimations: true);
    addTearDown(tester.platformDispatcher.clearAccessibilityFeaturesTestValue);
    SharedPreferences.setMockInitialValues({});
    final app = await _WorkspaceApp.create();
    addTearDown(() => app.dispose(tester));
    await tester.pumpWidget(app.widget);
    await tester.pumpAndSettle();
    app.router.go('/account');
    await _pumpUntil(tester, find.text('Account settings'));

    expect(find.text('Account settings'), findsOneWidget);
    expect(
      find.byWidgetPredicate(
        (widget) =>
            widget is FadeTransition &&
            widget.opacity.value >= 0.95 &&
            widget.opacity.value < 1,
      ),
      findsNothing,
    );
    expect(tester.takeException(), isNull);
  });

  testWidgets(
    'workspace tabs stay opaque and restart a short content transition',
    (tester) async {
      tester.view.physicalSize = const Size(1280, 900);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      SharedPreferences.setMockInitialValues({});
      final app = await _WorkspaceApp.create();
      addTearDown(() => app.dispose(tester));
      await tester.pumpWidget(app.widget);
      await tester.pumpAndSettle();

      app.router.go('/servers/server-a/console');
      await _pumpWorkspace(tester);
      expect(_workspaceContentOffset(tester), 0);
      expect(
        find.ancestor(
          of: find.byKey(const ValueKey('server-workspace-content')),
          matching: find.byType(FadeTransition),
        ),
        findsNothing,
      );
      expect(
        find.ancestor(
          of: find.byKey(const ValueKey('server-workspace-content')),
          matching: find.byType(AnimatedOpacity),
        ),
        findsNothing,
      );

      app.router.go('/servers/server-a/files');
      await _pumpUntilCondition(
        tester,
        () => _selectedSidebarTile(tester, 'Files').selected,
      );
      expect(_workspaceContentOffset(tester), 6);
      await tester.pump(const Duration(milliseconds: 90));
      final halfwayOffset = _workspaceContentOffset(tester);
      expect(halfwayOffset, greaterThan(0));
      expect(halfwayOffset, lessThan(6));

      app.router.go('/servers/server-a/backups');
      await _pumpUntilCondition(
        tester,
        () => _selectedSidebarTile(tester, 'Backups').selected,
      );
      expect(_workspaceContentOffset(tester), 6);
      await tester.pumpAndSettle();
      expect(_workspaceContentOffset(tester), 0);
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets('workspace tab transition honors reduced motion', (tester) async {
    tester.platformDispatcher.accessibilityFeaturesTestValue =
        const FakeAccessibilityFeatures(disableAnimations: true);
    addTearDown(tester.platformDispatcher.clearAccessibilityFeaturesTestValue);
    SharedPreferences.setMockInitialValues({});
    final app = await _WorkspaceApp.create();
    addTearDown(() => app.dispose(tester));
    await tester.pumpWidget(app.widget);
    await tester.pumpAndSettle();

    app.router.go('/servers/server-a/console');
    await _pumpWorkspace(tester);
    app.router.go('/servers/server-a/files');
    await tester.pump();

    expect(_workspaceContentOffset(tester), 0);
    expect(tester.takeException(), isNull);
  });

  testWidgets(
    'same-server tab navigation keeps workspace, terminal ticket and drafts',
    (tester) async {
      tester.view.physicalSize = const Size(1280, 900);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      SharedPreferences.setMockInitialValues({});

      final app = await _WorkspaceApp.create();
      addTearDown(() => app.dispose(tester));
      await tester.pumpWidget(app.widget);
      await tester.pumpAndSettle();
      app.router.go('/servers/server-a/console');
      await _pumpWorkspace(tester);

      final workspace = _workspaceCubit(tester);
      final initialTicketCount = app.api.ticketCalls['server-a'];
      expect(initialTicketCount, 1);
      await tester.enterText(_commandField(), 'unsaved console command');

      app.router.go('/servers/server-a/files');
      await _pumpWorkspace(tester);
      expect(_selectedSidebarTile(tester, 'Files').selected, isTrue);
      await tester.tap(find.text('plugins'));
      await _pumpWorkspace(tester);
      expect(workspace.state.directory, '/plugins');
      final fileLoadsAtDirectory = app.api.fileCalls.length;

      app.router.go('/servers/server-a/startup');
      await _pumpWorkspace(tester);
      final startupField = _textField('Message of the day');
      await tester.enterText(startupField, 'unsaved startup value');

      app.router.go('/servers/server-a/manage');
      await _pumpWorkspace(tester);
      final renewalField = _textField('Renewal key');
      await tester.enterText(renewalField, 'unsaved renewal key');
      expect(_selectedSidebarTile(tester, 'Manage').selected, isTrue);

      app.router.go('/servers/server-a/files');
      await _pumpWorkspace(tester);
      expect(_workspaceCubit(tester), same(workspace));
      expect(workspace.state.directory, '/plugins');
      expect(app.api.fileCalls.length, fileLoadsAtDirectory);
      expect(app.api.ticketCalls['server-a'], initialTicketCount);

      app.router.go('/servers/server-a/startup');
      await _pumpWorkspace(tester);
      expect(
        tester
            .widget<TextField>(_textField('Message of the day'))
            .controller!
            .text,
        'unsaved startup value',
      );

      app.router.go('/servers/server-a/manage');
      await _pumpWorkspace(tester);
      expect(
        tester.widget<TextField>(_textField('Renewal key')).controller!.text,
        'unsaved renewal key',
      );
      expect(_workspaceCubit(tester), same(workspace));
      app.router.go('/servers/server-a/console');
      await _pumpWorkspace(tester);
      expect(
        tester.widget<TextField>(_commandField()).controller!.text,
        'unsaved console command',
      );
      expect(app.api.ticketCalls['server-a'], initialTicketCount);
    },
  );

  testWidgets('changing server and leaving workspace release old polling', (
    tester,
  ) async {
    SharedPreferences.setMockInitialValues({});
    final app = await _WorkspaceApp.create();
    addTearDown(() => app.dispose(tester));
    await tester.pumpWidget(app.widget);
    await tester.pumpAndSettle();

    app.router.go('/servers/server-a/console');
    await _pumpWorkspace(tester);
    final first = _workspaceCubit(tester);
    final firstResourceCalls = app.api.resourceCalls['server-a'];

    app.router.go('/servers/server-b/startup');
    await _pumpWorkspace(tester);
    final second = _workspaceCubit(tester);
    expect(second, isNot(same(first)));
    expect(first.isClosed, isTrue);
    expect(app.api.consoleCalls, containsAll(['server-a', 'server-b']));
    final secondResourceCalls = app.api.resourceCalls['server-b'];

    await tester.pump(const Duration(seconds: 6));
    await tester.pump();
    expect(app.api.resourceCalls['server-a'], firstResourceCalls);
    expect(
      app.api.resourceCalls['server-b'],
      greaterThan(secondResourceCalls!),
    );

    app.router.go('/console');
    await tester.pumpAndSettle();
    expect(second.isClosed, isTrue);
    final secondCallsAfterLeave = app.api.resourceCalls['server-b'];
    await tester.pump(const Duration(seconds: 6));
    await tester.pump();
    expect(app.api.resourceCalls['server-b'], secondCallsAfterLeave);
  });

  testWidgets('base alias and unknown tab resolve to selected console entry', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(1280, 900);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    SharedPreferences.setMockInitialValues({});
    final app = await _WorkspaceApp.create();
    addTearDown(() => app.dispose(tester));
    await tester.pumpWidget(app.widget);
    await tester.pumpAndSettle();

    app.router.go('/servers/server-a');
    await _pumpWorkspace(tester);
    expect(
      app.router.routeInformationProvider.value.uri.path,
      '/servers/server-a/console',
    );
    expect(_selectedSidebarTile(tester, 'Console').selected, isTrue);

    app.router.go('/servers/server-a/not-a-tab');
    await _pumpWorkspace(tester);
    expect(
      app.router.routeInformationProvider.value.uri.path,
      '/servers/server-a/console',
    );
    expect(_selectedSidebarTile(tester, 'Console').selected, isTrue);
    expect(tester.takeException(), isNull);
  });

  testWidgets(
    'editable file opens editor, guards draft and saves by shortcut',
    (tester) async {
      tester.view.physicalSize = const Size(1280, 900);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      SharedPreferences.setMockInitialValues({});
      final app = await _WorkspaceApp.create();
      addTearDown(() => app.dispose(tester));
      await tester.pumpWidget(app.widget);
      await tester.pumpAndSettle();

      app.router.go('/servers/server-a/files');
      await _pumpWorkspace(tester);
      await tester.tap(find.text('server.jar'));
      await tester.pumpAndSettle();
      expect(find.byType(ServerFileEditorPage), findsNothing);
      expect(
        app.router.routeInformationProvider.value.uri.path,
        '/servers/server-a/files',
      );
      await tester.tap(find.text('settings.yml'));
      await tester.pumpAndSettle();

      expect(find.byType(ServerFileEditorPage), findsOneWidget);
      expect(
        app.router.routeInformationProvider.value.uri.path,
        '/servers/server-a/editor',
      );
      expect(_selectedSidebarTile(tester, 'Files').selected, isTrue);
      final editor = find.byType(TextField);
      expect(
        tester.widget<TextField>(editor).controller!.text,
        'server: true\n',
      );

      await tester.enterText(editor, 'server:\n  motd: changed');
      await tester.tap(find.byTooltip('Back to files'));
      await tester.pumpAndSettle();
      expect(find.text('Discard unsaved changes?'), findsOneWidget);
      await tester.tap(find.text('Keep editing'));
      await tester.pumpAndSettle();
      expect(find.byType(ServerFileEditorPage), findsOneWidget);

      app.api.failFileWrite = true;
      await tester.tap(find.text('Save'));
      await tester.pumpAndSettle();
      expect(find.text('Could not write file'), findsOneWidget);
      expect(
        tester.widget<TextField>(editor).controller!.text,
        'server:\n  motd: changed',
      );
      expect(_workspaceCubit(tester).state.editorDirty, isTrue);
      expect(app.api.fileWrites, isEmpty);

      app.api.failFileWrite = false;
      await tester.tap(find.text('Retry'));
      await tester.pumpAndSettle();
      expect(app.api.fileWrites, hasLength(1));
      expect(app.api.fileWrites.single.$3, 'server:\n  motd: changed');

      await tester.enterText(editor, 'server:\n  motd: shortcut');
      await tester.tap(editor);
      await tester.sendKeyDownEvent(LogicalKeyboardKey.controlLeft);
      await tester.sendKeyEvent(LogicalKeyboardKey.keyS);
      await tester.sendKeyUpEvent(LogicalKeyboardKey.controlLeft);
      await tester.pumpAndSettle();
      expect(app.api.fileWrites, hasLength(2));
      expect(app.api.fileWrites.last.$3, 'server:\n  motd: shortcut');

      await tester.tap(find.byTooltip('Back to files'));
      await tester.pumpAndSettle();
      expect(
        app.router.routeInformationProvider.value.uri.path,
        '/servers/server-a/files',
      );
      expect(_workspaceCubit(tester).state.directory, '/');
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets('failed editor read cannot save stale content', (tester) async {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    SharedPreferences.setMockInitialValues({});
    final app = await _WorkspaceApp.create();
    app.api.failFileRead = true;
    addTearDown(() => app.dispose(tester));
    await tester.pumpWidget(app.widget);
    await tester.pumpAndSettle();

    app.router.go('/servers/server-a/files');
    await _pumpWorkspace(tester);
    await tester.tap(find.text('settings.yml'));
    await tester.pumpAndSettle();

    expect(find.text('Could not read file'), findsOneWidget);
    expect(tester.widget<TextField>(find.byType(TextField)).enabled, isFalse);
    expect(
      tester.widget<FilledButton>(find.byType(FilledButton)).onPressed,
      isNull,
    );
    expect(app.api.fileWrites, isEmpty);
    expect(app.api.fileReadCalls, 1);
    expect(tester.takeException(), isNull);
  });

  test('editor enforces the 2 MiB UTF-8 byte limit before writing', () async {
    final api = _WorkspaceApi(
      ApiClient(
        tokenStore: _MemoryTokenStore(),
        baseUrl: 'https://example.test/api/v1',
      ),
    );
    final cubit = ServerWorkspaceCubit(api, 'server-a');
    await cubit.loadEditorFile('/settings.yml');

    cubit.updateEditorContent('é' * (1024 * 1024 + 1));
    expect(await cubit.saveEditorFile(), isFalse);
    expect(cubit.state.editorContent, hasLength(1024 * 1024 + 1));
    expect(cubit.state.editorError, 'Text files are limited to 2 MiB.');
    expect(api.fileWrites, isEmpty);
    await cubit.close();
  });
}

bool _has1600pxContentFrame(WidgetTester tester) {
  final frames = find.byWidgetPredicate(
    (widget) => widget is ConstrainedBox && widget.constraints.maxWidth == 1600,
  );
  return frames.evaluate().any(
    (element) => tester.getSize(find.byWidget(element.widget)).width == 1600,
  );
}

Future<void> _pumpWorkspace(WidgetTester tester) async {
  await tester.pump();
  await tester.pump(const Duration(milliseconds: 220));
  await tester.pump();
}

Future<void> _pumpUntil(WidgetTester tester, Finder finder) async {
  await _pumpUntilCondition(tester, () => finder.evaluate().isNotEmpty);
  expect(finder, findsAtLeastNWidgets(1));
}

Future<void> _pumpUntilCondition(
  WidgetTester tester,
  bool Function() condition,
) async {
  for (var frame = 0; frame < 10 && !condition(); frame++) {
    await tester.pump(Duration.zero);
  }
  expect(condition(), isTrue);
}

double _workspaceContentOffset(WidgetTester tester) => tester
    .widget<Transform>(find.byKey(const ValueKey('server-workspace-content')))
    .transform
    .storage[13];

ServerWorkspaceCubit _workspaceCubit(WidgetTester tester) {
  final editorPage = find.byType(ServerFileEditorPage);
  final workspacePage = find.byType(ServerWorkspacePage);
  final page = editorPage.evaluate().isNotEmpty ? editorPage : workspacePage;
  return tester.element(page).read<ServerWorkspaceCubit>();
}

ListTile _selectedSidebarTile(WidgetTester tester, String label) => tester
    .widgetList<ListTile>(
      find.descendant(
        of: find.byType(UserSidebar),
        matching: find.byType(ListTile),
      ),
    )
    .firstWhere((tile) {
      final tileFinder = find.byWidget(tile);
      return find
          .descendant(of: tileFinder, matching: find.text(label))
          .evaluate()
          .isNotEmpty;
    });

Finder _textField(String label) => find.byWidgetPredicate(
  (widget) => widget is TextField && widget.decoration?.labelText == label,
  description: 'TextField with label "$label"',
);

Finder _commandField() => find.byWidgetPredicate(
  (widget) =>
      widget is TextField && widget.decoration?.hintText == 'Enter a command',
  description: 'Terminal command input',
);

class _WorkspaceApp {
  _WorkspaceApp._(this.api, this.session, this.site, this.refresh, this.router);

  final _WorkspaceApi api;
  final SessionCubit session;
  final SiteCubit site;
  final SessionRefresh refresh;
  final GoRouter router;

  static Future<_WorkspaceApp> create() async {
    final tokens = _MemoryTokenStore();
    await tokens.write('signed-in-token');
    final api = _WorkspaceApi(
      ApiClient(tokenStore: tokens, baseUrl: 'https://example.test/api/v1'),
    );
    final session = SessionCubit(api: api, tokenStore: tokens);
    final site = SiteCubit(api);
    final refresh = SessionRefresh(session.stream);
    final router = buildRouter(session: session, refresh: refresh);
    await session.bootstrap();
    await site.load();
    return _WorkspaceApp._(api, session, site, refresh, router);
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

class _MemoryTokenStore extends TokenStore {
  String? _token;

  @override
  String? get current => _token;

  @override
  Future<String?> read() async => _token;

  @override
  Future<void> write(String token) async => _token = token;

  @override
  Future<void> clear() async => _token = null;
}

class _WorkspaceApi extends PeoApi {
  _WorkspaceApi(super.client);

  final Map<String, int> ticketCalls = {};
  final Map<String, int> resourceCalls = {};
  final List<String> consoleCalls = [];
  final List<(String, String)> fileCalls = [];
  final List<(String, String, String)> fileWrites = [];
  int fileReadCalls = 0;
  bool failFileRead = false;
  bool failFileWrite = false;
  final List<Completer<TerminalTicket>> _terminalTickets = [];
  int serversCalls = 0;
  bool failServers = false;

  void completeTerminalTickets() {
    for (final ticket in _terminalTickets) {
      if (!ticket.isCompleted) {
        ticket.complete(const TerminalTicket(ticket: 'test-ticket'));
      }
    }
  }

  @override
  Future<User> me() async =>
      const User(name: 'Tester', email: 'test@example.test');

  @override
  Future<SiteConfig> siteConfig() async =>
      const SiteConfig(applicationName: 'PEO', loggedIn: true);

  @override
  Future<Storefront> storefront() async => const Storefront();

  @override
  Future<List<MessageItem>> messages() async => const [];

  @override
  Future<List<WareEntity>> servers() async {
    serversCalls++;
    if (failServers) throw StateError('server list unavailable');
    return const [
      WareEntity(id: 'server-a', hostName: 'Server server-a'),
      WareEntity(id: 'server-b', hostName: 'Server server-b'),
    ];
  }

  @override
  Future<List<Order>> orders() async => const [];

  @override
  Future<List<ServerStatus>> serverStatuses() async => const [];

  @override
  Future<WareEntity> server(String id) async => WareEntity(
    id: id,
    specId: 'product-$id',
    hostName: 'Server $id',
    validDate: '2030-01-01T00:00:00Z',
  );

  @override
  Future<ProductDetail> product(String specId) async => const ProductDetail(
    product: ProductCard(egg: 2, allowedEggIds: [2]),
    pricing: Pricing(),
    eggs: [Egg(id: 2, name: 'Paper')],
  );

  @override
  Future<ServerConsole> serverConsole(String id) async {
    consoleCalls.add(id);
    return ServerConsole(
      server: ConsoleServer(id: id, name: 'Server $id', status: 'running'),
      startup: const ServerStartup(
        command: 'java -jar server.jar',
        variables: [
          StartupVariable(
            key: 'MOTD',
            name: 'Message of the day',
            value: 'Welcome',
            isEditable: true,
          ),
        ],
      ),
    );
  }

  @override
  Future<ServerResources> serverResources(String id) async {
    resourceCalls.update(id, (count) => count + 1, ifAbsent: () => 1);
    return const ServerResources(
      currentState: 'running',
      resources: ResourceUsage(memoryBytes: 1048576, cpuAbsolute: 12),
    );
  }

  @override
  Future<TerminalTicket> serverTerminalTicket(String id) {
    ticketCalls.update(id, (count) => count + 1, ifAbsent: () => 1);
    final ticket = Completer<TerminalTicket>();
    _terminalTickets.add(ticket);
    return ticket.future;
  }

  @override
  Future<List<ServerFile>> serverFiles(String id, String directory) async {
    fileCalls.add((id, directory));
    if (directory == '/') {
      return const [
        ServerFile(name: 'plugins', isFile: false),
        ServerFile(
          name: 'settings.yml',
          isFile: true,
          isEditable: true,
          mimeType: 'application/yaml',
          size: 13,
        ),
        ServerFile(name: 'server.jar', isFile: true, isEditable: false),
      ];
    }
    return const [
      ServerFile(name: 'config.yml', isFile: true, isEditable: true),
    ];
  }

  @override
  Future<List<ServerBackup>> serverBackups(String id) async => const [];

  @override
  Future<String> readServerFile(String id, String file) async {
    fileReadCalls++;
    if (failFileRead) {
      throw const ApiException(
        code: 'internal_error',
        message: 'Could not read file',
      );
    }
    return 'server: true\n';
  }

  @override
  Future<void> writeServerFile(String id, String file, String content) async {
    if (failFileWrite) {
      throw const ApiException(
        code: 'internal_error',
        message: 'Could not write file',
      );
    }
    fileWrites.add((id, file, content));
  }
}
