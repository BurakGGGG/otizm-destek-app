import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../core/config/env.dart';
import '../../../core/haptics.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_theme.dart';
import '../../../i18n/strings.g.dart';
import '../../auth/domain/app_user.dart';
import '../../auth/presentation/auth_controller.dart';
import '../data/watched_videos.dart';
import '../domain/guide_content.dart';

/// Kullanıcı Rehberi (web `/kullanici-rehberi`): rolüne göre başlangıç
/// adımları, bölüm kataloğu (arama + kategori) ve eğitim videoları.
///
/// Videolar web sunucusunda barındığı (webm, 66 MB) için uygulamaya
/// gömülmez; kart web rehberini ilgili videoda açar.
class GuideScreen extends ConsumerStatefulWidget {
  const GuideScreen({super.key});

  @override
  ConsumerState<GuideScreen> createState() => _GuideScreenState();
}

class _GuideScreenState extends ConsumerState<GuideScreen> {
  final _search = TextEditingController();
  String _query = '';
  int _groupIndex = 0;

  @override
  void dispose() {
    _search.dispose();
    super.dispose();
  }

  Future<void> _openVideo(TutorialVideo video) async {
    final t = context.t;
    final uri = Uri.parse(
      '${Env.webBaseUrl}/kullanici-rehberi?video=${video.id}',
    );
    final opened = await launchUrl(uri, mode: LaunchMode.externalApplication);
    if (!mounted) return;
    if (opened) {
      ref.read(watchedVideosProvider.notifier).markWatched(video.id);
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(t.guide.videoOpenError)));
    }
  }

  @override
  Widget build(BuildContext context) {
    final t = context.t;
    final colors = context.colors;
    final text = Theme.of(context).textTheme;
    final isExpert =
        ref.watch(authControllerProvider).user?.role == UserRole.expert;
    final groups = isExpert ? expertGuideGroups(t) : parentGuideGroups(t);
    final searching = _query.trim().isNotEmpty;
    final filtered = filterGuideGroups(groups, _query);
    final videos = parentTutorialVideos(t)
        .where((video) => !searching || video.matches(_query))
        .toList();
    final visibleGroups = searching
        ? filtered
        : [groups[_groupIndex.clamp(0, groups.length - 1)]];
    final watched = ref.watch(watchedVideosProvider);

    return Scaffold(
      appBar: AppBar(title: Text(t.guide.title)),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.margin,
            AppSpacing.md,
            AppSpacing.margin,
            40,
          ),
          children: [
            Text(
              t.guide.subtitle,
              style: text.bodySmall?.copyWith(color: colors.textSecondary),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _search,
              onChanged: (value) => setState(() => _query = value),
              decoration: InputDecoration(
                hintText: t.guide.searchHint,
                prefixIcon: const Icon(Icons.search, size: 20),
                suffixIcon: searching
                    ? IconButton(
                        icon: const Icon(Icons.close, size: 18),
                        onPressed: () {
                          _search.clear();
                          setState(() => _query = '');
                        },
                      )
                    : null,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              t.guide.countLabel(
                visible: guidePageCount(filtered),
                total: guidePageCount(groups),
              ),
              style: text.labelSmall?.copyWith(color: colors.textTertiary),
            ),
            const SizedBox(height: AppSpacing.md),
            if (!searching) ...[
              _SectionHeader(
                title: t.guide.startTitle,
                subtitle: t.guide.startSubtitle,
              ),
              const SizedBox(height: 10),
              for (final step in guideStartSteps(t, expert: isExpert)) ...[
                _StartStepCard(step: step),
                const SizedBox(height: 10),
              ],
              const SizedBox(height: AppSpacing.sm),
            ],
            _SectionHeader(
              title: t.guide.sectionsTitle,
              subtitle: searching ? null : t.guide.sectionsSubtitle,
            ),
            const SizedBox(height: 10),
            if (!searching && groups.length > 1) ...[
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    for (var i = 0; i < groups.length; i++) ...[
                      ChoiceChip(
                        label: Text(groups[i].title),
                        selected: i == _groupIndex,
                        onSelected: (_) => setState(() => _groupIndex = i),
                      ),
                      const SizedBox(width: 8),
                    ],
                  ],
                ),
              ),
              const SizedBox(height: 12),
            ],
            if (searching && filtered.isEmpty && videos.isEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 24),
                child: Text(
                  t.guide.searchEmpty,
                  textAlign: TextAlign.center,
                  style:
                      text.bodyMedium?.copyWith(color: colors.textTertiary),
                ),
              ),
            for (final group in visibleGroups) ...[
              Text(
                group.description,
                style: text.labelSmall?.copyWith(color: colors.textSecondary),
              ),
              const SizedBox(height: 10),
              for (final page in group.pages) ...[
                _GuidePageCard(page: page),
                const SizedBox(height: 10),
              ],
              const SizedBox(height: 6),
            ],
            const SizedBox(height: AppSpacing.sm),
            _SectionHeader(
              title: t.guide.videosTitle,
              subtitle: t.guide.videosSubtitle,
            ),
            const SizedBox(height: 6),
            Text(
              t.guide.videoProgress(
                done: watched.length,
                total: parentTutorialVideos(t).length,
              ),
              style: text.labelSmall?.copyWith(color: colors.textTertiary),
            ),
            const SizedBox(height: 10),
            for (final video in videos) ...[
              _VideoCard(
                video: video,
                watched: watched.contains(video.id),
                onOpen: () => _openVideo(video),
                onToggleWatched: () => ref
                    .read(watchedVideosProvider.notifier)
                    .toggle(video.id),
              ),
              const SizedBox(height: 10),
            ],
          ],
        ),
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.title, this.subtitle});

  final String title;
  final String? subtitle;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final text = Theme.of(context).textTheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: text.titleSmall),
        if (subtitle case final subtitle?) ...[
          const SizedBox(height: 2),
          Text(
            subtitle,
            style: text.labelSmall?.copyWith(color: colors.textSecondary),
          ),
        ],
      ],
    );
  }
}

/// "Nereden başlamalı?" adımı — dokununca ilgili bölümü açar.
class _StartStepCard extends StatelessWidget {
  const _StartStepCard({required this.step});

  final GuideStartStep step;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final text = Theme.of(context).textTheme;
    final route = step.route;

    return InkWell(
      borderRadius: BorderRadius.circular(AppRadius.lg),
      onTap: route == null ? null : () => context.push(route),
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.md),
        decoration: BoxDecoration(
          color: colors.primary.withValues(alpha: .05),
          borderRadius: BorderRadius.circular(AppRadius.lg),
          border: Border.all(color: colors.primary.withValues(alpha: .16)),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                color: colors.surface,
                borderRadius: BorderRadius.circular(AppRadius.md),
              ),
              child: Icon(step.icon, size: 20, color: colors.primary),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(step.title, style: text.labelLarge),
                  const SizedBox(height: 2),
                  Text(
                    step.description,
                    style: text.bodySmall
                        ?.copyWith(color: colors.textSecondary),
                  ),
                  const SizedBox(height: 6),
                  _Badge(label: step.badge),
                ],
              ),
            ),
            if (route != null)
              Icon(Icons.chevron_right, size: 20, color: colors.textTertiary),
          ],
        ),
      ),
    );
  }
}

/// Bölüm kartı: ne işe yarar / ne zaman kullanılır + bölüme git.
class _GuidePageCard extends StatelessWidget {
  const _GuidePageCard({required this.page});

  final GuidePage page;

  @override
  Widget build(BuildContext context) {
    final t = context.t;
    final colors = context.colors;
    final text = Theme.of(context).textTheme;

    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(color: colors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(page.icon, size: 20, color: colors.primary),
              const SizedBox(width: 8),
              Expanded(child: Text(page.title, style: text.titleSmall)),
              if (page.badge case final badge?) _Badge(label: badge),
            ],
          ),
          const SizedBox(height: 10),
          _Labelled(label: t.guide.purposeLabel, value: page.purpose),
          const SizedBox(height: 8),
          _Labelled(label: t.guide.whenLabel, value: page.useWhen),
          const SizedBox(height: 10),
          Align(
            alignment: AlignmentDirectional.centerEnd,
            child: TextButton.icon(
              onPressed: () {
                Haptics.selection();
                context.push(page.route);
              },
              icon: const Icon(Icons.arrow_forward, size: 16),
              label: Text(t.guide.openPage),
            ),
          ),
        ],
      ),
    );
  }
}

class _Labelled extends StatelessWidget {
  const _Labelled({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final text = Theme.of(context).textTheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: text.labelSmall?.copyWith(
            color: colors.textTertiary,
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(height: 2),
        Text(value, style: text.bodySmall),
      ],
    );
  }
}

class _Badge extends StatelessWidget {
  const _Badge({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: colors.primary.withValues(alpha: .10),
        borderRadius: BorderRadius.circular(AppRadius.sm),
      ),
      child: Text(
        label,
        style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: colors.primary,
              fontWeight: FontWeight.w700,
            ),
      ),
    );
  }
}

/// Eğitim videosu kartı — açılış tarayıcıda, izlendi işareti cihazda saklanır.
class _VideoCard extends StatelessWidget {
  const _VideoCard({
    required this.video,
    required this.watched,
    required this.onOpen,
    required this.onToggleWatched,
  });

  final TutorialVideo video;
  final bool watched;
  final VoidCallback onOpen;
  final VoidCallback onToggleWatched;

  @override
  Widget build(BuildContext context) {
    final t = context.t;
    final colors = context.colors;
    final text = Theme.of(context).textTheme;

    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(
          color: watched ? colors.success.withValues(alpha: .45) : colors.border,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  color: colors.primary.withValues(alpha: .08),
                  borderRadius: BorderRadius.circular(AppRadius.md),
                ),
                child: Icon(
                  watched ? Icons.check_circle_outline : Icons.play_arrow,
                  size: 20,
                  color: watched ? colors.success : colors.primary,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(video.title, style: text.titleSmall),
                    const SizedBox(height: 2),
                    Text(
                      '${video.category} · ${video.duration}',
                      style: text.labelSmall
                          ?.copyWith(color: colors.textTertiary),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            video.description,
            style: text.bodySmall?.copyWith(color: colors.textSecondary),
          ),
          const SizedBox(height: 6),
          Row(
            children: [
              TextButton.icon(
                onPressed: onToggleWatched,
                icon: Icon(
                  watched
                      ? Icons.check_box_outlined
                      : Icons.check_box_outline_blank,
                  size: 16,
                ),
                label: Text(
                  watched ? t.guide.videoWatched : t.guide.videoMarkWatched,
                ),
              ),
              const Spacer(),
              FilledButton.tonalIcon(
                onPressed: onOpen,
                icon: const Icon(Icons.open_in_new, size: 16),
                label: Text(t.guide.videoWatch),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
