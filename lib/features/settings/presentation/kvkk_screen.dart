import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/haptics.dart';
import '../../../core/network/api_exception.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/empty_state.dart';
import '../../../i18n/strings.g.dart';
import '../data/kvkk_repository.dart';
import '../domain/kvkk.dart';

/// KVKK hakları ekranı — web `SettingsPage` içindeki rıza anahtarları +
/// `KvkkRightsPanel` (başvurular, rıza geçmişi) karşılığı.
///
/// Rıza türü ve başvuru türü kodları backend enum'ları olduğundan sabittir;
/// yalnızca etiketleri çevrilir.
class KvkkScreen extends ConsumerWidget {
  const KvkkScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = context.t;
    final overview = ref.watch(consentOverviewProvider);

    return Scaffold(
      appBar: AppBar(title: Text(t.kvkk.title)),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async {
            ref.invalidate(consentOverviewProvider);
            ref.invalidate(kvkkRequestsProvider);
          },
          child: ListView(
            padding: const EdgeInsets.all(AppSpacing.margin),
            children: [
              _RightsCard(),
              const SizedBox(height: AppSpacing.md),
              overview.when(
                loading: () => const Center(
                  child: Padding(
                    padding: EdgeInsets.all(AppSpacing.lg),
                    child: CircularProgressIndicator(),
                  ),
                ),
                error: (e, _) => ErrorRetry(
                  message: e is ApiException ? e.message : null,
                  onRetry: () => ref.invalidate(consentOverviewProvider),
                ),
                data: (data) => Column(
                  children: [
                    if (data.requiresReconsent) ...[
                      _ReconsentCard(version: data.policyVersion),
                      const SizedBox(height: AppSpacing.md),
                    ],
                    _ConsentsCard(overview: data),
                    const SizedBox(height: AppSpacing.md),
                    _HistoryCard(history: data.history),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              const _RequestsCard(),
              const SizedBox(height: AppSpacing.lg),
            ],
          ),
        ),
      ),
    );
  }
}

/// KVKK md. 11 bilgilendirmesi (web ile aynı metin).
class _RightsCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final t = context.t;
    final colors = context.colors;
    final text = Theme.of(context).textTheme;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(Icons.balance_outlined, color: colors.primary),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(t.kvkk.rightsTitle, style: text.titleSmall),
                  const SizedBox(height: 4),
                  Text(t.kvkk.rightsBody, style: text.bodySmall),
                  const SizedBox(height: 4),
                  Align(
                    alignment: AlignmentDirectional.centerStart,
                    child: TextButton.icon(
                      onPressed: () => context.push('/legal/kvkk'),
                      icon: const Icon(Icons.open_in_new, size: 16),
                      label: Text(t.legal.readNotice),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ReconsentCard extends ConsumerStatefulWidget {
  const _ReconsentCard({required this.version});

  final String version;

  @override
  ConsumerState<_ReconsentCard> createState() => _ReconsentCardState();
}

class _ReconsentCardState extends ConsumerState<_ReconsentCard> {
  bool _busy = false;

  Future<void> _accept() async {
    final t = context.t;
    setState(() => _busy = true);
    try {
      await ref.read(kvkkRepositoryProvider).reconsent();
      if (!mounted) return;
      Haptics.success();
      ref.invalidate(consentOverviewProvider);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(t.kvkk.reconsentSaved)));
    } on ApiException catch (e) {
      if (!mounted) return;
      setState(() => _busy = false);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(e.message)));
    }
  }

  @override
  Widget build(BuildContext context) {
    final t = context.t;
    final colors = context.colors;
    final text = Theme.of(context).textTheme;
    return Card(
      color: colors.warning.withValues(alpha: .12),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.shield_outlined, color: colors.warning),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    widget.version.isEmpty
                        ? t.kvkk.reconsentTitle
                        : t.kvkk.reconsentTitleVersion(version: widget.version),
                    style: text.titleSmall,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),
            Text(t.kvkk.reconsentBody, style: text.bodySmall),
            const SizedBox(height: 12),
            FilledButton(
              onPressed: _busy ? null : _accept,
              child: Text(t.kvkk.reconsentAccept),
            ),
          ],
        ),
      ),
    );
  }
}

/// Amaç bazlı rıza anahtarları (KVKK açık rıza belirli olmalı).
class _ConsentsCard extends ConsumerStatefulWidget {
  const _ConsentsCard({required this.overview});

  final ConsentOverview overview;

  @override
  ConsumerState<_ConsentsCard> createState() => _ConsentsCardState();
}

class _ConsentsCardState extends ConsumerState<_ConsentsCard> {
  String? _saving;

  Future<void> _toggle(String type, bool value) async {
    setState(() => _saving = type);
    try {
      await ref.read(kvkkRepositoryProvider).setConsent(type, value);
      if (!mounted) return;
      Haptics.selection();
      ref.invalidate(consentOverviewProvider);
    } on ApiException catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(e.message)));
    } finally {
      if (mounted) setState(() => _saving = null);
    }
  }

  @override
  Widget build(BuildContext context) {
    final t = context.t;
    final text = Theme.of(context).textTheme;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(t.kvkk.consentsTitle, style: text.titleMedium),
            const SizedBox(height: 4),
            Text(
              t.kvkk.consentsSubtitle,
              style: text.bodySmall?.copyWith(color: context.colors.textTertiary),
            ),
            for (final type in ConsentTypes.toggleable)
              SwitchListTile(
                contentPadding: EdgeInsets.zero,
                dense: true,
                value: widget.overview.granted(type),
                title: Text(consentLabel(context, type), style: text.bodyMedium),
                subtitle: Text(
                  consentDescription(context, type),
                  style: text.bodySmall,
                ),
                onChanged: _saving != null
                    ? null
                    : (value) => _toggle(type, value),
              ),
          ],
        ),
      ),
    );
  }
}

class _HistoryCard extends StatelessWidget {
  const _HistoryCard({required this.history});

  final List<ConsentHistoryEntry> history;

  @override
  Widget build(BuildContext context) {
    final t = context.t;
    final colors = context.colors;
    final text = Theme.of(context).textTheme;
    if (history.isEmpty) return const SizedBox.shrink();

    return Card(
      child: ExpansionTile(
        shape: const Border(),
        leading: Icon(Icons.history, color: colors.primary),
        title: Text(t.kvkk.historyTitle, style: text.titleSmall),
        childrenPadding: const EdgeInsets.fromLTRB(
          AppSpacing.md,
          0,
          AppSpacing.md,
          AppSpacing.md,
        ),
        children: [
          for (final entry in history)
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    entry.granted ? Icons.check_circle : Icons.cancel,
                    size: 16,
                    color: entry.granted ? colors.success : colors.textTertiary,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          consentLabel(context, entry.consentType),
                          style: text.bodySmall,
                        ),
                        Text(
                          [
                            if (entry.createdAt != null)
                              formatKvkkDate(entry.createdAt!),
                            if (entry.policyVersion?.isNotEmpty ?? false)
                              't.${entry.policyVersion}',
                            if (entry.source?.isNotEmpty ?? false) entry.source!,
                          ].join(' · '),
                          style: text.labelSmall?.copyWith(
                            color: colors.textTertiary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

/// Veri sahibi başvuruları: yeni başvuru + durum takibi.
class _RequestsCard extends ConsumerWidget {
  const _RequestsCard();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = context.t;
    final colors = context.colors;
    final text = Theme.of(context).textTheme;
    final requests = ref.watch(kvkkRequestsProvider);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(t.kvkk.requestsTitle, style: text.titleMedium),
            const SizedBox(height: 4),
            Text(
              t.kvkk.requestsSubtitle,
              style: text.bodySmall?.copyWith(color: colors.textTertiary),
            ),
            const SizedBox(height: 12),
            OutlinedButton.icon(
              onPressed: () => showModalBottomSheet<bool>(
                context: context,
                isScrollControlled: true,
                builder: (_) => const _RequestSheet(),
              ).then((created) {
                if (created == true) ref.invalidate(kvkkRequestsProvider);
              }),
              icon: const Icon(Icons.description_outlined),
              label: Text(t.kvkk.newRequest),
            ),
            const SizedBox(height: 8),
            requests.when(
              loading: () => const Padding(
                padding: EdgeInsets.all(AppSpacing.md),
                child: LinearProgressIndicator(minHeight: 2),
              ),
              error: (_, _) => Text(
                t.kvkk.requestsError,
                style: text.bodySmall?.copyWith(color: colors.error),
              ),
              data: (items) => items.isEmpty
                  ? Text(
                      t.kvkk.requestsEmpty,
                      style: text.bodySmall?.copyWith(
                        color: colors.textTertiary,
                      ),
                    )
                  : Column(
                      children: [
                        for (final request in items)
                          _RequestTile(request: request),
                      ],
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

class _RequestTile extends StatelessWidget {
  const _RequestTile({required this.request});

  final KvkkRequest request;

  @override
  Widget build(BuildContext context) {
    final t = context.t;
    final colors = context.colors;
    final text = Theme.of(context).textTheme;
    final (statusLabel, statusColor) = switch (request.status) {
      'ACIK' => (t.kvkk.statusOpen, colors.primary),
      'INCELENIYOR' => (t.kvkk.statusReviewing, colors.warning),
      'TAMAMLANDI' => (t.kvkk.statusDone, colors.success),
      'REDDEDILDI' => (t.kvkk.statusRejected, colors.error),
      _ => (request.status, colors.textTertiary),
    };

    return Container(
      margin: const EdgeInsets.only(top: 8),
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: colors.surfaceVariant,
        borderRadius: BorderRadius.circular(AppRadius.md),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  kvkkRequestLabel(context, request.requestType),
                  style: text.bodyMedium,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: statusColor.withValues(alpha: .14),
                  borderRadius: BorderRadius.circular(AppRadius.sm),
                ),
                child: Text(
                  statusLabel,
                  style: text.labelSmall?.copyWith(
                    color: statusColor,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
          if (request.createdAt != null || request.dueAt != null) ...[
            const SizedBox(height: 4),
            Text(
              [
                if (request.createdAt != null)
                  t.kvkk.receivedOn(date: formatKvkkDate(request.createdAt!)),
                if (request.dueAt != null)
                  t.kvkk.dueOn(date: formatKvkkDate(request.dueAt!)),
              ].join(' · '),
              style: text.labelSmall?.copyWith(color: colors.textTertiary),
            ),
          ],
          if (request.response case final response?
              when response.trim().isNotEmpty) ...[
            const SizedBox(height: 8),
            Text(response, style: text.bodySmall),
          ],
        ],
      ),
    );
  }
}

/// Yeni başvuru formu.
class _RequestSheet extends ConsumerStatefulWidget {
  const _RequestSheet();

  @override
  ConsumerState<_RequestSheet> createState() => _RequestSheetState();
}

class _RequestSheetState extends ConsumerState<_RequestSheet> {
  String _type = KvkkRequestTypes.info;
  final _description = TextEditingController();
  bool _busy = false;
  String? _error;

  @override
  void dispose() {
    _description.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final t = context.t;
    if (_description.text.trim().isEmpty) {
      setState(() => _error = t.kvkk.errorDescriptionRequired);
      return;
    }
    setState(() {
      _error = null;
      _busy = true;
    });
    try {
      await ref
          .read(kvkkRepositoryProvider)
          .createRequest(
            requestType: _type,
            description: _description.text.trim(),
          );
      if (!mounted) return;
      Haptics.success();
      Navigator.of(context).pop(true);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(t.kvkk.requestCreated)));
    } on ApiException catch (e) {
      if (mounted) {
        setState(() {
          _error = e.message;
          _busy = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final t = context.t;
    final text = Theme.of(context).textTheme;

    return Padding(
      padding: EdgeInsets.only(
        left: AppSpacing.margin,
        right: AppSpacing.margin,
        top: AppSpacing.lg,
        bottom: MediaQuery.viewInsetsOf(context).bottom + AppSpacing.lg,
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(t.kvkk.newRequest, style: text.titleMedium),
            const SizedBox(height: 12),
            RadioGroup<String>(
              groupValue: _type,
              onChanged: (value) {
                if (_busy) return;
                setState(() => _type = value ?? _type);
              },
              child: Column(
                children: [
                  for (final type in KvkkRequestTypes.all)
                    RadioListTile<String>(
                      contentPadding: EdgeInsets.zero,
                      dense: true,
                      value: type,
                      title: Text(
                        kvkkRequestLabel(context, type),
                        style: text.bodySmall,
                      ),
                    ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _description,
              maxLines: 4,
              decoration: InputDecoration(
                labelText: t.kvkk.descriptionLabel,
                hintText: t.kvkk.descriptionHint,
                errorText: _error,
                errorMaxLines: 3,
              ),
            ),
            const SizedBox(height: 8),
            Text(t.kvkk.responseTime, style: text.labelSmall),
            const SizedBox(height: 16),
            FilledButton(
              onPressed: _busy ? null : _submit,
              child: _busy
                  ? const SizedBox(
                      height: 22,
                      width: 22,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : Text(t.kvkk.submitRequest),
            ),
          ],
        ),
      ),
    );
  }
}

/// Rıza türü etiketi (kod veri, etiket çevrilir).
String consentLabel(BuildContext context, String type) {
  final t = context.t;
  return switch (type) {
    ConsentTypes.notice => t.kvkk.consentNotice,
    ConsentTypes.aiAnalysis => t.kvkk.consentAi,
    ConsentTypes.emergencyCard => t.kvkk.consentEmergency,
    ConsentTypes.matching => t.kvkk.consentMatching,
    ConsentTypes.marketing => t.kvkk.consentMarketing,
    _ => type,
  };
}

String consentDescription(BuildContext context, String type) {
  final t = context.t;
  return switch (type) {
    ConsentTypes.aiAnalysis => t.kvkk.consentAiBody,
    ConsentTypes.emergencyCard => t.kvkk.consentEmergencyBody,
    ConsentTypes.matching => t.kvkk.consentMatchingBody,
    ConsentTypes.marketing => t.kvkk.consentMarketingBody,
    _ => '',
  };
}

String kvkkRequestLabel(BuildContext context, String type) {
  final t = context.t;
  return switch (type) {
    KvkkRequestTypes.info => t.kvkk.requestInfo,
    KvkkRequestTypes.correction => t.kvkk.requestCorrection,
    KvkkRequestTypes.deletion => t.kvkk.requestDeletion,
    KvkkRequestTypes.transfer => t.kvkk.requestTransfer,
    KvkkRequestTypes.objection => t.kvkk.requestObjection,
    KvkkRequestTypes.damages => t.kvkk.requestDamages,
    _ => type,
  };
}

String formatKvkkDate(DateTime date) {
  final local = date.toLocal();
  final day = local.day.toString().padLeft(2, '0');
  final month = local.month.toString().padLeft(2, '0');
  return '$day.$month.${local.year}';
}
