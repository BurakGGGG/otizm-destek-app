import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/empty_state.dart';
import '../../../core/widgets/skeleton.dart';
import '../../../i18n/strings.g.dart';
import '../data/community_repository.dart';
import '../domain/weekly_question.dart';
import 'weekly_question_detail_screen.dart';

/// `weekly` çeviri alanıyla göreli zaman metni (az önce / dk / sa / gün).
String weeklyRelativeTime(Translations t, DateTime? dt) {
  if (dt == null) return '';
  final diff = DateTime.now().difference(dt);
  if (diff.inMinutes < 1) return t.weekly.justNow;
  if (diff.inMinutes < 60) return t.weekly.minsAgo(count: diff.inMinutes);
  if (diff.inHours < 24) return t.weekly.hoursAgo(count: diff.inHours);
  return t.weekly.daysAgo(count: diff.inDays);
}

/// Haftanın Sorusu — topluluk sorularının listesi. Bir soruya dokununca
/// cevaplar + cevap yazma ekranı açılır. Veli tarafına yönelik topluluk özelliği.
class WeeklyQuestionScreen extends ConsumerWidget {
  const WeeklyQuestionScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = context.t;
    final async = ref.watch(weeklyQuestionsProvider);

    return Scaffold(
      appBar: AppBar(title: Text(t.weekly.title)),
      body: SafeArea(
        child: async.when(
          loading: () => const SkeletonList(count: 3),
          error: (e, _) =>
              ErrorRetry(onRetry: () => ref.invalidate(weeklyQuestionsProvider)),
          data: (questions) {
            if (questions.isEmpty) {
              return RefreshIndicator(
                onRefresh: () async =>
                    ref.invalidate(weeklyQuestionsProvider),
                child: ListView(
                  children: [
                    SizedBox(
                      height: 360,
                      child: EmptyState(
                        icon: Icons.local_fire_department_outlined,
                        message: t.weekly.empty,
                      ),
                    ),
                  ],
                ),
              );
            }
            return RefreshIndicator(
              onRefresh: () async => ref.invalidate(weeklyQuestionsProvider),
              child: ListView.separated(
                padding: const EdgeInsets.fromLTRB(
                  AppSpacing.margin,
                  AppSpacing.md,
                  AppSpacing.margin,
                  24,
                ),
                itemCount: questions.length + 1,
                separatorBuilder: (_, _) => const SizedBox(height: 12),
                itemBuilder: (_, i) {
                  if (i == 0) return const _WeeklyIntro();
                  final q = questions[i - 1];
                  return _QuestionCard(
                    question: q,
                    onOpen: () => Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) =>
                            WeeklyQuestionDetailScreen(questionId: q.id),
                      ),
                    ),
                  );
                },
              ),
            );
          },
        ),
      ),
    );
  }
}

class _WeeklyIntro extends StatelessWidget {
  const _WeeklyIntro();

  @override
  Widget build(BuildContext context) {
    final t = context.t;
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.local_fire_department_outlined,
            color: context.colors.primary,
            size: 20,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              t.weekly.subtitle,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: context.colors.textSecondary,
                  ),
            ),
          ),
        ],
      ),
    );
  }
}

class _QuestionCard extends StatelessWidget {
  const _QuestionCard({required this.question, required this.onOpen});

  final WeeklyQuestion question;
  final VoidCallback onOpen;

  @override
  Widget build(BuildContext context) {
    final t = context.t;
    final text = Theme.of(context).textTheme;

    return Card(
      margin: EdgeInsets.zero,
      child: InkWell(
        borderRadius: BorderRadius.circular(AppRadius.lg),
        onTap: onOpen,
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  if (question.weekLabel != null &&
                      question.weekLabel!.isNotEmpty)
                    Text(
                      question.weekLabel!,
                      style: text.labelSmall?.copyWith(
                        color: context.colors.textTertiary,
                      ),
                    ),
                  const Spacer(),
                  if (question.tag != null) _TagChip(label: question.tag!),
                ],
              ),
              const SizedBox(height: 8),
              Text(question.question, style: text.titleMedium),
              const SizedBox(height: 12),
              Row(
                children: [
                  Icon(
                    Icons.mode_comment_outlined,
                    size: 16,
                    color: context.colors.textTertiary,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    t.weekly.answerCount(count: question.answers.length),
                    style: text.labelMedium?.copyWith(
                      color: context.colors.textSecondary,
                    ),
                  ),
                  if (question.expertCount > 0) ...[
                    const SizedBox(width: 16),
                    Icon(
                      Icons.workspace_premium_outlined,
                      size: 16,
                      color: context.colors.primary,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      t.weekly.expertCount(count: question.expertCount),
                      style: text.labelMedium?.copyWith(
                        color: context.colors.primary,
                      ),
                    ),
                  ],
                  const Spacer(),
                  Icon(
                    Icons.chevron_right,
                    color: context.colors.textTertiary,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _TagChip extends StatelessWidget {
  const _TagChip({required this.label});
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
      decoration: BoxDecoration(
        color: context.colors.primary.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(AppRadius.full),
      ),
      child: Text(
        label,
        style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: context.colors.primary,
              fontWeight: FontWeight.w700,
            ),
      ),
    );
  }
}
