import 'dart:ui';

import 'package:flutter_test/flutter_test.dart';
import 'package:otizm_destek_app/features/appointments/domain/appointment.dart';
import 'package:otizm_destek_app/features/appointments/presentation/appointments_screen.dart';
import 'package:otizm_destek_app/i18n/strings.g.dart';

import 'support/fake_backend.dart';

/// Randevu kartı aksiyonları: puanlama yalnızca tamamlanmış ve puanlanmamış
/// randevuda, seri iptali yalnızca tekrarlayan ve iptal edilebilir olanda.
void main() {
  setUpAll(loadTestFonts);

  test('tekrarlayan seans alanları okunur', () {
    final appointment = Appointment.fromJson(const {
      'id': 'a1',
      'date': '2026-09-02',
      'time': '14:30',
      'status': 'CONFIRMED',
      'recurringGroupId': 'rg1',
      'recurrenceIndex': 3,
    });
    expect(appointment.isRecurring, isTrue);
    expect(appointment.recurrenceIndex, 3);
  });

  test('serisiz randevu isRecurring değil', () {
    final appointment = Appointment.fromJson(const {
      'id': 'a2',
      'date': '2026-09-02',
      'time': '14:30',
      'status': 'CONFIRMED',
    });
    expect(appointment.isRecurring, isFalse);
  });

  testWidgets('kart aksiyonları duruma göre görünür', (tester) async {
    final t = AppLocale.tr.buildSync();
    usePhoneSurface(tester);
    tester.view.physicalSize = const Size(1080, 3600);
    addTearDown(tester.view.resetPhysicalSize);

    await tester.pumpWidget(hostApp(const AppointmentsScreen()));
    await settleScreen(tester);

    // a4 tamamlanmış ve puanlanmamış → değerlendir; a3 puanlı → yok.
    expect(find.text(t.appointments.rate), findsOneWidget);
    // a2 seriye ait ve bekliyor → seriyi iptal et + "2. seans" rozeti.
    expect(find.text(t.appointments.cancelSeries), findsOneWidget);
    expect(find.text(t.appointments.seriesIndex(index: 2)), findsOneWidget);
    // a3'ün puanı yıldızlarla gösterilir.
    expect(find.text(t.appointments.ratingShown), findsOneWidget);
  });
}
