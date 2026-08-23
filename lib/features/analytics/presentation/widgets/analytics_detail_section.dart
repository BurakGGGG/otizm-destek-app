import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../i18n/strings.g.dart';
import '../../domain/analytics_summary.dart';

/// Gün aralığı seçici (7/14/30/90 — web `RANGE_OPTIONS`).
class AnalyticsRangeBar extends StatelessWidget {
  const AnalyticsRangeBar({
    super.key,
    required this.selected,
    required this.onSelect,
  });

  final int selected;
  final ValueChanged<int> onSelect;

  @override
  Widget build(BuildContext context) {
    final t = context.t;
    // Dört aralık tek satırda: Wrap kullanıldığında son seçenek alt satıra
    // düşüp seçiciyi ikiye bölüyordu. Yatay kaydırma büyük yazı modunda da
    // taşmıyor (ekrandaki diğer süzgeç şeritleriyle aynı desen).
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          for (final days in kAnalyticsRanges) ...[
            ChoiceChip(
              label: Text(t.analytics.rangeDays(count: days)),
              selected: selected == days,
              showCheckmark: false,
              onSelected: (_) => onSelect(days),
            ),
            if (days != kAnalyticsRanges.last) const SizedBox(width: 8),
          ],
        ],
      ),
    );
  }
}

/// Takip skoru + öngörüler + eksik veri önerileri.
class AnalyticsSummaryCard extends StatelessWidget {
  const AnalyticsSummaryCard({super.key, required this.summary});

  final AnalyticsSummary summary;

  @override
  Widget build(BuildContext context) {
    final t = context.t;
    final colors = context.colors;
    final text = Theme.of(context).textTheme;
    final levelColor = switch (summary.level) {
      WellbeingLevel.strong => colors.success,
      WellbeingLevel.growing => colors.primary,
      WellbeingLevel.waiting => colors.warning,
    };

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
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(t.analytics.scoreTitle, style: text.titleSmall),
                    const SizedBox(height: 2),
                    Text(
                      t.analytics.scoreCoverage(
                        count: summary.dataCoverage,
                        total: 6,
                      ),
                      style: text.labelSmall
                          ?.copyWith(color: colors.textSecondary),
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '${summary.wellbeingScore}',
                    style: text.headlineSmall?.copyWith(color: levelColor),
                  ),
                  Text(
                    _levelLabel(t, summary.level),
                    style: text.labelSmall?.copyWith(color: levelColor),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 10),
          ClipRRect(
            borderRadius: BorderRadius.circular(AppRadius.full),
            child: LinearProgressIndicator(
              value: summary.wellbeingScore / 100,
              minHeight: 6,
              backgroundColor: colors.surfaceVariant,
              valueColor: AlwaysStoppedAnimation(levelColor),
            ),
          ),
          if (summary.insights.isNotEmpty) ...[
            const SizedBox(height: 14),
            for (final insight in summary.insights)
              Padding(
                padding: const EdgeInsets.only(bottom: 6),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.insights_outlined,
                      size: 16,
                      color: colors.primary,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        insightText(t, insight),
                        style: text.bodySmall,
                      ),
                    ),
                  ],
                ),
              ),
          ],
          if (summary.actions.isNotEmpty) ...[
            const SizedBox(height: 8),
            Text(
              t.analytics.actionsTitle,
              style: text.labelSmall?.copyWith(color: colors.textSecondary),
            ),
            const SizedBox(height: 6),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                for (final action in summary.actions)
                  ActionChip(
                    avatar: Icon(_actionIcon(action), size: 16),
                    label: Text(_actionLabel(t, action)),
                    onPressed: () => context.push(_actionRoute(action)),
                  ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}

/// Günlük seri grafiği (ruh hali/uyku). Sütunlar tarih sırasıyla çizilir;
/// nokta sayısı çoksa yalnızca ilk ve son tarih etiketlenir.
class DailySeriesCard extends StatelessWidget {
  const DailySeriesCard({
    super.key,
    required this.icon,
    required this.title,
    required this.unit,
    required this.points,
    required this.format,
    this.fixedMax,
    this.secondaryPoints,
    this.secondaryLabel,
  });

  final IconData icon;
  final String title;
  final String unit;
  final List<DailyPoint> points;
  final String Function(double) format;
  final double? fixedMax;

  /// İkinci seri (uyku kalitesi gibi) — varsa açık tonda çizilir.
  final List<DailyPoint>? secondaryPoints;
  final String? secondaryLabel;

  @override
  Widget build(BuildContext context) {
    final t = context.t;
    final colors = context.colors;
    final text = Theme.of(context).textTheme;
    if (points.isEmpty) {
      return _EmptyCard(icon: icon, title: title, message: t.analytics.noData);
    }

    final maxValue = fixedMax ??
        points.map((p) => p.value).fold<double>(1, (a, b) => a > b ? a : b);
    final secondary = secondaryPoints ?? const <DailyPoint>[];
    final secondaryMax = secondary.isEmpty
        ? 1.0
        : secondary.map((p) => p.value).fold<double>(1, (a, b) => a > b ? a : b);

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
          _CardHeader(icon: icon, title: title, unit: unit),
          const SizedBox(height: 14),
          SizedBox(
            height: 120,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                for (var i = 0; i < points.length; i++)
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 1.5),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          if (secondary.length == points.length)
                            Container(
                              height: (secondary[i].value / secondaryMax * 30)
                                  .clamp(2, 30),
                              decoration: BoxDecoration(
                                color: colors.success.withValues(alpha: .55),
                                borderRadius: const BorderRadius.vertical(
                                  top: Radius.circular(3),
                                ),
                              ),
                            ),
                          const SizedBox(height: 2),
                          Container(
                            height: (points[i].value / maxValue * 78)
                                .clamp(2, 78),
                            decoration: BoxDecoration(
                              color: colors.primary,
                              borderRadius: const BorderRadius.vertical(
                                top: Radius.circular(3),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Text(
                _dayLabel(points.first.date),
                style: text.labelSmall?.copyWith(color: colors.textTertiary),
              ),
              const Spacer(),
              Text(
                _dayLabel(points.last.date),
                style: text.labelSmall?.copyWith(color: colors.textTertiary),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Row(
            children: [
              _Legend(color: colors.primary, label: unit),
              if (secondaryLabel != null && secondary.isNotEmpty) ...[
                const SizedBox(width: 12),
                _Legend(
                  color: colors.success.withValues(alpha: .55),
                  label: secondaryLabel!,
                ),
              ],
              const Spacer(),
              Text(
                format(
                  points.fold<double>(0, (sum, p) => sum + p.value) /
                      points.length,
                ),
                style: text.labelSmall?.copyWith(color: colors.textSecondary),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// Kategori kırılımı (davranış/kilometre taşı/not) — yatay çubuklar.
class CategoryBreakdownCard extends StatelessWidget {
  const CategoryBreakdownCard({
    super.key,
    required this.icon,
    required this.title,
    required this.unit,
    required this.items,
    this.showIntensity = false,
    this.labelOf,
  });

  final IconData icon;
  final String title;
  final String unit;
  final List<CategoryCount> items;
  final bool showIntensity;

  /// Etiketi dönüştürmek için (ör. `2026-08` → `Ağu`).
  final String Function(String)? labelOf;

  @override
  Widget build(BuildContext context) {
    final t = context.t;
    final colors = context.colors;
    final text = Theme.of(context).textTheme;
    if (items.isEmpty) {
      return _EmptyCard(icon: icon, title: title, message: t.analytics.noData);
    }
    final maxCount =
        items.map((i) => i.count).fold<int>(1, (a, b) => a > b ? a : b);

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
          _CardHeader(icon: icon, title: title, unit: unit),
          const SizedBox(height: 12),
          for (final item in items.take(6))
            Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          labelOf?.call(item.name) ?? item.name,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: text.labelSmall,
                        ),
                      ),
                      Text(
                        showIntensity && item.averageIntensity != null
                            ? t.analytics.countWithIntensity(
                                count: item.count,
                                intensity:
                                    item.averageIntensity!.toStringAsFixed(1),
                              )
                            : '${item.count}',
                        style: text.labelSmall
                            ?.copyWith(color: colors.textSecondary),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(AppRadius.full),
                    child: LinearProgressIndicator(
                      value: item.count / maxCount,
                      minHeight: 6,
                      backgroundColor: colors.surfaceVariant,
                      valueColor: AlwaysStoppedAnimation(colors.primary),
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

class _CardHeader extends StatelessWidget {
  const _CardHeader({
    required this.icon,
    required this.title,
    required this.unit,
  });

  final IconData icon;
  final String title;
  final String unit;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final text = Theme.of(context).textTheme;
    return Row(
      children: [
        Container(
          width: 34,
          height: 34,
          decoration: BoxDecoration(
            color: colors.primary.withValues(alpha: .12),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, size: 18, color: colors.primary),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: text.titleSmall),
              Text(
                unit,
                style: text.labelSmall?.copyWith(color: colors.textTertiary),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _EmptyCard extends StatelessWidget {
  const _EmptyCard({
    required this.icon,
    required this.title,
    required this.message,
  });

  final IconData icon;
  final String title;
  final String message;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final text = Theme.of(context).textTheme;
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(color: colors.border),
      ),
      child: Row(
        children: [
          Icon(icon, size: 18, color: colors.textTertiary),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: text.titleSmall),
                Text(
                  message,
                  style: text.labelSmall?.copyWith(color: colors.textTertiary),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Legend extends StatelessWidget {
  const _Legend({required this.color, required this.label});

  final Color color;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 4),
        Text(
          label,
          style: Theme.of(context)
              .textTheme
              .labelSmall
              ?.copyWith(color: context.colors.textTertiary),
        ),
      ],
    );
  }
}

String _dayLabel(String isoDate) {
  final parts = isoDate.split('-');
  return parts.length == 3 ? '${parts[2]}.${parts[1]}' : isoDate;
}

String _levelLabel(Translations t, WellbeingLevel level) => switch (level) {
      WellbeingLevel.strong => t.analytics.scoreStrong,
      WellbeingLevel.growing => t.analytics.scoreGrowing,
      WellbeingLevel.waiting => t.analytics.scoreWaiting,
    };

IconData _actionIcon(AnalyticsAction action) => switch (action) {
      AnalyticsAction.addMood => Icons.mood_outlined,
      AnalyticsAction.addSleep => Icons.bedtime_outlined,
      AnalyticsAction.addNote => Icons.sticky_note_2_outlined,
      AnalyticsAction.addMilestone => Icons.emoji_events_outlined,
    };

String _actionLabel(Translations t, AnalyticsAction action) =>
    switch (action) {
      AnalyticsAction.addMood => t.analytics.actionMood,
      AnalyticsAction.addSleep => t.analytics.actionSleep,
      AnalyticsAction.addNote => t.analytics.actionNote,
      AnalyticsAction.addMilestone => t.analytics.actionMilestone,
    };

String _actionRoute(AnalyticsAction action) => switch (action) {
      AnalyticsAction.addMood => '/daily-tracker',
      AnalyticsAction.addSleep => '/daily-tracker',
      AnalyticsAction.addNote => '/notes',
      AnalyticsAction.addMilestone => '/children',
    };

/// Öngörü metni — kurallar saf tarafta, cümleler burada.
String insightText(Translations t, AnalyticsInsight insight) {
  return switch (insight.kind) {
    InsightKind.moodHigh => t.analytics.insightMoodHigh(
        days: insight.rangeDays,
        value: insight.value,
      ),
    InsightKind.moodLow => t.analytics.insightMoodLow(
        days: insight.rangeDays,
        value: insight.value,
      ),
    InsightKind.sleepShort => t.analytics.insightSleepShort(value: insight.value),
    InsightKind.sleepGood => t.analytics.insightSleepGood(value: insight.value),
    InsightKind.topMilestoneCategory => t.analytics.insightMilestones(
        category: insight.value,
        count: insight.count,
      ),
    InsightKind.appointments => insight.secondCount > 0
        ? t.analytics.insightAppointmentsWithPending(
            count: insight.count,
            pending: insight.secondCount,
          )
        : t.analytics.insightAppointments(count: insight.count),
  };
}
