import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/empty_state.dart';
import '../../../core/widgets/skeleton.dart';
import '../../../i18n/strings.g.dart';
import '../../children/data/child_repository.dart';
import '../../children/domain/child.dart';
import '../../medications/presentation/medication_tab.dart';
import '../../sleep/data/sleep_repository.dart';
import '../../sleep/presentation/sleep_tab.dart';
import '../data/mood_repository.dart';
import '../domain/mood_entry.dart';
import '../domain/tracker_insights.dart';
import 'mood_tab.dart';

/// Günlük Takip — Duygu / Uyku / İlaç sekmeleri (web DailyTrackerPage karşılığı).
class DailyTrackerScreen extends ConsumerStatefulWidget {
  const DailyTrackerScreen({super.key});

  @override
  ConsumerState<DailyTrackerScreen> createState() =>
      _DailyTrackerScreenState();
}

class _DailyTrackerScreenState extends ConsumerState<DailyTrackerScreen> {
  String? _selectedChildId;

  @override
  Widget build(BuildContext context) {
    final t = context.t;
    final childrenAsync = ref.watch(childrenProvider);

    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: Text(t.dailyTracker.title),
          bottom: TabBar(
            tabs: [
              Tab(icon: const Icon(Icons.mood_outlined), text: t.dailyTracker.tabMood),
              Tab(icon: const Icon(Icons.bedtime_outlined), text: t.dailyTracker.tabSleep),
              Tab(icon: const Icon(Icons.medication_outlined), text: t.dailyTracker.tabMeds),
            ],
          ),
        ),
        body: SafeArea(
          child: childrenAsync.when(
            loading: () => const SkeletonList(count: 3),
            error: (e, _) =>
                ErrorRetry(onRetry: () => ref.invalidate(childrenProvider)),
            data: (children) {
              if (children.isEmpty) {
                return EmptyState(
                  icon: Icons.child_care_outlined,
                  message: t.dailyTracker.noChild,
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
                  _InsightsBar(childId: childId),
                  Expanded(
                    child: TabBarView(
                      children: [
                        MoodTab(childId: childId),
                        SleepTab(childId: childId),
                        MedicationTab(childId: childId),
                      ],
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

/// Haftalık özet şeridi — ortalama uyku, en sık ruh hali, en sık tetikleyici
/// ve eksiksiz gün sayısı (web `DailyTrackerPage` başlığındaki dört kutu).
class _InsightsBar extends ConsumerWidget {
  const _InsightsBar({required this.childId});

  final String childId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = context.t;
    final moods = ref.watch(moodEntriesProvider(childId)).asData?.value;
    final sleeps = ref.watch(sleepEntriesProvider(childId)).asData?.value;
    if (moods == null || sleeps == null) return const SizedBox.shrink();
    if (moods.isEmpty && sleeps.isEmpty) return const SizedBox.shrink();

    final insights = buildTrackerInsights(moods: moods, sleeps: sleeps);
    final minutes = insights.averageSleepMinutes;
    final mood = insights.topMoodLevel;

    return Padding(
      padding: const EdgeInsets.fromLTRB(AppSpacing.margin, 8, AppSpacing.margin, 0),
      child: Row(
        children: [
          _InsightTile(
            icon: Icons.bedtime_outlined,
            label: t.dailyTracker.insightSleep,
            value: minutes == null
                ? t.dailyTracker.insightNone
                : t.dailyTracker.insightHours(
                    hours: '${minutes ~/ 60}',
                    minutes: '${minutes % 60}',
                  ),
          ),
          const SizedBox(width: 8),
          _InsightTile(
            icon: Icons.mood_outlined,
            label: t.dailyTracker.insightMood,
            value: mood == null
                ? t.dailyTracker.insightNone
                : kMoodEmojis[(mood - 1).clamp(0, kMoodEmojis.length - 1)],
          ),
          const SizedBox(width: 8),
          _InsightTile(
            icon: Icons.bolt_outlined,
            label: t.dailyTracker.insightTrigger,
            value: insights.topTrigger ?? t.dailyTracker.insightNone,
          ),
          const SizedBox(width: 8),
          _InsightTile(
            icon: Icons.event_available_outlined,
            label: t.dailyTracker.insightComplete,
            value: t.dailyTracker.insightDays(count: insights.completeDays),
          ),
        ],
      ),
    );
  }
}

class _InsightTile extends StatelessWidget {
  const _InsightTile({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final text = Theme.of(context).textTheme;
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
        decoration: BoxDecoration(
          color: colors.surface,
          borderRadius: BorderRadius.circular(AppRadius.md),
          border: Border.all(color: colors.border),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, size: 14, color: colors.primary),
            const SizedBox(height: 4),
            Text(
              label,
              style: text.labelSmall?.copyWith(color: colors.textTertiary),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            Text(
              value,
              style: text.labelMedium?.copyWith(fontWeight: FontWeight.w700),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
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
