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
import '../../sleep/presentation/sleep_tab.dart';
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
