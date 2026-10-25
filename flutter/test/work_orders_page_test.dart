import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:peo_web/api/api_client.dart';
import 'package:peo_web/api/peo_api.dart';
import 'package:peo_web/api/token_store.dart';
import 'package:peo_web/models/content.dart';
import 'package:peo_web/pages/user/work_orders_page.dart';
import 'package:peo_web/theme/peo_theme.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('work orders fit mobile, tablet, and desktop widths', (
    tester,
  ) async {
    await tester.pumpWidget(_Harness(api: _TestApi()));
    await tester.pumpAndSettle();

    for (final width in [320, 390, 768, 1024, 1440]) {
      tester.view.physicalSize = Size(width.toDouble(), 900);
      tester.view.devicePixelRatio = 1;
      await tester.pump();
      expect(tester.takeException(), isNull, reason: 'viewport width $width');
      expect(find.text('New request'), findsOneWidget);
      expect(find.text('Request history'), findsOneWidget);
      expect(find.text(_TestApi.longTitle), findsOneWidget);
      expect(find.text(_TestApi.longDetails), findsOneWidget);
    }
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
  });

  testWidgets('ticket submission disables repeats and shows confirmation', (
    tester,
  ) async {
    final api = _TestApi()..createResult = Completer<WorkOrderItem>();
    await tester.pumpWidget(_Harness(api: api));
    await tester.pumpAndSettle();

    await tester.enterText(
      find.widgetWithText(TextField, 'Subject'),
      'Login issue',
    );
    await tester.enterText(
      find.widgetWithText(TextField, 'Details'),
      'Cannot sign in',
    );
    await tester.tap(find.text('Open ticket'));
    await tester.pump();

    expect(api.createdTitle, 'Login issue');
    expect(api.createdText, 'Cannot sign in');
    expect(
      tester.widget<FilledButton>(find.byType(FilledButton)).onPressed,
      isNull,
    );

    api.createResult!.complete(const WorkOrderItem(id: 'ticket-1'));
    await tester.pumpAndSettle();
    expect(find.text('work order opened'), findsOneWidget);
    expect(api.workOrderLoads, 2);
  });
}

class _Harness extends StatelessWidget {
  const _Harness({required this.api});

  final PeoApi api;

  @override
  Widget build(BuildContext context) => RepositoryProvider<PeoApi>.value(
    value: api,
    child: MaterialApp(theme: PeoTheme.light, home: const WorkOrdersPage()),
  );
}

class _TestApi extends PeoApi {
  _TestApi() : super(ApiClient(tokenStore: TokenStore()));

  Completer<WorkOrderItem>? createResult;
  String? createdTitle;
  String? createdText;
  int workOrderLoads = 0;

  static const longTitle =
      'A long support request title that should wrap cleanly on narrow screens';
  static const longDetails =
      'The server has been unavailable since the latest restart. I checked the console output and configuration, and can provide additional details if needed.';

  @override
  Future<List<WorkOrderItem>> workOrders() async {
    workOrderLoads++;
    return const [
      WorkOrderItem(
        id: 'ticket-1',
        orderTitle: longTitle,
        orderText: longDetails,
        createdAt: '2026-10-25T08:00:00Z',
      ),
    ];
  }

  @override
  Future<WorkOrderItem> createWorkOrder(CreateWorkOrderRequest body) {
    createdTitle = body.title;
    createdText = body.text;
    return createResult?.future ?? Future.value(const WorkOrderItem());
  }
}
