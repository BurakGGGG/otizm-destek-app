import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/haptics.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_theme.dart';
import '../../../i18n/strings.g.dart';

/// Topluluk merkezi (web `/topluluk` CommunityHubPage birebir): dağınık
/// topluluk bölümlerini tek girişte toplar. Profil menüsündeki altı ayrı
/// satırın yerine geçer; alt bölümler buradan açılır.
class CommunityScreen extends StatelessWidget {
  const CommunityScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final t = context.t;
    final colors = context.colors;
    final text = Theme.of(context).textTheme;

    final areas = <({IconData icon, String title, String body, String route})>[
      (
        icon: Icons.diversity_3_outlined,
        title: t.similar.title,
        body: t.community.similarText,
        route: '/similar-families',
      ),
      (
        icon: Icons.chat_bubble_outline,
        title: t.messages.title,
        body: t.community.messagesText,
        route: '/messages',
      ),
      (
        icon: Icons.groups_outlined,
        title: t.groups.title,
        body: t.community.groupsText,
        route: '/groups',
      ),
      (
        icon: Icons.place_outlined,
        title: t.meetup.title,
        body: t.community.meetupsText,
        route: '/meetups',
      ),
      (
        icon: Icons.groups_2_outlined,
        title: t.forum.title,
        body: t.community.forumText,
        route: '/forum',
      ),
      (
        icon: Icons.favorite_outline,
        title: t.wall.title,
        body: t.community.wallText,
        route: '/support-wall',
      ),
      (
        icon: Icons.local_fire_department_outlined,
        title: t.weekly.title,
        body: t.community.weeklyText,
        route: '/weekly-question',
      ),
    ];

    return Scaffold(
      appBar: AppBar(title: Text(t.community.title)),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.margin,
            AppSpacing.md,
            AppSpacing.margin,
            40,
          ),
          children: [
            Container(
              padding: const EdgeInsets.all(AppSpacing.md),
              decoration: BoxDecoration(
                color: colors.primary.withValues(alpha: .06),
                borderRadius: BorderRadius.circular(AppRadius.lg),
                border: Border.all(color: colors.primary.withValues(alpha: .18)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.verified_user_outlined,
                          size: 16, color: colors.primary),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          t.community.badge,
                          style: text.labelSmall?.copyWith(
                            color: colors.primary,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    t.community.intro,
                    style:
                        text.bodySmall?.copyWith(color: colors.textSecondary),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            Text(t.community.areasTitle, style: text.titleSmall),
            const SizedBox(height: 2),
            Text(
              t.community.areasSubtitle,
              style: text.labelSmall?.copyWith(color: colors.textSecondary),
            ),
            const SizedBox(height: 10),
            for (final area in areas) ...[
              _AreaCard(
                icon: area.icon,
                title: area.title,
                body: area.body,
                onTap: () {
                  Haptics.selection();
                  context.push(area.route);
                },
              ),
              const SizedBox(height: 10),
            ],
            const SizedBox(height: AppSpacing.sm),
            Container(
              padding: const EdgeInsets.all(AppSpacing.md),
              decoration: BoxDecoration(
                color: colors.success.withValues(alpha: .08),
                borderRadius: BorderRadius.circular(AppRadius.lg),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.shield_outlined,
                          size: 16, color: colors.success),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          t.community.safetyTitle,
                          style: text.labelLarge
                              ?.copyWith(color: colors.success),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(t.community.safetyBody, style: text.bodySmall),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _AreaCard extends StatelessWidget {
  const _AreaCard({
    required this.icon,
    required this.title,
    required this.body,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final String body;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final text = Theme.of(context).textTheme;

    return InkWell(
      borderRadius: BorderRadius.circular(AppRadius.lg),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.md),
        decoration: BoxDecoration(
          color: colors.surface,
          borderRadius: BorderRadius.circular(AppRadius.lg),
          border: Border.all(color: colors.border),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: colors.primary.withValues(alpha: .08),
                borderRadius: BorderRadius.circular(AppRadius.md),
              ),
              child: Icon(icon, size: 20, color: colors.primary),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: text.titleSmall),
                  const SizedBox(height: 2),
                  Text(
                    body,
                    style:
                        text.bodySmall?.copyWith(color: colors.textSecondary),
                  ),
                ],
              ),
            ),
            Icon(Icons.chevron_right, size: 20, color: colors.textTertiary),
          ],
        ),
      ),
    );
  }
}
