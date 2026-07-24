import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../i18n/strings.g.dart';
import '../../domain/treatment_plan.dart';
import '../../domain/treatment_state.dart';
import '../treatment_screen.dart';

/// Kilometre taşı kategorileri (web `MILESTONE_CATEGORIES` — veri, çevrilmez).
const kMilestoneCategories = [
  'İletişim',
  'Sosyal',
  'Duyusal',
  'Davranış',
  'Motor',
  'Eğitim',
];

/// Hedefler sekmesi — özel hedef CRUD, alan bazlı ilerleme, kilometre taşı,
/// son notlar ve yaklaşan etkinlikler.
class TreatmentGoalsTab extends StatefulWidget {
  const TreatmentGoalsTab(
      {super.key, required this.data, required this.actions});

  final TreatmentData data;
  final TreatmentActions actions;

  @override
  State<TreatmentGoalsTab> createState() => _TreatmentGoalsTabState();
}

class _TreatmentGoalsTabState extends State<TreatmentGoalsTab> {
  final _goalDraft = TextEditingController();
  String _goalFocus = 'communication';
  String? _goalDueDate;

  String? _editingGoalId;
  final _editDraft = TextEditingController();
  String _editFocus = 'communication';
  String? _editDueDate;

  final _milestoneTitle = TextEditingController();
  String _milestoneCategory = kMilestoneCategories.first;
  bool _savingMilestone = false;

  @override
  void dispose() {
    _goalDraft.dispose();
    _editDraft.dispose();
    _milestoneTitle.dispose();
    super.dispose();
  }

  Future<void> _addGoal() async {
    final saved = await widget.actions
        .addGoal(_goalDraft.text, _goalFocus, _goalDueDate);
    if (saved && mounted) {
      setState(() {
        _goalDraft.clear();
        _goalDueDate = null;
      });
    }
  }

  Future<void> _saveEditing() async {
    final id = _editingGoalId;
    if (id == null) return;
    final saved = await widget.actions
        .updateGoal(id, _editDraft.text, _editFocus, _editDueDate);
    if (saved && mounted) setState(() => _editingGoalId = null);
  }

  Future<void> _addMilestone() async {
    setState(() => _savingMilestone = true);
    final saved = await widget.actions
        .addMilestone(_milestoneTitle.text, _milestoneCategory);
    if (!mounted) return;
    setState(() {
      _savingMilestone = false;
      if (saved) _milestoneTitle.clear();
    });
  }

  Future<void> _pickDate({
    required String? current,
    required ValueChanged<String?> onPicked,
  }) async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.tryParse(current ?? '') ?? now,
      firstDate: now.subtract(const Duration(days: 365)),
      lastDate: now.add(const Duration(days: 365 * 2)),
    );
    if (picked != null) onPicked(treatmentDateKey(picked));
  }

  @override
  Widget build(BuildContext context) {
    final t = context.t;
    final data = widget.data;

    return ListView(
      padding: const EdgeInsets.all(AppSpacing.margin),
      children: [
        _buildAddGoalCard(context),
        if (data.state.customGoals.isNotEmpty) ...[
          const SizedBox(height: 12),
          _buildCustomGoals(context),
        ],
        const SizedBox(height: 16),
        Text(
          t.treatment.groupsHeader.toUpperCase(),
          style: Theme.of(context).textTheme.labelSmall?.copyWith(
                color: context.colors.textTertiary,
                fontWeight: FontWeight.w800,
                letterSpacing: 1.4,
              ),
        ),
        const SizedBox(height: 8),
        if (data.mergedGroups.isEmpty)
          _EmptyBox(
            title: t.treatment.emptyGroupsTitle,
            body: t.treatment.emptyGroupsBody,
          )
        else
          for (final group in data.mergedGroups) ...[
            _GoalGroupCard(
              group: group,
              toggles: data.state.templateGoalToggles,
              saving: data.saving,
              onToggleTemplate: widget.actions.toggleTemplateGoal,
            ),
            const SizedBox(height: 12),
          ],
        _buildMilestoneCard(context),
        const SizedBox(height: 12),
        _buildNotesCard(context),
        const SizedBox(height: 12),
        _buildUpcomingCard(context),
        const SizedBox(height: 24),
      ],
    );
  }

  Widget _buildAddGoalCard(BuildContext context) {
    final t = context.t;
    final text = Theme.of(context).textTheme;
    final saving = widget.data.saving;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(t.treatment.addGoalTitle, style: text.titleMedium),
            const SizedBox(height: 4),
            Text(
              t.treatment.addGoalSubtitle,
              style: text.bodySmall?.copyWith(
                color: context.colors.textSecondary,
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _goalDraft,
              enabled: !saving,
              textCapitalization: TextCapitalization.sentences,
              decoration: InputDecoration(hintText: t.treatment.goalHint),
            ),
            const SizedBox(height: 10),
            Wrap(
              spacing: 6,
              runSpacing: 6,
              children: [
                for (final key in kFocusKeys)
                  ChoiceChip(
                    label: Text(kFocusLabels[key] ?? key),
                    selected: _goalFocus == key,
                    showCheckmark: false,
                    onSelected:
                        saving ? null : (_) => setState(() => _goalFocus = key),
                  ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: saving
                        ? null
                        : () => _pickDate(
                              current: _goalDueDate,
                              onPicked: (v) =>
                                  setState(() => _goalDueDate = v),
                            ),
                    icon: const Icon(Icons.event, size: 16),
                    label: Text(
                      _goalDueDate ?? t.treatment.dueDateLabel,
                      style: const TextStyle(fontSize: 12),
                    ),
                  ),
                ),
                if (_goalDueDate != null)
                  IconButton(
                    onPressed: saving
                        ? null
                        : () => setState(() => _goalDueDate = null),
                    icon: const Icon(Icons.clear, size: 18),
                  ),
                const SizedBox(width: 8),
                FilledButton.icon(
                  onPressed: saving ? null : _addGoal,
                  icon: saving
                      ? const SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Icon(Icons.add, size: 18),
                  label: Text(
                      saving ? t.treatment.saving : t.treatment.addGoal),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCustomGoals(BuildContext context) {
    final t = context.t;
    final text = Theme.of(context).textTheme;
    final data = widget.data;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              t.treatment.yourGoals.toUpperCase(),
              style: text.labelSmall?.copyWith(
                color: context.colors.textTertiary,
                fontWeight: FontWeight.w800,
                letterSpacing: 1.4,
              ),
            ),
            const SizedBox(height: 10),
            for (final goal in data.state.customGoals) ...[
              if (_editingGoalId == goal.id)
                _buildEditForm(context)
              else
                _CustomGoalTile(
                  goal: goal,
                  saving: data.saving,
                  onToggle: () => widget.actions.toggleGoal(goal.id),
                  onEdit: () => setState(() {
                    _editingGoalId = goal.id;
                    _editDraft.text = goal.title;
                    _editFocus = goal.focusKey;
                    _editDueDate = goal.dueDate;
                  }),
                  onDelete: () => widget.actions.deleteGoal(goal.id),
                ),
              const SizedBox(height: 8),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildEditForm(BuildContext context) {
    final t = context.t;
    final saving = widget.data.saving;
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: context.colors.surfaceVariant,
        borderRadius: BorderRadius.circular(AppRadius.md),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextField(
            controller: _editDraft,
            enabled: !saving,
            textCapitalization: TextCapitalization.sentences,
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 6,
            runSpacing: 6,
            children: [
              for (final key in kFocusKeys)
                ChoiceChip(
                  label: Text(kFocusLabels[key] ?? key),
                  selected: _editFocus == key,
                  showCheckmark: false,
                  onSelected:
                      saving ? null : (_) => setState(() => _editFocus = key),
                ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: saving
                      ? null
                      : () => _pickDate(
                            current: _editDueDate,
                            onPicked: (v) => setState(() => _editDueDate = v),
                          ),
                  icon: const Icon(Icons.event, size: 16),
                  label: Text(
                    _editDueDate ?? t.treatment.dueDateLabel,
                    style: const TextStyle(fontSize: 12),
                  ),
                ),
              ),
              if (_editDueDate != null)
                IconButton(
                  onPressed: saving
                      ? null
                      : () => setState(() => _editDueDate = null),
                  icon: const Icon(Icons.clear, size: 18),
                ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              FilledButton(
                onPressed: saving ? null : _saveEditing,
                child: Text(t.treatment.save),
              ),
              const SizedBox(width: 8),
              OutlinedButton(
                onPressed: saving
                    ? null
                    : () => setState(() => _editingGoalId = null),
                child: Text(t.treatment.cancel),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMilestoneCard(BuildContext context) {
    final t = context.t;
    final text = Theme.of(context).textTheme;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.emoji_events_outlined,
                    color: context.colors.warning),
                const SizedBox(width: 8),
                Expanded(
                  child:
                      Text(t.treatment.milestoneTitle, style: text.titleSmall),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              t.treatment.milestoneSubtitle,
              style: text.bodySmall?.copyWith(
                color: context.colors.textSecondary,
              ),
            ),
            const SizedBox(height: 10),
            Wrap(
              spacing: 6,
              runSpacing: 6,
              children: [
                for (final c in kMilestoneCategories)
                  ChoiceChip(
                    label: Text(c),
                    selected: _milestoneCategory == c,
                    showCheckmark: false,
                    onSelected: _savingMilestone
                        ? null
                        : (_) => setState(() => _milestoneCategory = c),
                  ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _milestoneTitle,
                    enabled: !_savingMilestone,
                    textCapitalization: TextCapitalization.sentences,
                    decoration:
                        InputDecoration(hintText: t.treatment.milestoneHint),
                  ),
                ),
                const SizedBox(width: 8),
                FilledButton(
                  onPressed: _savingMilestone ? null : _addMilestone,
                  child: _savingMilestone
                      ? const SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : Text(t.treatment.save),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNotesCard(BuildContext context) {
    final t = context.t;
    final text = Theme.of(context).textTheme;
    final notes = widget.data.notes;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.assignment_outlined, color: context.colors.primary),
                const SizedBox(width: 8),
                Text(t.treatment.notesTitle, style: text.titleSmall),
              ],
            ),
            const SizedBox(height: 10),
            if (notes.isEmpty)
              Text(
                t.treatment.notesEmpty,
                style: text.bodySmall?.copyWith(
                  color: context.colors.textSecondary,
                ),
              )
            else
              for (final note in notes.take(3)) ...[
                Container(
                  width: double.infinity,
                  margin: const EdgeInsets.only(bottom: 8),
                  padding: const EdgeInsets.all(AppSpacing.md),
                  decoration: BoxDecoration(
                    color: context.colors.surfaceVariant,
                    borderRadius: BorderRadius.circular(AppRadius.md),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              note.title,
                              style: text.bodyMedium
                                  ?.copyWith(fontWeight: FontWeight.w700),
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(
                              color: context.colors.warning
                                  .withValues(alpha: 0.12),
                              borderRadius:
                                  BorderRadius.circular(AppRadius.full),
                            ),
                            child: Text(
                              treatmentMoodLabel(note.mood),
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.w700,
                                color: context.colors.warning,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        (note.content?.isNotEmpty ?? false)
                            ? note.content!
                            : t.treatment.noteEmptyContent,
                        style: text.bodySmall?.copyWith(
                          color: context.colors.textSecondary,
                        ),
                      ),
                      if ((note.createdAt ?? note.noteDate) != null) ...[
                        const SizedBox(height: 6),
                        Text(
                          treatmentDateKey(
                              (note.createdAt ?? note.noteDate)!),
                          style: text.labelSmall?.copyWith(
                            color: context.colors.textTertiary,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ],
          ],
        ),
      ),
    );
  }

  Widget _buildUpcomingCard(BuildContext context) {
    final t = context.t;
    final text = Theme.of(context).textTheme;
    final data = widget.data;
    final items = <({String title, String subtitle})>[
      for (final a in data.activeAppointments.take(2))
        (
          title: a.expertName ?? '',
          subtitle: '${treatmentDateKey(a.date)} - ${a.time}',
        ),
      for (final e in data.events.take(2))
        (
          title: e.title,
          subtitle: treatmentDateKey(e.startTime),
        ),
    ];

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.event_available_outlined,
                    color: context.colors.success),
                const SizedBox(width: 8),
                Text(t.treatment.upcomingTitle, style: text.titleSmall),
              ],
            ),
            const SizedBox(height: 10),
            if (items.isEmpty)
              Text(
                t.treatment.upcomingEmpty,
                style: text.bodySmall?.copyWith(
                  color: context.colors.textSecondary,
                ),
              )
            else
              for (final item in items) ...[
                Container(
                  width: double.infinity,
                  margin: const EdgeInsets.only(bottom: 8),
                  padding: const EdgeInsets.all(AppSpacing.md),
                  decoration: BoxDecoration(
                    color: context.colors.surfaceVariant,
                    borderRadius: BorderRadius.circular(AppRadius.md),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.title,
                        style: text.bodyMedium
                            ?.copyWith(fontWeight: FontWeight.w700),
                      ),
                      Text(
                        item.subtitle,
                        style: text.bodySmall?.copyWith(
                          color: context.colors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            const SizedBox(height: 4),
            Row(
              children: [
                FilledButton.icon(
                  onPressed: () => context.push('/appointments'),
                  icon: const Icon(Icons.calendar_month, size: 16),
                  label: Text(t.treatment.goAppointments),
                ),
                const SizedBox(width: 8),
                OutlinedButton(
                  onPressed: () => context.push('/calendar'),
                  child: Text(t.treatment.goCalendar),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _CustomGoalTile extends StatelessWidget {
  const _CustomGoalTile({
    required this.goal,
    required this.saving,
    required this.onToggle,
    required this.onEdit,
    required this.onDelete,
  });

  final EditableGoal goal;
  final bool saving;
  final VoidCallback onToggle;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final t = context.t;
    final text = Theme.of(context).textTheme;
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: goal.done
            ? context.colors.success.withValues(alpha: 0.08)
            : context.colors.surface,
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border.all(
          color: goal.done
              ? context.colors.success.withValues(alpha: 0.4)
              : context.colors.border,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InkWell(
            onTap: saving ? null : onToggle,
            borderRadius: BorderRadius.circular(AppRadius.full),
            child: Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color:
                    goal.done ? context.colors.success : context.colors.surface,
                border: Border.all(
                  color: goal.done
                      ? context.colors.success
                      : context.colors.border,
                  width: 2,
                ),
              ),
              child: goal.done
                  ? const Icon(Icons.check, size: 14, color: Colors.white)
                  : null,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  goal.title,
                  style:
                      text.bodyMedium?.copyWith(fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 2),
                Wrap(
                  spacing: 6,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    Text(
                      (kFocusLabels[goal.focusKey] ?? goal.focusKey)
                          .toUpperCase(),
                      style: text.labelSmall?.copyWith(
                        color: context.colors.textTertiary,
                        letterSpacing: 0.6,
                      ),
                    ),
                    if (goal.dueDate != null)
                      Text(
                        '📅 ${goal.dueDate}',
                        style: text.labelSmall?.copyWith(
                          color: context.colors.primary,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ),
          IconButton(
            visualDensity: VisualDensity.compact,
            onPressed: saving ? null : onEdit,
            tooltip: t.treatment.edit,
            icon: Icon(Icons.edit_outlined,
                size: 18, color: context.colors.textSecondary),
          ),
          IconButton(
            visualDensity: VisualDensity.compact,
            onPressed: saving ? null : onDelete,
            tooltip: t.treatment.delete,
            icon: Icon(Icons.delete_outline,
                size: 18, color: context.colors.error),
          ),
        ],
      ),
    );
  }
}

class _GoalGroupCard extends StatelessWidget {
  const _GoalGroupCard({
    required this.group,
    required this.toggles,
    required this.saving,
    required this.onToggleTemplate,
  });

  final GoalGroup group;
  final Map<String, bool> toggles;
  final bool saving;
  final Future<void> Function(String label) onToggleTemplate;

  static const _focusIcons = <String, IconData>{
    'communication': Icons.chat_bubble_outline,
    'social': Icons.front_hand_outlined,
    'sensory': Icons.auto_awesome_outlined,
    'motor': Icons.fitness_center_outlined,
    'behavior': Icons.psychology_outlined,
    'education': Icons.menu_book_outlined,
  };

  @override
  Widget build(BuildContext context) {
    final t = context.t;
    final text = Theme.of(context).textTheme;
    final templateLabels =
        group.templateItems.map((i) => i.label).toSet();
    final doneCount = group.items.where((i) => i.status == 'done').length;
    final tone = group.tone == 'violet'
        ? context.colors.secondary
        : context.colors.primary;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
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
                    _focusIcons[group.key] ?? Icons.flag_outlined,
                    color: tone,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(group.title, style: text.titleSmall),
                      Text(
                        t.treatment.groupDone(
                          done: doneCount,
                          total: group.items.length,
                        ),
                        style: text.labelSmall?.copyWith(
                          color: context.colors.textTertiary,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  width: 44,
                  height: 44,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      CircularProgressIndicator(
                        value: group.percent / 100,
                        strokeWidth: 4,
                        backgroundColor: context.colors.surfaceVariant,
                        color: tone,
                      ),
                      Text(
                        '${group.percent}%',
                        style: text.labelSmall?.copyWith(
                          fontWeight: FontWeight.w800,
                          fontSize: 9,
                          color: tone,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            for (final item in group.items) ...[
              Builder(builder: (context) {
                final isTemplate = templateLabels.contains(item.label);
                final isToggled = isTemplate && (toggles[item.label] ?? false);
                final isDone = item.status == 'done' || isToggled;
                return Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Row(
                    children: [
                      if (isTemplate)
                        InkWell(
                          onTap: saving
                              ? null
                              : () => onToggleTemplate(item.label),
                          borderRadius:
                              BorderRadius.circular(AppRadius.full),
                          child: Container(
                            width: 20,
                            height: 20,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: isDone
                                  ? context.colors.success
                                  : context.colors.surface,
                              border: Border.all(
                                color: isDone
                                    ? context.colors.success
                                    : context.colors.border,
                                width: 2,
                              ),
                            ),
                            child: isDone
                                ? const Icon(Icons.check,
                                    size: 12, color: Colors.white)
                                : null,
                          ),
                        )
                      else
                        Container(
                          width: 10,
                          height: 10,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: isDone
                                ? context.colors.success
                                : item.status == 'active'
                                    ? context.colors.primary
                                    : context.colors.warning,
                          ),
                        ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          item.label,
                          style: text.bodySmall?.copyWith(
                            fontWeight: FontWeight.w600,
                            color: isDone
                                ? context.colors.success
                                : context.colors.textPrimary,
                          ),
                        ),
                      ),
                      Text(
                        isDone
                            ? t.treatment.statusDone
                            : item.status == 'active'
                                ? t.treatment.statusActive
                                : t.treatment.statusUpcoming,
                        style: text.labelSmall?.copyWith(
                          color: isDone
                              ? context.colors.success
                              : context.colors.textTertiary,
                          fontWeight:
                              isDone ? FontWeight.w700 : FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                );
              }),
            ],
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(AppSpacing.md),
              decoration: BoxDecoration(
                color: context.colors.surfaceVariant,
                borderRadius: BorderRadius.circular(AppRadius.md),
              ),
              child: Text(
                group.summary,
                style: text.bodySmall?.copyWith(
                  color: context.colors.textSecondary,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _EmptyBox extends StatelessWidget {
  const _EmptyBox({required this.title, required this.body});

  final String title;
  final String body;

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: context.colors.surfaceVariant,
        borderRadius: BorderRadius.circular(AppRadius.md),
      ),
      child: Column(
        children: [
          Icon(Icons.flag_outlined,
              size: 32, color: context.colors.textTertiary),
          const SizedBox(height: 8),
          Text(
            title,
            style: text.bodyMedium?.copyWith(fontWeight: FontWeight.w700),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 4),
          Text(
            body,
            style: text.bodySmall?.copyWith(
              color: context.colors.textSecondary,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
