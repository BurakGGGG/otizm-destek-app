import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/haptics.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../i18n/strings.g.dart';
import '../../domain/treatment_plan.dart';
import '../treatment_screen.dart';

/// Araçlar sekmesi — duyusal profil (kalıcı), tetikleyici özeti, jeton panosu
/// (oturum içi) ve nefes/AI kısayolları. Web'in statik demo "Uzman Notları"
/// paneli bilinçli olarak kapsam dışıdır (gerçek veri değil).
class TreatmentToolsTab extends StatefulWidget {
  const TreatmentToolsTab(
      {super.key, required this.data, required this.actions});

  final TreatmentData data;
  final TreatmentActions actions;

  @override
  State<TreatmentToolsTab> createState() => _TreatmentToolsTabState();
}

class _TreatmentToolsTabState extends State<TreatmentToolsTab> {
  // Jeton panosu — web gibi oturum içi (kalıcılaştırılmaz).
  int _tokens = 0;
  String? _reward;
  final _rewardInput = TextEditingController();

  @override
  void dispose() {
    _rewardInput.dispose();
    super.dispose();
  }

  void _addToken() {
    if (_tokens >= 5) return;
    Haptics.success();
    setState(() => _tokens++);
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(AppSpacing.margin),
      children: [
        _buildSensoryCard(context),
        const SizedBox(height: 12),
        _buildTriggerCard(context),
        const SizedBox(height: 12),
        _buildTokenCard(context),
        const SizedBox(height: 12),
        _ShortcutCard(
          icon: Icons.self_improvement,
          title: context.t.treatment.breathTitle,
          body: context.t.treatment.breathBody,
          actionLabel: context.t.treatment.breathOpen,
          onTap: () => context.push('/crisis'),
        ),
        const SizedBox(height: 12),
        _ShortcutCard(
          icon: Icons.auto_awesome,
          title: context.t.treatment.aiStoryTitle,
          body: context.t.treatment.aiStoryBody,
          actionLabel: context.t.treatment.aiStoryOpen,
          onTap: () => context.push('/chat'),
        ),
        const SizedBox(height: 24),
      ],
    );
  }

  Widget _buildSensoryCard(BuildContext context) {
    final t = context.t;
    final text = Theme.of(context).textTheme;
    final data = widget.data;
    final profile = data.state.sensoryProfile;

    final metrics = [
      (
        label: t.treatment.metricSound,
        value: profile.sound,
        levelLabel: sensoryValueLabel(profile.sound),
        note: t.treatment.metricSoundNote,
        color: context.colors.error,
      ),
      (
        label: t.treatment.metricTouch,
        value: profile.touch,
        levelLabel: sensoryValueLabel(profile.touch),
        note: t.treatment.metricTouchNote,
        color: context.colors.warning,
      ),
      (
        label: t.treatment.metricVisual,
        value: profile.visual,
        levelLabel: sensoryValueLabel(profile.visual, reverse: true),
        note: t.treatment.metricVisualNote,
        color: context.colors.success,
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
                Icon(Icons.thermostat, color: context.colors.primary),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        t.treatment.sensorySubtitle.toUpperCase(),
                        style: text.labelSmall?.copyWith(
                          color: context.colors.textTertiary,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 1.2,
                        ),
                      ),
                      Text(t.treatment.sensoryTitle, style: text.titleSmall),
                    ],
                  ),
                ),
                FilledButton(
                  style: AppButtonStyles.inlineFilled,
                  onPressed:
                      data.saving ? null : () => widget.actions.saveSensory(),
                  child: Text(
                    data.saving ? t.treatment.saving : t.treatment.save,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            for (final metric in metrics) ...[
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
                            metric.label,
                            style: text.bodySmall
                                ?.copyWith(fontWeight: FontWeight.w700),
                          ),
                        ),
                        Text(
                          metric.levelLabel,
                          style: text.labelSmall?.copyWith(
                            fontWeight: FontWeight.w800,
                            color: context.colors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(AppRadius.full),
                      child: LinearProgressIndicator(
                        value: metric.value / 100,
                        minHeight: 6,
                        backgroundColor: context.colors.surface,
                        color: metric.color,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      metric.note,
                      style: text.labelSmall?.copyWith(
                        color: context.colors.textTertiary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
            const SizedBox(height: 4),
            Text(
              t.treatment.sliderHeader,
              style: text.bodyMedium?.copyWith(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 4),
            _SensorySlider(
              label: t.treatment.sliderSound,
              value: profile.sound,
              saving: data.saving,
              onChanged: (v) => widget.actions
                  .updateSensory(profile.copyWith(sound: v)),
            ),
            _SensorySlider(
              label: t.treatment.sliderTouch,
              value: profile.touch,
              saving: data.saving,
              onChanged: (v) => widget.actions
                  .updateSensory(profile.copyWith(touch: v)),
            ),
            _SensorySlider(
              label: t.treatment.sliderVisual,
              value: profile.visual,
              saving: data.saving,
              onChanged: (v) => widget.actions
                  .updateSensory(profile.copyWith(visual: v)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTriggerCard(BuildContext context) {
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
                Icon(Icons.warning_amber_outlined,
                    color: context.colors.warning),
                const SizedBox(width: 8),
                Text(t.treatment.triggerTitle, style: text.titleSmall),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              widget.data.plan.triggerSummary,
              style: text.bodySmall?.copyWith(
                color: context.colors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTokenCard(BuildContext context) {
    final t = context.t;
    final text = Theme.of(context).textTheme;
    final reward = _reward ?? t.treatment.tokenDefaultReward;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.stars_outlined, color: context.colors.warning),
                const SizedBox(width: 8),
                Text(t.treatment.tokenTitle, style: text.titleSmall),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              t.treatment.tokenSubtitle,
              style: text.bodySmall?.copyWith(
                color: context.colors.textSecondary,
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _rewardInput,
                    decoration: InputDecoration(
                      labelText: t.treatment.tokenRewardLabel,
                      hintText: t.treatment.tokenRewardHint,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                OutlinedButton(
                  style: AppButtonStyles.inlineOutlined,
                  onPressed: () {
                    final v = _rewardInput.text.trim();
                    if (v.isEmpty) return;
                    Haptics.selection();
                    setState(() {
                      _reward = v;
                      _rewardInput.clear();
                      _tokens = 0;
                    });
                  },
                  child: Text(t.treatment.tokenSetReward),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              '${t.treatment.tokenActive}: $reward',
              style: text.bodySmall?.copyWith(
                color: context.colors.primary,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 12),
            if (_tokens >= 5)
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
                  children: [
                    Icon(Icons.emoji_events,
                        size: 36, color: context.colors.success),
                    const SizedBox(height: 6),
                    Text(
                      t.treatment.tokenFullTitle,
                      style: text.bodyMedium
                          ?.copyWith(fontWeight: FontWeight.w700),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      t.treatment.tokenFullBody(reward: reward),
                      style: text.bodySmall?.copyWith(
                        color: context.colors.textSecondary,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    OutlinedButton.icon(
                      onPressed: () => setState(() => _tokens = 0),
                      icon: const Icon(Icons.refresh, size: 16),
                      label: Text(t.treatment.tokenReset),
                    ),
                  ],
                ),
              )
            else ...[
              Center(
                child: Text(
                  t.treatment.tokenCollect(count: _tokens),
                  style:
                      text.bodyMedium?.copyWith(fontWeight: FontWeight.w700),
                ),
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  for (var i = 0; i < 5; i++) ...[
                    InkWell(
                      onTap: i == _tokens ? _addToken : null,
                      borderRadius: BorderRadius.circular(AppRadius.full),
                      child: Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: i < _tokens
                              ? context.colors.warning
                              : context.colors.surfaceVariant,
                          border: i == _tokens
                              ? Border.all(
                                  color: context.colors.warning, width: 2)
                              : null,
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          '⭐',
                          style: TextStyle(
                            fontSize: 18,
                            color: i < _tokens ? null : Colors.transparent,
                          ),
                        ),
                      ),
                    ),
                    if (i < 4) const SizedBox(width: 8),
                  ],
                ],
              ),
              const SizedBox(height: 10),
              Center(
                child: FilledButton(
                  style: FilledButton.styleFrom(
                    backgroundColor: context.colors.warning,
                  ),
                  onPressed: _addToken,
                  child: Text(t.treatment.tokenAdd),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _SensorySlider extends StatelessWidget {
  const _SensorySlider({
    required this.label,
    required this.value,
    required this.saving,
    required this.onChanged,
  });

  final String label;
  final int value;
  final bool saving;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                label,
                style: text.bodySmall?.copyWith(fontWeight: FontWeight.w700),
              ),
            ),
            Text(
              '%$value',
              style: text.labelSmall?.copyWith(
                color: context.colors.primary,
                fontWeight: FontWeight.w800,
              ),
            ),
          ],
        ),
        Slider(
          value: value.toDouble(),
          min: 10,
          max: 100,
          divisions: 90,
          onChanged: saving ? null : (v) => onChanged(v.round()),
        ),
      ],
    );
  }
}

class _ShortcutCard extends StatelessWidget {
  const _ShortcutCard({
    required this.icon,
    required this.title,
    required this.body,
    required this.actionLabel,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final String body;
  final String actionLabel;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: context.colors.primary),
                const SizedBox(width: 8),
                Expanded(child: Text(title, style: text.titleSmall)),
              ],
            ),
            const SizedBox(height: 6),
            Text(
              body,
              style: text.bodySmall?.copyWith(
                color: context.colors.textSecondary,
              ),
            ),
            const SizedBox(height: 10),
            OutlinedButton.icon(
              onPressed: onTap,
              icon: const Icon(Icons.arrow_forward, size: 16),
              label: Text(actionLabel),
            ),
          ],
        ),
      ),
    );
  }
}
