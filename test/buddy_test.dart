import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:otizm_destek_app/core/network/api_exception.dart';
import 'package:otizm_destek_app/features/similar_families/data/buddy_repository.dart';
import 'package:otizm_destek_app/features/similar_families/domain/buddy.dart';
import 'package:otizm_destek_app/features/similar_families/domain/similar_family.dart';
import 'package:otizm_destek_app/features/similar_families/presentation/similar_families_screen.dart';
import 'package:otizm_destek_app/i18n/strings.g.dart';

import 'support/fake_backend.dart';

/// Aile bağlantıları (buddy/mentor) — sözleşme ve çember sekmesi.
void main() {
  setUpAll(loadTestFonts);

  test('BuddyDto alanları okunur', () {
    final buddy = Buddy.fromJson(const {
      'relationshipId': 'r1',
      'buddyId': 'u9',
      'fullName': ' Merve D. ',
      'city': 'Bursa',
      'distanceKm': 4.25,
      'isMentorRelation': true,
      'requestMessage': ' Tanışmak isterim ',
      'status': 'PENDING',
    });
    expect(buddy.relationshipId, 'r1');
    expect(buddy.fullName, 'Merve D.');
    expect(buddy.distanceKm, 4.25);
    expect(buddy.mentorRelation, isTrue);
    expect(buddy.requestMessage, 'Tanışmak isterim');
  });

  test('mentor bayrağı yoksa arkadaş bağlantısıdır', () {
    final buddy = Buddy.fromJson(const {'buddyId': 'u1', 'fullName': 'A'});
    expect(buddy.mentorRelation, isFalse);
    expect(buddy.status, 'NONE');
    expect(buddy.relationshipId, isNull);
  });

  group('geri çekme koşulu', () {
    SimilarFamily family({
      required String status,
      bool byMe = true,
      String? id = 'r1',
    }) =>
        SimilarFamily(
          parentId: 'p1',
          parentName: 'A',
          childAgeRange: '4-6',
          relationshipStatus: status,
          requestedByMe: byMe,
          relationshipId: id,
        );

    test('yalnızca kendi gönderdiğin bekleyen istek geri çekilir', () {
      expect(family(status: 'PENDING').canWithdraw, isTrue);
      expect(family(status: 'PENDING', byMe: false).canWithdraw, isFalse);
      expect(family(status: 'ACCEPTED').canWithdraw, isFalse);
      expect(family(status: 'PENDING', id: null).canWithdraw, isFalse);
    });
  });

  testWidgets('çember sekmesi gelen isteği ve bağlantıları gösterir',
      (tester) async {
    final t = AppLocale.tr.buildSync();
    usePhoneSurface(tester);
    await tester.pumpWidget(hostApp(const SimilarFamiliesScreen()));
    await settleScreen(tester);

    await tester.tap(find.text(t.similar.tabCircle));
    await tester.pumpAndSettle();

    // Gelen istek: ad, not ve iki aksiyon.
    expect(find.text('Merve D.'), findsOneWidget);
    expect(find.textContaining('dil terapisine'), findsOneWidget);
    // Aynı metin buluşma isteği kartında da var (Kabul et / Reddet).
    expect(find.text(t.similar.accept), findsNWidgets(2));
    expect(find.text(t.similar.reject), findsNWidgets(2));

    // Kabul edilmiş bağlantılar: ikisi de kartlarıyla listelenir.
    expect(find.text('Uzm. Psk. Selin Aksoy'), findsOneWidget);
    expect(find.text('Zeynep A.'), findsWidgets);
    expect(find.byTooltip(t.similar.removeBuddy), findsNWidgets(2));
    expect(find.byTooltip(t.similar.message), findsNWidgets(2));
  });

  testWidgets('bekleyen istek kartında geri çekme görünür', (tester) async {
    final t = AppLocale.tr.buildSync();
    usePhoneSurface(tester);
    await tester.pumpWidget(hostApp(const SimilarFamiliesScreen()));
    await settleScreen(tester);

    await tester.dragUntilVisible(
      find.text(t.similar.withdraw),
      find.byType(Scrollable).last,
      const Offset(0, -200),
    );
    expect(find.text(t.similar.withdraw), findsOneWidget);
  });

  testWidgets('bağlantılar yüklenemezse tekrar dene gösterilir',
      (tester) async {
    final t = AppLocale.tr.buildSync();
    usePhoneSurface(tester);
    await tester.pumpWidget(hostApp(
      const SimilarFamiliesScreen(),
      overrides: [
        myBuddiesProvider.overrideWith((ref) async {
          throw const ApiException('Bağlantı yok');
        }),
      ],
    ));
    await settleScreen(tester);

    await tester.tap(find.text(t.similar.tabCircle));
    await tester.pumpAndSettle();

    expect(find.text(t.common.retry), findsOneWidget);
    expect(find.text(t.similar.circleEmpty), findsNothing);
  });
}
