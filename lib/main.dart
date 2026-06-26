import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app.dart';
import 'firebase_options.dart';
import 'i18n/strings.g.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Cihaz diline göre başlat (desteklenmiyorsa temel dil tr).
  LocaleSettings.useDeviceLocale();

  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  } catch (e) {
    // Native yapılandırma eksikse (ör. iOS plist) uygulama yine de açılsın.
    debugPrint('Firebase başlatılamadı: $e');
  }

  // TODO(Faz 5): Firebase başarıyla başladıysa Crashlytics/Analytics bağla.

  runApp(
    TranslationProvider(
      child: const ProviderScope(child: OtizmDestekApp()),
    ),
  );
}
