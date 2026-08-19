import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:otizm_destek_app/i18n/strings.g.dart';

import 'support/fake_backend.dart';

/// Her ekranı sahte veriyle gerçekten kurar ve hiçbir çizim/düzen hatası
/// atmadığını doğrular. Tema, satır içindeki butonlara sonsuz asgari genişlik
/// verdiği için düzen hataları burada patlar; bu tarama şimdiye dek randevu
/// kartı ve benzer aileler ekranındaki gerçek çökmeleri yakaladı.
///
/// Ekran listesi ekran görüntüsü üreteciyle ortaktır
/// (`test/support/fake_backend.dart` → `screenCatalog`).
void main() {
  setUpAll(() async {
    LocaleSettings.setLocaleSync(AppLocale.tr);
    // Gerçek fontlar olmadan metinler test fontunun sabit genişliğiyle
    // çizilir ve olmayan taşmalar raporlanır.
    await loadTestFonts();
  });
  setUp(() => LocaleSettings.setLocaleSync(AppLocale.tr));

  for (final screen in screenCatalog()) {
    testWidgets('${screen.name} hatasız kurulur', (tester) async {
      usePhoneSurface(tester);
      await tester.pumpWidget(
        hostApp(
          screen.build(),
          overrides: screen.overrides,
          variant: screen.variant,
          fontFallback: const [emojiFontFamily],
        ),
      );
      await settleScreen(tester);
      if (screen.after != null) await screen.after!(tester);
      expect(tester.takeException(), isNull);
      expect(find.byType(MaterialApp), findsOneWidget);
    });
  }
}
