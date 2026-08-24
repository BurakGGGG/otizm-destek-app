import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

import '../../../core/haptics.dart';
import '../../../core/network/api_exception.dart';
import '../../../core/settings/app_preferences.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/theme/theme_mode_provider.dart';
import '../../../i18n/strings.g.dart';
import '../../auth/domain/app_user.dart';
import '../../auth/presentation/auth_controller.dart';
import '../../notifications/data/push_service.dart';
import '../data/settings_repository.dart';
import 'change_password_sheet.dart';
import 'delete_account_sheet.dart';

/// Ayarlar ekranı — web `SettingsPage` karşılığı (mobile'da anlamlı bölümler).
///
/// Hesap, bildirim/gizlilik tercihleri, görünüm, güvenlik (şifre değiştirme)
/// ve KVKK veri hakları (verileri indirme, hesap silme) tek yerde toplanır.
class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = context.t;
    final user = ref.watch(authControllerProvider).user;
    final isExpert = user?.role == UserRole.expert;

    return Scaffold(
      appBar: AppBar(title: Text(t.settings.title)),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(AppSpacing.margin),
          children: [
            _AccountCard(user: user),
            const SizedBox(height: AppSpacing.md),

            _Section(
              icon: Icons.notifications_none,
              title: t.settings.notificationsTitle,
              subtitle: t.settings.notificationsSubtitle,
              children: [
                const _DevicePermissionRow(),
                _PrefSwitch(
                  pref: AppPreference.notifMessages,
                  label: t.settings.notifMessages,
                ),
                _PrefSwitch(
                  pref: AppPreference.notifAppointment,
                  label: t.settings.notifAppointment,
                ),
                _PrefSwitch(
                  pref: AppPreference.apptReminder24h,
                  label: t.settings.notifApptReminder,
                ),
                _PrefSwitch(
                  pref: AppPreference.notifExpertNote,
                  label: t.settings.notifExpertNote,
                ),
                _PrefSwitch(
                  pref: AppPreference.notifTaskAssigned,
                  label: t.settings.notifTaskAssigned,
                ),
                _PrefSwitch(
                  pref: AppPreference.notifForum,
                  label: t.settings.notifForum,
                ),
                _PrefSwitch(
                  pref: AppPreference.notifMatching,
                  label: t.settings.notifMatching,
                ),
                _PrefSwitch(
                  pref: AppPreference.notifCalendar,
                  label: t.settings.notifCalendar,
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.md),

            _Section(
              icon: Icons.shield_outlined,
              title: t.settings.privacyTitle,
              subtitle: t.settings.privacySubtitle,
              children: [
                _PrefSwitch(
                  pref: AppPreference.privacyShowProfile,
                  label: t.settings.privacyShowProfile,
                ),
                _PrefSwitch(
                  pref: AppPreference.privacyAllowMessages,
                  label: t.settings.privacyAllowMessages,
                  onServer: (ref, value) => ref
                      .read(authControllerProvider.notifier)
                      .updateProfile(allowDirectMessages: value),
                ),
                _PrefSwitch(
                  pref: AppPreference.privacyFamilyMessages,
                  label: t.settings.privacyFamilyMessages,
                  onServer: (ref, value) => ref
                      .read(authControllerProvider.notifier)
                      .updateProfile(allowFamilyMessages: value),
                ),
                if (!isExpert)
                  _PrefSwitch(
                    pref: AppPreference.privacyShareProgress,
                    label: t.settings.privacyShareProgress,
                  ),
                _PrefSwitch(
                  pref: AppPreference.privacyApproximateLocation,
                  label: t.settings.privacyApproximateLocation,
                  onServer: (ref, value) => ref
                      .read(authControllerProvider.notifier)
                      .updateProfile(approximateLocationOnly: value),
                ),
                _PrefSwitch(
                  pref: AppPreference.privacyHidePresence,
                  label: t.settings.privacyHidePresence,
                  onServer: (ref, value) => ref
                      .read(authControllerProvider.notifier)
                      .updateProfile(hideOnlineStatus: value),
                ),
                if (!isExpert) const _MatchingPreferences(),
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: const Icon(Icons.block_outlined),
                  title: Text(t.settings.blockedTitle),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => context.push('/blocked'),
                ),
                // Uzmanların çocuk verisine erişimi cihaz tercihi değil,
                // sunucudaki onaylardır — ayrı ekrana götürülür.
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: const Icon(Icons.verified_user_outlined),
                  title: Text(t.expertAccess.title),
                  subtitle: Text(t.expertAccess.intro),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => context.push('/expert-access'),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.md),

            const _AppearanceSection(),
            const SizedBox(height: AppSpacing.md),

            _Section(
              icon: Icons.accessibility_new_outlined,
              title: t.settings.accessibilityTitle,
              subtitle: t.settings.accessibilitySubtitle,
              children: [
                _PrefSwitch(
                  pref: AppPreference.a11yLargeText,
                  label: t.settings.a11yLargeText,
                  description: t.settings.a11yLargeTextBody,
                ),
                _PrefSwitch(
                  pref: AppPreference.a11yCalmMode,
                  label: t.settings.a11yCalmMode,
                  description: t.settings.a11yCalmModeBody,
                ),
                _PrefSwitch(
                  pref: AppPreference.a11yHighContrast,
                  label: t.settings.a11yHighContrast,
                  description: t.settings.a11yHighContrastBody,
                ),
                _PrefSwitch(
                  pref: AppPreference.a11yReduceMotion,
                  label: t.settings.a11yReduceMotion,
                  description: t.settings.a11yReduceMotionBody,
                ),
                _PrefSwitch(
                  pref: AppPreference.a11ySimpleMode,
                  label: t.settings.a11ySimpleMode,
                  description: t.settings.a11ySimpleModeBody,
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.md),

            _Section(
              icon: Icons.lock_outline,
              title: t.settings.securityTitle,
              subtitle: t.settings.securitySubtitle,
              children: [
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: const Icon(Icons.password_outlined),
                  title: Text(t.settings.changePassword),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => showModalBottomSheet<void>(
                    context: context,
                    isScrollControlled: true,
                    builder: (_) => const ChangePasswordSheet(),
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.md),

            _Section(
              icon: Icons.policy_outlined,
              title: t.settings.dataTitle,
              subtitle: t.settings.dataSubtitle,
              children: [
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: const Icon(Icons.verified_user_outlined),
                  title: Text(t.settings.kvkkPanel),
                  subtitle: Text(t.settings.kvkkPanelBody),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => context.push('/kvkk'),
                ),
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: const Icon(Icons.description_outlined),
                  title: Text(t.legal.title),
                  subtitle: Text(t.legal.subtitle, maxLines: 2),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => context.push('/legal'),
                ),
                const _DownloadDataTile(),
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: Icon(
                    Icons.delete_forever_outlined,
                    color: context.colors.error,
                  ),
                  title: Text(
                    t.settings.deleteAccount,
                    style: TextStyle(color: context.colors.error),
                  ),
                  subtitle: Text(t.settings.deleteAccountBody),
                  onTap: () => showModalBottomSheet<void>(
                    context: context,
                    isScrollControlled: true,
                    builder: (_) => const DeleteAccountSheet(),
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.lg),
          ],
        ),
      ),
    );
  }
}

class _AccountCard extends StatelessWidget {
  const _AccountCard({required this.user});

  final AppUser? user;

  @override
  Widget build(BuildContext context) {
    final t = context.t;
    final text = Theme.of(context).textTheme;
    return Card(
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: context.colors.primary.withValues(alpha: .12),
          child: Icon(Icons.person_outline, color: context.colors.primary),
        ),
        title: Text(user?.displayName ?? t.profile.defaultUser),
        subtitle: Text(user?.email ?? '', style: text.bodySmall),
        trailing: const Icon(Icons.chevron_right),
        onTap: () => context.push('/account'),
      ),
    );
  }
}

/// Başlıklı ayar bölümü kartı.
class _Section extends StatelessWidget {
  const _Section({
    required this.icon,
    required this.title,
    required this.children,
    this.subtitle,
  });

  final IconData icon;
  final String title;
  final String? subtitle;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final text = Theme.of(context).textTheme;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: colors.primary),
                const SizedBox(width: 10),
                Expanded(child: Text(title, style: text.titleMedium)),
              ],
            ),
            if (subtitle case final sub?) ...[
              const SizedBox(height: 4),
              Text(
                sub,
                style: text.bodySmall?.copyWith(color: colors.textTertiary),
              ),
            ],
            const SizedBox(height: 4),
            ...children,
          ],
        ),
      ),
    );
  }
}

/// Cihazda saklanan bir tercihi açıp kapatan anahtar.
/// Cihaz bildirim izni satırı — izin yoksa yeniden istemeyi dener, kalıcı
/// reddedilmişse sistem ayarlarına yönlendiren açıklama gösterir.
/// (Web'deki `NotificationPermissionBanner` karşılığı.)
class _DevicePermissionRow extends ConsumerWidget {
  const _DevicePermissionRow();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = context.t;
    final granted = ref.watch(pushPermissionProvider).asData?.value;
    // Firebase kurulu değilse (test/emülatör) satır hiç görünmez.
    if (granted == null) return const SizedBox.shrink();

    if (granted) {
      return ListTile(
        contentPadding: EdgeInsets.zero,
        leading: Icon(
          Icons.notifications_active_outlined,
          color: context.colors.success,
        ),
        title: Text(t.settings.pushGranted),
        subtitle: Text(
          t.settings.pushGrantedHint,
          style: Theme.of(context).textTheme.bodySmall,
        ),
      );
    }

    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Icon(
        Icons.notifications_off_outlined,
        color: context.colors.error,
      ),
      title: Text(t.settings.pushDenied),
      subtitle: Text(
        t.settings.pushDeniedHint,
        style: Theme.of(context).textTheme.bodySmall,
      ),
      trailing: TextButton(
        onPressed: () async {
          final messenger = ScaffoldMessenger.of(context);
          final ok = await ref.read(pushServiceProvider).requestPermission();
          ref.invalidate(pushPermissionProvider);
          messenger.showSnackBar(SnackBar(
            content: Text(ok ? t.settings.pushGranted : t.settings.pushDenied),
          ));
        },
        child: Text(t.settings.pushRequest),
      ),
    );
  }
}

/// Eşleşme tercihleri — sunucuda saklanır (`PUT /users/me`).
///
/// Kodlar paylaşılan veridir (DENEYIM_PAYLASIMI, YAZISMA…); yalnızca
/// etiketler çevrilir. Web Ayarlar > Gizlilik altında aynı iki grup var.
class _MatchingPreferences extends ConsumerStatefulWidget {
  const _MatchingPreferences();

  @override
  ConsumerState<_MatchingPreferences> createState() =>
      _MatchingPreferencesState();
}

class _MatchingPreferencesState extends ConsumerState<_MatchingPreferences> {
  late Set<String> _intents;
  late Set<String> _comms;
  bool _seeded = false;

  @override
  Widget build(BuildContext context) {
    final t = context.t;
    final text = Theme.of(context).textTheme;
    final user = ref.watch(authControllerProvider).user;
    if (!_seeded && user != null) {
      _seeded = true;
      _intents = {...user.supportIntents};
      _comms = {...user.communicationPreferences};
    } else if (!_seeded) {
      _intents = {};
      _comms = {};
    }

    final intents = <String, String>{
      'DENEYIM_PAYLASIMI': t.settings.intentExperience,
      'DUZENLI_DESTEK': t.settings.intentRegular,
      'YEREL_BULUSMA': t.settings.intentLocalMeet,
      'MENTOR_ARIYOR': t.settings.intentSeekMentor,
      'MENTORLUK': t.settings.intentBeMentor,
    };
    final comms = <String, String>{
      'YAZISMA': t.settings.commWriting,
      'GORUNTULU': t.settings.commVideo,
      'AKSAM': t.settings.commEvening,
    };

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 8),
        Text(t.settings.matchingTitle, style: text.bodyMedium),
        Text(
          t.settings.matchingHint,
          style: text.labelSmall?.copyWith(color: context.colors.textTertiary),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            for (final entry in intents.entries)
              FilterChip(
                label: Text(entry.value),
                selected: _intents.contains(entry.key),
                onSelected: (_) => _toggle(_intents, entry.key, intents: true),
              ),
          ],
        ),
        const SizedBox(height: 12),
        Text(t.settings.communicationTitle, style: text.bodyMedium),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            for (final entry in comms.entries)
              FilterChip(
                label: Text(entry.value),
                selected: _comms.contains(entry.key),
                onSelected: (_) => _toggle(_comms, entry.key, intents: false),
              ),
          ],
        ),
      ],
    );
  }

  Future<void> _toggle(
    Set<String> target,
    String code, {
    required bool intents,
  }) async {
    Haptics.selection();
    setState(() {
      target.contains(code) ? target.remove(code) : target.add(code);
    });
    final messenger = ScaffoldMessenger.of(context);
    final error = await ref.read(authControllerProvider.notifier).updateProfile(
          supportIntents: intents ? _intents.toList() : null,
          communicationPreferences: intents ? null : _comms.toList(),
        );
    if (error != null && mounted) {
      messenger.showSnackBar(SnackBar(content: Text(error)));
    }
  }
}

class _PrefSwitch extends ConsumerWidget {
  const _PrefSwitch({
    required this.pref,
    required this.label,
    this.description,
    this.onServer,
  });

  final AppPreference pref;
  final String label;
  final String? description;

  /// Cihaz tercihiyle birlikte sunucuya da yazılan anahtarlarda çalışır
  /// (web de aynı dört tercihi `PUT /users/me` ile saklıyor).
  final Future<String?> Function(WidgetRef ref, bool value)? onServer;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final prefs = ref.watch(appPreferencesProvider);
    return SwitchListTile(
      contentPadding: EdgeInsets.zero,
      dense: true,
      value: preferenceOf(prefs, pref),
      title: Text(label, style: Theme.of(context).textTheme.bodyMedium),
      subtitle: description == null
          ? null
          : Text(description!, style: Theme.of(context).textTheme.bodySmall),
      onChanged: (value) {
        Haptics.selection();
        ref.read(appPreferencesProvider.notifier).set(pref, value);
        // Sunucu yazımı düşse de cihaz tercihi korunur; hata gösterilir.
        final messenger = ScaffoldMessenger.of(context);
        final failure = onServer?.call(ref, value);
        failure?.then((error) {
          if (error != null) {
            messenger.showSnackBar(SnackBar(content: Text(error)));
          }
        });
      },
    );
  }
}

/// Görünüm: tema ve dil (Profil sekmesindeki seçiciler buraya taşındı).
class _AppearanceSection extends ConsumerWidget {
  const _AppearanceSection();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = context.t;
    final mode = ref.watch(themeModeProvider);
    final locale = TranslationProvider.of(context).locale;

    return _Section(
      icon: Icons.palette_outlined,
      title: t.settings.appearanceTitle,
      children: [
        const SizedBox(height: 8),
        Text(t.theme.title, style: Theme.of(context).textTheme.labelMedium),
        const SizedBox(height: 6),
        SegmentedButton<ThemeMode>(
          segments: [
            ButtonSegment(value: ThemeMode.system, label: Text(t.theme.system)),
            ButtonSegment(value: ThemeMode.light, label: Text(t.theme.light)),
            ButtonSegment(value: ThemeMode.dark, label: Text(t.theme.dark)),
          ],
          selected: {mode},
          showSelectedIcon: false,
          onSelectionChanged: (s) =>
              ref.read(themeModeProvider.notifier).setMode(s.first),
        ),
        const SizedBox(height: 16),
        Text(t.language.title, style: Theme.of(context).textTheme.labelMedium),
        const SizedBox(height: 6),
        SegmentedButton<AppLocale>(
          segments: [
            ButtonSegment(value: AppLocale.tr, label: Text(t.language.turkish)),
            ButtonSegment(value: AppLocale.en, label: Text(t.language.english)),
          ],
          selected: {locale},
          showSelectedIcon: false,
          onSelectionChanged: (s) => LocaleSettings.setLocale(s.first),
        ),
      ],
    );
  }
}

/// KVKK veri taşınabilirliği: hesabın verisini JSON olarak indirip paylaşır.
class _DownloadDataTile extends ConsumerStatefulWidget {
  const _DownloadDataTile();

  @override
  ConsumerState<_DownloadDataTile> createState() => _DownloadDataTileState();
}

class _DownloadDataTileState extends ConsumerState<_DownloadDataTile> {
  bool _busy = false;

  Future<void> _download() async {
    final t = context.t;
    setState(() => _busy = true);
    try {
      final json = await ref
          .read(settingsRepositoryProvider)
          .downloadAccountData();
      final dir = await getTemporaryDirectory();
      final file = File('${dir.path}/verilerim.json');
      await file.writeAsString(json);
      if (!mounted) return;
      await SharePlus.instance.share(
        ShareParams(
          files: [XFile(file.path, mimeType: 'application/json')],
          fileNameOverrides: const ['verilerim.json'],
          subject: t.settings.downloadDataSubject,
        ),
      );
    } on ApiException catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(e.message)));
      }
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final t = context.t;
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: const Icon(Icons.download_outlined),
      title: Text(t.settings.downloadData),
      subtitle: Text(t.settings.downloadDataBody),
      trailing: _busy
          ? const SizedBox(
              height: 18,
              width: 18,
              child: CircularProgressIndicator(strokeWidth: 2),
            )
          : const Icon(Icons.chevron_right),
      onTap: _busy ? null : _download,
    );
  }
}
