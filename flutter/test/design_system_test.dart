import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:peo_web/theme/peo_theme.dart';
import 'package:peo_web/widgets/async_view.dart';
import 'package:peo_web/widgets/motion.dart';
import 'package:peo_web/widgets/responsive.dart';

void main() {
  test('Peo theme keeps content light and the navigation brand-dark', () {
    final theme = PeoTheme.light;

    expect(theme.useMaterial3, isTrue);
    expect(theme.colorScheme.brightness, Brightness.light);
    expect(PeoTokens.background, Colors.white);
    expect(theme.scaffoldBackgroundColor, Colors.white);
    expect(theme.appBarTheme.backgroundColor, PeoTokens.navBackground);
    expect(theme.appBarTheme.foregroundColor, PeoTokens.navText);
    expect(theme.drawerTheme.backgroundColor, PeoTokens.navBackground);
    expect(theme.cardTheme.color, Colors.white);
    expect(theme.colorScheme.surfaceContainerLowest, PeoTokens.background);
    expect(theme.colorScheme.surface, PeoTokens.panel);
    expect(theme.colorScheme.surfaceContainer, PeoTokens.panelRaised);
    expect(theme.colorScheme.primary, const Color(0xFF007BFC));
    expect(theme.colorScheme.secondary, const Color(0xFF51B9FF));
    expect(theme.colorScheme.primary, PeoTokens.accent);
    expect(theme.colorScheme.secondary, PeoTokens.accentAlt);
    expect(theme.textTheme.headlineMedium?.fontSize, PeoTokens.headlineMedium);
    expect(theme.inputDecorationTheme.focusedBorder, isNotNull);
    expect(theme.filledButtonTheme.style, isNotNull);
  });

  test('responsive columns follow the mobile, tablet, and desktop widths', () {
    expect(PeoBreakpoints.isMobile(390), isTrue);
    expect(PeoBreakpoints.isMobile(640), isFalse);
    expect(PeoBreakpoints.isDesktop(1023), isFalse);
    expect(PeoBreakpoints.isDesktop(1024), isTrue);

    // Store content widths after its horizontal page padding is applied.
    expect(PeoBreakpoints.gridColumns(390 - 32, minTileWidth: 300), 1);
    expect(PeoBreakpoints.gridColumns(768 - 64, minTileWidth: 300), 2);
    expect(
      PeoBreakpoints.gridColumns(1240 - 64, minTileWidth: 300, maxColumns: 3),
      3,
    );
  });

  testWidgets('keyboard focus and reduced motion remain usable', (
    tester,
  ) async {
    final focusNode = FocusNode();
    addTearDown(focusNode.dispose);

    await tester.pumpWidget(
      MaterialApp(
        theme: PeoTheme.light,
        home: MediaQuery(
          data: const MediaQueryData(disableAnimations: true),
          child: Scaffold(
            body: PageEntrance(
              child: Column(
                children: [
                  TextField(
                    focusNode: focusNode,
                    decoration: const InputDecoration(labelText: 'Email'),
                  ),
                  const EmptyPanel(message: 'Nothing here yet.'),
                ],
              ),
            ),
          ),
        ),
      ),
    );

    await tester.sendKeyEvent(LogicalKeyboardKey.tab);
    await tester.pump();

    expect(focusNode.hasFocus, isTrue);
    expect(find.text('Nothing here yet.'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('adaptive grid lays out without overflow at target widths', (
    tester,
  ) async {
    for (final width in [390.0, 768.0, 1280.0]) {
      tester.view.physicalSize = Size(width, 900);
      tester.view.devicePixelRatio = 1;
      await tester.pumpWidget(
        MaterialApp(
          theme: PeoTheme.light,
          home: Scaffold(
            body: Center(
              child: SizedBox(
                width: width - 32,
                child: AdaptiveGrid(
                  minTileWidth: 300,
                  maxColumns: 3,
                  children: [
                    for (var i = 0; i < 6; i++)
                      Card(child: SizedBox(height: 80, child: Text('Plan $i'))),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.text('Plan 0'), findsOneWidget);
      expect(tester.takeException(), isNull, reason: 'width $width');
    }
    tester.view.resetPhysicalSize();
    tester.view.resetDevicePixelRatio();
  });
}
