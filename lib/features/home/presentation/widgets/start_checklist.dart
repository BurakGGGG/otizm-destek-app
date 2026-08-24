import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/providers.dart';
import '../../../../core/storage/visited_routes.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../i18n/strings.g.dart';
import '../../data/daily_plan_provider.dart';
import '../../domain/daily_plan.dart';

/// "Hızlı başlangıç" kartının kapatılma durumu (cihazda saklanır — web
/// `dashboard-onboarding-dismissed` anahtarıyla aynı amaç).
class StartChecklistDismissed extends Notifier<bool> {
  static const _storageKey = 'dashboard-onboarding-dismissed';

  @override
  bool build() {
    _restore();
    return false;
  }

  Future<void> _restore() async {
    try {
      final raw =
          await ref.read(secureStorageProvider).readPreference(_storageKey);
      if (raw == 'true') state = true;
    } catch (_) {
      // Okunamazsa kart görünür kalır.
    }
  }

  Future<void> dismiss() async {
    state = true;
    try {
      await ref
          .read(secureStorageProvider)
          .savePreference(_storageKey, 'true');
    } catch (_) {
      // Kayıt başarısızsa kapatma oturum içinde geçerli kalır.
    }
  }
}

final startChecklistDismissedProvider =
    NotifierProvider<StartChecklistDismissed, bool>(
      StartChecklistDismissed.new,
    );

/// Yeni kullanıcı için üç adımlı başlangıç listesi. Adımlar tamamlanınca ya
/// da kullanıcı kapatınca görünmez.
class StartChecklist extends ConsumerWidget {
  const StartChecklist({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (ref.watch(startChecklistDismissedProvider)) {
      return const SizedBox.shrink();
    }
    final input = ref.watch(dailyPlanInputProvider).asData?.value;
    if (input == null) return const SizedBox.shrink();

    final visited = ref.watch(visitedRoutesProvider);
    final items = startChecklist(
      hasChild: input.hasChild,
      hasMoodToday: input.hasMoodToday,
      visitedTracker: visited.contains('/daily-tracker'),
      visitedCrisis: visited.contains('/crisis'),
    );
    if (items.every((item) => item.done)) return const SizedBox.shrink();

    final t = context.t;
    final colors = context.colors;
    final text = Theme.of(context).textTheme;
    final done = items.where((item) => item.done).length;

    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.md),
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: colors.primary.withValues(alpha: .06),
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(color: colors.primary.withValues(alpha: .20)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.flag_outlined, size: 18, color: colors.primary),
              const SizedBox(width: 8),
              Expanded(
                child: Text(t.dailyPlan.startTitle, style: text.titleSmall),
              ),
              Text(
                t.dailyPlan.startReady(
                  percent: startChecklistPercent(items),
                ),
                style: text.labelSmall?.copyWith(color: colors.primary),
              ),
              IconButton(
                onPressed: () =>
                    ref.read(startChecklistDismissedProvider.notifier).dismiss(),
                icon: const Icon(Icons.close, size: 18),
                tooltip: t.dailyPlan.startDismiss,
                visualDensity: VisualDensity.compact,
              ),
            ],
          ),
          Text(
            t.dailyPlan.startIntro,
            style: text.labelSmall?.copyWith(color: colors.textSecondary),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(AppRadius.full),
                  child: LinearProgressIndicator(
                    value: done / items.length,
                    minHeight: 6,
                    backgroundColor: colors.surface,
                    valueColor: AlwaysStoppedAnimation(colors.primary),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Text(
                t.dailyPlan.startProgress(done: done, total: items.length),
                style: text.labelSmall?.copyWith(color: colors.textSecondary),
              ),
            ],
          ),
          const SizedBox(height: 12),
          for (final item in items) ...[
            _StepRow(item: item),
            if (item != items.last) const SizedBox(height: 8),
          ],
        ],
      ),
    );
  }
}

class _StepRow extends StatelessWidget {
  const _StepRow({required this.item});

  final StartChecklistItem item;

  @override
  Widget build(BuildContext context) {
    final t = context.t;
    final colors = context.colors;
    final text = Theme.of(context).textTheme;
    final (title, detail, icon) = switch (item.step) {
      StartStep.childProfile => (
          t.dailyPlan.checkChildProfile,
          t.dailyPlan.checkChildProfileDetail,
          Icons.child_care_outlined,
        ),
      StartStep.dailyLog => (
          t.dailyPlan.checkDailyLog,
          t.dailyPlan.checkDailyLogDetail,
          Icons.assignment_outlined,
        ),
      StartStep.crisisGuide => (
          t.dailyPlan.checkCrisis,
          t.dailyPlan.checkCrisisDetail,
          Icons.self_improvement_outlined,
        ),
    };

    return InkWell(
      borderRadius: BorderRadius.circular(AppRadius.md),
      onTap: () => context.push(item.route),
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: colors.surface,
          borderRadius: BorderRadius.circular(AppRadius.md),
          border: Border.all(color: colors.border),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(
              item.done ? Icons.check_circle : icon,
              size: 20,
              color: item.done ? colors.success : colors.primary,
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: text.labelLarge?.copyWith(
                      color: item.done ? colors.textSecondary : null,
                      decoration:
                          item.done ? TextDecoration.lineThrough : null,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    detail,
                    style: text.labelSmall
                        ?.copyWith(color: colors.textSecondary),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Text(
              item.done ? t.dailyPlan.checkDone : t.dailyPlan.checkTodo,
              style: text.labelSmall?.copyWith(
                color: item.done ? colors.success : colors.primary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
