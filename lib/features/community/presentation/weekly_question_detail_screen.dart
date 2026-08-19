import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/haptics.dart';
import '../../../core/network/api_exception.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/empty_state.dart';
import '../../../core/widgets/skeleton.dart';
import '../../../i18n/strings.g.dart';
import '../data/community_repository.dart';
import '../domain/weekly_question.dart';
import 'weekly_question_screen.dart';

/// Haftanın Sorusu detayı — soru + aile cevapları (beğeni) + cevap yazma.
class WeeklyQuestionDetailScreen extends ConsumerStatefulWidget {
  const WeeklyQuestionDetailScreen({super.key, required this.questionId});

  final String questionId;

  @override
  ConsumerState<WeeklyQuestionDetailScreen> createState() =>
      _WeeklyQuestionDetailScreenState();
}

class _WeeklyQuestionDetailScreenState
    extends ConsumerState<WeeklyQuestionDetailScreen> {
  final TextEditingController _answer = TextEditingController();
  final Set<String> _selectedTags = {};

  /// İyimser beğeni üst-katmanı: answer id → (likes, liked).
  final Map<String, ({int likes, bool liked})> _likeOverride = {};
  bool _anonymous = false;
  bool _sending = false;

  @override
  void dispose() {
    _answer.dispose();
    super.dispose();
  }

  Future<void> _toggleLike(WeeklyAnswer answer) async {
    final current = _likeOverride[answer.id] ??
        (likes: answer.likes, liked: answer.liked);
    final optimistic = current.liked
        ? (likes: current.likes - 1, liked: false)
        : (likes: current.likes + 1, liked: true);
    setState(() => _likeOverride[answer.id] = optimistic);
    Haptics.selection();
    try {
      final updated =
          await ref.read(communityRepositoryProvider).toggleWeeklyAnswerLike(
                answer.id,
              );
      if (!mounted) return;
      setState(() =>
          _likeOverride[answer.id] = (likes: updated.likes, liked: updated.liked));
    } on ApiException catch (e) {
      if (!mounted) return;
      setState(() => _likeOverride[answer.id] = current);
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.message)));
    }
  }

  Future<void> _send(String questionId) async {
    final t = context.t;
    final body = _answer.text.trim();
    if (body.isEmpty) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(t.weekly.errorEmpty)));
      return;
    }
    setState(() => _sending = true);
    try {
      final raw = WeeklyAnswer.encode(
        text: body,
        anonymous: _anonymous,
        tags: _selectedTags.toList(),
      );
      await ref
          .read(communityRepositoryProvider)
          .createWeeklyAnswer(questionId, raw);
      if (!mounted) return;
      _answer.clear();
      FocusScope.of(context).unfocus();
      setState(() {
        _selectedTags.clear();
        _anonymous = false;
        _sending = false;
      });
      ref.invalidate(weeklyQuestionsProvider);
      Haptics.success();
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(t.weekly.sent)));
    } on ApiException catch (e) {
      if (!mounted) return;
      setState(() => _sending = false);
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.message)));
    }
  }

  @override
  Widget build(BuildContext context) {
    final t = context.t;
    final async = ref.watch(weeklyQuestionsProvider);

    return Scaffold(
      appBar: AppBar(title: Text(t.weekly.title)),
      body: SafeArea(
        child: async.when(
          loading: () => const SkeletonList(count: 4),
          error: (e, _) =>
              ErrorRetry(onRetry: () => ref.invalidate(weeklyQuestionsProvider)),
          data: (questions) {
            final question = questions
                .where((q) => q.id == widget.questionId)
                .firstOrNull;
            if (question == null) {
              return EmptyState(
                icon: Icons.local_fire_department_outlined,
                message: t.weekly.empty,
              );
            }
            return Column(
              children: [
                Expanded(
                  child: RefreshIndicator(
                    onRefresh: () async =>
                        ref.invalidate(weeklyQuestionsProvider),
                    child: ListView(
                      padding: const EdgeInsets.fromLTRB(
                        AppSpacing.margin,
                        AppSpacing.md,
                        AppSpacing.margin,
                        24,
                      ),
                      children: [
                        _QuestionHeader(question: question),
                        const SizedBox(height: 20),
                        Text(
                          t.weekly.answersTitle,
                          style: Theme.of(context).textTheme.titleSmall,
                        ),
                        const SizedBox(height: 12),
                        if (question.answers.isEmpty)
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 24),
                            child: EmptyState(
                              icon: Icons.forum_outlined,
                              message: t.weekly.noAnswers,
                            ),
                          )
                        else
                          for (final a in question.answers) ...[
                            _AnswerTile(
                              answer: a,
                              likes: _likeOverride[a.id]?.likes ?? a.likes,
                              liked: _likeOverride[a.id]?.liked ?? a.liked,
                              onLike: () => _toggleLike(a),
                            ),
                            const SizedBox(height: 10),
                          ],
                      ],
                    ),
                  ),
                ),
                _AnswerComposer(
                  controller: _answer,
                  anonymous: _anonymous,
                  selectedTags: _selectedTags,
                  sending: _sending,
                  onToggleAnonymous: (v) => setState(() => _anonymous = v),
                  onToggleTag: (tag) => setState(() {
                    _selectedTags.contains(tag)
                        ? _selectedTags.remove(tag)
                        : _selectedTags.add(tag);
                  }),
                  onSend: () => _send(question.id),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _QuestionHeader extends StatelessWidget {
  const _QuestionHeader({required this.question});
  final WeeklyQuestion question;

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    return Card(
      margin: EdgeInsets.zero,
      color: context.colors.primary.withValues(alpha: 0.06),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.local_fire_department_outlined,
                  size: 18,
                  color: context.colors.primary,
                ),
                const SizedBox(width: 6),
                if (question.weekLabel != null &&
                    question.weekLabel!.isNotEmpty)
                  Text(
                    question.weekLabel!,
                    style: text.labelSmall?.copyWith(
                      color: context.colors.textSecondary,
                    ),
                  ),
                const Spacer(),
                if (question.tag != null)
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                    decoration: BoxDecoration(
                      color: context.colors.primary,
                      borderRadius: BorderRadius.circular(AppRadius.full),
                    ),
                    child: Text(
                      question.tag!,
                      style: text.labelSmall?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 10),
            Text(question.question, style: text.titleLarge),
          ],
        ),
      ),
    );
  }
}

class _AnswerTile extends StatelessWidget {
  const _AnswerTile({
    required this.answer,
    required this.likes,
    required this.liked,
    required this.onLike,
  });

  final WeeklyAnswer answer;
  final int likes;
  final bool liked;
  final VoidCallback onLike;

  @override
  Widget build(BuildContext context) {
    final t = context.t;
    final text = Theme.of(context).textTheme;
    final author = answer.displayAuthor ?? t.weekly.anonymousUser;

    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: context.colors.surface,
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border.all(
          color: answer.isExpert
              ? context.colors.primary.withValues(alpha: 0.4)
              : context.colors.border,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 14,
                backgroundColor:
                    context.colors.primary.withValues(alpha: 0.12),
                child: Icon(
                  answer.isAnonymous ? Icons.person_outline : Icons.face,
                  size: 16,
                  color: context.colors.primary,
                ),
              ),
              const SizedBox(width: 8),
              Flexible(
                child: Text(
                  author,
                  style: text.labelLarge,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              if (answer.isExpert) ...[
                const SizedBox(width: 6),
                _ExpertBadge(title: answer.expertTitle),
              ],
              const Spacer(),
              Text(
                weeklyRelativeTime(t, answer.createdAt),
                style: text.labelSmall?.copyWith(
                  color: context.colors.textTertiary,
                ),
              ),
            ],
          ),
          if (!answer.isAnonymous &&
              answer.city != null &&
              answer.city!.isNotEmpty) ...[
            const SizedBox(height: 4),
            Row(
              children: [
                Icon(
                  Icons.place_outlined,
                  size: 13,
                  color: context.colors.textTertiary,
                ),
                const SizedBox(width: 3),
                Text(
                  answer.city!,
                  style: text.labelSmall?.copyWith(
                    color: context.colors.textTertiary,
                  ),
                ),
              ],
            ),
          ],
          const SizedBox(height: 8),
          Text(answer.displayText, style: text.bodyMedium),
          if (answer.tags.isNotEmpty) ...[
            const SizedBox(height: 8),
            Wrap(
              spacing: 6,
              runSpacing: 6,
              children: [
                for (final tag in answer.tags)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: context.colors.background,
                      borderRadius: BorderRadius.circular(AppRadius.full),
                      border: Border.all(color: context.colors.border),
                    ),
                    child: Text(
                      tag,
                      style: text.labelSmall?.copyWith(
                        color: context.colors.textSecondary,
                      ),
                    ),
                  ),
              ],
            ),
          ],
          const SizedBox(height: 8),
          InkWell(
            borderRadius: BorderRadius.circular(AppRadius.full),
            onTap: onLike,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 4),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    liked ? Icons.favorite : Icons.favorite_border,
                    size: 18,
                    color: liked
                        ? context.colors.primary
                        : context.colors.textTertiary,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    '$likes',
                    style: text.labelMedium?.copyWith(
                      color: liked
                          ? context.colors.primary
                          : context.colors.textSecondary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ExpertBadge extends StatelessWidget {
  const _ExpertBadge({this.title});
  final String? title;

  @override
  Widget build(BuildContext context) {
    final t = context.t;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: context.colors.primary.withValues(alpha: 0.14),
        borderRadius: BorderRadius.circular(AppRadius.full),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.workspace_premium,
            size: 12,
            color: context.colors.primary,
          ),
          const SizedBox(width: 3),
          Text(
            (title == null || title!.isEmpty) ? t.weekly.expertBadge : title!,
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: context.colors.primary,
                  fontWeight: FontWeight.w700,
                ),
          ),
        ],
      ),
    );
  }
}

class _AnswerComposer extends StatelessWidget {
  const _AnswerComposer({
    required this.controller,
    required this.anonymous,
    required this.selectedTags,
    required this.sending,
    required this.onToggleAnonymous,
    required this.onToggleTag,
    required this.onSend,
  });

  final TextEditingController controller;
  final bool anonymous;
  final Set<String> selectedTags;
  final bool sending;
  final ValueChanged<bool> onToggleAnonymous;
  final ValueChanged<String> onToggleTag;
  final VoidCallback onSend;

  @override
  Widget build(BuildContext context) {
    final t = context.t;
    return Container(
      padding: EdgeInsets.only(
        left: AppSpacing.md,
        right: AppSpacing.md,
        top: 10,
        bottom: MediaQuery.viewInsetsOf(context).bottom + 10,
      ),
      decoration: BoxDecoration(
        color: context.colors.surface,
        border: Border(top: BorderSide(color: context.colors.border)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextField(
            controller: controller,
            minLines: 1,
            maxLines: 4,
            maxLength: 500,
            textCapitalization: TextCapitalization.sentences,
            decoration: InputDecoration(
              hintText: t.weekly.answerHint,
              isDense: true,
              counterText: '',
            ),
          ),
          const SizedBox(height: 6),
          Wrap(
            spacing: 6,
            runSpacing: 2,
            children: [
              for (final tag in kWeeklyAnswerTags)
                FilterChip(
                  label: Text(tag),
                  selected: selectedTags.contains(tag),
                  showCheckmark: false,
                  visualDensity: VisualDensity.compact,
                  onSelected: (_) => onToggleTag(tag),
                ),
            ],
          ),
          Row(
            children: [
              Switch(
                value: anonymous,
                onChanged: onToggleAnonymous,
              ),
              Text(t.weekly.anonymous, style: Theme.of(context).textTheme.bodySmall),
              const Spacer(),
              FilledButton.icon(
                style: AppButtonStyles.inlineFilled,
                onPressed: sending ? null : onSend,
                icon: sending
                    ? const SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Icon(Icons.send, size: 16),
                label: Text(t.weekly.send),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
