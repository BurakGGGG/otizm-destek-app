import '../../../core/settings/app_preferences.dart';
import 'app_notification.dart';

/// Bildirim kategorileri — web `notificationUtils.ts` birebir.
enum NotificationCategory { all, appointments, messages, forum, tasks, social, system }

/// Backend bildirim tipi → kategori (web `TYPE_CATEGORY_MAP` birebir).
/// Eşleşmeyen tipler sistem sayılır.
const Map<String, NotificationCategory> kNotificationTypeCategories = {
  'APPOINTMENT_REQUEST': NotificationCategory.appointments,
  'APPOINTMENT_CONFIRMED': NotificationCategory.appointments,
  'APPOINTMENT_CANCELLED': NotificationCategory.appointments,
  'APPOINTMENT_RESCHEDULED': NotificationCategory.appointments,
  'APPOINTMENT_COMPLETED': NotificationCategory.appointments,
  'APPOINTMENT_REMINDER': NotificationCategory.appointments,
  'APPOINTMENT_SOON': NotificationCategory.appointments,
  'APPOINTMENT_RATED': NotificationCategory.appointments,
  'SESSION_NOTES_ADDED': NotificationCategory.appointments,
  'MEETING_LINK_ADDED': NotificationCategory.appointments,
  'CALENDAR_REMINDER': NotificationCategory.appointments,
  'MESSAGE': NotificationCategory.messages,
  'COMMENT': NotificationCategory.forum,
  'CONSULTATION_REPLY': NotificationCategory.forum,
  'BUDDY_REQUEST': NotificationCategory.social,
  'BUDDY_ACCEPT': NotificationCategory.social,
  'MEETING_INVITE': NotificationCategory.social,
  'MEETING_UPDATE': NotificationCategory.social,
  'GROUP_MEETING_SCHEDULED': NotificationCategory.social,
  'GROUP_MEMBER_JOINED': NotificationCategory.social,
  'TASK_ASSIGNED': NotificationCategory.tasks,
  'TASK_COMPLETED': NotificationCategory.tasks,
  'TASK_REVIEWED': NotificationCategory.tasks,
  'TASK_OVERDUE': NotificationCategory.tasks,
  'LOCAL_REMINDER': NotificationCategory.tasks,
  'CONNECTION_AUTO_APPROVED': NotificationCategory.system,
  'PATIENT_LINKED': NotificationCategory.system,
  'CONNECTION_APPROVED': NotificationCategory.system,
  'CONNECTION_REJECTED': NotificationCategory.system,
  'CONNECTION_REVOKED': NotificationCategory.system,
  'EXPERT_APPROVED': NotificationCategory.system,
  'EXPERT_REJECTED': NotificationCategory.system,
  'LICENSE_VERIFIED': NotificationCategory.system,
  'MODERATION_WARNING': NotificationCategory.system,
  'CONTENT_REMOVED': NotificationCategory.system,
  'CLINICAL_SHARE': NotificationCategory.system,
};

NotificationCategory notificationCategoryOf(String? type) {
  if (type == null) return NotificationCategory.system;
  return kNotificationTypeCategories[type] ?? NotificationCategory.system;
}

/// Bildirim tipi → kullanıcı tercihi (web `TYPE_PREF_MAP` birebir).
/// Eşleşmeyen tipler her zaman gösterilir.
const Map<String, AppPreference> kNotificationTypePreferences = {
  'MESSAGE': AppPreference.notifMessages,
  'COMMENT': AppPreference.notifForum,
  'CONSULTATION_REPLY': AppPreference.notifForum,
  'BUDDY_REQUEST': AppPreference.notifMatching,
  'BUDDY_ACCEPT': AppPreference.notifMatching,
  'MEETING_INVITE': AppPreference.notifMatching,
  'MEETING_UPDATE': AppPreference.notifMatching,
  'APPOINTMENT_REQUEST': AppPreference.notifAppointment,
  'APPOINTMENT_CONFIRMED': AppPreference.notifAppointment,
  'APPOINTMENT_CANCELLED': AppPreference.notifAppointment,
  'APPOINTMENT_RESCHEDULED': AppPreference.notifAppointment,
  'APPOINTMENT_REMINDER': AppPreference.notifCalendar,
  'APPOINTMENT_SOON': AppPreference.notifCalendar,
  'CALENDAR_REMINDER': AppPreference.notifCalendar,
  'TASK_ASSIGNED': AppPreference.notifTaskAssigned,
  'TASK_COMPLETED': AppPreference.notifTaskAssigned,
  'TASK_REVIEWED': AppPreference.notifTaskAssigned,
  'TASK_OVERDUE': AppPreference.notifTaskAssigned,
  'SESSION_NOTES_ADDED': AppPreference.notifExpertNote,
};

/// Kullanıcı bu tür bildirimleri kapattıysa listede gösterilmez
/// (web `shouldShowNotification` ile aynı davranış).
bool shouldShowNotification(String? type, Map<AppPreference, bool> prefs) {
  final pref = type == null ? null : kNotificationTypePreferences[type];
  if (pref == null) return true;
  return preferenceOf(prefs, pref);
}

/// Tarihe göre gruplanmış bildirimler (web `groupNotificationsByDate`).
enum NotificationDateGroup { today, yesterday, thisWeek, older }

NotificationDateGroup notificationDateGroup(DateTime? createdAt, DateTime now) {
  if (createdAt == null) return NotificationDateGroup.older;
  final todayStart = DateTime(now.year, now.month, now.day);
  final yesterdayStart = todayStart.subtract(const Duration(days: 1));
  final weekStart = todayStart.subtract(const Duration(days: 6));
  final value = createdAt.toLocal();
  if (!value.isBefore(todayStart)) return NotificationDateGroup.today;
  if (!value.isBefore(yesterdayStart)) return NotificationDateGroup.yesterday;
  if (!value.isBefore(weekStart)) return NotificationDateGroup.thisWeek;
  return NotificationDateGroup.older;
}

/// Bildirimleri tarih gruplarına ayırır (sıra korunur).
Map<NotificationDateGroup, List<AppNotification>> groupNotificationsByDate(
  List<AppNotification> items, {
  DateTime? now,
}) {
  final reference = now ?? DateTime.now();
  final grouped = <NotificationDateGroup, List<AppNotification>>{
    for (final group in NotificationDateGroup.values) group: <AppNotification>[],
  };
  for (final item in items) {
    grouped[notificationDateGroup(item.createdAt, reference)]!.add(item);
  }
  grouped.removeWhere((_, value) => value.isEmpty);
  return grouped;
}
