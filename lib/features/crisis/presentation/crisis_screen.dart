import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../core/haptics.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_theme.dart';
import '../../../i18n/strings.g.dart';

/// Kriz Rehberi — zor anlarda adım adım müdahale (statik içerik + nefes egzersizi).
class CrisisScreen extends ConsumerWidget {
  const CrisisScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = context.t;
    final cards = t.crisis.cards;
    final data = [
      (
        icon: Icons.bolt_outlined,
        color: const Color(0xFFDC2626),
        title: cards.meltdown.title,
        subtitle: cards.meltdown.subtitle,
        steps: cards.meltdown.steps,
        avoid: cards.meltdown.avoid,
        emergency: cards.meltdown.emergency,
      ),
      (
        icon: Icons.volume_up_outlined,
        color: const Color(0xFFEA580C),
        title: cards.sensory.title,
        subtitle: cards.sensory.subtitle,
        steps: cards.sensory.steps,
        avoid: cards.sensory.avoid,
        emergency: null,
      ),
      (
        icon: Icons.warning_amber_outlined,
        color: const Color(0xFFD97706),
        title: cards.aggression.title,
        subtitle: cards.aggression.subtitle,
        steps: cards.aggression.steps,
        avoid: cards.aggression.avoid,
        emergency: cards.aggression.emergency,
      ),
      (
        icon: Icons.favorite_outline,
        color: const Color(0xFF7C3AED),
        title: cards.anxiety.title,
        subtitle: cards.anxiety.subtitle,
        steps: cards.anxiety.steps,
        avoid: cards.anxiety.avoid,
        emergency: null,
      ),
    ];

    return Scaffold(
      appBar: AppBar(title: Text(t.crisis.title)),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(
              AppSpacing.margin, 12, AppSpacing.margin, 32),
          children: [
            _Hero(),
            const SizedBox(height: 16),
            const _BreathingCard(),
            const SizedBox(height: 16),
            for (final card in data) ...[
              _CrisisCard(
                icon: card.icon,
                accent: card.color,
                title: card.title,
                subtitle: card.subtitle,
                steps: card.steps,
                avoid: card.avoid,
                emergency: card.emergency,
              ),
              const SizedBox(height: 12),
            ],
            const SizedBox(height: 8),
            const _EmergencyContacts(),
            const SizedBox(height: 12),
            _Disclaimer(),
          ],
        ),
      ),
    );
  }
}

class _Hero extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final t = context.t;
    final colors = context.colors;
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: colors.error.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(AppRadius.xl),
        border: Border.all(color: colors.error.withValues(alpha: 0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.health_and_safety_outlined,
                  size: 20, color: colors.error),
              const SizedBox(width: 8),
              Text(
                t.crisis.title.toUpperCase(),
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 0.5,
                  color: colors.error,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(t.crisis.heroTitle,
              style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 4),
          Text(
            t.crisis.heroSubtitle,
            style: Theme.of(context)
                .textTheme
                .bodyMedium
                ?.copyWith(color: colors.textSecondary),
          ),
        ],
      ),
    );
  }
}

/// Nefes egzersizi — 4 sn nefes al, 6 sn nefes ver döngüsü, animasyonlu halka.
class _BreathingCard extends StatefulWidget {
  const _BreathingCard();

  @override
  State<_BreathingCard> createState() => _BreathingCardState();
}

enum _Breath { idle, inhale, exhale }

class _BreathingCardState extends State<_BreathingCard> {
  _Breath _step = _Breath.idle;
  int _timeLeft = 0;
  Timer? _timer;

  static const _inhaleSeconds = 4;
  static const _exhaleSeconds = 6;

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _toggle() {
    if (_step == _Breath.idle) {
      _startStep(_Breath.inhale);
    } else {
      _timer?.cancel();
      setState(() {
        _step = _Breath.idle;
        _timeLeft = 0;
      });
    }
  }

  void _startStep(_Breath step) {
    _timer?.cancel();
    Haptics.selection();
    var seconds = step == _Breath.inhale ? _inhaleSeconds : _exhaleSeconds;
    setState(() {
      _step = step;
      _timeLeft = seconds;
    });
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      seconds -= 1;
      if (seconds < 0) {
        _startStep(step == _Breath.inhale ? _Breath.exhale : _Breath.inhale);
      } else {
        setState(() => _timeLeft = seconds);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final t = context.t;
    const dark = Color(0xFF0F172A);
    const inhaleColor = Color(0xFF34D399);
    const exhaleColor = Color(0xFF818CF8);
    final active = _step != _Breath.idle;
    final ringColor = _step == _Breath.inhale ? inhaleColor : exhaleColor;
    final scale = switch (_step) {
      _Breath.inhale => 1.0,
      _Breath.exhale => 0.62,
      _Breath.idle => 0.78,
    };
    final label = switch (_step) {
      _Breath.inhale => t.crisis.breathingInhale,
      _Breath.exhale => t.crisis.breathingExhale,
      _Breath.idle => t.crisis.breathingReady,
    };

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 28, horizontal: 20),
      decoration: BoxDecoration(
        color: dark,
        borderRadius: BorderRadius.circular(AppRadius.xl),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.spa_outlined, size: 18, color: exhaleColor),
              const SizedBox(width: 8),
              Text(
                t.crisis.breathingTitle,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w800,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            t.crisis.breathingSubtitle,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 12, color: Color(0xFF94A3B8)),
          ),
          const SizedBox(height: 24),
          SizedBox(
            height: 220,
            width: 220,
            child: Stack(
              alignment: Alignment.center,
              children: [
                AnimatedContainer(
                  duration: Duration(
                      seconds: _step == _Breath.inhale
                          ? _inhaleSeconds
                          : _step == _Breath.exhale
                              ? _exhaleSeconds
                              : 1),
                  curve: Curves.easeInOut,
                  width: 220 * scale,
                  height: 220 * scale,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: ringColor.withValues(alpha: active ? 0.22 : 0.10),
                    border: Border.all(
                      color: ringColor.withValues(alpha: active ? 0.6 : 0.25),
                      width: 2,
                    ),
                  ),
                ),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      label,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 1.5,
                        color: active ? Colors.white : const Color(0xFFCBD5E1),
                      ),
                    ),
                    if (active) ...[
                      const SizedBox(height: 4),
                      Text(
                        '$_timeLeft',
                        style: const TextStyle(
                          fontSize: 44,
                          fontWeight: FontWeight.w900,
                          color: Colors.white,
                          height: 1,
                        ),
                      ),
                      Text(
                        t.crisis.breathingSeconds,
                        style: const TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 1,
                          color: Color(0xFF94A3B8),
                        ),
                      ),
                    ] else ...[
                      const SizedBox(height: 4),
                      Text(
                        t.crisis.breathingReadyHint,
                        style: const TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 1,
                          color: Color(0xFF64748B),
                        ),
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          FilledButton(
            onPressed: _toggle,
            style: FilledButton.styleFrom(
              backgroundColor: active ? const Color(0xFF334155) : exhaleColor,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppRadius.full),
              ),
              padding:
                  const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
            ),
            child: Text(
              active ? t.crisis.breathingStop : t.crisis.breathingStart,
              style: const TextStyle(
                fontWeight: FontWeight.w800,
                letterSpacing: 1,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _CrisisCard extends StatefulWidget {
  const _CrisisCard({
    required this.icon,
    required this.accent,
    required this.title,
    required this.subtitle,
    required this.steps,
    required this.avoid,
    required this.emergency,
  });

  final IconData icon;
  final Color accent;
  final String title;
  final String subtitle;
  final List<String> steps;
  final List<String> avoid;
  final String? emergency;

  @override
  State<_CrisisCard> createState() => _CrisisCardState();
}

class _CrisisCardState extends State<_CrisisCard> {
  bool _open = false;

  Future<void> _callEmergency() async {
    // "112 — ..." metninden numarayı çıkar.
    final match = RegExp(r'\d{3,4}').firstMatch(widget.emergency ?? '');
    if (match == null) return;
    Haptics.selection();
    await launchUrl(Uri(scheme: 'tel', path: match.group(0)));
  }

  @override
  Widget build(BuildContext context) {
    final t = context.t;
    final colors = context.colors;
    return Card(
      margin: EdgeInsets.zero,
      child: Column(
        children: [
          InkWell(
            onTap: () {
              Haptics.selection();
              setState(() => _open = !_open);
            },
            borderRadius: BorderRadius.circular(AppRadius.lg),
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.md),
              child: Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: widget.accent.withValues(alpha: 0.14),
                      borderRadius: BorderRadius.circular(AppRadius.md),
                    ),
                    child: Icon(widget.icon, size: 20, color: widget.accent),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(widget.title,
                            style: Theme.of(context).textTheme.titleSmall),
                        const SizedBox(height: 2),
                        Text(
                          widget.subtitle,
                          style: Theme.of(context)
                              .textTheme
                              .bodySmall
                              ?.copyWith(color: colors.textTertiary),
                        ),
                      ],
                    ),
                  ),
                  AnimatedRotation(
                    turns: _open ? 0.5 : 0,
                    duration: const Duration(milliseconds: 200),
                    child: Icon(Icons.expand_more, color: colors.textTertiary),
                  ),
                ],
              ),
            ),
          ),
          if (_open)
            Padding(
              padding: const EdgeInsets.fromLTRB(
                  AppSpacing.md, 0, AppSpacing.md, AppSpacing.md),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _SectionLabel(
                    icon: Icons.check_circle_outline,
                    color: colors.success,
                    label: t.crisis.stepsLabel,
                  ),
                  const SizedBox(height: 8),
                  for (var i = 0; i < widget.steps.length; i++)
                    _StepRow(
                      leading: '${i + 1}',
                      leadingColor: colors.success,
                      text: widget.steps[i],
                    ),
                  const SizedBox(height: 12),
                  _SectionLabel(
                    icon: Icons.cancel_outlined,
                    color: colors.error,
                    label: t.crisis.avoidLabel,
                  ),
                  const SizedBox(height: 8),
                  for (final item in widget.avoid)
                    _StepRow(
                      leading: '✕',
                      leadingColor: colors.error,
                      text: item,
                    ),
                  if (widget.emergency != null) ...[
                    const SizedBox(height: 12),
                    InkWell(
                      onTap: _callEmergency,
                      borderRadius: BorderRadius.circular(AppRadius.lg),
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: colors.error.withValues(alpha: 0.10),
                          borderRadius: BorderRadius.circular(AppRadius.lg),
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.call, size: 20, color: colors.error),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    t.crisis.emergencyLabel,
                                    style: TextStyle(
                                      fontSize: 10,
                                      fontWeight: FontWeight.w700,
                                      color: colors.error,
                                    ),
                                  ),
                                  Text(
                                    widget.emergency!,
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleSmall
                                        ?.copyWith(color: colors.error),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
        ],
      ),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  const _SectionLabel({
    required this.icon,
    required this.color,
    required this.label,
  });

  final IconData icon;
  final Color color;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 15, color: color),
        const SizedBox(width: 6),
        Text(
          label.toUpperCase(),
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w800,
            letterSpacing: 0.5,
            color: color,
          ),
        ),
      ],
    );
  }
}

class _StepRow extends StatelessWidget {
  const _StepRow({
    required this.leading,
    required this.leadingColor,
    required this.text,
  });

  final String leading;
  final Color leadingColor;
  final String text;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 22,
            height: 22,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: leadingColor.withValues(alpha: 0.14),
              shape: BoxShape.circle,
            ),
            child: Text(
              leading,
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w800,
                color: leadingColor,
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(top: 2),
              child: Text(
                text,
                style: Theme.of(context)
                    .textTheme
                    .bodyMedium
                    ?.copyWith(color: colors.textPrimary, height: 1.35),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _EmergencyContacts extends StatelessWidget {
  const _EmergencyContacts();

  @override
  Widget build(BuildContext context) {
    final t = context.t;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(t.crisis.contactsTitle,
            style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: 8),
        _ContactTile(
          number: '112',
          label: t.crisis.contact112Label,
          desc: t.crisis.contact112Desc,
          color: const Color(0xFFDC2626),
        ),
        const SizedBox(height: 8),
        _ContactTile(
          number: '183',
          label: t.crisis.contact183Label,
          desc: t.crisis.contact183Desc,
          color: const Color(0xFF6366F1),
        ),
      ],
    );
  }
}

class _ContactTile extends StatelessWidget {
  const _ContactTile({
    required this.number,
    required this.label,
    required this.desc,
    required this.color,
  });

  final String number;
  final String label;
  final String desc;
  final Color color;

  Future<void> _call() async {
    Haptics.selection();
    await launchUrl(Uri(scheme: 'tel', path: number));
  }

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    return Card(
      margin: EdgeInsets.zero,
      child: InkWell(
        onTap: _call,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Row(
            children: [
              Container(
                width: 52,
                height: 40,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(AppRadius.md),
                ),
                child: Text(
                  number,
                  style: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w900,
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(label, style: text.titleSmall),
                    Text(
                      desc,
                      style: text.bodySmall
                          ?.copyWith(color: context.colors.textTertiary),
                    ),
                  ],
                ),
              ),
              Icon(Icons.call, color: color),
            ],
          ),
        ),
      ),
    );
  }
}

class _Disclaimer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final t = context.t;
    final colors = context.colors;
    return Text(
      t.crisis.disclaimer,
      textAlign: TextAlign.center,
      style: TextStyle(
        fontSize: 11,
        height: 1.4,
        color: colors.textTertiary,
      ),
    );
  }
}
