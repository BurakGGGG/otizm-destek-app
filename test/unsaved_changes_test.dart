import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:otizm_destek_app/core/widgets/unsaved_changes_guard.dart';
import 'package:otizm_destek_app/features/notes/presentation/note_form_screen.dart';
import 'package:otizm_destek_app/i18n/strings.g.dart';

import 'support/fake_backend.dart';

/// Formdan onaysız çıkışta veri kaybını engelleyen kural.
void main() {
  setUpAll(loadTestFonts);

  Future<void> openGuarded(WidgetTester tester, {required bool dirty}) async {
    await tester.pumpWidget(hostApp(
      Builder(
        builder: (context) => Scaffold(
          body: TextButton(
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute<void>(
                builder: (_) => UnsavedChangesGuard(
                  hasChanges: () => dirty,
                  child: const Scaffold(body: Text('form')),
                ),
              ),
            ),
            child: const Text('aç'),
          ),
        ),
      ),
    ));
    await tester.tap(find.text('aç'));
    await tester.pumpAndSettle();
    expect(find.text('form'), findsOneWidget);
  }

  Future<void> back(WidgetTester tester) async {
    tester.state<NavigatorState>(find.byType(Navigator).first).maybePop();
    await tester.pumpAndSettle();
  }

  testWidgets('boş form onay sormadan kapanır', (tester) async {
    await openGuarded(tester, dirty: false);
    await back(tester);
    expect(find.text('form'), findsNothing);
  });

  testWidgets('doldurulmuş formda onay istenir', (tester) async {
    await openGuarded(tester, dirty: true);
    await back(tester);
    expect(find.text(t.common.unsaved.title), findsOneWidget);

    // "Formda kal" ekranda tutar.
    await tester.tap(find.text(t.common.unsaved.stay));
    await tester.pumpAndSettle();
    expect(find.text('form'), findsOneWidget);

    // "Çık" gerçekten kapatır.
    await back(tester);
    await tester.tap(find.text(t.common.unsaved.leave));
    await tester.pumpAndSettle();
    expect(find.text('form'), findsNothing);
  });

  testWidgets('not formuna yazıldıysa geri tuşu onay ister', (tester) async {
    await tester.pumpWidget(hostApp(
      Builder(
        builder: (context) => Scaffold(
          body: TextButton(
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute<void>(
                builder: (_) => const NoteFormScreen(childId: 'c1'),
              ),
            ),
            child: const Text('aç'),
          ),
        ),
      ),
    ));
    await tester.tap(find.text('aç'));
    await tester.pumpAndSettle();

    await tester.enterText(find.byType(TextField).first, 'Bugün Ada…');
    await tester.pumpAndSettle();
    await back(tester);
    expect(find.text(t.common.unsaved.title), findsOneWidget);
  });
}
