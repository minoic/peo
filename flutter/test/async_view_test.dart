import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:peo_web/api/api_exception.dart';
import 'package:peo_web/state/async_value.dart';
import 'package:peo_web/theme/peo_theme.dart';
import 'package:peo_web/widgets/async_view.dart';

void main() {
  testWidgets('rapid state changes keep outgoing transition keys unique', (
    tester,
  ) async {
    Widget app(AsyncValue<String> value) => MaterialApp(
      theme: PeoTheme.light,
      home: Scaffold(
        body: AsyncView<String>(
          value: value,
          builder: (context, data) => Text(data, key: ValueKey(data)),
        ),
      ),
    );

    Future<void> pumpState(AsyncValue<String> value) =>
        tester.pumpWidget(app(value), duration: Duration.zero);

    await pumpState(const AsyncValue.idle());
    await pumpState(const AsyncValue.loading());
    await tester.pump(const Duration(milliseconds: 50));
    await pumpState(
      const AsyncValue.failure(
        ApiException(code: 'failure', message: 'Request failed'),
      ),
    );
    await tester.pump(const Duration(milliseconds: 5));
    await pumpState(const AsyncValue.ready('ready again'));
    await tester.pump();

    expect(tester.takeException(), isNull);
    expect(find.text('ready again'), findsOneWidget);
  });

  testWidgets('refresh continues to display the previous payload', (
    tester,
  ) async {
    Widget app(AsyncValue<String> value) => MaterialApp(
      theme: PeoTheme.light,
      home: Scaffold(
        body: AsyncView<String>(
          value: value,
          builder: (context, data) => Text(data),
        ),
      ),
    );

    await tester.pumpWidget(app(const AsyncValue.ready('existing data')));
    await tester.pumpWidget(
      app(const AsyncValue<String>.ready('existing data').refreshing()),
    );

    expect(find.text('existing data'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('refresh preserves state in the rendered payload', (
    tester,
  ) async {
    Widget app(AsyncValue<String> value) => MaterialApp(
      home: Scaffold(
        body: AsyncView<String>(
          value: value,
          builder: (context, data) => _StatefulPayload(label: data),
        ),
      ),
    );

    await tester.pumpWidget(app(const AsyncValue.ready('item')));
    await tester.tap(find.byType(ElevatedButton));
    await tester.pump();
    expect(find.text('item: 1'), findsOneWidget);

    await tester.pumpWidget(
      app(const AsyncValue<String>.ready('item').refreshing()),
    );
    expect(find.text('item: 1'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('reusing a child key across overlapping transitions is safe', (
    tester,
  ) async {
    Widget app(AsyncValue<String> value) => MaterialApp(
      theme: PeoTheme.light,
      home: Scaffold(
        body: AsyncView<String>(
          value: value,
          builder: (context, data) =>
              Text(data, key: const ValueKey('payload')),
        ),
      ),
    );

    await tester.pumpWidget(
      app(const AsyncValue.ready('first')),
      duration: Duration.zero,
    );
    await tester.pumpWidget(
      app(
        const AsyncValue.failure(
          ApiException(code: 'failure', message: 'Request failed'),
        ),
      ),
      duration: Duration.zero,
    );
    await tester.pump(const Duration(milliseconds: 20));
    await tester.pumpWidget(
      app(const AsyncValue.ready('second')),
      duration: Duration.zero,
    );
    await tester.pump();

    expect(tester.takeException(), isNull);
    expect(find.text('second'), findsOneWidget);
  });

  testWidgets('reduced motion still builds rapid transitions without errors', (
    tester,
  ) async {
    Widget app(AsyncValue<String> value) => MaterialApp(
      theme: PeoTheme.light,
      home: MediaQuery(
        data: const MediaQueryData(disableAnimations: true),
        child: Scaffold(
          body: AsyncView<String>(
            value: value,
            builder: (context, data) => Text(data),
          ),
        ),
      ),
    );

    await tester.pumpWidget(app(const AsyncValue.loading()));
    await tester.pumpWidget(app(const AsyncValue.ready('ready')));
    await tester.pumpWidget(app(const AsyncValue.loading()));

    expect(tester.takeException(), isNull);
  });
}

class _StatefulPayload extends StatefulWidget {
  const _StatefulPayload({required this.label});

  final String label;

  @override
  State<_StatefulPayload> createState() => _StatefulPayloadState();
}

class _StatefulPayloadState extends State<_StatefulPayload> {
  int _count = 0;

  @override
  Widget build(BuildContext context) => Column(
    mainAxisSize: MainAxisSize.min,
    children: [
      Text('${widget.label}: $_count'),
      ElevatedButton(
        onPressed: () => setState(() => _count++),
        child: const Text('Increment'),
      ),
    ],
  );
}
