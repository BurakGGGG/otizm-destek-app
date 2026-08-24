import 'package:flutter_test/flutter_test.dart';
import 'package:otizm_destek_app/core/settings/app_preferences.dart';
import 'package:otizm_destek_app/features/notifications/domain/app_notification.dart';
import 'package:otizm_destek_app/features/notifications/domain/notification_category.dart';

AppNotification _n(String id, {String? type, DateTime? createdAt}) {
  return AppNotification(
    id: id,
    title: id,
    type: type,
    createdAt: createdAt,
  );
}

void main() {
  group('bildirim kategorileri (web notificationUtils birebir)', () {
    test('tipler doğru kategoriye düşer', () {
      expect(
        notificationCategoryOf('APPOINTMENT_CONFIRMED'),
        NotificationCategory.appointments,
      );
      expect(notificationCategoryOf('COMMENT'), NotificationCategory.forum);
      expect(
        notificationCategoryOf('BUDDY_REQUEST'),
        NotificationCategory.social,
      );
      expect(
        notificationCategoryOf('TASK_ASSIGNED'),
        NotificationCategory.tasks,
      );
      expect(
        notificationCategoryOf('CALENDAR_REMINDER'),
        NotificationCategory.appointments,
      );
    });

    test('bilinmeyen ve boş tip sistem sayılır', () {
      expect(notificationCategoryOf('YENI_TIP'), NotificationCategory.system);
      expect(notificationCategoryOf(null), NotificationCategory.system);
    });
  });

  group('tercihe göre gizleme', () {
    test('kapatılan tür listede gösterilmez', () {
      final prefs = {AppPreference.notifForum: false};
      expect(shouldShowNotification('COMMENT', prefs), isFalse);
      expect(shouldShowNotification('CONSULTATION_REPLY', prefs), isFalse);
    });

    test('eşleşmeyen tipler her zaman gösterilir', () {
      final prefs = {AppPreference.notifForum: false};
      expect(shouldShowNotification('EXPERT_APPROVED', prefs), isTrue);
      expect(shouldShowNotification(null, prefs), isTrue);
    });

    test('varsayılan (kayıtsız) tercih açıktır', () {
      expect(shouldShowNotification('TASK_ASSIGNED', const {}), isTrue);
    });
  });

  group('tarihe göre gruplama', () {
    final now = DateTime(2026, 8, 16, 12);

    test('bugün / dün / bu hafta / daha eski ayrımı', () {
      expect(
        notificationDateGroup(DateTime(2026, 8, 16, 1), now),
        NotificationDateGroup.today,
      );
      expect(
        notificationDateGroup(DateTime(2026, 8, 15, 23), now),
        NotificationDateGroup.yesterday,
      );
      expect(
        notificationDateGroup(DateTime(2026, 8, 11), now),
        NotificationDateGroup.thisWeek,
      );
      expect(
        notificationDateGroup(DateTime(2026, 8, 9), now),
        NotificationDateGroup.older,
      );
      // Tarihi olmayan bildirim en alta düşer.
      expect(notificationDateGroup(null, now), NotificationDateGroup.older);
    });

    test('boş gruplar sonuçta yer almaz, sıra korunur', () {
      final grouped = groupNotificationsByDate([
        _n('a', createdAt: DateTime(2026, 8, 16, 9)),
        _n('b', createdAt: DateTime(2026, 8, 16, 8)),
        _n('c', createdAt: DateTime(2026, 8, 9)),
      ], now: now);
      expect(grouped.keys, [
        NotificationDateGroup.today,
        NotificationDateGroup.older,
      ]);
      expect(
        grouped[NotificationDateGroup.today]!.map((n) => n.id).toList(),
        ['a', 'b'],
      );
    });
  });
}
