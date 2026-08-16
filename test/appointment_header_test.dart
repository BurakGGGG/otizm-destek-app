import 'package:flutter_test/flutter_test.dart';
import 'package:otizm_destek_app/features/appointments/domain/appointment.dart';
import 'package:otizm_destek_app/features/appointments/presentation/widgets/next_appointment_card.dart';
import 'package:otizm_destek_app/i18n/strings.g.dart';

Appointment _a(
  String id,
  DateTime date,
  String time, {
  String status = 'CONFIRMED',
}) {
  return Appointment(id: id, date: date, time: time, status: status);
}

void main() {
  LocaleSettings.setLocaleSync(AppLocale.tr);
  final t = AppLocale.tr.buildSync();

  // Pazar 16 Ağustos 2026 — hafta pazartesi 10 Ağustos'ta başlar.
  final now = DateTime(2026, 8, 16, 12);

  group('randevu sayaçları', () {
    final list = [
      _a('bugun', DateTime(2026, 8, 16), '09:00'),
      _a('bugun-iptal', DateTime(2026, 8, 16), '10:00', status: 'CANCELLED'),
      _a('hafta-ici', DateTime(2026, 8, 12), '11:00', status: 'COMPLETED'),
      _a('gelecek-hafta', DateTime(2026, 8, 20), '11:00', status: 'PENDING'),
      _a('gecen-ay', DateTime(2026, 7, 30), '11:00'),
    ];

    test('bugün/bu hafta/bu ay iptalleri saymaz', () {
      final stats = appointmentStats(list, now: now);
      expect(stats.today, 1);
      // 12 ve 16 Ağustos bu hafta; 20 Ağustos gelecek hafta (web'de sayılıyor).
      expect(stats.week, 2);
      expect(stats.month, 3);
    });

    test('durum sayaçları tüm kayıtları kapsar', () {
      final stats = appointmentStats(list, now: now);
      expect(stats.pending, 1);
      expect(stats.completed, 1);
      expect(stats.cancelled, 1);
    });
  });

  group('sıradaki randevu', () {
    test('bugünden itibaren en yakın onaylı/bekleyen randevu', () {
      final next = nextAppointment([
        _a('yarin', DateTime(2026, 8, 17), '09:00'),
        _a('bugun-gec', DateTime(2026, 8, 16), '18:00'),
        _a('dun', DateTime(2026, 8, 15), '09:00'),
      ], now: now);
      expect(next?.id, 'bugun-gec');
    });

    test('iptal ve tamamlananlar atlanır', () {
      final next = nextAppointment([
        _a('iptal', DateTime(2026, 8, 16), '13:00', status: 'CANCELLED'),
        _a('bitti', DateTime(2026, 8, 16), '14:00', status: 'COMPLETED'),
        _a('acik', DateTime(2026, 8, 18), '15:00'),
      ], now: now);
      expect(next?.id, 'acik');
    });

    test('uygun randevu yoksa null', () {
      expect(
        nextAppointment([_a('dun', DateTime(2026, 8, 10), '09:00')], now: now),
        isNull,
      );
    });

    test('başlangıç anı tarih + saatten kurulur', () {
      expect(
        _a('x', DateTime(2026, 8, 16), '14:30').startsAt,
        DateTime(2026, 8, 16, 14, 30),
      );
      // Saniyeli format da kabul edilir.
      expect(
        _a('x', DateTime(2026, 8, 16), '14:30:00').startsAt,
        DateTime(2026, 8, 16, 14, 30),
      );
    });
  });

  group('geri sayım metni', () {
    test('gün varsa gün/saat/dakika', () {
      final label = countdownLabel(
        t,
        const Duration(days: 2, hours: 3, minutes: 4, seconds: 5),
      );
      expect(label, '2 gün 3 sa 4 dk kaldı');
    });

    test('aynı gün saat/dakika/saniye', () {
      final label =
          countdownLabel(t, const Duration(hours: 1, minutes: 2, seconds: 3));
      expect(label, '1 sa 2 dk 3 sn kaldı');
    });

    test('süre dolduysa görüşme zamanı', () {
      expect(countdownLabel(t, Duration.zero), t.appointments.countdownNow);
      expect(
        countdownLabel(t, const Duration(minutes: -5)),
        t.appointments.countdownNow,
      );
    });
  });
}
