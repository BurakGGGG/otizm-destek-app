import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers.dart';

/// Cihazda saklanan kullanıcı tercihleri (web'de localStorage karşılığı).
///
/// Anahtar adları web `SettingsPage` ile aynı tutulur; böylece iki platformun
/// aynı tercihi kastettiği tek bakışta görülür. Sunucuda saklanmaz — bildirim
/// ve gizlilik tercihleri cihaz bazlıdır.
enum AppPreference {
  // Bildirimler
  notifMessages('notif_messages', true),
  notifForum('notif_forum', true),
  notifMatching('notif_matching', true),
  notifCalendar('notif_calendar', true),
  notifAppointment('notif_appt_confirm', true),
  notifExpertNote('notif_expert_note', true),
  notifTaskAssigned('notif_task_assigned', true),
  apptReminder24h('appt_reminder_24h', true),

  // Gizlilik
  privacyShowProfile('privacy_show_profile', true),
  privacyAllowMessages('privacy_allow_messages', true),
  privacyShareProgress('privacy_share_progress', true),
  privacyApproximateLocation('privacy_approximate_location', true),
  privacyHidePresence('privacy_hide_presence', false),

  // Erişilebilirlik
  a11yLargeText('access-large-text', false),
  a11yReduceMotion('access-reduce-motion', false),
  a11yHighContrast('access-high-contrast', false),
  a11yCalmMode('access-calm-mode', false);

  const AppPreference(this.key, this.defaultValue);

  final String key;
  final bool defaultValue;
}

/// Tercihleri güvenli depodan okuyup yazan denetleyici.
class AppPreferencesController extends Notifier<Map<AppPreference, bool>> {
  @override
  Map<AppPreference, bool> build() {
    _restore();
    return {for (final pref in AppPreference.values) pref: pref.defaultValue};
  }

  Future<void> _restore() async {
    try {
      final storage = ref.read(secureStorageProvider);
      final restored = <AppPreference, bool>{};
      for (final pref in AppPreference.values) {
        final raw = await storage.readPreference(pref.key);
        restored[pref] = raw == null ? pref.defaultValue : raw == 'true';
      }
      state = restored;
    } catch (_) {
      // Depo okunamazsa varsayılanlarla devam edilir.
    }
  }

  bool value(AppPreference pref) => state[pref] ?? pref.defaultValue;

  Future<void> set(AppPreference pref, bool value) async {
    state = {...state, pref: value};
    try {
      await ref
          .read(secureStorageProvider)
          .savePreference(pref.key, value.toString());
    } catch (_) {
      // Kayıt başarısızsa tercih oturum içinde geçerli kalır.
    }
  }
}

final appPreferencesProvider =
    NotifierProvider<AppPreferencesController, Map<AppPreference, bool>>(
      AppPreferencesController.new,
    );

/// Tek bir tercihi izlemek için kısayol.
bool preferenceOf(Map<AppPreference, bool> prefs, AppPreference pref) =>
    prefs[pref] ?? pref.defaultValue;
