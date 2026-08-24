// Ekran görüntüsü üreteci (test değil, araç).
//
//   flutter test tool/screenshots_test.dart --update-goldens
//
// Çıktılar `build/screens/*.png` altına yazılır (git dışında). Ekranlar
// `test/support/fake_backend.dart` içindeki sahte verilerle kurulur; ağ ya da
// oturum gerekmez. `flutter test` yalnızca `test/` klasörünü çalıştırdığı için
// bu dosya normal takıma girmez — aynı ekran listesi her koşuda
// `test/screens_build_test.dart` tarafından çizilip denetlenir.
//
// Not: tema düzeyindeki metin biçimleri font ailesini ve emoji yedeğini
// taşıyor; ekran kodunda ailesiz bırakılan bir `TextStyle` kalırsa başsız
// render'da kutu çizilir (cihazda sistem fontuna düşer). Yükseltilmiş
// (elevation) yüzeylerin gölgesi başsız render'da sert siyah bir çerçeve gibi
// çıkar — açılır menü/FAB görüntülerindeki bu kusur beklenendir.
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:otizm_destek_app/i18n/strings.g.dart';

import '../test/support/fake_backend.dart';

void main() {
  setUpAll(() async {
    LocaleSettings.setLocaleSync(AppLocale.tr);
    await loadTestFonts();
  });

  for (final screen in screenCatalog()) {
    testWidgets(screen.name, (tester) async {
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
      await expectLater(
        find.byType(MaterialApp),
        matchesGoldenFile('../build/screens/${screen.name}.png'),
      );
    });
  }
}
