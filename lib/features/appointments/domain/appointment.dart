/// Randevu durumu (backend: PENDING/CONFIRMED/COMPLETED/CANCELLED).
enum AppointmentStatusKind { pending, confirmed, completed, cancelled, unknown }

/// Backend `AppointmentDto` karşılığı (randevu).
class Appointment {
  const Appointment({
    required this.id,
    required this.date,
    required this.time,
    required this.status,
    this.expertId,
    this.childId,
    this.expertName,
    this.expertTitle,
    this.parentName,
    this.childName,
    this.type,
    this.notes,
    this.meetingLink,
    this.cancellationReason,
    this.duration,
    this.rating,
  });

  final String id;
  final DateTime date;
  final String time; // "HH:mm"
  final String status; // PENDING | CONFIRMED | COMPLETED | CANCELLED ...
  final String? expertId;
  final String? childId;
  final String? expertName;
  final String? expertTitle;
  final String? parentName;
  final String? childName;
  final String? type; // FACE_TO_FACE | ONLINE
  final String? notes;
  final String? meetingLink;
  final String? cancellationReason;
  final int? duration;
  final int? rating;

  AppointmentStatusKind get statusKind {
    switch (status.toUpperCase()) {
      case 'PENDING':
        return AppointmentStatusKind.pending;
      case 'CONFIRMED':
        return AppointmentStatusKind.confirmed;
      case 'COMPLETED':
        return AppointmentStatusKind.completed;
      case 'CANCELLED':
        return AppointmentStatusKind.cancelled;
      default:
        return AppointmentStatusKind.unknown;
    }
  }

  bool get isCancelled => statusKind == AppointmentStatusKind.cancelled;
  bool get isOnline => (type ?? '').toUpperCase() == 'ONLINE';

  /// Bugün veya gelecekteki, iptal/tamamlanmamış randevu.
  bool get isUpcoming {
    if (isCancelled || statusKind == AppointmentStatusKind.completed) {
      return false;
    }
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    return !date.isBefore(today);
  }

  factory Appointment.fromJson(Map<String, dynamic> json) {
    return Appointment(
      id: json['id']?.toString() ?? '',
      date: DateTime.tryParse(json['date']?.toString() ?? '') ?? DateTime.now(),
      time: json['time'] as String? ?? '',
      status: json['status'] as String? ?? '',
      expertId: json['expertId']?.toString(),
      childId: json['childId']?.toString(),
      expertName: json['expertName'] as String?,
      expertTitle: json['expertTitle'] as String?,
      parentName: json['parentName'] as String?,
      childName: json['childName'] as String?,
      type: json['type'] as String?,
      notes: json['notes'] as String?,
      meetingLink: json['meetingLink'] as String?,
      cancellationReason: json['cancellationReason'] as String?,
      duration: (json['duration'] as num?)?.toInt(),
      rating: (json['rating'] as num?)?.toInt(),
    );
  }
}
