import 'package:flutter/material.dart';

/// Etkinlik tipi kodları — DB'de sabit kod saklanır (etiketler i18n'den gelir,
/// güvenle çevrilebilir). Renkler web ile aynı.
class CalendarEventType {
  const CalendarEventType(this.code, this.color, this.icon);
  final String code;
  final Color color;
  final IconData icon;
}

const _terapi = Color(0xFF4F46E5);
const _doktor = Color(0xFF059669);
const _egitim = Color(0xFFD97706);
const _aktivite = Color(0xFFDC2626);
const _appointment = Color(0xFF0EA5E9);
const _diger = Color(0xFF6B7280);

const kCalendarEventTypes = [
  CalendarEventType('TERAPI', _terapi, Icons.psychology_outlined),
  CalendarEventType('DOKTOR', _doktor, Icons.medical_services_outlined),
  CalendarEventType('EGITIM', _egitim, Icons.menu_book_outlined),
  CalendarEventType('AKTIVITE', _aktivite, Icons.directions_run_outlined),
  CalendarEventType('APPOINTMENT', _appointment, Icons.videocam_outlined),
  CalendarEventType('DIGER', _diger, Icons.label_outline),
];

CalendarEventType calendarTypeOf(String? code) {
  for (final t in kCalendarEventTypes) {
    if (t.code == code) return t;
  }
  return kCalendarEventTypes.last; // DIGER
}

/// Hatırlatma seçenekleri (dakika); null = kapalı. Web ile aynı.
const kReminderOptions = <int?>[null, 15, 30, 60, 120, 1440];

/// Etkinlik durumları.
const kCalendarStatuses = ['PLANNED', 'COMPLETED', 'CANCELLED'];

/// Backend `CalendarEventDto` karşılığı (takvim etkinliği).
class CalendarEvent {
  const CalendarEvent({
    required this.id,
    required this.title,
    required this.startTime,
    this.description,
    this.eventType = 'DIGER',
    this.endTime,
    this.status = 'PLANNED',
    this.location,
    this.reminderMinutesBefore,
    this.color,
    this.childId,
    this.childName,
  });

  final String id;
  final String title;
  final DateTime startTime;
  final String? description;
  final String eventType;
  final DateTime? endTime;
  final String status;
  final String? location;
  final int? reminderMinutesBefore;
  final String? color;
  final String? childId;
  final String? childName;

  bool get isCancelled => status == 'CANCELLED';
  bool get isCompleted => status == 'COMPLETED';

  factory CalendarEvent.fromJson(Map<String, dynamic> json) {
    return CalendarEvent(
      id: json['id']?.toString() ?? '',
      title: json['title'] as String? ?? '',
      startTime:
          DateTime.tryParse(json['startTime']?.toString() ?? '') ??
              DateTime.now(),
      description: json['description'] as String?,
      eventType: json['eventType'] as String? ?? 'DIGER',
      endTime: DateTime.tryParse(json['endTime']?.toString() ?? ''),
      status: json['status'] as String? ?? 'PLANNED',
      location: json['location'] as String?,
      reminderMinutesBefore:
          (json['reminderMinutesBefore'] as num?)?.toInt(),
      color: json['color'] as String?,
      childId: json['childId']?.toString(),
      childName: json['childName'] as String?,
    );
  }
}
