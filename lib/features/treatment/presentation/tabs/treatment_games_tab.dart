import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../i18n/strings.g.dart';
import '../../domain/treatment_plan.dart';
import '../../domain/treatment_state.dart';
import '../treatment_screen.dart';
import '../widgets/notify_expert_sheet.dart';

/// Oyunlar sekmesi — günlük aktiviteler, geri bildirim, oyun geçmişi ve
/// sosyal hikâyeler.
class TreatmentGamesTab extends StatefulWidget {
  const TreatmentGamesTab(
      {super.key, required this.data, required this.actions});

  final TreatmentData data;
  final TreatmentActions actions;

  @override
  State<TreatmentGamesTab> createState() => _TreatmentGamesTabState();
}

/// Web `computeGameAdaptationHints` — son 5 oturuma göre uyum ipucu.
({String type, String message})? _adaptationHint(
  BuildContext context,
  List<GameSession> sessions,
  String gameId,
) {
  final t = context.t;
  final recent = sessions
      .where((s) => s.gameId == gameId)
      .map((s) => s.status)
      .toList();
  final last5 = recent.length > 5
      ? recent.sublist(recent.length - 5)
      : recent;
  final easy = last5.where((s) => s == 'easy').length;
  final challenging = last5.where((s) => s == 'challenging').length;
  final independent = last5.where((s) => s == 'independent').length;
  if (independent >= 3) {
    return (type: 'mastered', message: t.treatment.hintMastered);
  }
  if (easy >= 3) return (type: 'easy', message: t.treatment.hintEasy);
  if (challenging >= 3) {
    return (type: 'challenging', message: t.treatment.hintChallenging);
  }
  return null;
}

class _TreatmentGamesTabState extends State<TreatmentGamesTab> {
  String _filter = 'all';

  final _storyTitle = TextEditingController();
  final _storyIcon = TextEditingController(text: '📖');
  final _storyGoal = TextEditingController();
  bool _savingStory = false;

  @override
  void dispose() {
    _storyTitle.dispose();
    _storyIcon.dispose();
    _storyGoal.dispose();
    super.dispose();
  }

  Future<void> _addStory() async {
    setState(() => _savingStory = true);
    final saved = await widget.actions
        .addStory(_storyTitle.text, _storyIcon.text, _storyGoal.text);
    if (!mounted) return;
    setState(() {
      _savingStory = false;
      if (saved) {
        _storyTitle.clear();
        _storyIcon.text = '📖';
        _storyGoal.clear();
      }
    });
  }

  Future<void> _confirmDeleteStory(String storyId) async {
    final t = context.t;
    final ok = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(t.treatment.deleteStoryTitle),
        content: Text(t.treatment.deleteStoryConfirm),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(t.treatment.cancel),
          ),
          FilledButton(
            style:
                FilledButton.styleFrom(backgroundColor: context.colors.error),
            onPressed: () => Navigator.of(context).pop(true),
            child: Text(t.treatment.delete),
          ),
        ],
      ),
    );
    if (ok == true) await widget.actions.deleteStory(storyId);
  }

  void _openNotifySheet(TherapyGame game) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      builder: (_) => NotifyExpertSheet(gameTitle: game.title),
    );
  }

  @override
  Widget build(BuildContext context) {
    final t = context.t;
    final text = Theme.of(context).textTheme;
    final data = widget.data;
    final games = data.plan.games;
    final filtered = _filter == 'all'
        ? games
        : games.where((g) => g.key == _filter).toList();
    final challengingCount =
        data.state.gameSessions.where((s) => s.status == 'challenging').length;
    final recentSessions = [...data.state.gameSessions]
      ..sort((a, b) => b.completedAt.compareTo(a.completedAt));

    return ListView(
      padding: const EdgeInsets.all(AppSpacing.margin),
      children: [
        if (data.showMilestoneBanner) ...[
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(AppSpacing.md),
            decoration: BoxDecoration(
              color: context.colors.success.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(AppRadius.md),
              border: Border.all(
                color: context.colors.success.withValues(alpha: 0.4),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  t.treatment.allDoneTitle,
                  style:
                      text.bodyMedium?.copyWith(fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 2),
                Text(
                  t.treatment.allDoneBody,
                  style: text.bodySmall?.copyWith(
                    color: context.colors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
        ],
        Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(t.treatment.gamesTitle, style: text.titleMedium),
                  const SizedBox(height: 2),
                  Text(
                    t.treatment.gamesSubtitle,
                    style: text.bodySmall?.copyWith(
                      color: context.colors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Align(
          alignment: Alignment.centerLeft,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              color: data.todayCompletedGames.length == games.length &&
                      games.isNotEmpty
                  ? context.colors.success.withValues(alpha: 0.12)
                  : context.colors.surfaceVariant,
              borderRadius: BorderRadius.circular(AppRadius.full),
            ),
            child: Text(
              t.treatment.todayDone(
                done: data.todayCompletedGames.length,
                total: games.length,
              ),
              style: text.labelSmall?.copyWith(fontWeight: FontWeight.w700),
            ),
          ),
        ),
        const SizedBox(height: 10),
        SizedBox(
          height: 40,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: kFocusKeys.length + 1,
            separatorBuilder: (_, _) => const SizedBox(width: 6),
            itemBuilder: (_, i) {
              final key = i == 0 ? 'all' : kFocusKeys[i - 1];
              final label = i == 0
                  ? t.treatment.filterAll
                  : (kFocusLabels[key] ?? key);
              return ChoiceChip(
                label: Text(label),
                selected: _filter == key,
                showCheckmark: false,
                onSelected: (_) => setState(() => _filter = key),
              );
            },
          ),
        ),
        const SizedBox(height: 12),
        if (filtered.isEmpty)
          Container(
            padding: const EdgeInsets.all(AppSpacing.lg),
            decoration: BoxDecoration(
              color: context.colors.surfaceVariant,
              borderRadius: BorderRadius.circular(AppRadius.md),
            ),
            child: Text(
              t.treatment.emptyGames,
              textAlign: TextAlign.center,
              style: text.bodySmall?.copyWith(
                color: context.colors.textSecondary,
              ),
            ),
          )
        else
          for (final game in filtered) ...[
            _GameCard(
              game: game,
              done: data.todayCompletedGames.contains(game.id),
              feedback: data.todayGameFeedback[game.id],
              hint: _adaptationHint(context, data.state.gameSessions, game.id),
              saving: data.saving,
              onToggle: () => widget.actions.toggleGameCompletion(game.id),
              onFeedback: (status) =>
                  widget.actions.saveGameFeedback(game.id, status),
              onNotify: () => _openNotifySheet(game),
            ),
            const SizedBox(height: 12),
          ],
        _buildHistoryCard(
            context, recentSessions.take(5).toList(), challengingCount),
        const SizedBox(height: 12),
        _buildStoriesCard(context),
        const SizedBox(height: 24),
      ],
    );
  }

  Widget _buildHistoryCard(
    BuildContext context,
    List<GameSession> recent,
    int challengingCount,
  ) {
    final t = context.t;
    final text = Theme.of(context).textTheme;
    final data = widget.data;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child:
                      Text(t.treatment.historyTitle, style: text.titleSmall),
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color:
                        context.colors.primary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(AppRadius.full),
                  ),
                  child: Text(
                    t.treatment
                        .historyCount(count: data.state.gameSessions.length)
                        .toUpperCase(),
                    style: text.labelSmall?.copyWith(
                      color: context.colors.primary,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 2),
            Text(
              t.treatment.historySubtitle,
              style: text.bodySmall?.copyWith(
                color: context.colors.textSecondary,
              ),
            ),
            if (challengingCount > 0) ...[
              const SizedBox(height: 10),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(AppSpacing.md),
                decoration: BoxDecoration(
                  color: context.colors.warning.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(AppRadius.md),
                  border: Border.all(
                    color: context.colors.warning.withValues(alpha: 0.4),
                  ),
                ),
                child: Text(
                  t.treatment.challengingSummary(count: challengingCount),
                  style: text.bodySmall,
                ),
              ),
            ],
            const SizedBox(height: 10),
            if (recent.isEmpty)
              Text(
                t.treatment.historyEmpty,
                style: text.bodySmall?.copyWith(
                  color: context.colors.textSecondary,
                ),
              )
            else
              for (final session in recent) ...[
                Builder(builder: (context) {
                  final game = data.plan.games
                      .where((g) => g.id == session.gameId)
                      .firstOrNull;
                  return Container(
                    width: double.infinity,
                    margin: const EdgeInsets.only(bottom: 8),
                    padding: const EdgeInsets.all(AppSpacing.md),
                    decoration: BoxDecoration(
                      color: context.colors.surfaceVariant,
                      borderRadius: BorderRadius.circular(AppRadius.md),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                game?.title ?? session.linkedGoal,
                                style: text.bodySmall
                                    ?.copyWith(fontWeight: FontWeight.w700),
                              ),
                              Text(
                                session.dayKey,
                                style: text.labelSmall?.copyWith(
                                  color: context.colors.textTertiary,
                                ),
                              ),
                            ],
                          ),
                        ),
                        _FeedbackBadge(status: session.status),
                      ],
                    ),
                  );
                }),
              ],
          ],
        ),
      ),
    );
  }

  Widget _buildStoriesCard(BuildContext context) {
    final t = context.t;
    final text = Theme.of(context).textTheme;
    final data = widget.data;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(t.treatment.storiesTitle, style: text.titleSmall),
            const SizedBox(height: 2),
            Text(
              t.treatment.storiesSubtitle,
              style: text.bodySmall?.copyWith(
                color: context.colors.textSecondary,
              ),
            ),
            const SizedBox(height: 12),
            for (final story in data.plan.stories)
              _StoryTile(
                icon: story.icon,
                title: story.title,
                meta: story.meta,
                linkedGoal: story.linkedGoal,
              ),
            for (final story in data.state.customStories)
              _StoryTile(
                icon: story.icon,
                title: story.title,
                linkedGoal: story.linkedGoal,
                isCustom: true,
                onDelete: () => _confirmDeleteStory(story.id),
              ),
            const SizedBox(height: 8),
            Text(
              t.treatment.addStoryTitle,
              style: text.bodyMedium?.copyWith(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                SizedBox(
                  width: 56,
                  child: TextField(
                    controller: _storyIcon,
                    enabled: !_savingStory,
                    maxLength: 2,
                    textAlign: TextAlign.center,
                    decoration: const InputDecoration(counterText: ''),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: TextField(
                    controller: _storyTitle,
                    enabled: !_savingStory,
                    textCapitalization: TextCapitalization.sentences,
                    decoration:
                        InputDecoration(hintText: t.treatment.storyTitleHint),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _storyGoal,
                    enabled: !_savingStory,
                    decoration:
                        InputDecoration(hintText: t.treatment.storyGoalHint),
                  ),
                ),
                const SizedBox(width: 8),
                FilledButton.icon(
                  style: AppButtonStyles.inlineFilled,
                  onPressed: _savingStory ? null : _addStory,
                  icon: _savingStory
                      ? const SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Icon(Icons.add, size: 18),
                  label: Text(t.treatment.storyAdd),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _GameCard extends StatelessWidget {
  const _GameCard({
    required this.game,
    required this.done,
    required this.feedback,
    required this.hint,
    required this.saving,
    required this.onToggle,
    required this.onFeedback,
    required this.onNotify,
  });

  final TherapyGame game;
  final bool done;
  final String? feedback;
  final ({String type, String message})? hint;
  final bool saving;
  final VoidCallback onToggle;
  final ValueChanged<String> onFeedback;
  final VoidCallback onNotify;

  static const _gameIcons = <String, IconData>{
    'communication': Icons.chat_bubble_outline,
    'social': Icons.sports_esports_outlined,
    'sensory': Icons.auto_awesome_outlined,
    'motor': Icons.fitness_center_outlined,
    'behavior': Icons.psychology_outlined,
    'education': Icons.menu_book_outlined,
  };

  Color _toneColor(BuildContext context) {
    switch (game.tone) {
      case 'emerald':
        return context.colors.success;
      case 'amber':
        return context.colors.warning;
      default:
        return context.colors.primary;
    }
  }

  @override
  Widget build(BuildContext context) {
    final t = context.t;
    final text = Theme.of(context).textTheme;
    final tone = _toneColor(context);
    final h = hint;

    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadius.lg),
        side: done
            ? BorderSide(color: context.colors.success, width: 1.5)
            : BorderSide(color: context.colors.border),
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (h != null) ...[
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: (h.type == 'challenging'
                          ? context.colors.warning
                          : h.type == 'mastered'
                              ? context.colors.secondary
                              : context.colors.success)
                      .withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(AppRadius.sm),
                ),
                child: Row(
                  children: [
                    Icon(
                      h.type == 'challenging'
                          ? Icons.warning_amber_outlined
                          : Icons.trending_up,
                      size: 14,
                      color: h.type == 'challenging'
                          ? context.colors.warning
                          : h.type == 'mastered'
                              ? context.colors.secondary
                              : context.colors.success,
                    ),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        h.message,
                        style: text.labelSmall
                            ?.copyWith(fontWeight: FontWeight.w700),
                      ),
                    ),
                    if (h.type == 'challenging')
                      TextButton(
                        style: TextButton.styleFrom(
                          visualDensity: VisualDensity.compact,
                          padding:
                              const EdgeInsets.symmetric(horizontal: 8),
                        ),
                        onPressed: onNotify,
                        child: Text(
                          t.treatment.notifyExpert,
                          style: const TextStyle(fontSize: 11),
                        ),
                      ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
            ],
            Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: tone.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(AppRadius.md),
                  ),
                  child: Icon(
                    _gameIcons[game.key] ?? Icons.extension_outlined,
                    color: tone,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(game.title, style: text.titleSmall),
                      Text(
                        game.skill,
                        style: text.labelSmall?.copyWith(
                          color: context.colors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: done
                            ? context.colors.success.withValues(alpha: 0.12)
                            : context.colors.surfaceVariant,
                        borderRadius:
                            BorderRadius.circular(AppRadius.full),
                      ),
                      child: Text(
                        done
                            ? t.treatment.gameDoneBadge
                            : t.treatment.gameReady,
                        style: text.labelSmall?.copyWith(
                          fontWeight: FontWeight.w700,
                          color: done
                              ? context.colors.success
                              : context.colors.textSecondary,
                        ),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      game.duration,
                      style: text.labelSmall?.copyWith(
                        color: context.colors.textTertiary,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              t.treatment.methodLabel(name: game.approach),
              style: text.labelSmall?.copyWith(
                color: context.colors.textSecondary,
              ),
            ),
            const SizedBox(height: 8),
            Text(game.instruction, style: text.bodySmall),
            const SizedBox(height: 8),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(AppSpacing.md),
              decoration: BoxDecoration(
                color: context.colors.surfaceVariant,
                borderRadius: BorderRadius.circular(AppRadius.md),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    t.treatment.whyGood.toUpperCase(),
                    style: text.labelSmall?.copyWith(
                      color: context.colors.textTertiary,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 0.8,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    game.benefit,
                    style: text.bodySmall?.copyWith(
                      color: context.colors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 6,
              runSpacing: 4,
              children: [
                _TagChip(label: t.treatment.goalBadge(name: game.linkedGoal)),
                _TagChip(label: t.treatment.toolBadge(name: game.linkedTool)),
              ],
            ),
            const SizedBox(height: 8),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(AppSpacing.md),
              decoration: BoxDecoration(
                color: context.colors.warning.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(AppRadius.md),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.lightbulb_outline,
                      size: 15, color: context.colors.warning),
                  const SizedBox(width: 8),
                  Expanded(child: Text(game.tip, style: text.bodySmall)),
                ],
              ),
            ),
            const SizedBox(height: 10),
            SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                style: FilledButton.styleFrom(
                  backgroundColor: done
                      ? context.colors.success
                      : context.colors.primary,
                ),
                onPressed: saving ? null : onToggle,
                icon: const Icon(Icons.check_circle_outline, size: 18),
                label: Text(
                    done ? t.treatment.playedToday : t.treatment.playToday),
              ),
            ),
            const SizedBox(height: 10),
            Text(
              t.treatment.feedbackQuestion.toUpperCase(),
              style: text.labelSmall?.copyWith(
                color: context.colors.textTertiary,
                fontWeight: FontWeight.w800,
                letterSpacing: 0.8,
              ),
            ),
            const SizedBox(height: 6),
            _FeedbackBadge(status: feedback),
            const SizedBox(height: 8),
            Row(
              children: [
                for (final option in kGameReflections) ...[
                  Expanded(
                    child: _FeedbackButton(
                      status: option,
                      selected: feedback == option,
                      saving: saving,
                      onTap: () => onFeedback(option),
                    ),
                  ),
                  if (option != kGameReflections.last)
                    const SizedBox(width: 6),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }
}

/// Geri bildirim durum kutusu (web `getGameFeedbackMeta`).
class _FeedbackBadge extends StatelessWidget {
  const _FeedbackBadge({required this.status});

  final String? status;

  @override
  Widget build(BuildContext context) {
    final t = context.t;
    final (label, color) = switch (status) {
      'easy' => (t.treatment.fbEasyLong, context.colors.success),
      'assisted' => (t.treatment.fbAssistedLong, context.colors.primary),
      'independent' => (
          t.treatment.fbIndependentLong,
          context.colors.secondary
        ),
      'challenging' => (
          t.treatment.fbChallengingLong,
          context.colors.warning
        ),
      _ => (t.treatment.fbNone, context.colors.textTertiary),
    };
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(AppRadius.sm),
        border: Border.all(color: color.withValues(alpha: 0.35)),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w700,
          color: color,
        ),
      ),
    );
  }
}

class _FeedbackButton extends StatelessWidget {
  const _FeedbackButton({
    required this.status,
    required this.selected,
    required this.saving,
    required this.onTap,
  });

  final String status;
  final bool selected;
  final bool saving;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final t = context.t;
    final (emoji, label, color) = switch (status) {
      'easy' => ('😊', t.treatment.fbEasy, context.colors.success),
      'assisted' => ('🤝', t.treatment.fbAssisted, context.colors.primary),
      'independent' => (
          '⭐',
          t.treatment.fbIndependent,
          context.colors.secondary
        ),
      _ => ('💪', t.treatment.fbChallenging, context.colors.warning),
    };
    return InkWell(
      onTap: saving ? null : onTap,
      borderRadius: BorderRadius.circular(AppRadius.md),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
        decoration: BoxDecoration(
          color: selected ? color : color.withValues(alpha: 0.06),
          borderRadius: BorderRadius.circular(AppRadius.md),
          border: Border.all(
            color: selected ? color : color.withValues(alpha: 0.35),
          ),
        ),
        child: Column(
          children: [
            Text(emoji, style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 2),
            Text(
              label,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 9,
                fontWeight: FontWeight.w700,
                color: selected ? Colors.white : color,
              ),
            ),
          ],
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
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: context.colors.primary.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(AppRadius.full),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w600,
          color: context.colors.primary,
        ),
      ),
    );
  }
}

class _StoryTile extends StatelessWidget {
  const _StoryTile({
    required this.icon,
    required this.title,
    this.meta,
    required this.linkedGoal,
    this.isCustom = false,
    this.onDelete,
  });

  final String icon;
  final String title;
  final String? meta;
  final String linkedGoal;
  final bool isCustom;
  final VoidCallback? onDelete;

  @override
  Widget build(BuildContext context) {
    final t = context.t;
    final text = Theme.of(context).textTheme;
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: isCustom
            ? context.colors.primary.withValues(alpha: 0.05)
            : context.colors.surfaceVariant,
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: isCustom
            ? Border.all(
                color: context.colors.primary.withValues(alpha: 0.25))
            : null,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(icon, style: const TextStyle(fontSize: 28)),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style:
                      text.bodyMedium?.copyWith(fontWeight: FontWeight.w700),
                ),
                if (meta != null)
                  Text(
                    meta!,
                    style: text.bodySmall?.copyWith(
                      color: context.colors.textSecondary,
                    ),
                  ),
                const SizedBox(height: 4),
                Wrap(
                  spacing: 6,
                  runSpacing: 4,
                  children: [
                    _TagChip(
                      label: t.treatment
                          .linkedGoalBadge(name: linkedGoal)
                          .toUpperCase(),
                    ),
                    if (isCustom)
                      _TagChip(
                          label: t.treatment.customBadge.toUpperCase()),
                  ],
                ),
              ],
            ),
          ),
          if (onDelete != null)
            IconButton(
              tooltip: context.t.common.a11y.delete,
              visualDensity: VisualDensity.compact,
              onPressed: onDelete,
              icon: Icon(Icons.delete_outline,
                  size: 18, color: context.colors.error),
            ),
        ],
      ),
    );
  }
}
