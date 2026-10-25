import 'package:flutter/material.dart';

/// Color and motion tokens shared across Peo's Flutter surfaces.
abstract final class PeoTokens {
  static const background = Color(0xFFFFFFFF);
  static const panel = Color(0xFFFFFFFF);
  static const panelRaised = Color(0xFFF5F8FC);
  static const navBackground = Color(0xFF142149);
  static const navSurface = Color(0xFF1B2E52);
  static const navActive = Color(0xFF253B64);
  static const navHover = Color(0xFF20375F);
  static const navText = Color(0xFFF5F8FF);
  static const navTextMuted = Color(0xFFC6D3E8);
  static const navDivider = Color(0xFF344A70);
  static const accent = Color(0xFF007BFC);
  static const accentAlt = Color(0xFF51B9FF);
  static const accentPale = Color(0xFFC9F4FF);
  static const onAccent = Color(0xFF0B1020);

  static const text = Color(0xFF142149);
  static const textSecondary = Color(0xFF465974);
  static const textMuted = Color(0xFF63748A);
  static const border = Color(0xFFDCE5EF);

  static const success = Color(0xFF1F8056);
  static const warning = Color(0xFF986000);
  static const danger = Color(0xFFBE3E50);

  static const shadow = Color(0x1A142149);
  static const hoverGlow = Color(0x22007BFC);
  static const cardElevation = 0.0;
  static const hoverBlur = 24.0;
  static const hoverLift = 2.0;

  static const displayLarge = 42.0;
  static const displayMedium = 36.0;
  static const displaySmall = 32.0;
  static const headlineLarge = 30.0;
  static const headlineMedium = 26.0;
  static const headlineSmall = 22.0;
  static const titleLarge = 20.0;
  static const titleMedium = 16.0;
  static const titleSmall = 14.0;
  static const bodyLarge = 16.0;
  static const bodyMedium = 14.0;
  static const bodySmall = 12.0;
  static const labelLarge = 13.0;
  static const labelMedium = 12.0;
  static const labelSmall = 11.0;

  static const space1 = 4.0;
  static const space2 = 8.0;
  static const space3 = 12.0;
  static const space4 = 16.0;
  static const space5 = 24.0;
  static const space6 = 32.0;
  static const space7 = 40.0;

  static const radiusSmall = 10.0;
  static const radiusMedium = 16.0;
  static const radiusLarge = 22.0;

  static const borderWidth = 1.0;
  static const focusWidth = 2.0;

  static const motionFast = Duration(milliseconds: 140);
  static const motionStandard = Duration(milliseconds: 200);
}

/// The single Material 3 theme used by the web application.
abstract final class PeoTheme {
  static ThemeData get light {
    final scheme =
        ColorScheme.fromSeed(
          seedColor: PeoTokens.accent,
          brightness: Brightness.light,
        ).copyWith(
          primary: PeoTokens.accent,
          onPrimary: PeoTokens.onAccent,
          primaryContainer: const Color(0xFFD9EBFF),
          onPrimaryContainer: const Color(0xFF123F75),
          secondary: PeoTokens.accentAlt,
          onSecondary: PeoTokens.navBackground,
          secondaryContainer: const Color(0xFFE6F4FF),
          onSecondaryContainer: const Color(0xFF183452),
          tertiary: PeoTokens.warning,
          onTertiary: Colors.white,
          error: PeoTokens.danger,
          onError: Colors.white,
          errorContainer: const Color(0xFFFCEBED),
          onErrorContainer: const Color(0xFF8C2634),
          surface: PeoTokens.panel,
          onSurface: PeoTokens.text,
          onSurfaceVariant: PeoTokens.textSecondary,
          surfaceContainerLowest: PeoTokens.background,
          surfaceContainerLow: PeoTokens.panel,
          surfaceContainer: PeoTokens.panelRaised,
          surfaceContainerHigh: const Color(0xFFEEF3F9),
          surfaceContainerHighest: const Color(0xFFE7EEF6),
          outline: PeoTokens.textMuted,
          outlineVariant: PeoTokens.border,
          shadow: PeoTokens.shadow,
          scrim: const Color(0xB8000000),
        );
    final base = ThemeData(colorScheme: scheme, useMaterial3: true);
    final baseText = base.textTheme.apply(
      bodyColor: PeoTokens.text,
      displayColor: PeoTokens.text,
    );
    final textTheme = baseText.copyWith(
      displayLarge: baseText.displayLarge?.copyWith(
        fontSize: PeoTokens.displayLarge,
        fontWeight: FontWeight.w700,
        height: 1.1,
        letterSpacing: -1.2,
      ),
      displayMedium: baseText.displayMedium?.copyWith(
        fontSize: PeoTokens.displayMedium,
        fontWeight: FontWeight.w700,
        height: 1.12,
        letterSpacing: -0.8,
      ),
      displaySmall: baseText.displaySmall?.copyWith(
        fontSize: PeoTokens.displaySmall,
        fontWeight: FontWeight.w700,
        height: 1.15,
      ),
      headlineLarge: baseText.headlineLarge?.copyWith(
        fontSize: PeoTokens.headlineLarge,
        fontWeight: FontWeight.w700,
        height: 1.18,
      ),
      headlineMedium: baseText.headlineMedium?.copyWith(
        fontSize: PeoTokens.headlineMedium,
        fontWeight: FontWeight.w700,
        height: 1.2,
      ),
      headlineSmall: baseText.headlineSmall?.copyWith(
        fontSize: PeoTokens.headlineSmall,
        fontWeight: FontWeight.w700,
        height: 1.25,
      ),
      titleLarge: baseText.titleLarge?.copyWith(
        fontSize: PeoTokens.titleLarge,
        fontWeight: FontWeight.w600,
        height: 1.3,
      ),
      titleMedium: baseText.titleMedium?.copyWith(
        fontSize: PeoTokens.titleMedium,
        fontWeight: FontWeight.w600,
        height: 1.35,
      ),
      titleSmall: baseText.titleSmall?.copyWith(
        fontSize: PeoTokens.titleSmall,
        fontWeight: FontWeight.w600,
        height: 1.35,
      ),
      bodyLarge: baseText.bodyLarge?.copyWith(
        fontSize: PeoTokens.bodyLarge,
        height: 1.5,
      ),
      bodyMedium: baseText.bodyMedium?.copyWith(
        fontSize: PeoTokens.bodyMedium,
        height: 1.5,
      ),
      bodySmall: baseText.bodySmall?.copyWith(
        fontSize: PeoTokens.bodySmall,
        height: 1.4,
      ),
      labelLarge: baseText.labelLarge?.copyWith(
        fontSize: PeoTokens.labelLarge,
        fontWeight: FontWeight.w600,
      ),
      labelMedium: baseText.labelMedium?.copyWith(
        fontSize: PeoTokens.labelMedium,
        fontWeight: FontWeight.w600,
      ),
      labelSmall: baseText.labelSmall?.copyWith(
        fontSize: PeoTokens.labelSmall,
        fontWeight: FontWeight.w600,
      ),
    );
    final rounded = RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(PeoTokens.radiusMedium),
    );

    return base.copyWith(
      scaffoldBackgroundColor: PeoTokens.background,
      canvasColor: PeoTokens.panel,
      textTheme: textTheme,
      appBarTheme: const AppBarTheme(
        backgroundColor: PeoTokens.navBackground,
        foregroundColor: PeoTokens.navText,
        surfaceTintColor: Colors.transparent,
        elevation: PeoTokens.cardElevation,
        scrolledUnderElevation: 0,
        centerTitle: false,
      ),
      cardTheme: CardThemeData(
        color: PeoTokens.panel,
        surfaceTintColor: Colors.transparent,
        elevation: PeoTokens.cardElevation,
        margin: const EdgeInsets.only(bottom: PeoTokens.space3),
        shape: rounded.copyWith(
          side: const BorderSide(
            color: PeoTokens.border,
            width: PeoTokens.borderWidth,
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: PeoTokens.panelRaised,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: PeoTokens.space4,
          vertical: PeoTokens.space3,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(PeoTokens.radiusSmall),
          borderSide: const BorderSide(color: PeoTokens.border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(PeoTokens.radiusSmall),
          borderSide: const BorderSide(color: PeoTokens.border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(PeoTokens.radiusSmall),
          borderSide: const BorderSide(
            color: PeoTokens.accent,
            width: PeoTokens.focusWidth,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(PeoTokens.radiusSmall),
          borderSide: const BorderSide(color: PeoTokens.danger),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(PeoTokens.radiusSmall),
          borderSide: const BorderSide(
            color: PeoTokens.danger,
            width: PeoTokens.focusWidth,
          ),
        ),
        labelStyle: const TextStyle(color: PeoTokens.textSecondary),
        hintStyle: const TextStyle(color: PeoTokens.textMuted),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          minimumSize: const Size(48, 46),
          padding: const EdgeInsets.symmetric(horizontal: PeoTokens.space4),
          shape: rounded,
          animationDuration: PeoTokens.motionFast,
          textStyle: const TextStyle(fontWeight: FontWeight.w700),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          minimumSize: const Size(48, 46),
          padding: const EdgeInsets.symmetric(horizontal: PeoTokens.space4),
          shape: rounded,
          animationDuration: PeoTokens.motionFast,
          side: const BorderSide(color: PeoTokens.border),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          minimumSize: const Size(44, 44),
          shape: rounded,
          animationDuration: PeoTokens.motionFast,
        ),
      ),
      iconButtonTheme: IconButtonThemeData(
        style: IconButton.styleFrom(
          minimumSize: const Size(44, 44),
          shape: rounded,
          animationDuration: PeoTokens.motionFast,
        ),
      ),
      listTileTheme: ListTileThemeData(
        iconColor: PeoTokens.textSecondary,
        textColor: PeoTokens.text,
        selectedColor: PeoTokens.accent,
        selectedTileColor: scheme.primaryContainer.withValues(alpha: 0.64),
        shape: rounded,
        minVerticalPadding: PeoTokens.space2,
      ),
      tabBarTheme: const TabBarThemeData(
        labelColor: PeoTokens.accent,
        unselectedLabelColor: PeoTokens.textSecondary,
        indicatorColor: PeoTokens.accent,
        dividerColor: PeoTokens.border,
      ),
      chipTheme: base.chipTheme.copyWith(
        backgroundColor: PeoTokens.panelRaised,
        selectedColor: scheme.primaryContainer,
        side: const BorderSide(color: PeoTokens.border),
        shape: rounded,
        labelStyle: const TextStyle(color: PeoTokens.text),
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: PeoTokens.panel,
        surfaceTintColor: Colors.transparent,
        shape: rounded.copyWith(
          side: const BorderSide(color: PeoTokens.border),
        ),
        titleTextStyle: base.textTheme.titleLarge?.copyWith(
          color: PeoTokens.text,
          fontWeight: FontWeight.w700,
        ),
      ),
      popupMenuTheme: PopupMenuThemeData(
        color: PeoTokens.panelRaised,
        surfaceTintColor: Colors.transparent,
        shape: rounded.copyWith(
          side: const BorderSide(color: PeoTokens.border),
        ),
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: PeoTokens.navSurface,
        contentTextStyle: const TextStyle(color: PeoTokens.navText),
        behavior: SnackBarBehavior.floating,
        shape: rounded,
      ),
      dividerTheme: const DividerThemeData(
        color: PeoTokens.border,
        thickness: 1,
        space: PeoTokens.space5,
      ),
      progressIndicatorTheme: const ProgressIndicatorThemeData(
        color: PeoTokens.accent,
        linearTrackColor: PeoTokens.border,
        circularTrackColor: PeoTokens.border,
      ),
      tooltipTheme: const TooltipThemeData(
        decoration: BoxDecoration(
          color: PeoTokens.navSurface,
          borderRadius: BorderRadius.all(
            Radius.circular(PeoTokens.radiusSmall),
          ),
        ),
        textStyle: TextStyle(color: PeoTokens.navText),
      ),
      drawerTheme: const DrawerThemeData(
        backgroundColor: PeoTokens.navBackground,
        surfaceTintColor: Colors.transparent,
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: PeoTokens.navBackground,
        indicatorColor: PeoTokens.navActive,
        labelTextStyle: const WidgetStatePropertyAll(
          TextStyle(color: PeoTokens.navTextMuted),
        ),
      ),
      focusColor: PeoTokens.accent.withValues(alpha: 0.16),
      hoverColor: PeoTokens.accent.withValues(alpha: 0.08),
      splashColor: PeoTokens.accent.withValues(alpha: 0.12),
    );
  }
}
