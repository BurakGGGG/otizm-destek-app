import 'package:flutter/material.dart';

import 'app_colors.dart';

/// Serene Path tasarım sistemi ölçüleri.
class AppRadius {
  const AppRadius._();
  static const double sm = 8; // çip, mini etiket
  static const double md = 12; // input, küçük buton
  static const double lg = 16; // kart
  static const double xl = 24; // büyük yüzey / bottom sheet
  static const double full = 9999;
}

class AppSpacing {
  const AppSpacing._();
  static const double margin = 20; // mobil yan boşluk (1.25rem)
  static const double gutter = 16;
  static const double sm = 8;
  static const double md = 16;
  static const double lg = 24;
}

/// Uygulama teması (Serene Path). Otizm dostu: bol boşluk, sade tipografi,
/// gölge yerine ince çizgi/tonal katman, büyük dokunma hedefleri.
/// Satır (Row) içinde kullanılacak buton biçimleri.
///
/// Tema, dolgulu ve çerçeveli butonlara `Size.fromHeight(minTapTarget)`
/// veriyor; bu **asgari genişliği sonsuz** yapar. Row çocuklarına sınırsız
/// genişlik verdiği için sarmalanmamış bir buton "BoxConstraints forces an
/// infinite width" hatasıyla ekranı çökertir. İki çözüm var:
/// * buton satırı paylaşıp esneyecekse `Expanded` ile sarmalayın,
/// * metin alanı gibi bir öğenin yanında kompakt duracaksa bu biçimi verin.
class AppButtonStyles {
  const AppButtonStyles._();

  static ButtonStyle get inlineFilled =>
      FilledButton.styleFrom(minimumSize: const Size(0, AppTheme.minTapTarget));

  static ButtonStyle get inlineOutlined => OutlinedButton.styleFrom(
        minimumSize: const Size(0, AppTheme.minTapTarget),
      );

  /// İkincil (tonal) dolgu biçimi.
  ///
  /// Temadaki `filledButtonTheme` bütün FilledButton türevlerine uygulandığı
  /// için `FilledButton.tonal*` de birincil maviyle çiziliyordu; ekranda iki
  /// eylem yan yana durunca hangisinin ana eylem olduğu ayırt edilemiyordu.
  /// İkincil eylemler bu biçimle yumuşak zemin + birincil metin alır.
  static ButtonStyle tonal(BuildContext context) => FilledButton.styleFrom(
        backgroundColor: context.colors.primaryContainer,
        foregroundColor: context.colors.primary,
        minimumSize: const Size.fromHeight(AppTheme.minTapTarget),
      );

  /// Satır içi tonal biçim (asgari genişlik sonlu — bkz. [inlineFilled]).
  static ButtonStyle inlineTonal(BuildContext context) =>
      FilledButton.styleFrom(
        backgroundColor: context.colors.primaryContainer,
        foregroundColor: context.colors.primary,
        minimumSize: const Size(0, AppTheme.minTapTarget),
      );
}

class AppTheme {
  const AppTheme._();

  static const String _fontFamily = 'Inter';

  /// Emoji ve özel simgeler için sistem emoji ailesi yedeği (mesaj önizlemesi,
  /// PECS etiketi, ruh hâli gibi metinler tema tipografisiyle çizilir).
  static const List<String> _fontFallback = ['Noto Color Emoji'];
  static const double minTapTarget = 48;

  static ThemeData get light => _build(AppPalette.light, Brightness.light);
  static ThemeData get dark => _build(AppPalette.dark, Brightness.dark);

  /// Erişilebilirlik tercihlerine göre uyarlanmış tema.
  ///
  /// [reduceMotion] açıkken sayfa geçiş animasyonları kaldırılır (hareket
  /// duyarlılığı otizmde yaygındır).
  static ThemeData themeFor({
    required AppPalette palette,
    required Brightness brightness,
    bool reduceMotion = false,
  }) {
    return _build(palette, brightness, reduceMotion: reduceMotion);
  }

  static ThemeData _build(
    AppPalette p,
    Brightness brightness, {
    bool reduceMotion = false,
  }) {
    final colorScheme =
        ColorScheme.fromSeed(
          seedColor: p.primary,
          brightness: brightness,
        ).copyWith(
          primary: p.primary,
          onPrimary: p.onPrimary,
          primaryContainer: p.primaryContainer,
          secondary: p.secondary,
          surface: p.surface,
          error: p.error,
          outline: p.border,
          outlineVariant: p.border,
          onSurface: p.textPrimary,
          onSurfaceVariant: p.textSecondary,
        );

    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: p.background,
      fontFamily: _fontFamily,
      fontFamilyFallback: _fontFallback,
      visualDensity: VisualDensity.comfortable,
      splashFactory: reduceMotion
          ? NoSplash.splashFactory
          : InkRipple.splashFactory,
      pageTransitionsTheme: reduceMotion
          ? const PageTransitionsTheme(
              builders: {
                TargetPlatform.android: _NoTransitionsBuilder(),
                TargetPlatform.iOS: _NoTransitionsBuilder(),
              },
            )
          : const PageTransitionsTheme(),
      extensions: [p],
      dividerTheme: DividerThemeData(color: p.border, thickness: 1, space: 1),
      appBarTheme: AppBarTheme(
        backgroundColor: p.background,
        foregroundColor: p.textPrimary,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        titleTextStyle: TextStyle(
          fontFamily: _fontFamily,
          fontFamilyFallback: _fontFallback,
          fontSize: 18,
          fontWeight: FontWeight.w700,
          color: p.textPrimary,
        ),
      ),
      cardTheme: CardThemeData(
        color: p.surface,
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.lg),
          side: BorderSide(color: p.border),
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: p.primary,
          foregroundColor: p.onPrimary,
          minimumSize: const Size.fromHeight(minTapTarget),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.md),
          ),
          textStyle: const TextStyle(
            fontFamily: _fontFamily,
            fontFamilyFallback: _fontFallback,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: p.primary,
          minimumSize: const Size.fromHeight(minTapTarget),
          side: BorderSide(color: p.border),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.md),
          ),
          textStyle: const TextStyle(
            fontFamily: _fontFamily,
            fontFamilyFallback: _fontFallback,
            fontSize: 15,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(foregroundColor: p.primary),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: p.primary.withValues(alpha: 0.10),
        selectedColor: p.primary,
        disabledColor: p.surfaceVariant,
        showCheckmark: false,
        labelStyle: TextStyle(
          fontFamily: _fontFamily,
          fontFamilyFallback: _fontFallback,
          color: p.primary,
          fontWeight: FontWeight.w600,
          fontSize: 12.5,
        ),
        secondaryLabelStyle: TextStyle(
          fontFamily: _fontFamily,
          fontFamilyFallback: _fontFallback,
          color: p.onPrimary,
          fontWeight: FontWeight.w600,
          fontSize: 12.5,
        ),
        labelPadding: const EdgeInsets.symmetric(horizontal: 4),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
        side: BorderSide.none,
        shape: const StadiumBorder(),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: p.surface,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),
        hintStyle: TextStyle(color: p.textTertiary),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.md),
          borderSide: BorderSide(color: p.border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.md),
          borderSide: BorderSide(color: p.border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.md),
          borderSide: BorderSide(color: p.primary, width: 2),
        ),
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: p.surface,
        surfaceTintColor: Colors.transparent,
        indicatorColor: p.primary.withValues(alpha: 0.14),
        indicatorShape: const StadiumBorder(),
        elevation: 0,
        height: 68,
        labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
        labelTextStyle: WidgetStateProperty.resolveWith(
          (states) => TextStyle(
            fontFamily: _fontFamily,
            fontFamilyFallback: _fontFallback,
            fontSize: 12,
            fontWeight: states.contains(WidgetState.selected)
                ? FontWeight.w700
                : FontWeight.w500,
            color: states.contains(WidgetState.selected)
                ? p.primary
                : p.textSecondary,
          ),
        ),
        iconTheme: WidgetStateProperty.resolveWith(
          (states) => IconThemeData(
            size: 24,
            color: states.contains(WidgetState.selected)
                ? p.primary
                : p.textTertiary,
          ),
        ),
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: p.primary,
        foregroundColor: p.onPrimary,
        elevation: 0,
        focusElevation: 0,
        hoverElevation: 0,
        highlightElevation: 0,
        extendedTextStyle: const TextStyle(
          fontFamily: _fontFamily,
          fontFamilyFallback: _fontFallback,
          fontSize: 15,
          fontWeight: FontWeight.w600,
        ),
        shape: const StadiumBorder(),
      ),
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        backgroundColor: brightness == Brightness.light
            ? p.textPrimary
            : p.surfaceVariant,
        contentTextStyle: TextStyle(
          fontFamily: _fontFamily,
          fontFamilyFallback: _fontFallback,
          fontSize: 14,
          fontWeight: FontWeight.w500,
          height: 1.4,
          color: brightness == Brightness.light ? Colors.white : p.textPrimary,
        ),
        actionTextColor: brightness == Brightness.light
            ? p.primaryContainer
            : p.primary,
        elevation: 0,
        insetPadding: const EdgeInsets.all(AppSpacing.gutter),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.md),
        ),
      ),
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: p.surface,
        surfaceTintColor: Colors.transparent,
        modalBackgroundColor: p.surface,
        elevation: 0,
        modalElevation: 0,
        showDragHandle: true,
        dragHandleColor: p.border,
        dragHandleSize: const Size(40, 4),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(AppRadius.xl),
          ),
        ),
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: p.surface,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.xl),
        ),
        titleTextStyle: TextStyle(
          fontFamily: _fontFamily,
          fontFamilyFallback: _fontFallback,
          fontSize: 18,
          fontWeight: FontWeight.w700,
          color: p.textPrimary,
        ),
        contentTextStyle: TextStyle(
          fontFamily: _fontFamily,
          fontFamilyFallback: _fontFallback,
          fontSize: 14,
          height: 1.5,
          color: p.textSecondary,
        ),
      ),
      popupMenuTheme: PopupMenuThemeData(
        color: p.surface,
        surfaceTintColor: Colors.transparent,
        elevation: 3,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.lg),
          side: BorderSide(color: p.border),
        ),
        textStyle: TextStyle(
          fontFamily: _fontFamily,
          fontFamilyFallback: _fontFallback,
          fontSize: 14,
          color: p.textPrimary,
        ),
      ),
      tabBarTheme: TabBarThemeData(
        labelColor: p.primary,
        unselectedLabelColor: p.textSecondary,
        indicatorColor: p.primary,
        indicatorSize: TabBarIndicatorSize.tab,
        dividerColor: p.border,
        labelStyle: const TextStyle(
          fontFamily: _fontFamily,
          fontFamilyFallback: _fontFallback,
          fontSize: 14,
          fontWeight: FontWeight.w700,
        ),
        unselectedLabelStyle: const TextStyle(
          fontFamily: _fontFamily,
          fontFamilyFallback: _fontFallback,
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
        overlayColor: WidgetStatePropertyAll(
          p.primary.withValues(alpha: 0.06),
        ),
      ),
      listTileTheme: ListTileThemeData(
        iconColor: p.textSecondary,
        titleTextStyle: TextStyle(
          fontFamily: _fontFamily,
          fontFamilyFallback: _fontFallback,
          fontSize: 15,
          fontWeight: FontWeight.w600,
          height: 1.35,
          color: p.textPrimary,
        ),
        subtitleTextStyle: TextStyle(
          fontFamily: _fontFamily,
          fontFamilyFallback: _fontFallback,
          fontSize: 13,
          height: 1.4,
          color: p.textSecondary,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.md),
        ),
      ),
      progressIndicatorTheme: ProgressIndicatorThemeData(
        color: p.primary,
        linearTrackColor: p.surfaceVariant,
        circularTrackColor: p.surfaceVariant,
        linearMinHeight: 8,
      ),
      tooltipTheme: TooltipThemeData(
        decoration: BoxDecoration(
          color: p.textPrimary.withValues(alpha: 0.92),
          borderRadius: BorderRadius.circular(AppRadius.sm),
        ),
        textStyle: TextStyle(
          fontFamily: _fontFamily,
          fontFamilyFallback: _fontFallback,
          fontSize: 12,
          color: p.surface,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        waitDuration: const Duration(milliseconds: 500),
      ),
      segmentedButtonTheme: SegmentedButtonThemeData(
        style: ButtonStyle(
          textStyle: const WidgetStatePropertyAll(
            TextStyle(
              fontFamily: _fontFamily,
              fontFamilyFallback: _fontFallback,
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
          ),
          side: WidgetStatePropertyAll(BorderSide(color: p.border)),
          shape: WidgetStatePropertyAll(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppRadius.md),
            ),
          ),
        ),
      ),
      textTheme: TextTheme(
        headlineLarge: TextStyle(
          fontWeight: FontWeight.w700,
          fontSize: 24,
          height: 1.33,
          letterSpacing: -0.01,
          color: p.textPrimary,
        ),
        headlineSmall: TextStyle(
          fontWeight: FontWeight.w700,
          fontSize: 20,
          height: 1.4,
          color: p.textPrimary,
        ),
        titleMedium: TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 16,
          height: 1.4,
          color: p.textPrimary,
        ),
        bodyLarge: TextStyle(fontSize: 16, height: 1.5, color: p.textPrimary),
        bodyMedium: TextStyle(fontSize: 14, height: 1.5, color: p.textPrimary),
        bodySmall: TextStyle(fontSize: 13, height: 1.5, color: p.textSecondary),
        titleSmall: TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 15,
          height: 1.4,
          color: p.textPrimary,
        ),
        labelLarge: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: p.textPrimary,
        ),
        labelMedium: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: p.textSecondary,
        ),
        labelSmall: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.1,
          color: p.textSecondary,
        ),
      ),
    );
  }
}

/// Hareket azaltma açıkken kullanılan geçişsiz sayfa animasyonu.
class _NoTransitionsBuilder extends PageTransitionsBuilder {
  const _NoTransitionsBuilder();

  @override
  Widget buildTransitions<T>(
    PageRoute<T> route,
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) => child;
}
