import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/settings/app_preferences.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/user_avatar.dart';
import '../../../i18n/strings.g.dart';
import '../../auth/presentation/auth_controller.dart';

/// Profil sekmesindeki menü satırı.
typedef _MenuEntry = ({IconData icon, String label, String route});

/// Profil sekmesi — kullanıcı bilgisi, bölüm kısayolları ve çıkış.
/// Görünüm/dil tercihleri Ayarlar ekranına taşındı.
///
/// Basit mod (erişilebilirlik) açıkken yalnızca temel bölümler görünür,
/// geri kalanlar "tüm bölümler" başlığı altında toplanır — web'de sol menünün
/// sadeleşmesiyle aynı amaç.
class ProfileTab extends ConsumerStatefulWidget {
  const ProfileTab({super.key});

  @override
  ConsumerState<ProfileTab> createState() => _ProfileTabState();
}

class _ProfileTabState extends ConsumerState<ProfileTab> {
  bool _showAll = false;

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(authControllerProvider).user;
    final simpleMode = ref.watch(accessibilityProvider).simpleMode;
    final t = context.t;
    final text = Theme.of(context).textTheme;

    // Temel bölümler: basit modda yalnızca bunlar gösterilir.
    final primary = <_MenuEntry>[
      (
        icon: Icons.person_outline,
        label: t.profile.accountInfo,
        route: '/account',
      ),
      (
        icon: Icons.child_care_outlined,
        label: t.profile.myChildren,
        route: '/children',
      ),
      (
        icon: Icons.volunteer_activism_outlined,
        label: t.treatment.title,
        route: '/treatment',
      ),
      (
        icon: Icons.health_and_safety_outlined,
        label: t.crisis.title,
        route: '/crisis',
      ),
      (
        icon: Icons.settings_outlined,
        label: t.settings.title,
        route: '/settings',
      ),
      (
        icon: Icons.menu_book_outlined,
        label: t.guide.title,
        route: '/guide',
      ),
      (icon: Icons.help_outline, label: t.profile.help, route: '/help'),
    ];

    final secondary = <_MenuEntry>[
      (
        icon: Icons.assignment_turned_in_outlined,
        label: t.tasks.title,
        route: '/tasks',
      ),
      (
        icon: Icons.sticky_note_2_outlined,
        label: t.notesPage.title,
        route: '/notes',
      ),
      (
        icon: Icons.checklist_outlined,
        label: t.routines.title,
        route: '/routines',
      ),
      (
        icon: Icons.calendar_month_outlined,
        label: t.calendar.title,
        route: '/calendar',
      ),
      (
        icon: Icons.emergency_outlined,
        label: t.emergency.title,
        route: '/emergency',
      ),
      (icon: Icons.forum_outlined, label: t.wall.title, route: '/support-wall'),
      (icon: Icons.groups_2_outlined, label: t.forum.title, route: '/forum'),
      (
        icon: Icons.local_fire_department_outlined,
        label: t.weekly.title,
        route: '/weekly-question',
      ),
      (
        icon: Icons.groups_outlined,
        label: t.meetup.title,
        route: '/meetups',
      ),
      (
        icon: Icons.diversity_3_outlined,
        label: t.similar.title,
        route: '/similar-families',
      ),
      (
        icon: Icons.groups_2_outlined,
        label: t.groups.title,
        route: '/groups',
      ),
    ];

    final showSecondary = !simpleMode || _showAll;

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
          for (final entry in primary)
            _ProfileItem(
              icon: entry.icon,
              label: entry.label,
              onTap: () => context.push(entry.route),
            ),
          if (showSecondary)
            for (final entry in secondary)
              _ProfileItem(
                icon: entry.icon,
                label: entry.label,
                onTap: () => context.push(entry.route),
              ),
          if (simpleMode && !_showAll)
            TextButton.icon(
              onPressed: () => setState(() => _showAll = true),
              icon: const Icon(Icons.expand_more),
              label: Text(t.profile.showAllSections),
            ),
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
