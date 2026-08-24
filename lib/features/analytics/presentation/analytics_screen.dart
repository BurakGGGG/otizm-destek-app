import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

import '../../../core/network/api_exception.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/util/date_key.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/empty_state.dart';
import '../../../core/widgets/skeleton.dart';
import '../../../i18n/strings.g.dart';
import '../../children/data/child_repository.dart';
import '../../children/domain/child.dart';
import '../data/analytics_repository.dart';
import '../data/analytics_summary_provider.dart';
import '../domain/analytics_summary.dart';
import '../domain/analytics_trends.dart';
import 'widgets/analytics_detail_section.dart';
import 'widgets/ai_insights_card.dart';

/// Gelişim Paneli — seçili çocuğun son 6 aylık trend grafikleri
/// (`/api/analytics`).
class AnalyticsScreen extends ConsumerStatefulWidget {
  const AnalyticsScreen({super.key});

  @override
  ConsumerState<AnalyticsScreen> createState() => _AnalyticsScreenState();
}

class _AnalyticsScreenState extends ConsumerState<AnalyticsScreen> {
  String? _selectedChildId;
  int _rangeDays = 30;

  /// Ham kayıtları CSV olarak paylaşır (web'de indirme, mobilde paylaşım
  /// sayfası). Sütunlar web `exportCsv` ile aynı.
  Future<void> _shareCsv(String childId) async {
    final t = context.t;
    final messenger = ScaffoldMessenger.of(context);
    try {
      final sources =
          await ref.read(analyticsSourcesProvider(childId).future);
      final csv = analyticsCsv(
        moods: sources.moods,
        sleeps: sources.sleeps,
        milestones: sources.milestones,
      );
      // Yalnızca başlık satırı varsa paylaşacak kayıt yok demektir.
      if (!csv.contains('\n')) {
        messenger.showSnackBar(
          SnackBar(content: Text(t.analytics.exportEmpty)),
        );
        return;
      }
      final dir = await getTemporaryDirectory();
      final file = File('${dir.path}/gelisim-${localDateKey(DateTime.now())}.csv');
      await file.writeAsString(csv);
      await SharePlus.instance.share(
        ShareParams(
          files: [XFile(file.path, mimeType: 'text/csv')],
          fileNameOverrides: [file.uri.pathSegments.last],
        ),
      );
    } on ApiException catch (e) {
      messenger.showSnackBar(SnackBar(content: Text(e.message)));
    }
  }

  @override
  Widget build(BuildContext context) {
    final t = context.t;
    final childrenAsync = ref.watch(childrenProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(t.analytics.title),
        actions: [
          IconButton(
            tooltip: t.analytics.exportCsv,
            onPressed: _selectedChildId == null
                ? null
                : () => _shareCsv(_selectedChildId!),
            icon: const Icon(Icons.ios_share_outlined),
          ),
        ],
      ),
      body: SafeArea(
        child: childrenAsync.when(
          loading: () => const SkeletonList(count: 4),
          error: (e, _) =>
              ErrorRetry(onRetry: () => ref.invalidate(childrenProvider)),
          data: (children) {
            if (children.isEmpty) {
              return EmptyState(
                icon: Icons.child_care_outlined,
                message: t.analytics.noChild,
                actionLabel: t.children.add,
                actionIcon: Icons.child_care_outlined,
                onAction: () => context.push('/children'),
              );
            }
            final childId = _selectedChildId ??= children.first.id;
            return Column(
              children: [
                if (children.length > 1)
                  _ChildSelector(
                    children: children,
                    selectedId: childId,
                    onSelect: (id) => setState(() => _selectedChildId = id),
                  ),
                Expanded(
                  child: _TrendsBody(
                    childId: childId,
                    rangeDays: _rangeDays,
                    onRangeChanged: (days) =>
                        setState(() => _rangeDays = days),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _ChildSelector extends StatelessWidget {
  const _ChildSelector({
    required this.children,
    required this.selectedId,
    required this.onSelect,
  });

  final List<Child> children;
  final String selectedId;
  final ValueChanged<String> onSelect;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 56,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.margin, vertical: 8),
        itemCount: children.length,
        separatorBuilder: (_, _) => const SizedBox(width: 8),
        itemBuilder: (_, i) {
          final c = children[i];
          final sel = c.id == selectedId;
          return ChoiceChip(
            label: Text(c.name),
            selected: sel,
            onSelected: (_) => onSelect(c.id),
            showCheckmark: false,
            selectedColor: context.colors.primary,
            backgroundColor: context.colors.surface,
            side: BorderSide(color: context.colors.border),
            labelStyle: TextStyle(
              color: sel ? Colors.white : context.colors.textSecondary,
              fontWeight: FontWeight.w600,
              fontSize: 13,
            ),
          );
        },
      ),
    );
  }
}

class _TrendsBody extends ConsumerWidget {
  const _TrendsBody({
    required this.childId,
    required this.rangeDays,
    required this.onRangeChanged,
  });

  final String childId;
  final int rangeDays;
  final ValueChanged<int> onRangeChanged;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = context.t;
    final async = ref.watch(analyticsTrendsProvider(childId));
    return async.when(
      loading: () => const SkeletonList(count: 4),
      error: (e, _) => ErrorRetry(
          onRetry: () => ref.invalidate(analyticsTrendsProvider(childId))),
      data: (trends) {
        String count(double v) => v.round().toString();
        String oneDecimal(double v) => v.toStringAsFixed(1);
        return RefreshIndicator(
          onRefresh: () async =>
              ref.invalidate(analyticsTrendsProvider(childId)),
          child: ListView(
            padding: const EdgeInsets.fromLTRB(
                AppSpacing.margin, 4, AppSpacing.margin, 24),
            children: [
              Text(t.analytics.subtitle,
                  style: Theme.of(context).textTheme.bodySmall),
              const SizedBox(height: 16),
              AiInsightsCard(childId: childId),
              const SizedBox(height: 16),
              AnalyticsRangeBar(selected: rangeDays, onSelect: onRangeChanged),
              const SizedBox(height: 12),
              _DetailSection(childId: childId, rangeDays: rangeDays),
              const SizedBox(height: 16),
              _ChartCard(
                icon: Icons.emoji_events_outlined,
                title: t.analytics.milestones,
                unit: t.analytics.milestonesUnit,
                points: trends.milestones,
                format: count,
              ),
              const SizedBox(height: 12),
              _ChartCard(
                icon: Icons.mood_outlined,
                title: t.analytics.mood,
                unit: t.analytics.moodUnit,
                points: trends.moods,
                format: oneDecimal,
                fixedMax: 5,
              ),
              const SizedBox(height: 12),
              _ChartCard(
                icon: Icons.bedtime_outlined,
                title: t.analytics.sleep,
                unit: t.analytics.sleepUnit,
                // Backend dakika döndürür; saat olarak gösterilir.
                points: [
                  for (final p in trends.sleeps)
                    TrendPoint(month: p.month, value: p.value / 60),
                ],
                format: oneDecimal,
              ),
              const SizedBox(height: 12),
              _ChartCard(
                icon: Icons.psychology_outlined,
                title: t.analytics.behavior,
                unit: t.analytics.behaviorUnit,
                points: trends.behaviors,
                format: count,
              ),
            ],
          ),
        );
      },
    );
  }
}

class _ChartCard extends StatelessWidget {
  const _ChartCard({
    required this.icon,
    required this.title,
    required this.unit,
    required this.points,
    required this.format,
    this.fixedMax,
  });

  final IconData icon;
  final String title;
  final String unit;
  final List<TrendPoint> points;
  final String Function(double) format;

  /// Sabit üst sınır (örn. ruh hali için 5); yoksa serinin en büyüğü.
  final double? fixedMax;

  @override
  Widget build(BuildContext context) {
    final t = context.t;
    final text = Theme.of(context).textTheme;
    final hasData = points.any((p) => p.value > 0);

    return Card(
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: context.colors.primary.withValues(alpha: 0.12),
                    shape: BoxShape.circle,
                  ),
                  child:
                      Icon(icon, size: 20, color: context.colors.primary),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(title, style: text.titleSmall),
                      Text(unit,
                          style: text.bodySmall?.copyWith(
                              fontSize: 11,
                              color: context.colors.textTertiary)),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            if (!hasData)
              Padding(
                padding: const EdgeInsets.only(bottom: 4),
                child: Text(
                  t.analytics.noData,
                  style: text.bodySmall
                      ?.copyWith(color: context.colors.textTertiary),
                ),
              )
            else
              _MonthlyBars(
                points: points,
                format: format,
                fixedMax: fixedMax,
              ),
          ],
        ),
      ),
    );
  }
}

/// Tek serilik aylık çubuk grafik — eksen yerine sıfırdan büyük değerler
/// doğrudan etiketlenir; aylar kısaltmayla gösterilir.
class _MonthlyBars extends StatelessWidget {
  const _MonthlyBars({
    required this.points,
    required this.format,
    this.fixedMax,
  });

  final List<TrendPoint> points;
  final String Function(double) format;
  final double? fixedMax;

  static const double _chartHeight = 88;

  @override
  Widget build(BuildContext context) {
    final t = context.t;
    final colors = context.colors;
    var max = fixedMax ?? 0;
    if (fixedMax == null) {
      for (final p in points) {
        if (p.value > max) max = p.value;
      }
    }
    if (max <= 0) max = 1;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        for (var i = 0; i < points.length; i++) ...[
          if (i > 0) const SizedBox(width: 8),
          Expanded(child: _bar(context, t, colors, points[i], max)),
        ],
      ],
    );
  }

  Widget _bar(BuildContext context, Translations t, AppPalette colors,
      TrendPoint p, double max) {
    final ratio = (p.value / max).clamp(0.0, 1.0);
    final barHeight = p.value <= 0 ? 2.0 : (_chartHeight * ratio).clamp(4.0, _chartHeight);
    final monthIndex = p.monthNumber;
    final monthLabel = monthIndex >= 1 && monthIndex <= 12
        ? t.common.monthsShort[monthIndex - 1]
        : p.month;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (p.value > 0)
          Padding(
            padding: const EdgeInsets.only(bottom: 4),
            child: Text(
              format(p.value),
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w600,
                color: colors.textSecondary,
              ),
            ),
          ),
        Container(
          height: barHeight,
          width: double.infinity,
          decoration: BoxDecoration(
            color: p.value > 0
                ? colors.primary
                : colors.border,
            borderRadius:
                const BorderRadius.vertical(top: Radius.circular(4)),
          ),
        ),
        const SizedBox(height: 6),
        Text(
          monthLabel,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(fontSize: 10, color: colors.textTertiary),
        ),
      ],
    );
  }
}

/// Aralığa göre günlük seriler, kırılımlar ve takip skoru (web AnalyticsPage
/// grafik sekmelerinin mobil karşılığı — mobilde tek akışta).
class _DetailSection extends ConsumerWidget {
  const _DetailSection({required this.childId, required this.rangeDays});

  final String childId;
  final int rangeDays;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = context.t;
    final async = ref.watch(
      analyticsSummaryProvider((childId: childId, rangeDays: rangeDays)),
    );
    final summary = async.asData?.value;
    if (summary == null) {
      return async.isLoading
          ? const SkeletonList(count: 2, padding: EdgeInsets.zero)
          : const SizedBox.shrink();
    }

    return Column(
      children: [
        AnalyticsSummaryCard(summary: summary),
        const SizedBox(height: 12),
        DailySeriesCard(
          icon: Icons.mood_outlined,
          title: t.analytics.dailyMood,
          unit: t.analytics.dailyMoodUnit,
          points: summary.moodPoints,
          fixedMax: 5,
          format: (v) => v.toStringAsFixed(1),
        ),
        const SizedBox(height: 12),
        DailySeriesCard(
          icon: Icons.bedtime_outlined,
          title: t.analytics.dailySleep,
          unit: t.analytics.dailySleepUnit,
          points: summary.sleepHourPoints,
          secondaryPoints: summary.sleepQualityPoints,
          secondaryLabel: t.analytics.dailySleepQuality,
          format: (v) => v.toStringAsFixed(1),
        ),
        const SizedBox(height: 12),
        CategoryBreakdownCard(
          icon: Icons.psychology_outlined,
          title: t.analytics.behaviorCategories,
          unit: t.analytics.behaviorCategoriesUnit,
          items: summary.behaviorCategories,
          showIntensity: true,
        ),
        const SizedBox(height: 12),
        CategoryBreakdownCard(
          icon: Icons.emoji_events_outlined,
          title: t.analytics.milestoneCategories,
          unit: t.analytics.milestoneCategoriesUnit,
          items: summary.milestoneCategories,
        ),
        const SizedBox(height: 12),
        CategoryBreakdownCard(
          icon: Icons.sticky_note_2_outlined,
          title: t.analytics.notesActivity,
          unit: t.analytics.notesActivityUnit,
          items: summary.notesByMonth,
          labelOf: (month) {
            final parts = month.split('-');
            if (parts.length != 2) return month;
            final index = int.tryParse(parts[1]) ?? 0;
            return index >= 1 && index <= 12
                ? '${t.common.monthsShort[index - 1]} ${parts[0]}'
                : month;
          },
        ),
      ],
    );
  }
}
