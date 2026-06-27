/// Backend `ExpertAvailabilityDto` — uzmanın bir gün için müsaitlik planı.
class ExpertAvailability {
  const ExpertAvailability({
    required this.dayOfWeek,
    required this.enabled,
    this.startTime,
    this.endTime,
    this.blockedSlots = const [],
  });

  /// 1=Pazartesi … 7=Pazar (ISO; `DateTime.weekday` ile uyumlu).
  final int dayOfWeek;
  final bool enabled;
  final String? startTime; // "HH:mm"
  final String? endTime; // "HH:mm"
  final List<String> blockedSlots;

  factory ExpertAvailability.fromJson(Map<String, dynamic> json) {
    return ExpertAvailability(
      dayOfWeek: (json['dayOfWeek'] as num?)?.toInt() ?? 0,
      enabled: json['enabled'] as bool? ?? false,
      startTime: json['startTime'] as String?,
      endTime: json['endTime'] as String?,
      blockedSlots:
          (json['blockedSlots'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          const [],
    );
  }
}

int? _toMinutes(String? hhmm) {
  if (hhmm == null) return null;
  final parts = hhmm.split(':');
  if (parts.length < 2) return null;
  final h = int.tryParse(parts[0]);
  final m = int.tryParse(parts[1]);
  if (h == null || m == null) return null;
  return h * 60 + m;
}

String _fromMinutes(int total) {
  final h = (total ~/ 60).toString().padLeft(2, '0');
  final m = (total % 60).toString().padLeft(2, '0');
  return '$h:$m';
}

/// Seçilen [date] için rezervasyon yapılabilir boş slot'ları üretir.
///
/// Backend ile birebir: adım [step] dk, slot süresi [duration] dk; slot ancak
/// `başlangıç + süre <= bitiş` ise eklenir. [bookedTimes] backend'in döndürdüğü
/// **dolu/engelli** başlangıç saatleridir ve çıkarılır. [date] bugünse [now]'dan
/// önceki saatler elenir.
List<String> buildFreeSlots({
  required List<ExpertAvailability> availabilities,
  required DateTime date,
  required List<String> bookedTimes,
  DateTime? now,
  int duration = 50,
  int step = 30,
}) {
  ExpertAvailability? day;
  for (final a in availabilities) {
    if (a.dayOfWeek == date.weekday) {
      day = a;
      break;
    }
  }
  if (day == null || !day.enabled) return const [];

  final start = _toMinutes(day.startTime);
  final end = _toMinutes(day.endTime);
  if (start == null || end == null) return const [];

  final booked = bookedTimes.toSet();
  final current = now ?? DateTime.now();
  final isToday =
      date.year == current.year &&
      date.month == current.month &&
      date.day == current.day;
  final nowMinutes = current.hour * 60 + current.minute;

  final slots = <String>[];
  for (var cursor = start; cursor + duration <= end; cursor += step) {
    final label = _fromMinutes(cursor);
    if (booked.contains(label)) continue;
    if (isToday && cursor <= nowMinutes) continue;
    slots.add(label);
  }
  return slots;
}
