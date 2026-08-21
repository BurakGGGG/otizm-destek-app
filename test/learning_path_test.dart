import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:otizm_destek_app/features/guide/data/watched_videos.dart';
import 'package:otizm_destek_app/features/home/presentation/home_tab.dart';
import 'package:otizm_destek_app/i18n/strings.g.dart';

import 'support/fake_backend.dart';

/// Öğrenme yolu kartı: kapatılınca ya da rolün ilk videosu izlenince
/// görünmez (web ile aynı kural).
void main() {
  setUpAll(loadTestFonts);

  testWidgets('yeni kullanıcıya rehber kartı gösterilir', (tester) async {
    final t = AppLocale.tr.buildSync();
    usePhoneSurface(tester);
    await tester.pumpWidget(hostApp(const Scaffold(body: HomeTab())));
    await settleScreen(tester);
    expect(find.text(t.home.learningPathTitle), findsOneWidget);
  });

  testWidgets('ilk video izlendiyse kart görünmez', (tester) async {
    final t = AppLocale.tr.buildSync();
    usePhoneSurface(tester);
    await tester.pumpWidget(hostApp(
      const Scaffold(body: HomeTab()),
      overrides: [
        watchedVideosProvider.overrideWith(_WatchedFirstVideo.new),
      ],
    ));
    await settleScreen(tester);
    expect(find.text(t.home.learningPathTitle), findsNothing);
  });

  testWidgets('kapatılınca kart kaybolur', (tester) async {
    final t = AppLocale.tr.buildSync();
    usePhoneSurface(tester);
    await tester.pumpWidget(hostApp(const Scaffold(body: HomeTab())));
    await settleScreen(tester);

    await tester.tap(find.byTooltip(t.common.a11y.close).first);
    await tester.pumpAndSettle();
    expect(find.text(t.home.learningPathTitle), findsNothing);
  });
}

class _WatchedFirstVideo extends WatchedVideosController {
  @override
  Set<String> build() => {'02'};
}
