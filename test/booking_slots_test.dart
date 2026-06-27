import 'package:flutter_test/flutter_test.dart';
import 'package:otizm_destek_app/features/appointments/domain/expert_availability.dart';

void main() {
  // 2026-06-29 bir Pazartesi (weekday=1).
  final monday = DateTime(2026, 6, 29);
  ExpertAvailability mondayAvail({
    String start = '09:00',
    String end = '12:00',
    bool enabled = true,
  }) =>
      ExpertAvailability(
        dayOfWeek: 1,
        enabled: enabled,
        startTime: start,
        endTime: end,
      );

  // Slot süresi 50 dk, adım 30 dk; 09:00–12:00 → 09:00,09:30,10:00,10:30,11:00.
  // (11:30 + 50 = 12:20 > 12:00 olduğu için dışarıda.)
  test('adım 30 / süre 50 ile slotları üretir', () {
    final slots = buildFreeSlots(
      availabilities: [mondayAvail()],
      date: monday,
      bookedTimes: const [],
      now: DateTime(2026, 6, 28), // dünden bak ki "bugün" elemesi olmasın
    );
    expect(slots, ['09:00', '09:30', '10:00', '10:30', '11:00']);
  });

  test('dolu/engelli saatleri çıkarır', () {
    final slots = buildFreeSlots(
      availabilities: [mondayAvail()],
      date: monday,
      bookedTimes: const ['09:30', '11:00'],
      now: DateTime(2026, 6, 28),
    );
    expect(slots, ['09:00', '10:00', '10:30']);
  });

  test('o gün için müsaitlik yoksa boş döner', () {
    final slots = buildFreeSlots(
      availabilities: [mondayAvail(enabled: false)],
      date: monday,
      bookedTimes: const [],
      now: DateTime(2026, 6, 28),
    );
    expect(slots, isEmpty);
  });

  test('farklı güne ait müsaitlik kullanılmaz', () {
    final tuesday = DateTime(2026, 6, 30); // weekday=2
    final slots = buildFreeSlots(
      availabilities: [mondayAvail()], // sadece Pazartesi
      date: tuesday,
      bookedTimes: const [],
      now: DateTime(2026, 6, 28),
    );
    expect(slots, isEmpty);
  });

  test('bugünse geçmiş saatler elenir', () {
    // "Şimdi" 10:10 → 09:00/09:30/10:00 geçmiş, kalanlar 10:30, 11:00.
    final slots = buildFreeSlots(
      availabilities: [mondayAvail()],
      date: monday,
      bookedTimes: const [],
      now: DateTime(2026, 6, 29, 10, 10),
    );
    expect(slots, ['10:30', '11:00']);
  });
}
