import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:otizm_destek_app/features/messaging/presentation/conversation_thread_screen.dart';
import 'package:otizm_destek_app/features/messaging/presentation/conversations_screen.dart';
import 'package:otizm_destek_app/i18n/strings.g.dart';

import 'support/fake_backend.dart';

/// Grup sohbeti: liste ekranından oluşturma, başlıktan ayar paneli.
void main() {
  setUpAll(loadTestFonts);

  testWidgets('yeni sohbet sayfasında grup modu vardır', (tester) async {
    final t = AppLocale.tr.buildSync();
    usePhoneSurface(tester);
    await tester.pumpWidget(hostApp(const ConversationsScreen()));
    await settleScreen(tester);

    await tester.tap(find.widgetWithText(FloatingActionButton, t.messages.newChat));
    await tester.pumpAndSettle();

    expect(find.text(t.messages.chatGroup), findsOneWidget);
    await tester.tap(find.text(t.messages.chatGroup));
    await tester.pumpAndSettle();

    expect(find.text(t.messages.groupNameLabel), findsOneWidget);
    expect(find.text(t.messages.groupCreate), findsOneWidget);
  });

  testWidgets('grup sohbetinde ayar paneli üyeleri listeler', (tester) async {
    final t = AppLocale.tr.buildSync();
    usePhoneSurface(tester);
    await tester.pumpWidget(hostApp(
      const ConversationThreadScreen(
        conversationId: 'cv2',
        title: 'Okul Öncesi Aileler',
        isGroup: true,
      ),
    ));
    await settleScreen(tester);

    await tester.tap(find.byTooltip(t.messages.groupSettings));
    await tester.pumpAndSettle();

    expect(find.text(t.messages.groupSettings), findsOneWidget);
    expect(find.text(t.messages.groupMembers), findsOneWidget);
    // Kendisi listede yok, diğer üye var.
    expect(find.text('Uzm. Psk. Selin Aksoy'), findsWidgets);
  });

  testWidgets('birebir sohbette grup ayarı yok', (tester) async {
    final t = AppLocale.tr.buildSync();
    usePhoneSurface(tester);
    await tester.pumpWidget(hostApp(
      const ConversationThreadScreen(conversationId: 'cv1', title: 'Selin'),
    ));
    await settleScreen(tester);
    expect(find.byTooltip(t.messages.groupSettings), findsNothing);
  });
}
