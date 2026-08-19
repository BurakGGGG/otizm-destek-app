import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/skeleton.dart';
import '../../../core/widgets/user_avatar.dart';
import '../../../i18n/strings.g.dart';
import '../../appointments/data/appointment_repository.dart';
import '../../appointments/domain/appointment.dart';
import '../../auth/domain/app_user.dart';
import '../../auth/presentation/auth_controller.dart';
import '../../children/data/child_repository.dart';
import '../../children/data/connection_repository.dart';
import '../../children/domain/child.dart';
import '../../knowledge/data/knowledge_repository.dart';
import '../../knowledge/domain/article.dart';
import '../../knowledge/presentation/article_detail_screen.dart';
import '../data/daily_plan_provider.dart';
import 'widgets/daily_plan_card.dart';
import 'widgets/section_header.dart';
import 'widgets/start_checklist.dart';

/// Ana Sayfa sekmesi — backend'den gerçek veri (çocuklar, randevular, makaleler).
class HomeTab extends ConsumerWidget {
  const HomeTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authControllerProvider).user;
    final t = context.t;
    final text = Theme.of(context).textTheme;
    final name = user?.displayName ?? t.home.greetingFallback;
    // Günlük plan ve başlangıç listesi veli akışıdır (web'de de rol bazlı).
    final isParent = user?.role == UserRole.parent;

    return SafeArea(
      child: RefreshIndicator(
        onRefresh: () async {
          ref.invalidate(childrenProvider);
          ref.invalidate(appointmentsProvider);
          ref.invalidate(recommendedArticlesProvider);
          ref.invalidate(connectionRequestsProvider);
          ref.invalidate(dailyPlanInputProvider);
        },
        child: ListView(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.margin,
            8,
            AppSpacing.margin,
            24,
          ),
          children: [
            Text(t.home.greeting(name: name), style: text.headlineLarge),
            const SizedBox(height: 4),
            Text(t.home.subtitle, style: text.bodySmall),
            const SizedBox(height: AppSpacing.md),
            const _ExpertAccessBanner(),
            if (isParent) ...[
              const StartChecklist(),
              const DailyPlanCard(),
            ],
            const _QuickActions(),
            const SizedBox(height: AppSpacing.lg),

            SectionHeader(
              title: t.home.childrenTitle,
              onAction: () => context.push('/children'),
            ),
            const SizedBox(height: 12),
            const _ChildrenSection(),
            const SizedBox(height: AppSpacing.lg),

            SectionHeader(
              title: t.home.upcomingAppointments,
              onAction: () => context.push('/appointments'),
            ),
            const SizedBox(height: 12),
            const _AppointmentsSection(),
            const SizedBox(height: AppSpacing.lg),

            SectionHeader(
              title: t.home.recommendedArticles,
              actionLabel: t.common.more,
              onAction: () => context.push('/knowledge'),
            ),
            const SizedBox(height: 12),
            const _ArticlesSection(),
          ],
        ),
      ),
    );
  }
}

/// Hızlı eylemler — web gösterge panelindeki dört kayıt kısayolu.
class _QuickActions extends StatelessWidget {
  const _QuickActions();

  @override
  Widget build(BuildContext context) {
    final t = context.t;
    final actions = <({IconData icon, String label, String detail, String route})>[
      (
        icon: Icons.favorite_outline,
        label: t.home.quickTracker,
        detail: t.home.quickTrackerDetail,
        route: '/daily-tracker',
      ),
      (
        icon: Icons.psychology_outlined,
        label: t.home.quickBehavior,
        detail: t.home.quickBehaviorDetail,
        route: '/behavior',
      ),
      (
        icon: Icons.sticky_note_2_outlined,
        label: t.home.quickNote,
        detail: t.home.quickNoteDetail,
        route: '/notes',
      ),
      (
        icon: Icons.event_outlined,
        label: t.home.quickPlan,
        detail: t.home.quickPlanDetail,
        route: '/calendar',
      ),
    ];

    return LayoutBuilder(
      builder: (context, constraints) {
        final width = (constraints.maxWidth - 12) / 2;
        return Wrap(
          spacing: 12,
          runSpacing: 12,
          children: [
            for (final action in actions)
              SizedBox(
                width: width,
                child: _QuickActionCard(
                  icon: action.icon,
                  label: action.label,
                  detail: action.detail,
                  onTap: () => context.push(action.route),
                ),
              ),
          ],
        );
      },
    );
  }
}

class _QuickActionCard extends StatelessWidget {
  const _QuickActionCard({
    required this.icon,
    required this.label,
    required this.detail,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final String detail;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final text = Theme.of(context).textTheme;
    return InkWell(
      borderRadius: BorderRadius.circular(AppRadius.lg),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: colors.surface,
          borderRadius: BorderRadius.circular(AppRadius.lg),
          border: Border.all(color: colors.border),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: colors.primary.withValues(alpha: .08),
                borderRadius: BorderRadius.circular(AppRadius.md),
              ),
              child: Icon(icon, size: 18, color: colors.primary),
            ),
            const SizedBox(height: 10),
            Text(label, style: text.labelLarge),
            const SizedBox(height: 2),
            Text(
              detail,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: text.labelSmall?.copyWith(color: colors.textSecondary),
            ),
          ],
        ),
      ),
    );
  }
}

/// Bekleyen uzman erişim isteği varsa gösterilen uyarı şeridi (web gösterge
/// panelindeki "uzman erişim isteği" kartı). İstek yoksa yer kaplamaz.
class _ExpertAccessBanner extends ConsumerWidget {
  const _ExpertAccessBanner();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = context.t;
    final colors = context.colors;
    final text = Theme.of(context).textTheme;
    final requests =
        ref.watch(connectionRequestsProvider).asData?.value ?? const [];
    if (requests.isEmpty) return const SizedBox(height: AppSpacing.sm);

    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.md),
      child: InkWell(
        borderRadius: BorderRadius.circular(AppRadius.lg),
        onTap: () => context.push('/expert-access'),
        child: Container(
          padding: const EdgeInsets.all(AppSpacing.md),
          decoration: BoxDecoration(
            color: colors.warning.withValues(alpha: .10),
            borderRadius: BorderRadius.circular(AppRadius.lg),
            border: Border.all(color: colors.warning.withValues(alpha: .35)),
          ),
          child: Row(
            children: [
              Icon(Icons.notifications_active_outlined,
                  size: 20, color: colors.warning),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      t.expertAccess.pendingBanner(count: requests.length),
                      style: text.labelLarge,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      requests
                          .map((r) => r.expertName ?? t.expertAccess.unknownExpert)
                          .join(', '),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: text.labelSmall
                          ?.copyWith(color: colors.textSecondary),
                    ),
                  ],
                ),
              ),
              Icon(Icons.chevron_right, size: 20, color: colors.textTertiary),
            ],
          ),
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Çocuklar
// ---------------------------------------------------------------------------
class _ChildrenSection extends ConsumerWidget {
  const _ChildrenSection();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = context.t;
    return ref
        .watch(childrenProvider)
        .when(
          loading: () => const _SectionLoading(),
          error: (e, _) =>
              _SectionError(onRetry: () => ref.invalidate(childrenProvider)),
          data: (children) {
            if (children.isEmpty) {
              return _EmptyCard(
                message: t.home.noChildren,
                actionLabel: t.home.addChild,
                icon: Icons.child_care_outlined,
                onAction: () => context.push('/children'),
              );
            }
            return Column(
              children: [
                for (final c in children) ...[
                  _ChildCard(child: c),
                  const SizedBox(height: 12),
                ],
              ],
            );
          },
        );
  }
}

class _ChildCard extends StatelessWidget {
  const _ChildCard({required this.child});
  final Child child;

  @override
  Widget build(BuildContext context) {
    final t = context.t;
    final text = Theme.of(context).textTheme;
    final age = child.ageYears;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            UserAvatar(
              name: child.name,
              imageUrl: child.profileImageUrl,
              radius: 26,
              fallbackIcon: Icons.face,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(child.name, style: text.titleMedium),
                  if (age != null)
                    Text(
                      t.home.ageYears(years: age.toString()),
                      style: text.bodySmall,
                    )
                  else if (child.diagnosisInfo?.isNotEmpty ?? false)
                    Text(
                      child.diagnosisInfo!,
                      style: text.bodySmall,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                ],
              ),
            ),
            Icon(Icons.chevron_right, color: context.colors.textTertiary),
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Randevular
// ---------------------------------------------------------------------------
class _AppointmentsSection extends ConsumerWidget {
  const _AppointmentsSection();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = context.t;
    return ref
        .watch(upcomingAppointmentsProvider)
        .when(
          loading: () => const _SectionLoading(),
          error: (e, _) => _SectionError(
            onRetry: () => ref.invalidate(appointmentsProvider),
          ),
          data: (items) {
            if (items.isEmpty) {
              return _EmptyCard(
                message: t.home.noAppointments,
                icon: Icons.event_available_outlined,
              );
            }
            return Column(
              children: [
                for (final a in items.take(3)) ...[
                  _AppointmentTile(appointment: a),
                  const SizedBox(height: 12),
                ],
              ],
            );
          },
        );
  }
}

class _AppointmentTile extends StatelessWidget {
  const _AppointmentTile({required this.appointment});
  final Appointment appointment;

  @override
  Widget build(BuildContext context) {
    final t = context.t;
    final text = Theme.of(context).textTheme;
    final a = appointment;
    final month = t.common.monthsShort[a.date.month - 1];
    final title = a.expertName ?? a.type ?? '';
    final subtitle = a.expertTitle ?? a.childName ?? '';

    return Card(
      child: InkWell(
        borderRadius: BorderRadius.circular(AppRadius.lg),
        onTap: () => context.push('/appointments'),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  color: context.colors.primary.withValues(alpha: 0.10),
                  borderRadius: BorderRadius.circular(AppRadius.md),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '${a.date.day}',
                      style: TextStyle(
                        color: context.colors.primary,
                        fontWeight: FontWeight.w700,
                        fontSize: 18,
                      ),
                    ),
                    Text(
                      month,
                      style: TextStyle(
                        color: context.colors.primary,
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: text.titleMedium),
                    if (subtitle.isNotEmpty)
                      Text(subtitle, style: text.bodySmall),
                    const SizedBox(height: 2),
                    Row(
                      children: [
                        Icon(
                          Icons.schedule,
                          size: 14,
                          color: context.colors.textTertiary,
                        ),
                        const SizedBox(width: 4),
                        Text(a.time, style: text.bodySmall),
                      ],
                    ),
                  ],
                ),
              ),
              Icon(Icons.chevron_right, color: context.colors.textTertiary),
            ],
          ),
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Makaleler
// ---------------------------------------------------------------------------
class _ArticlesSection extends ConsumerWidget {
  const _ArticlesSection();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = context.t;
    return ref
        .watch(recommendedArticlesProvider)
        .when(
          loading: () => const _SectionLoading(),
          error: (e, _) => _SectionError(
            onRetry: () => ref.invalidate(recommendedArticlesProvider),
          ),
          data: (items) {
            if (items.isEmpty) {
              return _EmptyCard(
                message: t.home.noArticles,
                icon: Icons.menu_book_outlined,
              );
            }
            return Column(
              children: [
                for (final article in items.take(4)) ...[
                  _ArticleCard(article: article),
                  const SizedBox(height: 12),
                ],
              ],
            );
          },
        );
  }
}

class _ArticleCard extends StatelessWidget {
  const _ArticleCard({required this.article});
  final Article article;

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    final tag = article.category ?? article.format ?? '';
    return Card(
      child: InkWell(
        borderRadius: BorderRadius.circular(AppRadius.lg),
        onTap: () => Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => ArticleDetailScreen(
              id: article.id,
              initialTitle: article.title,
            ),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  color: context.colors.surfaceVariant,
                  borderRadius: BorderRadius.circular(AppRadius.md),
                ),
                child: Icon(
                  Icons.image_outlined,
                  color: context.colors.textTertiary,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (tag.isNotEmpty)
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 3,
                        ),
                        decoration: BoxDecoration(
                          color: context.colors.primary.withValues(alpha: 0.10),
                          borderRadius: BorderRadius.circular(AppRadius.sm),
                        ),
                        child: Text(
                          tag,
                          style: TextStyle(
                            color: context.colors.primary,
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    const SizedBox(height: 6),
                    Text(
                      article.title,
                      style: text.titleMedium,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (article.summary?.isNotEmpty ?? false) ...[
                      const SizedBox(height: 2),
                      Text(
                        article.summary!,
                        style: text.bodySmall,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Ortak durum bileşenleri
// ---------------------------------------------------------------------------
class _SectionLoading extends StatelessWidget {
  const _SectionLoading();

  @override
  Widget build(BuildContext context) {
    return const SkeletonList(count: 2, padding: EdgeInsets.zero);
  }
}

class _SectionError extends StatelessWidget {
  const _SectionError({required this.onRetry});
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final t = context.t;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Row(
          children: [
            Icon(Icons.error_outline, color: context.colors.error),
            const SizedBox(width: 12),
            Expanded(child: Text(t.common.loadError)),
            TextButton(onPressed: onRetry, child: Text(t.common.retry)),
          ],
        ),
      ),
    );
  }
}

class _EmptyCard extends StatelessWidget {
  const _EmptyCard({
    required this.message,
    required this.icon,
    this.actionLabel,
    this.onAction,
  });

  final String message;
  final IconData icon;
  final String? actionLabel;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Row(
          children: [
            Icon(icon, color: context.colors.textTertiary),
            const SizedBox(width: 12),
            Expanded(child: Text(message)),
            if (actionLabel != null && onAction != null)
              FilledButton.tonal(
                style: AppButtonStyles.inlineFilled,
                onPressed: onAction,
                child: Text(actionLabel!),
              ),
          ],
        ),
      ),
    );
  }
}
