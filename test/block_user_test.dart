import 'package:flutter_test/flutter_test.dart';
import 'package:otizm_destek_app/features/messaging/domain/conversation.dart';
import 'package:otizm_destek_app/features/messaging/presentation/conversation_thread_screen.dart';
import 'package:otizm_destek_app/features/settings/presentation/blocked_users_screen.dart';
import 'package:otizm_destek_app/i18n/strings.g.dart';

import 'support/fake_backend.dart';

/// Kullanıcı engelleme: birebir sohbette başlıktan, liste ve kaldırma
/// Ayarlar > Gizlilik altında.
void main() {
  setUpAll(loadTestFonts);

  test('birebir sohbette karşı taraf bulunur, grupta bulunmaz', () {
    const direct = Conversation(
      id: 'c1',
      type: 'DIRECT',
      participants: [
        Participant(id: 'u1', fullName: 'Ben'),
        Participant(id: 'u2', fullName: 'Karşı taraf'),
      ],
    );
    const group = Conversation(
      id: 'c2',
      type: 'GROUP',
      participants: [
        Participant(id: 'u1', fullName: 'Ben'),
        Participant(id: 'u2', fullName: 'Biri'),
      ],
    );
    expect(direct.otherParticipantId('u1'), 'u2');
    expect(group.otherParticipantId('u1'), isNull);
  });

  testWidgets('grup sohbetinde engelleme düğmesi yok', (tester) async {
    final t = AppLocale.tr.buildSync();
    usePhoneSurface(tester);
    await tester.pumpWidget(hostApp(
      const ConversationThreadScreen(conversationId: 'cv1', title: 'Grup'),
    ));
    await settleScreen(tester);
    expect(find.byTooltip(t.messages.blockUser), findsNothing);
  });

  testWidgets('birebir sohbette engelleme düğmesi var', (tester) async {
    final t = AppLocale.tr.buildSync();
    usePhoneSurface(tester);
    await tester.pumpWidget(hostApp(
      const ConversationThreadScreen(
        conversationId: 'cv1',
        title: 'Zeynep A.',
        otherUserId: 'u2',
      ),
    ));
    await settleScreen(tester);
    expect(find.byTooltip(t.messages.blockUser), findsOneWidget);
  });

  testWidgets('engellenenler listesi kaldırma sunar', (tester) async {
    final t = AppLocale.tr.buildSync();
    usePhoneSurface(tester);
    await tester.pumpWidget(hostApp(const BlockedUsersScreen()));
    await settleScreen(tester);
    expect(find.text('Kerem T.'), findsOneWidget);
    expect(find.text(t.settings.blockedRemove), findsOneWidget);
  });
}
