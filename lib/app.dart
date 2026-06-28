import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'core/app_keys.dart';
import 'core/providers.dart';
import 'core/router/app_router.dart';
import 'core/theme/app_theme.dart';
import 'core/theme/theme_mode_provider.dart';
import 'features/auth/presentation/auth_controller.dart';
import 'features/notifications/data/push_service.dart';
import 'i18n/strings.g.dart';

class OtizmDestekApp extends ConsumerWidget {
  const OtizmDestekApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(goRouterProvider);
    final themeMode = ref.watch(themeModeProvider);
    // TranslationProvider üzerinden mevcut dil; dil değişince yeniden çizilir.
    final locale = TranslationProvider.of(context).flutterLocale;

    // Oturum açılınca FCM token'ını kaydet; çıkınca kaldır (Firebase hazırsa).
    ref.listen(authControllerProvider.select((s) => s.status), (prev, next) {
      if (!ref.read(firebaseReadyProvider)) return;
      final push = ref.read(pushServiceProvider);
      if (next == AuthStatus.authenticated) {
        push.init();
      } else if (next == AuthStatus.unauthenticated &&
          prev == AuthStatus.authenticated) {
        push.unregister();
      }
    });

    return MaterialApp.router(
      onGenerateTitle: (context) => context.t.app.name,
      debugShowCheckedModeBanner: false,
      scaffoldMessengerKey: rootScaffoldMessengerKey,
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: themeMode,
      routerConfig: router,
      locale: locale,
      supportedLocales: AppLocaleUtils.supportedLocales,
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
    );
  }
}
