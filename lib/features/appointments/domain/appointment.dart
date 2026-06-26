/// Backend `AppointmentDto` karşılığı (randevu).
class Appointment {
  const Appointment({
    required this.id,
    required this.date,
    required this.time,
    required this.status,
    this.expertName,
    this.expertTitle,
    this.childName,
    this.type,
  });

  final String id;
  final DateTime date;
  final String time; // "HH:mm"
  final String status; // PENDING | CONFIRMED | COMPLETED | CANCELLED ...
  final String? expertName;
  final String? expertTitle;
  final String? childName;
  final String? type;

  bool get isCancelled => status.toUpperCase() == 'CANCELLED';

  /// Bugün veya gelecekteki, iptal edilmemiş randevu.
  bool get isUpcoming {
    if (isCancelled) return false;
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
      expertName: json['expertName'] as String?,
      expertTitle: json['expertTitle'] as String?,
      childName: json['childName'] as String?,
      type: json['type'] as String?,
    );
  }
}
