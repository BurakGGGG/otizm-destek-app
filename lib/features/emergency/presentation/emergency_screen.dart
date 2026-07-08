import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../core/haptics.dart';
import '../../../core/network/api_exception.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/empty_state.dart';
import '../../../core/widgets/skeleton.dart';
import '../../../i18n/strings.g.dart';
import '../../children/data/child_repository.dart';
import '../../children/domain/child.dart';
import '../data/emergency_repository.dart';
import '../domain/emergency_card.dart';

/// Acil Durum Kartı — çocuğun kritik bilgileri (`/api/emergency-card/{childId}`).
class EmergencyScreen extends ConsumerStatefulWidget {
  const EmergencyScreen({super.key});

  @override
  ConsumerState<EmergencyScreen> createState() => _EmergencyScreenState();
}

class _EmergencyScreenState extends ConsumerState<EmergencyScreen> {
  String? _selectedChildId;

  @override
  Widget build(BuildContext context) {
    final t = context.t;
    final childrenAsync = ref.watch(childrenProvider);

    return Scaffold(
      appBar: AppBar(title: Text(t.emergency.title)),
      body: SafeArea(
        child: childrenAsync.when(
          loading: () => const SkeletonList(count: 4),
          error: (e, _) =>
              ErrorRetry(onRetry: () => ref.invalidate(childrenProvider)),
          data: (children) {
            if (children.isEmpty) {
              return EmptyState(
                icon: Icons.child_care_outlined,
                message: t.emergency.noChild,
                actionLabel: t.children.add,
                actionIcon: Icons.child_care_outlined,
                onAction: () => context.push('/children'),
              );
            }
            final child =
                children.firstWhere((c) => c.id == _selectedChildId,
                    orElse: () => children.first);
            return Column(
              children: [
                if (children.length > 1)
                  _ChildSelector(
                    children: children,
                    selectedId: child.id,
                    onSelect: (id) => setState(() => _selectedChildId = id),
                  ),
                Expanded(child: _CardBody(child: child)),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _ChildSelector extends StatelessWidget {
  const _ChildSelector({
    required this.children,
    required this.selectedId,
    required this.onSelect,
  });

  final List<Child> children;
  final String selectedId;
  final ValueChanged<String> onSelect;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 56,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.margin, vertical: 8),
        itemCount: children.length,
        separatorBuilder: (_, _) => const SizedBox(width: 8),
        itemBuilder: (_, i) {
          final c = children[i];
          final sel = c.id == selectedId;
          return ChoiceChip(
            label: Text(c.name),
            selected: sel,
            onSelected: (_) => onSelect(c.id),
            showCheckmark: false,
            selectedColor: context.colors.primary,
            backgroundColor: context.colors.surface,
            side: BorderSide(color: context.colors.border),
            labelStyle: TextStyle(
              color: sel ? Colors.white : context.colors.textSecondary,
              fontWeight: FontWeight.w600,
              fontSize: 13,
            ),
          );
        },
      ),
    );
  }
}

class _CardBody extends ConsumerWidget {
  const _CardBody({required this.child});
  final Child child;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final async = ref.watch(emergencyCardProvider(child.id));
    return async.when(
      loading: () => const SkeletonList(count: 4),
      error: (e, _) => ErrorRetry(
          onRetry: () => ref.invalidate(emergencyCardProvider(child.id))),
      data: (card) {
        final birth = child.birthDate;
        final initial = card ??
            EmergencyCard.empty(
              childId: child.id,
              childName: child.name,
              birthDate: birth == null
                  ? ''
                  : '${birth.year}-${birth.month.toString().padLeft(2, '0')}'
                      '-${birth.day.toString().padLeft(2, '0')}',
            );
        return _EmergencyForm(
          key: ValueKey('${child.id}:${card?.updatedAt ?? ''}'),
          initial: initial,
          existed: card != null,
        );
      },
    );
  }
}

class _EmergencyForm extends ConsumerStatefulWidget {
  const _EmergencyForm({
    super.key,
    required this.initial,
    required this.existed,
  });

  final EmergencyCard initial;
  final bool existed;

  @override
  ConsumerState<_EmergencyForm> createState() => _EmergencyFormState();
}

class _EmergencyFormState extends ConsumerState<_EmergencyForm> {
  late final Map<String, TextEditingController> _c = {
    'childName': TextEditingController(text: widget.initial.childName),
    'birthDate': TextEditingController(text: widget.initial.birthDate),
    'diagnosisInfo': TextEditingController(text: widget.initial.diagnosisInfo),
    'languages': TextEditingController(text: widget.initial.languages),
    'contactName1': TextEditingController(text: widget.initial.contactName1),
    'contactPhone1': TextEditingController(text: widget.initial.contactPhone1),
    'contactRelation1':
        TextEditingController(text: widget.initial.contactRelation1),
    'contactName2': TextEditingController(text: widget.initial.contactName2),
    'contactPhone2': TextEditingController(text: widget.initial.contactPhone2),
    'contactRelation2':
        TextEditingController(text: widget.initial.contactRelation2),
    'doctorName': TextEditingController(text: widget.initial.doctorName),
    'doctorPhone': TextEditingController(text: widget.initial.doctorPhone),
    'hospital': TextEditingController(text: widget.initial.hospital),
    'medications': TextEditingController(text: widget.initial.medications),
    'allergies': TextEditingController(text: widget.initial.allergies),
    'medicalConditions':
        TextEditingController(text: widget.initial.medicalConditions),
    'triggersList': TextEditingController(text: widget.initial.triggersList),
    'calmingStrategies':
        TextEditingController(text: widget.initial.calmingStrategies),
    'avoidList': TextEditingController(text: widget.initial.avoidList),
    'specialInstructions':
        TextEditingController(text: widget.initial.specialInstructions),
  };

  late String _bloodType = widget.initial.bloodType;
  late String _communicationLevel = widget.initial.communicationLevel;
  late bool _selfInjury = widget.initial.selfInjury;
  late bool _wandering = widget.initial.wandering;
  late bool _nonVerbal = widget.initial.nonVerbal;
  bool _saving = false;

  @override
  void dispose() {
    for (final c in _c.values) {
      c.dispose();
    }
    super.dispose();
  }

  String _text(String key) => _c[key]!.text.trim();

  Future<void> _save() async {
    final t = context.t;
    setState(() => _saving = true);
    final card = EmergencyCard(
      childId: widget.initial.childId,
      updatedAt: DateTime.now().toIso8601String(),
      childName: _text('childName'),
      birthDate: _text('birthDate'),
      diagnosisInfo: _text('diagnosisInfo'),
      communicationLevel: _communicationLevel,
      languages: _text('languages'),
      bloodType: _bloodType,
      contactName1: _text('contactName1'),
      contactPhone1: _text('contactPhone1'),
      contactRelation1: _text('contactRelation1'),
      contactName2: _text('contactName2'),
      contactPhone2: _text('contactPhone2'),
      contactRelation2: _text('contactRelation2'),
      doctorName: _text('doctorName'),
      doctorPhone: _text('doctorPhone'),
      hospital: _text('hospital'),
      medications: _text('medications'),
      allergies: _text('allergies'),
      medicalConditions: _text('medicalConditions'),
      triggersList: _text('triggersList'),
      calmingStrategies: _text('calmingStrategies'),
      avoidList: _text('avoidList'),
      specialInstructions: _text('specialInstructions'),
      selfInjury: _selfInjury,
      wandering: _wandering,
      nonVerbal: _nonVerbal,
    );
    try {
      await ref.read(emergencyRepositoryProvider).save(card);
      ref.invalidate(emergencyCardProvider(card.childId));
      if (!mounted) return;
      Haptics.success();
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(t.emergency.saved)));
    } on ApiException catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.message)));
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final t = context.t;
    final colors = context.colors;
    return ListView(
      padding: const EdgeInsets.fromLTRB(
          AppSpacing.margin, 8, AppSpacing.margin, 32),
      children: [
        Text(
          t.emergency.subtitle,
          style: Theme.of(context)
              .textTheme
              .bodySmall
              ?.copyWith(color: colors.textTertiary),
        ),
        const SizedBox(height: 8),
        _StatusLine(existed: widget.existed, updatedAt: widget.initial.updatedAt),
        const SizedBox(height: 16),

        // Çocuk Bilgileri
        _Section(
          icon: Icons.person_outline,
          title: t.emergency.sectionChild,
          children: [
            _field(t.emergency.childName, 'childName'),
            _field(t.emergency.birthDate, 'birthDate'),
            _field(t.emergency.diagnosis, 'diagnosisInfo'),
            _dropdown(
              label: t.emergency.bloodType,
              value: _bloodType,
              options: kBloodTypes,
              display: (v) => v.isEmpty ? t.emergency.select : v,
              onChanged: (v) => setState(() => _bloodType = v),
            ),
            _dropdown(
              label: t.emergency.communicationLevel,
              value: _communicationLevel,
              options: const ['', ...kCommunicationLevels],
              display: (v) => v.isEmpty ? t.emergency.select : v,
              onChanged: (v) => setState(() => _communicationLevel = v),
            ),
            _field(t.emergency.languages, 'languages'),
            const SizedBox(height: 4),
            Text(t.emergency.warningsLabel,
                style: Theme.of(context).textTheme.labelLarge),
            const SizedBox(height: 4),
            _switch(t.emergency.selfInjury, _selfInjury,
                (v) => setState(() => _selfInjury = v)),
            _switch(t.emergency.wandering, _wandering,
                (v) => setState(() => _wandering = v)),
            _switch(t.emergency.nonVerbal, _nonVerbal,
                (v) => setState(() => _nonVerbal = v)),
          ],
        ),

        // Acil İletişim
        _Section(
          icon: Icons.phone_outlined,
          title: t.emergency.sectionContacts,
          children: [
            _ContactGroup(
              title: t.emergency.contact1,
              nameLabel: t.emergency.name,
              phoneLabel: t.emergency.phone,
              relationLabel: t.emergency.relation,
              nameController: _c['contactName1']!,
              phoneController: _c['contactPhone1']!,
              relationController: _c['contactRelation1']!,
            ),
            const SizedBox(height: 8),
            _ContactGroup(
              title: t.emergency.contact2,
              nameLabel: t.emergency.name,
              phoneLabel: t.emergency.phone,
              relationLabel: t.emergency.relation,
              nameController: _c['contactName2']!,
              phoneController: _c['contactPhone2']!,
              relationController: _c['contactRelation2']!,
            ),
            const SizedBox(height: 8),
            _ContactGroup(
              title: t.emergency.doctor,
              nameLabel: t.emergency.doctorName,
              phoneLabel: t.emergency.doctorPhone,
              extraLabel: t.emergency.hospital,
              nameController: _c['doctorName']!,
              phoneController: _c['doctorPhone']!,
              extraController: _c['hospital']!,
            ),
          ],
        ),

        // Tıbbi Bilgiler
        _Section(
          icon: Icons.favorite_outline,
          title: t.emergency.sectionMedical,
          children: [
            _field(t.emergency.medications, 'medications',
                hint: t.emergency.medicationsHint, multiline: true),
            _field(t.emergency.allergies, 'allergies',
                hint: t.emergency.allergiesHint, multiline: true),
            _field(t.emergency.conditions, 'medicalConditions',
                hint: t.emergency.conditionsHint, multiline: true),
          ],
        ),

        // Davranışsal Bilgiler
        _Section(
          icon: Icons.warning_amber_outlined,
          title: t.emergency.sectionBehavior,
          children: [
            _field(t.emergency.triggers, 'triggersList',
                hint: t.emergency.triggersHint, multiline: true),
            _field(t.emergency.calming, 'calmingStrategies',
                hint: t.emergency.calmingHint, multiline: true),
            _field(t.emergency.avoid, 'avoidList',
                hint: t.emergency.avoidHint, multiline: true),
            _field(t.emergency.special, 'specialInstructions',
                hint: t.emergency.specialHint, multiline: true),
          ],
        ),

        const SizedBox(height: 8),
        FilledButton.icon(
          onPressed: _saving ? null : _save,
          icon: _saving
              ? const SizedBox(
                  height: 18,
                  width: 18,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : const Icon(Icons.save_outlined),
          label: Text(t.emergency.save),
        ),
      ],
    );
  }

  Widget _field(String label, String key,
      {String? hint, bool multiline = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextField(
        controller: _c[key],
        minLines: multiline ? 2 : 1,
        maxLines: multiline ? 5 : 1,
        textCapitalization: TextCapitalization.sentences,
        decoration: InputDecoration(labelText: label, hintText: hint),
      ),
    );
  }

  Widget _dropdown({
    required String label,
    required String value,
    required List<String> options,
    required String Function(String) display,
    required ValueChanged<String> onChanged,
  }) {
    final safe = options.contains(value) ? value : options.first;
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: DropdownButtonFormField<String>(
        initialValue: safe,
        isExpanded: true,
        decoration: InputDecoration(labelText: label),
        items: [
          for (final o in options)
            DropdownMenuItem(
              value: o,
              child: Text(display(o),
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontSize: 14)),
            ),
        ],
        onChanged: (v) => onChanged(v ?? options.first),
      ),
    );
  }

  Widget _switch(String label, bool value, ValueChanged<bool> onChanged) {
    return SwitchListTile(
      contentPadding: EdgeInsets.zero,
      dense: true,
      title: Text(label, style: Theme.of(context).textTheme.bodyMedium),
      value: value,
      onChanged: (v) {
        Haptics.selection();
        onChanged(v);
      },
    );
  }
}

class _StatusLine extends StatelessWidget {
  const _StatusLine({required this.existed, required this.updatedAt});
  final bool existed;
  final String updatedAt;

  @override
  Widget build(BuildContext context) {
    final t = context.t;
    final colors = context.colors;
    final saved = existed && updatedAt.isNotEmpty;
    final date = DateTime.tryParse(updatedAt);
    final label = saved && date != null
        ? t.emergency.lastUpdated(
            date: '${date.day}.${date.month}.${date.year}')
        : t.emergency.notSaved;
    final color = saved ? colors.success : colors.warning;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(AppRadius.lg),
      ),
      child: Row(
        children: [
          Icon(saved ? Icons.check_circle_outline : Icons.info_outline,
              size: 18, color: color),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              label,
              style: TextStyle(
                  fontSize: 12, fontWeight: FontWeight.w600, color: color),
            ),
          ),
        ],
      ),
    );
  }
}

class _Section extends StatelessWidget {
  const _Section({
    required this.icon,
    required this.title,
    required this.children,
  });

  final IconData icon;
  final String title;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, size: 20, color: colors.primary),
                const SizedBox(width: 8),
                Text(title, style: Theme.of(context).textTheme.titleSmall),
              ],
            ),
            const SizedBox(height: 12),
            ...children,
          ],
        ),
      ),
    );
  }
}

/// İletişim grubu — telefon alanı yanında dokunmatik "Ara" düğmesi.
class _ContactGroup extends StatelessWidget {
  const _ContactGroup({
    required this.title,
    required this.nameLabel,
    required this.phoneLabel,
    required this.nameController,
    required this.phoneController,
    this.relationLabel,
    this.relationController,
    this.extraLabel,
    this.extraController,
  });

  final String title;
  final String nameLabel;
  final String phoneLabel;
  final TextEditingController nameController;
  final TextEditingController phoneController;
  final String? relationLabel;
  final TextEditingController? relationController;
  final String? extraLabel;
  final TextEditingController? extraController;

  Future<void> _call(BuildContext context) async {
    final raw = phoneController.text.trim();
    if (raw.isEmpty) return;
    final sanitized = raw.replaceAll(RegExp(r'[^0-9+]'), '');
    if (sanitized.isEmpty) return;
    Haptics.selection();
    final uri = Uri(scheme: 'tel', path: sanitized);
    if (!await launchUrl(uri) && context.mounted) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(context.t.errors.operationFailed)));
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: colors.surfaceVariant,
        borderRadius: BorderRadius.circular(AppRadius.lg),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: colors.primary,
            ),
          ),
          const SizedBox(height: 8),
          TextField(
            controller: nameController,
            textCapitalization: TextCapitalization.words,
            decoration: InputDecoration(labelText: nameLabel),
          ),
          const SizedBox(height: 12),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: TextField(
                  controller: phoneController,
                  keyboardType: TextInputType.phone,
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(
                        RegExp(r'[0-9+()\s-]')),
                  ],
                  decoration: InputDecoration(labelText: phoneLabel),
                ),
              ),
              const SizedBox(width: 8),
              IconButton.filledTonal(
                onPressed: () => _call(context),
                icon: const Icon(Icons.call, size: 20),
                tooltip: context.t.emergency.call,
              ),
            ],
          ),
          if (relationController != null) ...[
            const SizedBox(height: 12),
            TextField(
              controller: relationController,
              decoration: InputDecoration(labelText: relationLabel),
            ),
          ],
          if (extraController != null) ...[
            const SizedBox(height: 12),
            TextField(
              controller: extraController,
              decoration: InputDecoration(labelText: extraLabel),
            ),
          ],
        ],
      ),
    );
  }
}
