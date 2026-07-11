import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/theme/theme_mode_provider.dart';
import '../../../core/widgets/user_avatar.dart';
import '../../../i18n/strings.g.dart';
import '../../auth/presentation/auth_controller.dart';

/// Profil sekmesi — temel kullanıcı bilgisi, dil seçimi ve çıkış.
class ProfileTab extends ConsumerWidget {
  const ProfileTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authControllerProvider).user;
    final t = context.t;
    final text = Theme.of(context).textTheme;

    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.all(AppSpacing.margin),
        children: [
          const SizedBox(height: 8),
          Center(
            child: UserAvatar(
              name: user?.displayName ?? '',
              imageUrl: user?.profileImageUrl,
              radius: 40,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            user?.displayName ?? t.profile.defaultUser,
            textAlign: TextAlign.center,
            style: text.headlineSmall,
          ),
          Text(
            user?.email ?? '',
            textAlign: TextAlign.center,
            style: text.bodySmall,
          ),
          const SizedBox(height: 24),
          _ProfileItem(
            icon: Icons.person_outline,
            label: t.profile.accountInfo,
            onTap: () => context.push('/account'),
          ),
          _ProfileItem(
            icon: Icons.child_care_outlined,
            label: t.profile.myChildren,
            onTap: () => context.push('/children'),
          ),
          _ProfileItem(
            icon: Icons.volunteer_activism_outlined,
            label: t.treatment.title,
            onTap: () => context.push('/treatment'),
          ),
          _ProfileItem(
            icon: Icons.assignment_turned_in_outlined,
            label: t.tasks.title,
            onTap: () => context.push('/tasks'),
          ),
          _ProfileItem(
            icon: Icons.checklist_outlined,
            label: t.routines.title,
            onTap: () => context.push('/routines'),
          ),
          _ProfileItem(
            icon: Icons.calendar_month_outlined,
            label: t.calendar.title,
            onTap: () => context.push('/calendar'),
          ),
          _ProfileItem(
            icon: Icons.emergency_outlined,
            label: t.emergency.title,
            onTap: () => context.push('/emergency'),
          ),
          _ProfileItem(
            icon: Icons.health_and_safety_outlined,
            label: t.crisis.title,
            onTap: () => context.push('/crisis'),
          ),
          _ProfileItem(
            icon: Icons.forum_outlined,
            label: t.wall.title,
            onTap: () => context.push('/support-wall'),
          ),
          _ProfileItem(
            icon: Icons.local_fire_department_outlined,
            label: t.weekly.title,
            onTap: () => context.push('/weekly-question'),
          ),
          _ProfileItem(
            icon: Icons.groups_outlined,
            label: t.meetup.title,
            onTap: () => context.push('/meetups'),
          ),
          _ProfileItem(
            icon: Icons.diversity_3_outlined,
            label: t.similar.title,
            onTap: () => context.push('/similar-families'),
          ),
          _ProfileItem(
            icon: Icons.groups_2_outlined,
            label: t.groups.title,
            onTap: () => context.push('/groups'),
          ),
          _ProfileItem(
            icon: Icons.notifications_none,
            label: t.profile.notificationSettings,
            onTap: () => ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(t.common.comingSoon))),
          ),
          _ProfileItem(
            icon: Icons.help_outline,
            label: t.profile.help,
            onTap: () => context.push('/help'),
          ),
          const SizedBox(height: 16),
          const _LanguageSelector(),
          const SizedBox(height: 12),
          const _ThemeSelector(),
          const SizedBox(height: 24),
          OutlinedButton.icon(
            onPressed: () =>
                ref.read(authControllerProvider.notifier).signOut(),
            icon: Icon(Icons.logout, color: context.colors.error),
            style: OutlinedButton.styleFrom(
              foregroundColor: context.colors.error,
            ),
            label: Text(t.profile.signOut),
          ),
        ],
      ),
    );
  }
}

/// Dil seçici — TR/EN arası anlık geçiş (tüm uygulamayı yeniden çizer).
class _LanguageSelector extends StatelessWidget {
  const _LanguageSelector();

  @override
  Widget build(BuildContext context) {
    final t = context.t;
    final current = TranslationProvider.of(context).locale;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.language, color: context.colors.primary),
                const SizedBox(width: 12),
                Text(
                  t.language.title,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ],
            ),
            const SizedBox(height: 12),
            SegmentedButton<AppLocale>(
              segments: [
                ButtonSegment(
                  value: AppLocale.tr,
                  label: Text(t.language.turkish),
                ),
                ButtonSegment(
                  value: AppLocale.en,
                  label: Text(t.language.english),
                ),
              ],
              selected: {current},
              showSelectedIcon: false,
              onSelectionChanged: (selection) =>
                  LocaleSettings.setLocale(selection.first),
            ),
          ],
        ),
      ),
    );
  }
}

/// Tema seçici — Sistem/Açık/Koyu (kalıcı).
class _ThemeSelector extends ConsumerWidget {
  const _ThemeSelector();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = context.t;
    final mode = ref.watch(themeModeProvider);
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.brightness_6_outlined,
                  color: context.colors.primary,
                ),
                const SizedBox(width: 12),
                Text(
                  t.theme.title,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ],
            ),
            const SizedBox(height: 12),
            SegmentedButton<ThemeMode>(
              segments: [
                ButtonSegment(
                  value: ThemeMode.system,
                  label: Text(t.theme.system),
                ),
                ButtonSegment(
                  value: ThemeMode.light,
                  label: Text(t.theme.light),
                ),
                ButtonSegment(value: ThemeMode.dark, label: Text(t.theme.dark)),
              ],
              selected: {mode},
              showSelectedIcon: false,
              onSelectionChanged: (s) =>
                  ref.read(themeModeProvider.notifier).setMode(s.first),
            ),
          ],
        ),
      ),
    );
  }
}

class _ProfileItem extends StatelessWidget {
  const _ProfileItem({required this.icon, required this.label, this.onTap});
  final IconData icon;
  final String label;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.lg),
        ),
        leading: Icon(icon, color: context.colors.primary),
        title: Text(label),
        trailing: Icon(Icons.chevron_right, color: context.colors.textTertiary),
        onTap: onTap ?? () {},
      ),
    );
  }
}
