import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/network/api_exception.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/user_avatar.dart';
import '../../../i18n/strings.g.dart';
import '../../appointments/presentation/appointment_booking_screen.dart';
import '../../auth/domain/app_user.dart';
import '../../auth/presentation/auth_controller.dart';
import '../../appointments/data/appointment_repository.dart';
import '../../messaging/data/messaging_repository.dart';
import '../../reports/data/report_repository.dart';
import '../../reports/domain/report_reasons.dart';
import '../../messaging/presentation/conversation_thread_screen.dart';
import '../domain/expert.dart';
import 'widgets/expert_reviews_section.dart';

/// Uzman detay ekranı — liste öğesinden gelen [Expert] ile beslenir.
class ExpertDetailScreen extends ConsumerWidget {
  const ExpertDetailScreen({super.key, required this.expert});
  final Expert expert;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = context.t;
    final text = Theme.of(context).textTheme;
    final auth = ref.watch(authControllerProvider);
    final isParent = auth.user?.role == UserRole.parent;
    final isSelf = auth.user?.id == expert.id;
    final canBook = isParent && !isSelf && expert.verified;

    return Scaffold(
      appBar: AppBar(
        title: Text(expert.fullName),
        actions: [
          if (!isSelf)
            IconButton(
              tooltip: t.expertDetail.report,
              onPressed: () => _showReportSheet(context, ref, expert),
              icon: const Icon(Icons.flag_outlined),
            ),
        ],
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(AppSpacing.margin),
          children: [
            Row(
              children: [
                UserAvatar(
                  name: expert.fullName,
                  imageUrl: expert.profileImageUrl,
                  radius: 36,
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Flexible(
                            child: Text(
                              expert.fullName,
                              style: text.titleLarge,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          if (expert.verified) ...[
                            const SizedBox(width: 6),
                            Icon(
                              Icons.verified,
                              size: 18,
                              color: context.colors.primary,
                            ),
                          ],
                        ],
                      ),
                      if (expert.expertTitle?.isNotEmpty ?? false)
                        Text(
                          expert.expertTitle!,
                          style: text.bodyMedium?.copyWith(
                            color: context.colors.textSecondary,
                          ),
                        ),
                      const SizedBox(height: 6),
                      _RatingLine(expert: expert),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Konum / kurum / makale bilgisi
            if (expert.city?.isNotEmpty ?? false)
              _InfoRow(icon: Icons.place_outlined, text: expert.city!),
            if (expert.institution?.isNotEmpty ?? false)
              _InfoRow(
                icon: Icons.business_outlined,
                text: expert.institution!,
              ),
            if (expert.articleCount > 0)
              _InfoRow(
                icon: Icons.article_outlined,
                text: t.expertDetail.articleCount(count: expert.articleCount),
              ),

            const SizedBox(height: 12),
            _VerificationBadges(expert: expert),

            // Hakkında (uzmanın kendi metni)
            if (expert.bio?.trim().isNotEmpty ?? false) ...[
              const SizedBox(height: 20),
              Text(t.expertDetail.aboutTitle, style: text.titleSmall),
              const SizedBox(height: 6),
              Text(
                expert.bio!.trim(),
                style: text.bodyMedium?.copyWith(
                  color: context.colors.textSecondary,
                ),
              ),
            ],

            const SizedBox(height: 20),
            Text(t.expertDetail.professionalTitle, style: text.titleSmall),
            const SizedBox(height: 8),
            _ProfileFacts(expert: expert),

            // Uzmanlık alanları
            if (expert.specializations.isNotEmpty) ...[
              const SizedBox(height: 16),
              Text(t.expertDetail.specializationsTitle, style: text.titleSmall),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  for (final s in expert.specializations)
                    Chip(
                      label: Text(s),
                      backgroundColor: context.colors.primary.withValues(
                        alpha: 0.08,
                      ),
                      side: BorderSide.none,
                    ),
                ],
              ),
            ],

            const SizedBox(height: 28),
            _ExpertActions(
              expert: expert,
              canBook: canBook,
              canMessage: !isSelf,
              showNotAccepting: isParent && !isSelf && !expert.verified,
            ),
            const SizedBox(height: 28),
            ExpertReviewsSection(expert: expert, canReview: isParent && !isSelf),
          ],
        ),
      ),
    );
  }
}

/// Doğrulama rozetleri — web ProfilePage'deki onay/lisans satırı. Lisans
/// numarası `/experts` yanıtında dönmediği için (web'de de dolmuyor) yalnızca
/// doğrulama bayrakları gösterilir.
class _VerificationBadges extends StatelessWidget {
  const _VerificationBadges({required this.expert});
  final Expert expert;

  @override
  Widget build(BuildContext context) {
    final t = context.t;
    final colors = context.colors;
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        _Badge(
          icon: expert.verified ? Icons.verified : Icons.schedule,
          label: expert.verified
              ? t.expertDetail.badgeVerified
              : t.expertDetail.badgePending,
          color: expert.verified ? colors.success : colors.warning,
        ),
        if (expert.licenseVerified)
          _Badge(
            icon: Icons.workspace_premium_outlined,
            label: t.expertDetail.badgeLicenseVerified,
            color: colors.primary,
          ),
      ],
    );
  }
}

class _Badge extends StatelessWidget {
  const _Badge({
    required this.icon,
    required this.label,
    required this.color,
  });

  final IconData icon;
  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: color.withValues(alpha: .10),
        borderRadius: BorderRadius.circular(AppRadius.full),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: color),
          const SizedBox(width: 6),
          Text(
            label,
            style: Theme.of(context)
                .textTheme
                .labelSmall
                ?.copyWith(color: color),
          ),
        ],
      ),
    );
  }
}

/// Profil bilgileri tablosu — web ExpertsPage `ProfileFact` satırları.
/// Değerler uzmanın girdiği veridir; boşsa web ile aynı yedek metin.
class _ProfileFacts extends ConsumerWidget {
  const _ProfileFacts({required this.expert});
  final Expert expert;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = context.t;
    final slot = ref
        .watch(nextAvailableSlotProvider((
          expertId: expert.id,
          duration: expert.sessionDurationMinutes,
        )))
        .asData
        ?.value;
    final duration = expert.sessionDurationMinutes ?? 50;
    final serviceFormat = [
      if (expert.offersOnline) t.expertDetail.serviceOnline,
      if (expert.offersFaceToFace) t.expertDetail.serviceFaceToFace,
    ];

    final facts = <({String label, String value})>[
      (
        label: t.expertDetail.factNextSlot,
        value: slot == null
            ? t.expertDetail.factNextSlotEmpty
            : '${_slotDayLabel(t, slot.date)} · ${slot.time}',
      ),
      (
        label: t.expertDetail.factSession,
        value: t.expertDetail.factSessionValue(count: duration),
      ),
      (
        label: t.expertDetail.factAgeGroups,
        value: expert.ageGroups.isEmpty
            ? t.expertDetail.factAgeGroupsEmpty
            : expert.ageGroups.join(', '),
      ),
      (
        label: t.expertDetail.factLanguages,
        value: expert.spokenLanguages.isEmpty
            ? 'Türkçe' // web varsayılanı (veri)
            : expert.spokenLanguages.join(', '),
      ),
      (
        label: t.expertDetail.factSupportTopics,
        value: expert.supportTopics.isNotEmpty
            ? expert.supportTopics.join(', ')
            : expert.specializations.isNotEmpty
                ? expert.specializations.join(', ')
                : t.expertDetail.factSupportTopicsEmpty,
      ),
      (
        label: t.expertDetail.factService,
        value: serviceFormat.isEmpty
            ? t.expertDetail.factServiceEmpty
            : serviceFormat.join(' · '),
      ),
      (
        label: t.expertDetail.factFee,
        value: expertFeeLabel(expert) ?? t.expertDetail.factFeeEmpty,
      ),
      (
        label: t.expertDetail.factCancellation,
        value: expert.cancellationPolicy?.trim().isNotEmpty ?? false
            ? expert.cancellationPolicy!.trim()
            : t.expertDetail.factCancellationEmpty,
      ),
      if (expert.reschedulePolicy?.trim().isNotEmpty ?? false)
        (
          label: t.expertDetail.factReschedule,
          value: expert.reschedulePolicy!.trim(),
        ),
    ];

    final colors = context.colors;
    final text = Theme.of(context).textTheme;
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: colors.surfaceVariant.withValues(alpha: .5),
        borderRadius: BorderRadius.circular(AppRadius.md),
      ),
      child: Column(
        children: [
          for (final fact in facts) ...[
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: 130,
                  child: Text(
                    fact.label,
                    style: text.labelSmall
                        ?.copyWith(color: colors.textSecondary),
                  ),
                ),
                Expanded(child: Text(fact.value, style: text.bodySmall)),
              ],
            ),
            if (fact != facts.last) const Divider(height: 18),
          ],
        ],
      ),
    );
  }
}

/// Seans ücreti aralığı — web birebir: tek değer varsa tek fiyat, iki farklı
/// değer varsa aralık. Ücret yoksa null. (Uzman kartında da kullanılır.)
String? expertFeeLabel(Expert expert) {
  final min = expert.sessionFeeMin;
  final max = expert.sessionFeeMax;
  if (min == null && max == null) return null;
  final start = min ?? max;
  if (max != null && max != min && min != null) {
    return '₺$start – ₺$max';
  }
  return '₺$start';
}

/// `yyyy-MM-dd` → "12 Eylül" (web'deki gün/ay etiketiyle aynı biçim).
String _slotDayLabel(Translations t, String isoDate) {
  final date = DateTime.tryParse(isoDate);
  if (date == null) return isoDate;
  return '${date.day} ${t.common.monthsShort[date.month - 1]}';
}

/// Profil şikayeti — neden listesi paylaşılan veri (web REPORT_REASONS).
Future<void> _showReportSheet(
  BuildContext context,
  WidgetRef ref,
  Expert expert,
) async {
  final t = context.t;
  final noteController = TextEditingController();
  String? reason;

  final sent = await showModalBottomSheet<bool>(
    context: context,
    isScrollControlled: true,
    builder: (sheetContext) {
      return StatefulBuilder(
        builder: (sheetContext, setSheetState) {
          return Padding(
            padding: EdgeInsets.only(
              left: AppSpacing.margin,
              right: AppSpacing.margin,
              top: AppSpacing.md,
              bottom: MediaQuery.of(sheetContext).viewInsets.bottom +
                  AppSpacing.md,
            ),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    t.expertDetail.report,
                    style: Theme.of(sheetContext).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    t.expertDetail.reportReasonLabel,
                    style: Theme.of(sheetContext).textTheme.labelLarge,
                  ),
                  RadioGroup<String>(
                    groupValue: reason,
                    onChanged: (value) => setSheetState(() => reason = value),
                    child: Column(
                      children: [
                        for (final option in kExpertReportReasons)
                          RadioListTile<String>(
                            value: option,
                            contentPadding: EdgeInsets.zero,
                            dense: true,
                            // Neden metni sunucuya olduğu gibi gider (veri).
                            title: Text(option),
                          ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: noteController,
                    maxLines: 3,
                    decoration: InputDecoration(
                      labelText: t.expertDetail.reportNoteLabel,
                      hintText: t.expertDetail.reportNoteHint,
                    ),
                  ),
                  const SizedBox(height: 16),
                  FilledButton.icon(
                    onPressed: reason == null
                        ? null
                        : () => Navigator.of(sheetContext).pop(true),
                    icon: const Icon(Icons.flag_outlined, size: 18),
                    label: Text(t.expertDetail.reportSend),
                  ),
                ],
              ),
            ),
          );
        },
      );
    },
  );

  final selected = reason;
  final note = noteController.text;
  noteController.dispose();
  if (sent != true || selected == null || !context.mounted) return;

  final messenger = ScaffoldMessenger.of(context);
  try {
    await ref.read(reportRepositoryProvider).create(
          targetType: kReportTargetExpert,
          targetId: expert.id,
          reason: composeReportReason(selected, note),
        );
    messenger.showSnackBar(
      SnackBar(content: Text(t.expertDetail.reportSent)),
    );
  } on ApiException catch (e) {
    messenger.showSnackBar(SnackBar(content: Text(e.message)));
  }
}

/// Uzman detay aksiyonları: randevu al + mesaj gönder (konuşma başlatır).
class _ExpertActions extends ConsumerStatefulWidget {
  const _ExpertActions({
    required this.expert,
    required this.canBook,
    required this.canMessage,
    required this.showNotAccepting,
  });

  final Expert expert;
  final bool canBook;
  final bool canMessage;
  final bool showNotAccepting;

  @override
  ConsumerState<_ExpertActions> createState() => _ExpertActionsState();
}

class _ExpertActionsState extends ConsumerState<_ExpertActions> {
  bool _messaging = false;

  Future<void> _book() async {
    final result = await Navigator.of(context).push<String>(
      MaterialPageRoute(
        builder: (_) => AppointmentBookingScreen(expert: widget.expert),
      ),
    );
    if (result != null && mounted) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(result)));
    }
  }

  Future<void> _message() async {
    setState(() => _messaging = true);
    try {
      final conv = await ref
          .read(messagingRepositoryProvider)
          .getOrCreateDirect(widget.expert.id);
      if (!mounted) return;
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => ConversationThreadScreen(
            conversationId: conv.id,
            title: widget.expert.fullName,
            otherUserId: widget.expert.id,
          ),
        ),
      );
    } on ApiException catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(e.message)));
      }
    } finally {
      if (mounted) setState(() => _messaging = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final t = context.t;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (widget.canBook)
          FilledButton.icon(
            onPressed: _book,
            icon: const Icon(Icons.event_available_outlined),
            label: Text(t.expertDetail.bookAppointment),
          ),
        if (widget.canBook && widget.canMessage) const SizedBox(height: 12),
        if (widget.canMessage)
          OutlinedButton.icon(
            onPressed: _messaging ? null : _message,
            icon: _messaging
                ? const SizedBox(
                    height: 18,
                    width: 18,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Icon(Icons.chat_bubble_outline),
            label: Text(t.expertDetail.sendMessage),
          ),
        if (widget.showNotAccepting) ...[
          if (widget.canMessage) const SizedBox(height: 12),
          _EmptyHint(message: t.expertDetail.notAcceptingPatients),
        ],
      ],
    );
  }
}

class _RatingLine extends StatelessWidget {
  const _RatingLine({required this.expert});
  final Expert expert;

  @override
  Widget build(BuildContext context) {
    final t = context.t;
    if (!expert.hasRating) {
      return Text(
        t.specialists.ratingNew,
        style: TextStyle(color: context.colors.textTertiary, fontSize: 13),
      );
    }
    return Row(
      children: [
        Icon(Icons.star, size: 16, color: context.colors.warning),
        const SizedBox(width: 4),
        Text(
          expert.avgRating.toStringAsFixed(1),
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        const SizedBox(width: 6),
        Text(
          t.specialists.reviews(count: expert.reviewCount),
          style: TextStyle(color: context.colors.textTertiary, fontSize: 13),
        ),
      ],
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({required this.icon, required this.text});
  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Icon(icon, size: 18, color: context.colors.textTertiary),
          const SizedBox(width: 10),
          Expanded(child: Text(text)),
        ],
      ),
    );
  }
}

class _EmptyHint extends StatelessWidget {
  const _EmptyHint({required this.message});
  final String message;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: context.colors.surfaceVariant,
        borderRadius: BorderRadius.circular(AppRadius.md),
      ),
      child: Text(
        message,
        style: TextStyle(color: context.colors.textSecondary),
      ),
    );
  }
}
