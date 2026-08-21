import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/haptics.dart';
import '../../../core/network/api_exception.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/empty_state.dart';
import '../../../core/widgets/skeleton.dart';
import '../../../i18n/strings.g.dart';
import '../../auth/domain/app_user.dart';
import '../../auth/presentation/auth_controller.dart';
import '../data/appointment_repository.dart';
import '../domain/appointment.dart';
import '../domain/expert_availability.dart';
import 'widgets/appointment_detail_sheet.dart';
import 'widgets/next_appointment_card.dart';

/// Randevular — liste + rol bazlı aksiyonlar (`/api/appointments`).
class AppointmentsScreen extends ConsumerWidget {
  const AppointmentsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = context.t;
    final role = ref.watch(authControllerProvider).user?.role;
    final async = ref.watch(appointmentsProvider);

    return Scaffold(
      appBar: AppBar(title: Text(t.appointments.title)),
      body: async.when(
        loading: () => const SkeletonList(count: 4),
        error: (e, _) =>
            ErrorRetry(onRetry: () => ref.invalidate(appointmentsProvider)),
        data: (all) {
          if (all.isEmpty) {
            return EmptyState(
              icon: Icons.event_busy_outlined,
              message: t.appointments.empty,
              // Web'deki "Uzman bul" adımı: randevu yoksa doğrudan uzman
              // listesine (ana kabuktaki Uzmanlar sekmesi) götürür.
              actionLabel: role == UserRole.expert
                  ? null
                  : t.appointments.findExpert,
              actionIcon: Icons.search,
              onAction: role == UserRole.expert
                  ? null
                  : () => context.go('/home?tab=1'),
            );
          }
          final isExpert = role == UserRole.expert;
          final stats = appointmentStats(all);
          final next = nextAppointment(all);

          final upcoming = all.where((a) => a.isUpcoming).toList()
            ..sort((a, b) {
              final byDate = a.date.compareTo(b.date);
              return byDate != 0 ? byDate : a.time.compareTo(b.time);
            });
          final past = all.where((a) => !a.isUpcoming).toList()
            ..sort((a, b) {
              final byDate = b.date.compareTo(a.date);
              return byDate != 0 ? byDate : b.time.compareTo(a.time);
            });

          return RefreshIndicator(
            onRefresh: () async => ref.invalidate(appointmentsProvider),
            child: ListView(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.margin,
                8,
                AppSpacing.margin,
                24,
              ),
              children: [
                if (next != null) ...[
                  const SizedBox(height: 4),
                  NextAppointmentCard(
                    appointment: next,
                    isExpert: isExpert,
                  ),
                ],
                const SizedBox(height: AppSpacing.md),
                _StatsGrid(stats: stats),
                if (upcoming.isNotEmpty) ...[
                  _SectionLabel(t.appointments.upcoming),
                  for (final a in upcoming)
                    _AppointmentCard(appointment: a, role: role),
                ],
                if (past.isNotEmpty) ...[
                  const SizedBox(height: 8),
                  _SectionLabel(t.appointments.past),
                  for (final a in past)
                    _AppointmentCard(appointment: a, role: role),
                ],
              ],
            ),
          );
        },
      ),
    );
  }
}

/// Randevu sayaçları (web başlığındaki altı kutu).
class _StatsGrid extends StatelessWidget {
  const _StatsGrid({required this.stats});

  final AppointmentStats stats;

  @override
  Widget build(BuildContext context) {
    final t = context.t;
    final colors = context.colors;
    final items = <({String label, int value, Color color})>[
      (label: t.appointments.statToday, value: stats.today, color: colors.primary),
      (label: t.appointments.statWeek, value: stats.week, color: colors.primary),
      (label: t.appointments.statMonth, value: stats.month, color: colors.primary),
      (
        label: t.appointments.statPending,
        value: stats.pending,
        color: colors.warning
      ),
      (
        label: t.appointments.statCompleted,
        value: stats.completed,
        color: colors.success
      ),
      (
        label: t.appointments.statCancelled,
        value: stats.cancelled,
        color: colors.error
      ),
    ];

    return LayoutBuilder(
      builder: (context, constraints) {
        // Üç sütun; dar ekranlarda kutular kendiliğinden daralır.
        final width = (constraints.maxWidth - 2 * 8) / 3;
        return Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            for (final item in items)
              SizedBox(
                width: width,
                child: _StatBox(
                  label: item.label,
                  value: item.value,
                  color: item.color,
                ),
              ),
          ],
        );
      },
    );
  }
}

class _StatBox extends StatelessWidget {
  const _StatBox({
    required this.label,
    required this.value,
    required this.color,
  });

  final String label;
  final int value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final text = Theme.of(context).textTheme;
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
      decoration: BoxDecoration(
        color: color.withValues(alpha: .06),
        borderRadius: BorderRadius.circular(AppRadius.md),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$value',
            style: text.titleMedium
                ?.copyWith(color: color, fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: text.labelSmall?.copyWith(color: colors.textSecondary),
          ),
        ],
      ),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  const _SectionLabel(this.text);
  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8, bottom: 8),
      child: Text(
        text,
        style: Theme.of(
          context,
        ).textTheme.titleSmall?.copyWith(color: context.colors.textTertiary),
      ),
    );
  }
}

class _AppointmentCard extends ConsumerStatefulWidget {
  const _AppointmentCard({required this.appointment, required this.role});

  final Appointment appointment;
  final UserRole? role;

  @override
  ConsumerState<_AppointmentCard> createState() => _AppointmentCardState();
}

class _AppointmentCardState extends ConsumerState<_AppointmentCard> {
  bool _busy = false;

  Appointment get a => widget.appointment;
  bool get isExpert => widget.role == UserRole.expert;

  Future<void> _run(Future<Appointment> Function() action, String okMsg) async {
    setState(() => _busy = true);
    try {
      await action();
      ref.invalidate(appointmentsProvider);
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(okMsg)));
      }
    } on ApiException catch (e) {
      if (mounted) {
        setState(() => _busy = false);
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(e.message)));
      }
    }
  }

  Future<void> _cancel() async {
    final t = context.t;
    final controller = TextEditingController();
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(t.appointments.cancelTitle),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(t.appointments.cancelConfirm),
            const SizedBox(height: 16),
            TextField(
              controller: controller,
              minLines: 1,
              maxLines: 3,
              decoration: InputDecoration(
                labelText: t.appointments.cancelReasonLabel,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: Text(t.appointments.keepIt),
          ),
          FilledButton(
            style: FilledButton.styleFrom(
              backgroundColor: context.colors.error,
            ),
            onPressed: () => Navigator.of(ctx).pop(true),
            child: Text(t.appointments.cancel),
          ),
        ],
      ),
    );
    final reason = controller.text;
    controller.dispose();
    if (confirmed != true) return;
    Haptics.warning();
    await _run(
      () =>
          ref.read(appointmentRepositoryProvider).cancel(a.id, reason: reason),
      t.appointments.cancelled,
    );
  }

  /// Tamamlanmış randevuyu 1-5 yıldız ve isteğe bağlı yorumla puanlar.
  Future<void> _rate() async {
    final t = context.t;
    final result = await showModalBottomSheet<({int rating, String comment})>(
      context: context,
      isScrollControlled: true,
      builder: (_) => const _RateSheet(),
    );
    if (result == null) return;
    Haptics.success();
    await _run(
      () => ref.read(appointmentRepositoryProvider).rate(
            a.id,
            result.rating,
            comment: result.comment,
          ),
      t.appointments.rated,
    );
  }

  /// Tekrarlayan seansın tüm gelecekteki randevularını iptal eder.
  Future<void> _cancelSeries() async {
    final t = context.t;
    final groupId = a.recurringGroupId;
    if (groupId == null) return;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(t.appointments.cancelSeriesTitle),
        content: Text(t.appointments.cancelSeriesConfirm),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: Text(t.appointments.keepIt),
          ),
          FilledButton(
            style: FilledButton.styleFrom(
              backgroundColor: context.colors.error,
            ),
            onPressed: () => Navigator.of(ctx).pop(true),
            child: Text(t.appointments.cancelSeries),
          ),
        ],
      ),
    );
    if (confirmed != true || !mounted) return;
    Haptics.warning();
    setState(() => _busy = true);
    final messenger = ScaffoldMessenger.of(context);
    try {
      await ref.read(appointmentRepositoryProvider).cancelSeries(groupId);
      ref.invalidate(appointmentsProvider);
      messenger.showSnackBar(
        SnackBar(content: Text(t.appointments.seriesCancelled)),
      );
    } on ApiException catch (e) {
      if (mounted) setState(() => _busy = false);
      messenger.showSnackBar(SnackBar(content: Text(e.message)));
    }
  }

  Future<void> _reschedule() async {
    final t = context.t;
    final expertId = a.expertId;
    if (expertId == null || expertId.isEmpty) return;
    final result = await showModalBottomSheet<({String dateIso, String time})>(
      context: context,
      isScrollControlled: true,
      builder: (_) =>
          _RescheduleSheet(expertId: expertId, duration: a.duration ?? 50),
    );
    if (result == null || !mounted) return;
    await _run(
      () => ref.read(appointmentRepositoryProvider).reschedule(
            a.id,
            dateIso: result.dateIso,
            time: result.time,
            duration: a.duration,
          ),
      t.appointments.rescheduled,
    );
  }

  @override
  Widget build(BuildContext context) {
    final t = context.t;
    final text = Theme.of(context).textTheme;

    // Karşı taraf: veli için uzman; uzman için veli/çocuk.
    final counterpart = isExpert
        ? (a.parentName ?? a.childName ?? '')
        : [
            a.expertName,
            a.expertTitle,
          ].where((s) => s?.isNotEmpty ?? false).join(' · ');

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    counterpart.isEmpty ? a.type ?? '' : counterpart,
                    style: text.titleMedium,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                if (a.isRecurring) ...[
                  _SeriesBadge(index: a.recurrenceIndex),
                  const SizedBox(width: 6),
                ],
                _StatusChip(kind: a.statusKind),
              ],
            ),
            const SizedBox(height: 6),
            _InfoRow(
              icon: Icons.event_outlined,
              text: t.appointments.dateLine(
                day: a.date.day,
                month: t.common.monthsShort[a.date.month - 1],
                year: a.date.year,
                time: a.time,
              ),
            ),
            _InfoRow(
              icon: a.isOnline ? Icons.videocam_outlined : Icons.place_outlined,
              text: a.isOnline
                  ? t.appointments.typeOnline
                  : t.appointments.typeFaceToFace,
            ),
            if (isExpert && (a.childName?.isNotEmpty ?? false))
              _InfoRow(
                icon: Icons.child_care_outlined,
                text: t.appointments.withChild(name: a.childName!),
              ),
            if (a.rating case final rating?)
              Padding(
                padding: const EdgeInsets.only(top: 6),
                child: Row(
                  children: [
                    for (var i = 1; i <= 5; i++)
                      Icon(
                        i <= rating
                            ? Icons.star_rounded
                            : Icons.star_border_rounded,
                        size: 16,
                        color: i <= rating
                            ? context.colors.warning
                            : context.colors.textTertiary,
                      ),
                    const SizedBox(width: 6),
                    Text(
                      t.appointments.ratingShown,
                      style: text.labelSmall
                          ?.copyWith(color: context.colors.textTertiary),
                    ),
                  ],
                ),
              ),
            if (a.notes?.isNotEmpty ?? false)
              Padding(
                padding: const EdgeInsets.only(top: 6),
                child: Text(a.notes!, style: text.bodySmall),
              ),
            if (a.isCancelled && (a.cancellationReason?.isNotEmpty ?? false))
              Padding(
                padding: const EdgeInsets.only(top: 6),
                child: Text(
                  t.appointments.cancelReasonShown(
                    reason: a.cancellationReason!,
                  ),
                  style: text.bodySmall?.copyWith(color: context.colors.error),
                ),
              ),
            if (a.isOnline &&
                !a.isCancelled &&
                (a.meetingLink?.isNotEmpty ?? false))
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Row(
                  children: [
                    Icon(Icons.link, size: 18, color: context.colors.primary),
                    const SizedBox(width: 6),
                    Expanded(
                      child: SelectableText(
                        a.meetingLink!,
                        style: TextStyle(
                          color: context.colors.primary,
                          fontSize: 13,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ..._actions(t),
          ],
        ),
      ),
    );
  }

  List<Widget> _actions(Translations t) {
    final buttons = <Widget>[
      OutlinedButton.icon(
        style: AppButtonStyles.inlineOutlined,
        onPressed: () => showModalBottomSheet<void>(
          context: context,
          isScrollControlled: true,
          builder: (_) => AppointmentDetailSheet(appointment: a),
        ),
        icon: const Icon(Icons.info_outline, size: 18),
        label: Text(t.appointments.detailOpen),
      ),
    ];
    final kind = a.statusKind;

    // Ertele — veli ve uzman için, yaklaşan bekleyen/onaylı randevularda.
    final canReschedule = a.isUpcoming &&
        (kind == AppointmentStatusKind.pending ||
            kind == AppointmentStatusKind.confirmed) &&
        (a.expertId?.isNotEmpty ?? false);
    if (canReschedule) {
      buttons.add(
        OutlinedButton.icon(
          style: AppButtonStyles.inlineOutlined,
          onPressed: _busy ? null : _reschedule,
          icon: const Icon(Icons.edit_calendar_outlined, size: 18),
          label: Text(t.appointments.reschedule),
        ),
      );
    }

    if (isExpert) {
      if (kind == AppointmentStatusKind.pending) {
        buttons.add(
          FilledButton.tonalIcon(
            style: AppButtonStyles.inlineFilled,
            onPressed: _busy
                ? null
                : () => _run(
                    () => ref.read(appointmentRepositoryProvider).confirm(a.id),
                    t.appointments.confirmed,
                  ),
            icon: const Icon(Icons.check, size: 18),
            label: Text(t.appointments.confirm),
          ),
        );
      } else if (kind == AppointmentStatusKind.confirmed) {
        buttons.add(
          FilledButton.tonalIcon(
            style: AppButtonStyles.inlineFilled,
            onPressed: _busy
                ? null
                : () => _run(
                    () =>
                        ref.read(appointmentRepositoryProvider).complete(a.id),
                    t.appointments.completed,
                  ),
            icon: const Icon(Icons.task_alt, size: 18),
            label: Text(t.appointments.complete),
          ),
        );
      }
    } else {
      // PARENT — onay bekleyen/onaylı ve yaklaşan randevuyu iptal edebilir.
      if (a.isUpcoming &&
          (kind == AppointmentStatusKind.pending ||
              kind == AppointmentStatusKind.confirmed)) {
        buttons.add(
          OutlinedButton.icon(
            onPressed: _busy ? null : _cancel,
            style: OutlinedButton.styleFrom(
              foregroundColor: context.colors.error,
              minimumSize: const Size(0, AppTheme.minTapTarget),
            ),
            icon: const Icon(Icons.close, size: 18),
            label: Text(t.appointments.cancel),
          ),
        );
      }
      // Tamamlanmış ve henüz puanlanmamış randevu değerlendirilebilir.
      if (kind == AppointmentStatusKind.completed && a.rating == null) {
        buttons.add(
          FilledButton.tonalIcon(
            style: AppButtonStyles.inlineFilled,
            onPressed: _busy ? null : _rate,
            icon: const Icon(Icons.star_border_rounded, size: 18),
            label: Text(t.appointments.rate),
          ),
        );
      }
      // Seriye ait, iptal edilebilir bir randevuda tüm seri iptal edilebilir.
      if (a.isRecurring &&
          (kind == AppointmentStatusKind.pending ||
              kind == AppointmentStatusKind.confirmed)) {
        buttons.add(
          OutlinedButton.icon(
            style: AppButtonStyles.inlineOutlined,
            onPressed: _busy ? null : _cancelSeries,
            icon: const Icon(Icons.repeat, size: 18),
            label: Text(t.appointments.cancelSeries),
          ),
        );
      }
    }

    // Butonlar dörde çıkabildiği için satır yerine Wrap: dar ekranda alt
    // satıra iner. Satır içi biçim zorunlu — temada asgari genişlik sonsuz
    // (bkz. CLAUDE.md).
    return [
      const SizedBox(height: 10),
      Wrap(
        spacing: 8,
        runSpacing: 8,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          if (_busy)
            const SizedBox(
              height: 18,
              width: 18,
              child: CircularProgressIndicator(strokeWidth: 2),
            ),
          ...buttons,
        ],
      ),
    ];
  }
}

/// Tekrarlayan seans rozeti ("3. seans" ya da "Seri").
class _SeriesBadge extends StatelessWidget {
  const _SeriesBadge({this.index});

  final int? index;

  @override
  Widget build(BuildContext context) {
    final t = context.t;
    final colors = context.colors;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: colors.primaryContainer,
        borderRadius: BorderRadius.circular(AppRadius.full),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.repeat, size: 12, color: colors.primary),
          const SizedBox(width: 4),
          Text(
            index == null
                ? t.appointments.seriesBadge
                : t.appointments.seriesIndex(index: index!),
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: colors.primary,
                  fontWeight: FontWeight.w700,
                ),
          ),
        ],
      ),
    );
  }
}

/// Randevu değerlendirme formu (1-5 yıldız + isteğe bağlı yorum).
class _RateSheet extends StatefulWidget {
  const _RateSheet();

  @override
  State<_RateSheet> createState() => _RateSheetState();
}

class _RateSheetState extends State<_RateSheet> {
  final _comment = TextEditingController();
  int _rating = 5;

  @override
  void dispose() {
    _comment.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final t = context.t;
    final text = Theme.of(context).textTheme;

    return Padding(
      padding: EdgeInsets.only(
        left: AppSpacing.margin,
        right: AppSpacing.margin,
        top: AppSpacing.md,
        bottom: MediaQuery.viewInsetsOf(context).bottom + AppSpacing.md,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(t.appointments.rateTitle, style: text.titleMedium),
          const SizedBox(height: 8),
          Row(
            children: [
              for (var i = 1; i <= 5; i++)
                IconButton(
                  tooltip: t.appointments.rateStars(count: i),
                  onPressed: () => setState(() => _rating = i),
                  icon: Icon(
                    i <= _rating
                        ? Icons.star_rounded
                        : Icons.star_border_rounded,
                    size: 30,
                    color: i <= _rating
                        ? context.colors.warning
                        : context.colors.textTertiary,
                  ),
                ),
            ],
          ),
          const SizedBox(height: 8),
          TextField(
            controller: _comment,
            minLines: 2,
            maxLines: 4,
            textCapitalization: TextCapitalization.sentences,
            decoration:
                InputDecoration(labelText: t.appointments.rateComment),
          ),
          const SizedBox(height: 16),
          FilledButton.icon(
            onPressed: () => Navigator.of(context).pop(
              (rating: _rating, comment: _comment.text),
            ),
            icon: const Icon(Icons.send_outlined, size: 18),
            label: Text(t.appointments.rateSave),
          ),
          const SizedBox(height: 8),
        ],
      ),
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
      padding: const EdgeInsets.only(top: 2),
      child: Row(
        children: [
          Icon(icon, size: 16, color: context.colors.textTertiary),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: Theme.of(context).textTheme.bodyMedium,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}

/// Erteleme alt sayfası — uzman müsaitliğinden yeni tarih + saat seçtirir,
/// sonucu `(dateIso, time)` olarak döndürür.
class _RescheduleSheet extends ConsumerStatefulWidget {
  const _RescheduleSheet({required this.expertId, required this.duration});
  final String expertId;
  final int duration;

  @override
  ConsumerState<_RescheduleSheet> createState() => _RescheduleSheetState();
}

class _RescheduleSheetState extends ConsumerState<_RescheduleSheet> {
  List<ExpertAvailability> _availability = const [];
  List<String> _slots = const [];
  DateTime? _date;
  String? _time;
  bool _loadingSlots = false;

  @override
  void initState() {
    super.initState();
    _loadAvailability();
  }

  Future<void> _loadAvailability() async {
    try {
      final list = await ref
          .read(appointmentRepositoryProvider)
          .getAvailability(widget.expertId);
      if (mounted) setState(() => _availability = list);
    } catch (_) {
      // müsaitlik alınamadıysa slot üretilemez; boş kalır
    }
  }

  String _iso(DateTime d) =>
      '${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';

  Future<void> _pickDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: _date ?? now,
      firstDate: DateTime(now.year, now.month, now.day),
      lastDate: now.add(const Duration(days: 183)), // ~6 ay
    );
    if (picked == null) return;
    setState(() {
      _date = picked;
      _time = null;
      _slots = const [];
      _loadingSlots = true;
    });
    try {
      final booked = await ref
          .read(appointmentRepositoryProvider)
          .getBookedTimes(widget.expertId, _iso(picked),
              duration: widget.duration);
      final free = buildFreeSlots(
        availabilities: _availability,
        date: picked,
        bookedTimes: booked,
        duration: widget.duration,
      );
      if (mounted) setState(() => _slots = free);
    } catch (_) {
      if (mounted) setState(() => _slots = const []);
    } finally {
      if (mounted) setState(() => _loadingSlots = false);
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
            Text(t.appointments.rescheduleTitle, style: text.titleLarge),
            const SizedBox(height: 16),
            Text(t.booking.dateLabel,
                style: text.labelLarge?.copyWith(fontWeight: FontWeight.w600)),
            const SizedBox(height: 8),
            OutlinedButton.icon(
              onPressed: _pickDate,
              icon: const Icon(Icons.calendar_today_outlined, size: 18),
              label: Text(
                _date == null
                    ? t.booking.selectDate
                    : t.booking.dateValue(
                        day: _date!.day,
                        month: t.common.monthsShort[_date!.month - 1],
                        year: _date!.year,
                      ),
              ),
            ),
            const SizedBox(height: 16),
            Text(t.booking.timeLabel,
                style: text.labelLarge?.copyWith(fontWeight: FontWeight.w600)),
            const SizedBox(height: 8),
            if (_date == null)
              Text(t.booking.selectDateFirst,
                  style: text.bodySmall
                      ?.copyWith(color: context.colors.textSecondary))
            else if (_loadingSlots)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 8),
                child: LinearProgressIndicator(),
              )
            else if (_slots.isEmpty)
              Text(t.booking.noSlots,
                  style: text.bodySmall
                      ?.copyWith(color: context.colors.textSecondary))
            else
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  for (final s in _slots)
                    ChoiceChip(
                      label: Text(s),
                      selected: _time == s,
                      showCheckmark: false,
                      selectedColor:
                          context.colors.primary.withValues(alpha: 0.16),
                      onSelected: (_) => setState(() => _time = s),
                    ),
                ],
              ),
            const SizedBox(height: 20),
            FilledButton(
              onPressed: _date == null || _time == null
                  ? null
                  : () => Navigator.of(context)
                      .pop((dateIso: _iso(_date!), time: _time!)),
              child: Text(t.appointments.rescheduleConfirm),
            ),
          ],
        ),
      ),
    );
  }
}

class _StatusChip extends StatelessWidget {
  const _StatusChip({required this.kind});
  final AppointmentStatusKind kind;

  @override
  Widget build(BuildContext context) {
    final t = context.t;
    final (label, color) = switch (kind) {
      AppointmentStatusKind.pending => (
        t.appointments.statusPending,
        context.colors.warning,
      ),
      AppointmentStatusKind.confirmed => (
        t.appointments.statusConfirmed,
        context.colors.primary,
      ),
      AppointmentStatusKind.completed => (
        t.appointments.statusCompleted,
        context.colors.success,
      ),
      AppointmentStatusKind.cancelled => (
        t.appointments.statusCancelled,
        context.colors.error,
      ),
      AppointmentStatusKind.unknown => ('', context.colors.textTertiary),
    };
    if (label.isEmpty) return const SizedBox.shrink();
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(AppRadius.full),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: color,
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
