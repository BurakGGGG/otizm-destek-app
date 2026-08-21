import 'package:flutter_test/flutter_test.dart';
import 'package:otizm_destek_app/features/groups/domain/group.dart';
import 'package:otizm_destek_app/features/groups/presentation/group_detail_screen.dart';
import 'package:otizm_destek_app/i18n/strings.g.dart';

import 'support/fake_backend.dart';

/// Grup detayı: üye listesi ve buluşmalar yalnızca üyelere; buluşma planlama
/// yalnızca grubu kurana (backend de aynı kuralı uyguluyor).
void main() {
  setUpAll(loadTestFonts);

  const base = Group(
    id: 'gr1',
    name: 'Okul Öncesi Aileler',
    description: 'Anaokulu sürecindeki aileler.',
    category: 'Okul Dönemi',
    memberCount: 128,
    expertCount: 3,
  );

  test('GroupMeeting saat dilimsiz zamanı okur', () {
    final meeting = GroupMeeting.fromJson(const {
      'id': 'gm1',
      'title': 'Sohbet',
      'startTime': '2026-09-02T20:30:00',
      'meetingUrl': ' https://meet.example.com/a ',
    });
    expect(meeting.startTime, DateTime(2026, 9, 2, 20, 30));
    expect(meeting.meetingUrl, 'https://meet.example.com/a');
    expect(meeting.endTime, isNull);
  });

  test('GroupMember uzman rolünü tanır', () {
    final member = GroupMember.fromJson(const {
      'id': 'u5',
      'fullName': ' Uzm. Psk. Selin ',
      'role': 'EXPERT',
    });
    expect(member.fullName, 'Uzm. Psk. Selin');
    expect(member.isExpert, isTrue);
  });

  testWidgets('üye olmayan kullanıcıya katılma çağrısı gösterilir',
      (tester) async {
    final t = AppLocale.tr.buildSync();
    usePhoneSurface(tester);
    await tester.pumpWidget(hostApp(const GroupDetailScreen(group: base)));
    await settleScreen(tester);

    expect(find.text(t.groups.membersOnly), findsOneWidget);
    expect(find.text(t.groups.membersTitle), findsNothing);
    expect(find.text(t.groups.meetingAdd), findsNothing);
  });

  testWidgets('üye kullanıcı üyeleri ve buluşmaları görür', (tester) async {
    final t = AppLocale.tr.buildSync();
    usePhoneSurface(tester);
    await tester.pumpWidget(hostApp(
      const GroupDetailScreen(group: Group(
        id: 'gr1',
        name: 'Okul Öncesi Aileler',
        memberCount: 128,
        isMember: true,
      )),
    ));
    await settleScreen(tester);

    expect(find.text('Okula uyum sohbeti'), findsOneWidget);
    expect(find.text('Uzm. Psk. Selin Aksoy'), findsOneWidget);
    expect(find.text(t.groups.meetingJoin), findsOneWidget);
    // Grubu kuran değil: planlama düğmesi yok.
    expect(find.text(t.groups.meetingAdd), findsNothing);
  });

  testWidgets('grubu kuran buluşma planlayabilir', (tester) async {
    final t = AppLocale.tr.buildSync();
    usePhoneSurface(tester);
    await tester.pumpWidget(hostApp(
      const GroupDetailScreen(group: Group(
        id: 'gr1',
        name: 'Okul Öncesi Aileler',
        memberCount: 128,
        isMember: true,
        createdByUserId: 'u1',
      )),
    ));
    await settleScreen(tester);

    expect(find.text(t.groups.meetingAdd), findsOneWidget);
    expect(find.byTooltip(t.groups.meetingDelete), findsOneWidget);
  });
}
