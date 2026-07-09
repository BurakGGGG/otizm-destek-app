import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/haptics.dart';
import '../../../core/network/api_exception.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/empty_state.dart';
import '../../../core/widgets/skeleton.dart';
import '../../../i18n/strings.g.dart';
import '../data/community_repository.dart';
import '../domain/community_meetup.dart';
import 'widgets/meetup_form_sheet.dart';

/// Yerel Buluşmalar — şehir bazlı aile buluşmaları. Filtrele, katıl, oluştur.
class MeetupsScreen extends ConsumerStatefulWidget {
  const MeetupsScreen({super.key});

  @override
  ConsumerState<MeetupsScreen> createState() => _MeetupsScreenState();
}

class _MeetupsScreenState extends ConsumerState<MeetupsScreen> {
  String _city = 'Tümü';

  /// İyimser katılım üst-katmanı: meetup id → (attendees, joined).
  final Map<String, ({int attendees, bool joined})> _override = {};

  Future<void> _create() async {
    final t = context.t;
    final saved = await showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      builder: (_) => const MeetupFormSheet(),
    );
    if (saved == true && mounted) {
      ref.invalidate(meetupsProvider);
      Haptics.success();
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(t.meetup.created)));
    }
  }

  Future<void> _toggleAttendance(CommunityMeetup m) async {
    final t = context.t;
    final current = _override[m.id] ?? (attendees: m.attendees, joined: m.joined);
    final optimistic = current.joined
        ? (attendees: current.attendees - 1, joined: false)
        : (attendees: current.attendees + 1, joined: true);
    setState(() => _override[m.id] = optimistic);
    Haptics.selection();
    try {
      final updated = await ref
          .read(communityRepositoryProvider)
          .toggleMeetupAttendance(m.id);
      if (!mounted) return;
      setState(() => _override[m.id] =
          (attendees: updated.attendees, joined: updated.joined));
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(updated.joined ? t.meetup.joinedMsg : t.meetup.leftMsg),
      ));
    } on ApiException catch (e) {
      if (!mounted) return;
      setState(() => _override[m.id] = current);
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.message)));
    }
  }

  @override
  Widget build(BuildContext context) {
    final t = context.t;
    final async = ref.watch(meetupsProvider(_city));

    return Scaffold(
      appBar: AppBar(title: Text(t.meetup.title)),
      body: SafeArea(
        child: Column(
          children: [
            _CityFilter(
              selected: _city,
              onSelect: (c) => setState(() => _city = c),
            ),
            Expanded(
              child: async.when(
                loading: () => const SkeletonList(count: 3),
                error: (e, _) => ErrorRetry(
                  onRetry: () => ref.invalidate(meetupsProvider(_city)),
                ),
                data: (meetups) {
                  if (meetups.isEmpty) {
                    return RefreshIndicator(
                      onRefresh: () async =>
                          ref.invalidate(meetupsProvider(_city)),
                      child: ListView(
                        children: [
                          SizedBox(
                            height: 340,
                            child: EmptyState(
                              icon: Icons.groups_outlined,
                              message: t.meetup.empty,
                              actionLabel: t.meetup.add,
                              actionIcon: Icons.add,
                              onAction: _create,
                            ),
                          ),
                        ],
                      ),
                    );
                  }
                  return RefreshIndicator(
                    onRefresh: () async =>
                        ref.invalidate(meetupsProvider(_city)),
                    child: ListView.separated(
                      padding: const EdgeInsets.fromLTRB(
                        AppSpacing.margin,
                        AppSpacing.md,
                        AppSpacing.margin,
                        96,
                      ),
                      itemCount: meetups.length,
                      separatorBuilder: (_, _) => const SizedBox(height: 12),
                      itemBuilder: (_, i) {
                        final m = meetups[i];
                        final ov = _override[m.id];
                        return _MeetupCard(
                          meetup: m,
                          attendees: ov?.attendees ?? m.attendees,
                          joined: ov?.joined ?? m.joined,
                          onToggle: () => _toggleAttendance(m),
                        );
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _create,
        icon: const Icon(Icons.add),
        label: Text(t.meetup.add),
      ),
    );
  }
}

class _CityFilter extends StatelessWidget {
  const _CityFilter({required this.selected, required this.onSelect});

  final String selected;
  final ValueChanged<String> onSelect;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 48,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.margin,
          vertical: 8,
        ),
        itemCount: kMeetupFilterCities.length,
        separatorBuilder: (_, _) => const SizedBox(width: 8),
        itemBuilder: (_, i) {
          final c = kMeetupFilterCities[i];
          final isSel = selected == c;
          return ChoiceChip(
            label: Text(c),
            selected: isSel,
            showCheckmark: false,
            selectedColor: context.colors.primary,
            backgroundColor: context.colors.surface,
            side: BorderSide(color: context.colors.border),
            labelStyle: TextStyle(
              color: isSel ? Colors.white : context.colors.textSecondary,
              fontWeight: FontWeight.w600,
              fontSize: 13,
            ),
            onSelected: (_) => onSelect(c),
          );
        },
      ),
    );
  }
}

class _MeetupCard extends StatelessWidget {
  const _MeetupCard({
    required this.meetup,
    required this.attendees,
    required this.joined,
    required this.onToggle,
  });

  final CommunityMeetup meetup;
  final int attendees;
  final bool joined;
  final VoidCallback onToggle;

  String _countdown(BuildContext context) {
    final t = context.t;
    final today = DateTime.now();
    final d0 = DateTime(today.year, today.month, today.day);
    final d1 = DateTime(meetup.date.year, meetup.date.month, meetup.date.day);
    final diff = d1.difference(d0).inDays;
    if (diff < 0) return t.meetup.past;
    if (diff == 0) return t.meetup.today;
    if (diff == 1) return t.meetup.tomorrow;
    return t.meetup.inDays(count: diff);
  }

  @override
  Widget build(BuildContext context) {
    final t = context.t;
    final text = Theme.of(context).textTheme;
    final dateLabel =
        '${meetup.date.day} ${t.common.monthsShort[meetup.date.month - 1]} ${meetup.date.year}';

    return Card(
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  meetup.emoji?.isNotEmpty == true ? meetup.emoji! : '📍',
                  style: const TextStyle(fontSize: 28),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(meetup.title, style: text.titleMedium),
                      if (meetup.organizer != null &&
                          meetup.organizer!.isNotEmpty)
                        Text(
                          t.meetup.organizerBy(name: meetup.organizer!),
                          style: text.labelSmall?.copyWith(
                            color: context.colors.textTertiary,
                          ),
                        ),
                    ],
                  ),
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: context.colors.success.withValues(alpha: 0.14),
                    borderRadius: BorderRadius.circular(AppRadius.full),
                  ),
                  child: Text(
                    _countdown(context),
                    style: text.labelSmall?.copyWith(
                      color: context.colors.success,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            _InfoRow(
              icon: Icons.place_outlined,
              text: meetup.location,
            ),
            const SizedBox(height: 4),
            _InfoRow(
              icon: Icons.calendar_today_outlined,
              text: meetup.time == null
                  ? dateLabel
                  : '$dateLabel · ${meetup.time}',
            ),
            if (meetup.venue != null && meetup.venue!.isNotEmpty) ...[
              const SizedBox(height: 4),
              _InfoRow(icon: Icons.location_city_outlined, text: meetup.venue!),
            ],
            if (meetup.description != null &&
                meetup.description!.isNotEmpty) ...[
              const SizedBox(height: 8),
              Text(
                meetup.description!,
                style: text.bodyMedium?.copyWith(
                  color: context.colors.textSecondary,
                ),
              ),
            ],
            const Divider(height: 20),
            Row(
              children: [
                Icon(
                  Icons.people_outline,
                  size: 18,
                  color: context.colors.textTertiary,
                ),
                const SizedBox(width: 6),
                Text(
                  t.meetup.attendCount(count: attendees),
                  style: text.labelMedium?.copyWith(
                    color: context.colors.textSecondary,
                  ),
                ),
                const Spacer(),
                joined
                    ? OutlinedButton.icon(
                        onPressed: onToggle,
                        icon: const Icon(Icons.check, size: 18),
                        label: Text(t.meetup.joined),
                      )
                    : FilledButton.icon(
                        onPressed: onToggle,
                        icon: const Icon(Icons.add, size: 18),
                        label: Text(t.meetup.join),
                      ),
              ],
            ),
          ],
        ),
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
    return Row(
      children: [
        Icon(icon, size: 15, color: context.colors.textTertiary),
        const SizedBox(width: 6),
        Expanded(
          child: Text(
            text,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: context.colors.textSecondary,
                ),
          ),
        ),
      ],
    );
  }
}
