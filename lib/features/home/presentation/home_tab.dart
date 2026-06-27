import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_theme.dart';
import '../../../i18n/strings.g.dart';
import '../../appointments/data/appointment_repository.dart';
import '../../appointments/domain/appointment.dart';
import '../../auth/presentation/auth_controller.dart';
import '../../children/data/child_repository.dart';
import '../../children/domain/child.dart';
import '../../knowledge/data/knowledge_repository.dart';
import '../../knowledge/domain/article.dart';
import 'widgets/section_header.dart';

/// Ana Sayfa sekmesi — backend'den gerçek veri (çocuklar, randevular, makaleler).
class HomeTab extends ConsumerWidget {
  const HomeTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authControllerProvider).user;
    final t = context.t;
    final text = Theme.of(context).textTheme;
    final name = user?.displayName ?? t.home.greetingFallback;

    return SafeArea(
      child: RefreshIndicator(
        onRefresh: () async {
          ref.invalidate(childrenProvider);
          ref.invalidate(appointmentsProvider);
          ref.invalidate(recommendedArticlesProvider);
        },
        child: ListView(
          padding: const EdgeInsets.fromLTRB(
              AppSpacing.margin, 8, AppSpacing.margin, 24),
          children: [
            Text(t.home.greeting(name: name), style: text.headlineLarge),
            const SizedBox(height: 4),
            Text(t.home.subtitle, style: text.bodySmall),
            const SizedBox(height: AppSpacing.lg),

            SectionHeader(
              title: t.home.childrenTitle,
              onAction: () => context.push('/children'),
            ),
            const SizedBox(height: 12),
            const _ChildrenSection(),
            const SizedBox(height: AppSpacing.lg),

            SectionHeader(title: t.home.upcomingAppointments, onAction: () {}),
            const SizedBox(height: 12),
            const _AppointmentsSection(),
            const SizedBox(height: AppSpacing.lg),

            SectionHeader(
              title: t.home.recommendedArticles,
              actionLabel: t.common.more,
              onAction: () {},
            ),
            const SizedBox(height: 12),
            const _ArticlesSection(),
          ],
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
    return ref.watch(childrenProvider).when(
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
            CircleAvatar(
              radius: 26,
              backgroundColor: AppColors.primary.withValues(alpha: 0.12),
              backgroundImage: (child.profileImageUrl?.isNotEmpty ?? false)
                  ? NetworkImage(child.profileImageUrl!)
                  : null,
              child: (child.profileImageUrl?.isEmpty ?? true)
                  ? const Icon(Icons.face, color: AppColors.primary)
                  : null,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(child.name, style: text.titleMedium),
                  if (age != null)
                    Text(t.home.ageYears(years: age.toString()),
                        style: text.bodySmall)
                  else if (child.diagnosisInfo?.isNotEmpty ?? false)
                    Text(child.diagnosisInfo!,
                        style: text.bodySmall,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis),
                ],
              ),
            ),
            const Icon(Icons.chevron_right, color: AppColors.textTertiary),
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
    return ref.watch(upcomingAppointmentsProvider).when(
          loading: () => const _SectionLoading(),
          error: (e, _) => _SectionError(
              onRetry: () => ref.invalidate(appointmentsProvider)),
          data: (items) {
            if (items.isEmpty) {
              return _EmptyCard(
                  message: t.home.noAppointments,
                  icon: Icons.event_available_outlined);
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
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.10),
                borderRadius: BorderRadius.circular(AppRadius.md),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('${a.date.day}',
                      style: const TextStyle(
                          color: AppColors.primary,
                          fontWeight: FontWeight.w700,
                          fontSize: 18)),
                  Text(month,
                      style: const TextStyle(
                          color: AppColors.primary, fontSize: 11)),
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
                      const Icon(Icons.schedule,
                          size: 14, color: AppColors.textTertiary),
                      const SizedBox(width: 4),
                      Text(a.time, style: text.bodySmall),
                    ],
                  ),
                ],
              ),
            ),
            const Icon(Icons.chevron_right, color: AppColors.textTertiary),
          ],
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
    return ref.watch(recommendedArticlesProvider).when(
          loading: () => const _SectionLoading(),
          error: (e, _) => _SectionError(
              onRetry: () => ref.invalidate(recommendedArticlesProvider)),
          data: (items) {
            if (items.isEmpty) {
              return _EmptyCard(
                  message: t.home.noArticles,
                  icon: Icons.menu_book_outlined);
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
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                color: AppColors.surfaceVariant,
                borderRadius: BorderRadius.circular(AppRadius.md),
              ),
              child: const Icon(Icons.image_outlined,
                  color: AppColors.textTertiary),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (tag.isNotEmpty)
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withValues(alpha: 0.10),
                        borderRadius: BorderRadius.circular(AppRadius.sm),
                      ),
                      child: Text(tag,
                          style: const TextStyle(
                              color: AppColors.primary,
                              fontSize: 11,
                              fontWeight: FontWeight.w600)),
                    ),
                  const SizedBox(height: 6),
                  Text(article.title,
                      style: text.titleMedium,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis),
                  if (article.summary?.isNotEmpty ?? false) ...[
                    const SizedBox(height: 2),
                    Text(article.summary!,
                        style: text.bodySmall,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis),
                  ],
                ],
              ),
            ),
          ],
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
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: 24),
      child: Center(
        child: SizedBox(
          height: 28,
          width: 28,
          child: CircularProgressIndicator(strokeWidth: 2.5),
        ),
      ),
    );
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
            const Icon(Icons.error_outline, color: AppColors.error),
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
            Icon(icon, color: AppColors.textTertiary),
            const SizedBox(width: 12),
            Expanded(child: Text(message)),
            if (actionLabel != null && onAction != null)
              FilledButton.tonal(
                onPressed: onAction,
                child: Text(actionLabel!),
              ),
          ],
        ),
      ),
    );
  }
}
