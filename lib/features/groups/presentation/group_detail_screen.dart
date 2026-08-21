import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/haptics.dart';
import '../../../core/network/api_exception.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/util/external_link.dart';
import '../../../core/widgets/empty_state.dart';
import '../../../core/widgets/skeleton.dart';
import '../../../core/widgets/user_avatar.dart';
import '../../../i18n/strings.g.dart';
import '../../auth/presentation/auth_controller.dart';
import '../data/group_repository.dart';
import '../domain/group.dart';

/// Grup detayı — bilgi, üyeler ve buluşmalar (web `GroupDetailsModal`).
///
/// Üye listesi ve buluşmalar backend'de üyelere kısıtlı; üye değilken istek
/// atılmaz, kullanıcıya katılma çağrısı gösterilir. Buluşma planlamayı
/// yalnızca grubu kuran yapabilir (backend de aynı kuralı uyguluyor).
class GroupDetailScreen extends ConsumerWidget {
  const GroupDetailScreen({super.key, required this.group});

  final Group group;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = context.t;
    final text = Theme.of(context).textTheme;
    final colors = context.colors;
    final userId = ref.watch(authControllerProvider).user?.id;
    final isOwner =
        group.createdByUserId != null && group.createdByUserId == userId;

    return Scaffold(
      appBar: AppBar(title: Text(group.name)),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async {
            ref.invalidate(groupMembersProvider(group.id));
            ref.invalidate(groupMeetingsProvider(group.id));
          },
          child: ListView(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.margin,
              AppSpacing.md,
              AppSpacing.margin,
              AppSpacing.lg,
            ),
            children: [
              _Header(group: group),
              if (!group.isMember) ...[
                const SizedBox(height: 20),
                EmptyState(
                  icon: Icons.lock_outline,
                  message: t.groups.membersOnly,
                ),
              ] else ...[
                const SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: Text(t.groups.meetingsTitle,
                          style: text.titleSmall),
                    ),
                    if (isOwner)
                      TextButton.icon(
                        onPressed: () => _planMeeting(context, ref),
                        icon: const Icon(Icons.add, size: 18),
                        label: Text(t.groups.meetingAdd),
                      ),
                  ],
                ),
                const SizedBox(height: 8),
                _Meetings(group: group, isOwner: isOwner),
                const SizedBox(height: 20),
                Text(t.groups.membersTitle, style: text.titleSmall),
                const SizedBox(height: 8),
                _Members(groupId: group.id),
              ],
              const SizedBox(height: 12),
              Text(
                t.groups.detailHint,
                style: text.labelSmall?.copyWith(color: colors.textTertiary),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _planMeeting(BuildContext context, WidgetRef ref) async {
    final created = await showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      builder: (_) => _MeetingSheet(groupId: group.id),
    );
    if (created != true || !context.mounted) return;
    ref.invalidate(groupMeetingsProvider(group.id));
    Haptics.success();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(context.t.groups.meetingCreated)),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header({required this.group});

  final Group group;

  @override
  Widget build(BuildContext context) {
    final t = context.t;
    final text = Theme.of(context).textTheme;
    final colors = context.colors;

    return Card(
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                UserAvatar(
                  name: group.name,
                  imageUrl: group.avatarUrl,
                  radius: 24,
                  fallbackIcon: Icons.groups_outlined,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Flexible(
                            child: Text(group.name, style: text.titleMedium),
                          ),
                          if (group.verified) ...[
                            const SizedBox(width: 4),
                            Icon(Icons.verified,
                                size: 16, color: colors.primary),
                          ],
                        ],
                      ),
                      const SizedBox(height: 2),
                      Wrap(
                        spacing: 10,
                        children: [
                          if (group.category?.isNotEmpty == true)
                            Text(
                              group.category!,
                              style: text.labelSmall?.copyWith(
                                color: colors.primary,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          Text(
                            t.groups.memberCount(count: group.memberCount),
                            style: text.labelSmall
                                ?.copyWith(color: colors.textTertiary),
                          ),
                          if (group.expertCount > 0)
                            Text(
                              t.groups.expertCount(count: group.expertCount),
                              style: text.labelSmall
                                  ?.copyWith(color: colors.textTertiary),
                            ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            if (group.description?.isNotEmpty == true) ...[
              const SizedBox(height: 12),
              Text(
                group.description!,
                style: text.bodyMedium?.copyWith(color: colors.textSecondary),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _Meetings extends ConsumerWidget {
  const _Meetings({required this.group, required this.isOwner});

  final Group group;
  final bool isOwner;

  Future<void> _delete(
    BuildContext context,
    WidgetRef ref,
    GroupMeeting meeting,
  ) async {
    final t = context.t;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(t.groups.meetingDelete),
        content: Text(t.groups.meetingDeleteConfirm(title: meeting.title)),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: Text(t.common.cancel),
          ),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: AppColors.error),
            onPressed: () => Navigator.of(ctx).pop(true),
            child: Text(t.groups.meetingDelete),
          ),
        ],
      ),
    );
    if (confirmed != true || !context.mounted) return;
    final messenger = ScaffoldMessenger.of(context);
    try {
      await ref
          .read(groupRepositoryProvider)
          .deleteMeeting(group.id, meeting.id);
      ref.invalidate(groupMeetingsProvider(group.id));
      Haptics.warning();
    } on ApiException catch (e) {
      messenger.showSnackBar(SnackBar(content: Text(e.message)));
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = context.t;
    final async = ref.watch(groupMeetingsProvider(group.id));

    return async.when(
      loading: () => const SkeletonList(count: 2),
      // Üyelik/yetki hatasında bölüm sessizce boş görünür (web de öyle).
      error: (e, _) => EmptyState(
        icon: Icons.event_busy_outlined,
        message: t.groups.meetingsEmpty,
      ),
      data: (meetings) {
        if (meetings.isEmpty) {
          return EmptyState(
            icon: Icons.event_busy_outlined,
            message: t.groups.meetingsEmpty,
          );
        }
        return Column(
          children: [
            for (final meeting in meetings)
              _MeetingCard(
                meeting: meeting,
                onDelete: isOwner ? () => _delete(context, ref, meeting) : null,
              ),
          ],
        );
      },
    );
  }
}

class _MeetingCard extends StatelessWidget {
  const _MeetingCard({required this.meeting, this.onDelete});

  final GroupMeeting meeting;
  final VoidCallback? onDelete;

  @override
  Widget build(BuildContext context) {
    final t = context.t;
    final text = Theme.of(context).textTheme;
    final colors = context.colors;
    final start = meeting.startTime;
    final stamp = '${start.day.toString().padLeft(2, '0')}.'
        '${start.month.toString().padLeft(2, '0')}.${start.year} · '
        '${start.hour.toString().padLeft(2, '0')}:'
        '${start.minute.toString().padLeft(2, '0')}';

    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(child: Text(meeting.title, style: text.titleSmall)),
                if (onDelete != null)
                  IconButton(
                    tooltip: t.groups.meetingDelete,
                    visualDensity: VisualDensity.compact,
                    onPressed: onDelete,
                    icon: Icon(Icons.close, size: 18, color: colors.error),
                  ),
              ],
            ),
            Text(
              stamp,
              style: text.labelSmall?.copyWith(color: colors.primary),
            ),
            if (meeting.description?.isNotEmpty == true) ...[
              const SizedBox(height: 6),
              Text(meeting.description!, style: text.bodySmall),
            ],
            if (isSafeExternalLink(meeting.meetingUrl)) ...[
              const SizedBox(height: 8),
              OutlinedButton.icon(
                style: AppButtonStyles.inlineOutlined,
                onPressed: () => openExternalLink(meeting.meetingUrl),
                icon: const Icon(Icons.videocam_outlined, size: 18),
                label: Text(t.groups.meetingJoin),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _Members extends ConsumerWidget {
  const _Members({required this.groupId});

  final String groupId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = context.t;
    final text = Theme.of(context).textTheme;
    final colors = context.colors;
    final async = ref.watch(groupMembersProvider(groupId));

    return async.when(
      loading: () => const SkeletonList(count: 3),
      error: (e, _) => EmptyState(
        icon: Icons.person_off_outlined,
        message: t.groups.membersEmpty,
      ),
      data: (members) {
        if (members.isEmpty) {
          return EmptyState(
            icon: Icons.person_off_outlined,
            message: t.groups.membersEmpty,
          );
        }
        return Column(
          children: [
            for (final member in members)
              Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Row(
                  children: [
                    UserAvatar(
                      name: member.fullName,
                      imageUrl: member.profileImageUrl,
                      radius: 18,
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(member.fullName, style: text.bodyMedium),
                          if (member.expertTitle?.isNotEmpty == true ||
                              member.city?.isNotEmpty == true)
                            Text(
                              [
                                if (member.expertTitle?.isNotEmpty == true)
                                  member.expertTitle!,
                                if (member.city?.isNotEmpty == true)
                                  member.city!,
                              ].join(' · '),
                              style: text.labelSmall
                                  ?.copyWith(color: colors.textTertiary),
                            ),
                        ],
                      ),
                    ),
                    if (member.isExpert)
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 3,
                        ),
                        decoration: BoxDecoration(
                          color: colors.primaryContainer,
                          borderRadius: BorderRadius.circular(AppRadius.full),
                        ),
                        child: Text(
                          t.roles.expert,
                          style: text.labelSmall?.copyWith(
                            color: colors.primary,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
          ],
        );
      },
    );
  }
}

/// Buluşma planlama formu (başlık + tarih/saat zorunlu).
class _MeetingSheet extends ConsumerStatefulWidget {
  const _MeetingSheet({required this.groupId});

  final String groupId;

  @override
  ConsumerState<_MeetingSheet> createState() => _MeetingSheetState();
}

class _MeetingSheetState extends ConsumerState<_MeetingSheet> {
  final _title = TextEditingController();
  final _description = TextEditingController();
  final _url = TextEditingController();
  DateTime? _date;
  TimeOfDay? _time;
  bool _saving = false;
  String? _error;

  @override
  void dispose() {
    _title.dispose();
    _description.dispose();
    _url.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: _date ?? now,
      firstDate: now,
      lastDate: DateTime(now.year + 2),
    );
    if (picked != null) setState(() => _date = picked);
  }

  Future<void> _pickTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: _time ?? const TimeOfDay(hour: 20, minute: 0),
    );
    if (picked != null) setState(() => _time = picked);
  }

  Future<void> _save() async {
    final t = context.t;
    if (_title.text.trim().isEmpty) {
      setState(() => _error = t.groups.meetingErrorTitle);
      return;
    }
    if (_date == null || _time == null) {
      setState(() => _error = t.groups.meetingErrorDate);
      return;
    }
    final url = _url.text.trim();
    if (url.isNotEmpty && !isSafeExternalLink(url)) {
      setState(() => _error = t.groups.meetingErrorUrl);
      return;
    }
    setState(() {
      _error = null;
      _saving = true;
    });
    final navigator = Navigator.of(context);
    final messenger = ScaffoldMessenger.of(context);
    try {
      await ref.read(groupRepositoryProvider).createMeeting(
            widget.groupId,
            title: _title.text,
            startTime: DateTime(
              _date!.year,
              _date!.month,
              _date!.day,
              _time!.hour,
              _time!.minute,
            ),
            description: _description.text,
            meetingUrl: url,
          );
      navigator.pop(true);
    } on ApiException catch (e) {
      if (!mounted) return;
      setState(() => _saving = false);
      messenger.showSnackBar(SnackBar(content: Text(e.message)));
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
        top: AppSpacing.md,
        bottom: MediaQuery.viewInsetsOf(context).bottom + AppSpacing.md,
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(t.groups.meetingAdd, style: text.titleMedium),
            const SizedBox(height: 12),
            TextField(
              controller: _title,
              textCapitalization: TextCapitalization.sentences,
              decoration:
                  InputDecoration(labelText: t.groups.meetingTitleLabel),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    style: AppButtonStyles.inlineOutlined,
                    onPressed: _pickDate,
                    icon: const Icon(Icons.event_outlined, size: 18),
                    label: Text(
                      _date == null
                          ? t.groups.meetingPickDate
                          : '${_date!.day.toString().padLeft(2, '0')}.'
                              '${_date!.month.toString().padLeft(2, '0')}.'
                              '${_date!.year}',
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: OutlinedButton.icon(
                    style: AppButtonStyles.inlineOutlined,
                    onPressed: _pickTime,
                    icon: const Icon(Icons.schedule_outlined, size: 18),
                    label: Text(
                      _time == null
                          ? t.groups.meetingPickTime
                          : '${_time!.hour.toString().padLeft(2, '0')}:'
                              '${_time!.minute.toString().padLeft(2, '0')}',
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _url,
              keyboardType: TextInputType.url,
              decoration: InputDecoration(
                labelText: t.groups.meetingUrlLabel,
                hintText: 'https://',
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _description,
              minLines: 2,
              maxLines: 4,
              textCapitalization: TextCapitalization.sentences,
              decoration:
                  InputDecoration(labelText: t.groups.meetingNoteLabel),
            ),
            if (_error != null) ...[
              const SizedBox(height: 8),
              Text(
                _error!,
                style: text.labelSmall?.copyWith(color: context.colors.error),
              ),
            ],
            const SizedBox(height: 16),
            FilledButton.icon(
              onPressed: _saving ? null : _save,
              icon: _saving
                  ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                      ),
                    )
                  : const Icon(Icons.check, size: 18),
              label: Text(t.groups.meetingSave),
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }
}
