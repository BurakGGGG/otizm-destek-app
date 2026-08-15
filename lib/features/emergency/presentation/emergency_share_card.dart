import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:share_plus/share_plus.dart';

import '../../../core/config/env.dart';
import '../../../core/haptics.dart';
import '../../../core/network/api_exception.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_theme.dart';
import '../../../i18n/strings.g.dart';
import '../data/emergency_repository.dart';

/// Backend'in kabul ettiği paylaşım süreleri (saat) — web seçenekleriyle aynı.
const List<int> kEmergencyShareHours = [24, 72, 168, 720];

/// Paylaşım bağlantısının açılacağı web adresi (alıcı tarayıcıda görür).
String emergencyShareUrl(String token) =>
    '${Env.webBaseUrl}/acil-profil/$token';

/// Acil durum kartının süreli paylaşım bölümü (web'deki "QR Kod ile Paylaş").
///
/// Bağlantı yalnızca `ACIL_DURUM_KARTI` açık rızası varken üretilebilir;
/// rıza geri çekilirse backend mevcut bağlantıyı da geçersiz kılar.
class EmergencyShareCard extends ConsumerStatefulWidget {
  const EmergencyShareCard({super.key, required this.childId});

  final String childId;

  @override
  ConsumerState<EmergencyShareCard> createState() => _EmergencyShareCardState();
}

class _EmergencyShareCardState extends ConsumerState<EmergencyShareCard> {
  int _hours = kEmergencyShareHours.first;
  bool _busy = false;

  Future<void> _enable() async {
    setState(() => _busy = true);
    try {
      await ref
          .read(emergencyRepositoryProvider)
          .enableShare(widget.childId, _hours);
      ref.invalidate(emergencyShareProvider(widget.childId));
      if (mounted) Haptics.success();
    } on ApiException catch (e) {
      if (mounted) _snack(e.message);
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _disable() async {
    setState(() => _busy = true);
    try {
      await ref.read(emergencyRepositoryProvider).disableShare(widget.childId);
      ref.invalidate(emergencyShareProvider(widget.childId));
    } on ApiException catch (e) {
      if (mounted) _snack(e.message);
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  void _snack(String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  String _formatExpiry(DateTime value) {
    final local = value.toLocal();
    final day = local.day.toString().padLeft(2, '0');
    final month = local.month.toString().padLeft(2, '0');
    final hour = local.hour.toString().padLeft(2, '0');
    final minute = local.minute.toString().padLeft(2, '0');
    return '$day.$month.${local.year} $hour:$minute';
  }

  String _hoursLabel(BuildContext context, int hours) {
    final t = context.t;
    return switch (hours) {
      24 => t.emergency.share24h,
      72 => t.emergency.share3d,
      168 => t.emergency.share1w,
      _ => t.emergency.share30d,
    };
  }

  @override
  Widget build(BuildContext context) {
    final t = context.t;
    final colors = context.colors;
    final text = Theme.of(context).textTheme;
    final statusAsync = ref.watch(emergencyShareProvider(widget.childId));

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.qr_code_2_outlined, color: colors.primary),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(t.emergency.shareTitle, style: text.titleMedium),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              t.emergency.shareBody,
              style: text.bodySmall?.copyWith(color: colors.textTertiary),
            ),
            const SizedBox(height: 12),
            statusAsync.when(
              loading: () => const LinearProgressIndicator(minHeight: 2),
              error: (e, _) => Text(
                e is ApiException ? e.message : t.errors.unexpected,
                style: text.bodySmall?.copyWith(color: colors.error),
              ),
              data: (status) {
                if (!status.consentGranted) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(AppSpacing.md),
                        decoration: BoxDecoration(
                          color: colors.warning.withValues(alpha: .12),
                          borderRadius: BorderRadius.circular(AppRadius.md),
                        ),
                        child: Text(
                          t.emergency.shareConsentRequired,
                          style: text.bodySmall,
                        ),
                      ),
                      const SizedBox(height: 8),
                      OutlinedButton.icon(
                        onPressed: () => context.push('/kvkk'),
                        icon: const Icon(Icons.verified_user_outlined),
                        label: Text(t.emergency.shareOpenConsents),
                      ),
                    ],
                  );
                }
                if (status.isActive) {
                  final url = emergencyShareUrl(status.shareToken!);
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Center(
                        child: Container(
                          padding: const EdgeInsets.all(AppSpacing.md),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(AppRadius.md),
                            border: Border.all(color: colors.border),
                          ),
                          child: QrImageView(
                            data: url,
                            size: 168,
                            backgroundColor: Colors.white,
                            // Yazdırılan/gösterilen kod okunaklı kalsın.
                            errorCorrectionLevel: QrErrorCorrectLevel.M,
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      if (status.expiresAt case final expires?)
                        Text(
                          t.emergency.shareValidUntil(
                            date: _formatExpiry(expires),
                          ),
                          textAlign: TextAlign.center,
                          style: text.labelSmall?.copyWith(
                            color: colors.textTertiary,
                          ),
                        ),
                      const SizedBox(height: 10),
                      SelectableText(
                        url,
                        style: text.bodySmall?.copyWith(color: colors.primary),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(
                            child: OutlinedButton.icon(
                              onPressed: () async {
                                await Clipboard.setData(
                                  ClipboardData(text: url),
                                );
                                if (context.mounted) {
                                  _snack(t.emergency.shareCopied);
                                }
                              },
                              icon: const Icon(Icons.copy_outlined, size: 18),
                              label: Text(t.emergency.shareCopy),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: FilledButton.icon(
                              onPressed: () => SharePlus.instance.share(
                                ShareParams(
                                  text: '${t.emergency.shareMessage}\n$url',
                                  subject: t.emergency.shareTitle,
                                ),
                              ),
                              icon: const Icon(Icons.ios_share, size: 18),
                              label: Text(t.emergency.shareSend),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      TextButton.icon(
                        onPressed: _busy ? null : _disable,
                        icon: Icon(Icons.link_off, color: colors.error),
                        style: TextButton.styleFrom(
                          foregroundColor: colors.error,
                        ),
                        label: Text(t.emergency.shareDisable),
                      ),
                    ],
                  );
                }
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    DropdownButtonFormField<int>(
                      initialValue: _hours,
                      decoration: InputDecoration(
                        labelText: t.emergency.shareDuration,
                      ),
                      items: [
                        for (final hours in kEmergencyShareHours)
                          DropdownMenuItem(
                            value: hours,
                            child: Text(_hoursLabel(context, hours)),
                          ),
                      ],
                      onChanged: _busy
                          ? null
                          : (value) =>
                                setState(() => _hours = value ?? _hours),
                    ),
                    const SizedBox(height: 12),
                    FilledButton.icon(
                      onPressed: _busy ? null : _enable,
                      icon: const Icon(Icons.qr_code_2),
                      label: Text(t.emergency.shareEnable),
                    ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
