import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:otizm_destek_app/features/auth/domain/app_user.dart';
import 'package:otizm_destek_app/features/settings/presentation/settings_screen.dart';
import 'package:otizm_destek_app/i18n/strings.g.dart';

import 'support/fake_backend.dart';

/// Gizlilik tercihleri: dördü sunucuda da saklanır, eşleşme tercihleri
/// (supportIntents / communicationPreferences) sunucudan gelir.
void main() {
  setUpAll(loadTestFonts);

  test('kullanıcı gizlilik alanlarını okur, varsayılanları korur', () {
    final user = AppUser.fromJson(const {
      'id': 'u1',
      'email': 'a@b.c',
      'fullName': 'Elif',
      'role': 'PARENT',
      'allowDirectMessages': false,
      'hideOnlineStatus': true,
      'supportIntents': ['MENTOR_ARIYOR', 'YEREL_BULUSMA'],
      'communicationPreferences': ['AKSAM'],
    });
    expect(user.allowDirectMessages, isFalse);
    expect(user.hideOnlineStatus, isTrue);
    // Gelmeyen alanlar web ile aynı varsayılanlara düşer.
    expect(user.allowFamilyMessages, isTrue);
    expect(user.approximateLocationOnly, isTrue);
    expect(user.supportIntents, ['MENTOR_ARIYOR', 'YEREL_BULUSMA']);
    expect(user.communicationPreferences, ['AKSAM']);
  });

  testWidgets('ayarlarda eşleşme tercihleri sunucudaki değerle işaretli',
      (tester) async {
    final t = AppLocale.tr.buildSync();
    usePhoneSurface(tester);
    tester.view.physicalSize = const Size(1080, 5200);
    addTearDown(tester.view.resetPhysicalSize);

    await tester.pumpWidget(hostApp(const SettingsScreen()));
    await settleScreen(tester);

    expect(find.text(t.settings.privacyFamilyMessages), findsOneWidget);
    expect(find.text(t.settings.matchingTitle), findsOneWidget);

    final selected = tester
        .widgetList<FilterChip>(find.byType(FilterChip))
        .where((chip) => chip.selected)
        .length;
    // Sahte kullanıcıda iki tercih işaretli (bkz. fake_backend).
    expect(selected, 2);
  });
}
