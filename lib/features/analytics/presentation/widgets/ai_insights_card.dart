import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/network/api_exception.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../i18n/strings.g.dart';
import '../../../settings/data/kvkk_repository.dart';
import '../../../settings/domain/kvkk.dart';
import '../../data/ai_insights_repository.dart';

/// Yapay zekâ analizi kartı — web AnalyticsPage'deki analiz bölümü.
///
/// Akış (SSE) ile parça parça yazılır; akış kurulamazsa web gibi tek seferlik
/// uç noktaya düşülür. Veli `AI_ANALIZ` açık rızası vermemişse backend
/// reddettiği için kart en baştan rıza kapısı gösterir.
class AiInsightsCard extends ConsumerStatefulWidget {
  const AiInsightsCard({super.key, required this.childId});

  final String childId;

  @override
  ConsumerState<AiInsightsCard> createState() => _AiInsightsCardState();
}

class _AiInsightsCardState extends ConsumerState<AiInsightsCard> {
  String _type = kAnalysisTypes.first;
  String _text = '';
  bool _running = false;
  String? _error;
  StreamSubscription<String>? _sub;

  @override
  void dispose() {
    _sub?.cancel();
    super.dispose();
  }

  Future<void> _run() async {
    await _sub?.cancel();
    setState(() {
      _running = true;
      _text = '';
      _error = null;
    });
    final repository = ref.read(aiInsightsRepositoryProvider);
    _sub = repository.streamInsights(widget.childId, _type).listen(
      (chunk) {
        if (mounted) setState(() => _text += chunk);
      },
      onError: (Object error) async {
        // Akış kurulamadı: web de burada tek seferlik uç noktaya düşüyor.
        try {
          final text = await repository.getInsights(widget.childId, _type);
          if (mounted) {
            setState(() {
              _text = text;
              _running = false;
            });
          }
        } catch (_) {
          if (mounted) {
            setState(() {
              _error = error is ApiException
                  ? error.message
                  : context.t.analytics.aiError;
              _running = false;
            });
          }
        }
      },
      onDone: () {
        if (mounted) setState(() => _running = false);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final t = context.t;
    final colors = context.colors;
    final text = Theme.of(context).textTheme;
    final consents = ref.watch(consentOverviewProvider).asData?.value;
    final consentGranted = consents?.granted(ConsentTypes.aiAnalysis) ?? true;

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
              Icon(Icons.auto_awesome_outlined, size: 18, color: colors.primary),
              const SizedBox(width: 8),
              Expanded(
                child: Text(t.analytics.aiTitle, style: text.titleSmall),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            t.analytics.aiSubtitle,
            style: text.labelSmall?.copyWith(color: colors.textSecondary),
          ),
          const SizedBox(height: 12),
          if (!consentGranted) ...[
            _ConsentGate(),
          ] else ...[
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                for (final type in kAnalysisTypes)
                  ChoiceChip(
                    label: Text(_typeLabel(t, type)),
                    selected: _type == type,
                    showCheckmark: false,
                    onSelected: _running
                        ? null
                        : (_) => setState(() => _type = type),
                  ),
              ],
            ),
            const SizedBox(height: 12),
            FilledButton.tonalIcon(
              onPressed: _running ? null : _run,
              icon: _running
                  ? const SizedBox(
                      height: 16,
                      width: 16,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Icon(Icons.play_arrow_rounded, size: 18),
              label: Text(
                _running
                    ? t.analytics.aiRunning
                    : t.analytics.aiStart(type: _typeLabel(t, _type)),
              ),
            ),
            if (_error != null) ...[
              const SizedBox(height: 12),
              Text(
                _error!,
                style: text.bodySmall?.copyWith(color: colors.error),
              ),
            ],
            if (_text.isNotEmpty) ...[
              const SizedBox(height: 12),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: colors.surfaceVariant.withValues(alpha: .6),
                  borderRadius: BorderRadius.circular(AppRadius.md),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: aiInsightBlocks(context, _text),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                t.analytics.aiDisclaimer,
                style: text.labelSmall?.copyWith(color: colors.textTertiary),
              ),
            ],
          ],
        ],
      ),
    );
  }
}

String _typeLabel(Translations t, String type) => switch (type) {
      'GENERAL' => t.analytics.aiTypeGeneral,
      'BEHAVIORAL' => t.analytics.aiTypeBehavioral,
      'PROGRESS' => t.analytics.aiTypeProgress,
      'WEEKLY' => t.analytics.aiTypeWeekly,
      _ => type,
    };

/// Rıza yoksa gösterilen kapı — KVKK ekranına götürür.
class _ConsentGate extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final t = context.t;
    final colors = context.colors;
    final text = Theme.of(context).textTheme;
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: colors.warning.withValues(alpha: .10),
        borderRadius: BorderRadius.circular(AppRadius.md),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(t.analytics.aiConsentTitle, style: text.labelLarge),
          const SizedBox(height: 4),
          Text(
            t.analytics.aiConsentBody,
            style: text.labelSmall?.copyWith(color: colors.textSecondary),
          ),
          const SizedBox(height: 8),
          TextButton(
            onPressed: () => context.push('/kvkk'),
            child: Text(t.analytics.aiConsentAction),
          ),
        ],
      ),
    );
  }
}

/// Modelin ürettiği hafif markdown'ı (başlık, madde, **kalın**) widget'lara
/// çevirir. Tam markdown desteği amaçlanmaz; okunabilirlik yeterlidir.
List<Widget> aiInsightBlocks(BuildContext context, String raw) {
  final text = Theme.of(context).textTheme;
  final colors = context.colors;
  final widgets = <Widget>[];

  for (final line in raw.split('\n')) {
    final trimmed = line.trim();
    if (trimmed.isEmpty) {
      widgets.add(const SizedBox(height: 8));
      continue;
    }
    if (trimmed.startsWith('#')) {
      widgets.add(
        Padding(
          padding: const EdgeInsets.only(top: 4, bottom: 2),
          child: Text(
            trimmed.replaceFirst(RegExp(r'^#+\s*'), ''),
            style: text.titleSmall,
          ),
        ),
      );
      continue;
    }
    final isBullet = trimmed.startsWith('- ') ||
        trimmed.startsWith('* ') ||
        trimmed.startsWith('• ');
    final content = isBullet ? trimmed.substring(2).trim() : trimmed;
    final spans = _inlineSpans(content, text.bodySmall);
    widgets.add(
      Padding(
        padding: const EdgeInsets.only(bottom: 2),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (isBullet)
              Padding(
                padding: const EdgeInsets.only(right: 6, top: 2),
                child: Icon(
                  Icons.circle,
                  size: 6,
                  color: colors.textTertiary,
                ),
              ),
            Expanded(child: Text.rich(TextSpan(children: spans))),
          ],
        ),
      ),
    );
  }
  return widgets;
}

/// `**kalın**` işaretlerini kalın parçalara çevirir.
List<TextSpan> _inlineSpans(String content, TextStyle? base) {
  final spans = <TextSpan>[];
  final pattern = RegExp(r'\*\*(.+?)\*\*');
  var index = 0;
  for (final match in pattern.allMatches(content)) {
    if (match.start > index) {
      spans.add(TextSpan(text: content.substring(index, match.start), style: base));
    }
    spans.add(
      TextSpan(
        text: match.group(1),
        style: base?.copyWith(fontWeight: FontWeight.w700),
      ),
    );
    index = match.end;
  }
  if (index < content.length) {
    spans.add(TextSpan(text: content.substring(index), style: base));
  }
  return spans;
}
