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
    this.ratingComment,
    this.appointmentTopic,
    this.preSessionNotes,
    this.sessionNotes,
    this.sessionSummary,
    this.followUpRecommendations,
    this.followUpTask,
    this.cancellationBy,
    this.lateCancellation = false,
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
  final String? ratingComment;

  /// Randevu detayındaki serbest metinler (veli ve uzmanın girdiği veri).
  final String? appointmentTopic;
  final String? preSessionNotes;
  final String? sessionNotes;
  final String? sessionSummary;
  final String? followUpRecommendations;
  final String? followUpTask;

  /// İptali kimin yaptığı (PARENT | EXPERT | SYSTEM) ve geç iptal bayrağı.
  final String? cancellationBy;
  final bool lateCancellation;

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

  /// Randevunun başlangıç anı — `date` + `time` ("HH:mm" ya da "HH:mm:ss").
  /// Saat okunamazsa günün başlangıcı kullanılır.
  DateTime get startsAt {
    final parts = time.split(':');
    final hour = parts.isNotEmpty ? int.tryParse(parts[0]) ?? 0 : 0;
    final minute = parts.length > 1 ? int.tryParse(parts[1]) ?? 0 : 0;
    return DateTime(date.year, date.month, date.day, hour, minute);
  }

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
      ratingComment: json['ratingComment'] as String?,
      appointmentTopic: json['appointmentTopic'] as String?,
      preSessionNotes: json['preSessionNotes'] as String?,
      sessionNotes: json['sessionNotes'] as String?,
      sessionSummary: json['sessionSummary'] as String?,
      followUpRecommendations: json['followUpRecommendations'] as String?,
      followUpTask: json['followUpTask'] as String?,
      cancellationBy: json['cancellationBy'] as String?,
      lateCancellation: json['lateCancellation'] == true,
    );
  }
}

/// `GET /appointments/{id}/history` — durum değişikliği kaydı.
class AppointmentHistoryEntry {
  const AppointmentHistoryEntry({
    required this.newStatus,
    this.oldStatus,
    this.changedByName,
    this.note,
    this.changedAt,
  });

  final String newStatus;
  final String? oldStatus;
  final String? changedByName;
  final String? note;
  final DateTime? changedAt;

  factory AppointmentHistoryEntry.fromJson(Map<String, dynamic> json) {
    return AppointmentHistoryEntry(
      newStatus: json['newStatus'] as String? ?? '',
      oldStatus: json['oldStatus'] as String?,
      changedByName: json['changedByName'] as String?,
      note: json['note'] as String?,
      changedAt: DateTime.tryParse(json['changedAt']?.toString() ?? ''),
    );
  }
}

/// Randevu özeti (web AppointmentPage başlığındaki sayaçlar).
class AppointmentStats {
  const AppointmentStats({
    required this.today,
    required this.week,
    required this.month,
    required this.pending,
    required this.completed,
    required this.cancelled,
  });

  final int today;
  final int week;
  final int month;
  final int pending;
  final int completed;
  final int cancelled;
}

/// Sayaçlar — iptal edilenler "bugün/bu hafta/bu ay" sayımına girmez.
/// Web'den ayrım: "bu hafta" yalnızca içinde bulunulan haftayı sayar
/// (web `date >= pazartesi` diyip sonraki haftaları da katıyor).
AppointmentStats appointmentStats(List<Appointment> all, {DateTime? now}) {
  final current = now ?? DateTime.now();
  final today = DateTime(current.year, current.month, current.day);
  final weekStart = today.subtract(Duration(days: today.weekday - 1));
  final weekEnd = weekStart.add(const Duration(days: 7));
  bool sameDay(DateTime d) =>
      d.year == today.year && d.month == today.month && d.day == today.day;

  final active = all.where((a) => !a.isCancelled).toList();
  return AppointmentStats(
    today: active.where((a) => sameDay(a.date)).length,
    week: active
        .where((a) => !a.date.isBefore(weekStart) && a.date.isBefore(weekEnd))
        .length,
    month: active
        .where((a) =>
            a.date.year == today.year && a.date.month == today.month)
        .length,
    pending: all
        .where((a) => a.statusKind == AppointmentStatusKind.pending)
        .length,
    completed: all
        .where((a) => a.statusKind == AppointmentStatusKind.completed)
        .length,
    cancelled: all.where((a) => a.isCancelled).length,
  );
}

/// Sıradaki randevu — bugünden itibaren, iptal edilmemiş, tarih+saate göre
/// en yakın olan (web `nextAppointment` birebir; tamamlananlar da dışlanır).
Appointment? nextAppointment(List<Appointment> all, {DateTime? now}) {
  final current = now ?? DateTime.now();
  final today = DateTime(current.year, current.month, current.day);
  final upcoming = all
      .where((a) => !a.isCancelled)
      .where((a) => a.statusKind != AppointmentStatusKind.completed)
      .where((a) => !a.date.isBefore(today))
      .toList()
    ..sort((a, b) => a.startsAt.compareTo(b.startsAt));
  return upcoming.isEmpty ? null : upcoming.first;
}
