import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:otizm_destek_app/app.dart';
import 'package:otizm_destek_app/core/providers.dart';
import 'package:otizm_destek_app/core/storage/secure_storage.dart';
import 'package:otizm_destek_app/i18n/strings.g.dart';

/// Token okumayı/yazmayı bellek içinde taklit eden sahte depo (platform kanalı yok).
class _FakeSecureStorage extends SecureStorage {
  String? access;
  String? refresh;

  @override
  Future<String?> readAccessToken() async => access;

  @override
  Future<String?> readRefreshToken() async => refresh;

  @override
  Future<void> saveTokens({required String accessToken, String? refreshToken}) async {
    access = accessToken;
    refresh = refreshToken;
  }

  @override
  Future<void> clear() async {
    access = null;
    refresh = null;
  }
}

void main() {
  testWidgets('Oturum yokken giriş ekranı gösterilir',
      (WidgetTester tester) async {
    LocaleSettings.setLocaleSync(AppLocale.tr); // deterministik dil
    await tester.pumpWidget(
      TranslationProvider(
        child: ProviderScope(
          overrides: [
            secureStorageProvider.overrideWithValue(_FakeSecureStorage()),
          ],
          child: const OtizmDestekApp(),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Giriş Yap'), findsOneWidget);
  });
}
