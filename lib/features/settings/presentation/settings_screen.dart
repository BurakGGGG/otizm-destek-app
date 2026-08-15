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
                ),
                if (!isExpert)
                  _PrefSwitch(
                    pref: AppPreference.privacyShareProgress,
                    label: t.settings.privacyShareProgress,
                  ),
                _PrefSwitch(
                  pref: AppPreference.privacyApproximateLocation,
                  label: t.settings.privacyApproximateLocation,
                ),
                _PrefSwitch(
                  pref: AppPreference.privacyHidePresence,
                  label: t.settings.privacyHidePresence,
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
class _PrefSwitch extends ConsumerWidget {
  const _PrefSwitch({
    required this.pref,
    required this.label,
    this.description,
  });

  final AppPreference pref;
  final String label;
  final String? description;

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
