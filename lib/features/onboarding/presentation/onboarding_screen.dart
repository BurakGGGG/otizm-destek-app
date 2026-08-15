import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/haptics.dart';
import '../../../core/network/api_exception.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_theme.dart';
import '../../../i18n/strings.g.dart';
import '../../auth/domain/app_user.dart';
import '../../auth/presentation/auth_controller.dart';
import '../../children/data/child_repository.dart';
import '../../children/domain/child.dart';
import '../../forum/data/forum_repository.dart';
import '../domain/onboarding_options.dart';

/// İlk giriş sihirbazı (web `/baslangic` karşılığı).
///
/// Veli akışı: tanışma → çocuk profili → destek alanları (semptom etiketleri)
/// → başlangıç planı. Uzman/yönetici rollerinde çocuk adımı yoktur, kısa bir
/// karşılama gösterilir. Tamamlanma sunucuya yazılır
/// (`POST /users/me/onboarding-complete`), böylece diğer cihazlarda tekrar
/// açılmaz.
class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  int _step = 0;
  bool _busy = false;
  bool _existingChecked = false;

  final _name = TextEditingController();
  final _diagnosis = TextEditingController();
  DateTime? _birthDate;
  String? _primaryFocus;
  String? _communicationLevel;
  String? _supportNeed;

  Child? _child;
  final Set<String> _selectedTagIds = {};

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _loadExistingChild());
  }

  @override
  void dispose() {
    _name.dispose();
    _diagnosis.dispose();
    super.dispose();
  }

  bool get _isParent =>
      ref.read(authControllerProvider).user?.role == UserRole.parent;

  /// Mükerrer kayıt olmasın: kullanıcının çocuğu zaten varsa profil adımı
  /// atlanır ve mevcut kayıtla devam edilir (web ile aynı davranış).
  Future<void> _loadExistingChild() async {
    if (!_isParent) {
      setState(() => _existingChecked = true);
      return;
    }
    try {
      final children = await ref.read(childRepositoryProvider).getChildren();
      if (!mounted) return;
      if (children.isNotEmpty) {
        final child = children.first;
        setState(() {
          _child = child;
          _name.text = child.name;
          _birthDate = child.birthDate;
          _diagnosis.text = child.diagnosisInfo ?? '';
          _selectedTagIds.addAll(child.tags.map((tag) => tag.id));
          if (_step < 2) _step = 2;
        });
      }
    } on ApiException catch (_) {
      // Ağ hatası sihirbazı engellemesin; kullanıcı profili elle doldurur.
    } finally {
      if (mounted) setState(() => _existingChecked = true);
    }
  }

  Future<void> _saveChild() async {
    final t = context.t;
    final name = _name.text.trim();
    if (name.isEmpty) return _showError(t.onboarding.errorNameRequired);
    if (_birthDate != null && _birthDate!.isAfter(DateTime.now())) {
      return _showError(t.onboarding.errorBirthDateFuture);
    }
    setState(() => _busy = true);
    // Web ile birebir: seçimler çocuk kaydının serbest metin alanlarına yazılır.
    final therapies = [_communicationLevel, _supportNeed]
        .whereType<String>()
        .where((value) => value.isNotEmpty)
        .join(' · ');
    final draft = Child(
      id: _child?.id ?? '',
      name: name,
      birthDate: _birthDate,
      diagnosisInfo: _diagnosis.text.trim(),
      educationProgram: _primaryFocus == null
          ? null
          : '$kOnboardingFocusPrefix$_primaryFocus',
      therapies: therapies.isEmpty ? null : therapies,
    );
    try {
      final repo = ref.read(childRepositoryProvider);
      final saved = _child == null
          ? await repo.createChild(draft)
          : await repo.updateChild(_child!.id, draft);
      if (!mounted) return;
      setState(() {
        _child = saved;
        _busy = false;
        _step = 2;
      });
    } on ApiException catch (e) {
      if (!mounted) return;
      setState(() => _busy = false);
      _showError(e.message);
    }
  }

  Future<void> _saveTags() async {
    final child = _child;
    if (child == null || _selectedTagIds.isEmpty) {
      setState(() => _step = 3);
      return;
    }
    setState(() => _busy = true);
    try {
      final saved = await ref
          .read(childRepositoryProvider)
          .updateTags(child, _selectedTagIds.toList());
      if (!mounted) return;
      setState(() {
        _child = saved;
        _busy = false;
        _step = 3;
      });
    } on ApiException catch (e) {
      if (!mounted) return;
      setState(() => _busy = false);
      _showError(e.message);
    }
  }

  Future<void> _finish([String? goTo]) async {
    if (_busy) return;
    setState(() => _busy = true);
    final error = await ref
        .read(authControllerProvider.notifier)
        .completeOnboarding();
    if (!mounted) return;
    setState(() => _busy = false);
    if (error != null) return _showError(error);
    ref.invalidate(childrenProvider);
    Haptics.success();
    context.go(goTo ?? '/home');
  }

  void _showError(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    final t = context.t;
    final user = ref.watch(authControllerProvider).user;
    final parent = user?.role == UserRole.parent;

    return Scaffold(
      appBar: AppBar(
        title: Text(t.onboarding.title),
        actions: [
          TextButton(
            onPressed: _busy ? null : () => _finish(),
            child: Text(t.onboarding.skip),
          ),
        ],
      ),
      body: SafeArea(
        child: !_existingChecked
            ? const Center(child: CircularProgressIndicator())
            : Column(
                children: [
                  if (parent) _StepIndicator(step: _step),
                  Expanded(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.all(AppSpacing.margin),
                      child: parent
                          ? _parentStep(context)
                          : _RoleWelcome(
                              user: user,
                              busy: _busy,
                              onStart: () => _finish(),
                            ),
                    ),
                  ),
                ],
              ),
      ),
    );
  }

  Widget _parentStep(BuildContext context) {
    return switch (_step) {
      0 => _IntroStep(
        busy: _busy,
        onNext: () => setState(() => _step = 1),
      ),
      1 => _ChildStep(
        name: _name,
        diagnosis: _diagnosis,
        birthDate: _birthDate,
        primaryFocus: _primaryFocus,
        communicationLevel: _communicationLevel,
        supportNeed: _supportNeed,
        busy: _busy,
        onBirthDate: (date) => setState(() => _birthDate = date),
        onFocus: (value) => setState(() => _primaryFocus = value),
        onCommunication: (value) => setState(() => _communicationLevel = value),
        onSupport: (value) => setState(() => _supportNeed = value),
        onNext: _saveChild,
      ),
      2 => _TagsStep(
        selected: _selectedTagIds,
        busy: _busy,
        onToggle: (id) => setState(() {
          if (!_selectedTagIds.add(id)) _selectedTagIds.remove(id);
        }),
        onBack: () => setState(() => _step = 1),
        onNext: _saveTags,
      ),
      _ => _PlanStep(
        busy: _busy,
        childName: _child?.name,
        onBack: () => setState(() => _step = 2),
        onFinish: _finish,
      ),
    };
  }
}

class _StepIndicator extends StatelessWidget {
  const _StepIndicator({required this.step});

  final int step;

  @override
  Widget build(BuildContext context) {
    final t = context.t;
    final colors = context.colors;
    final labels = [
      t.onboarding.stepChild,
      t.onboarding.stepTags,
      t.onboarding.stepPlan,
    ];
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.margin,
        AppSpacing.md,
        AppSpacing.margin,
        0,
      ),
      child: Row(
        children: [
          for (var i = 0; i < labels.length; i++) ...[
            if (i > 0) const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 4,
                    decoration: BoxDecoration(
                      color: step >= i + 1
                          ? colors.primary
                          : colors.surfaceVariant,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    labels[i],
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: step >= i + 1
                          ? colors.primary
                          : colors.textTertiary,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _IntroStep extends StatelessWidget {
  const _IntroStep({required this.busy, required this.onNext});

  final bool busy;
  final VoidCallback onNext;

  @override
  Widget build(BuildContext context) {
    final t = context.t;
    final colors = context.colors;
    final text = Theme.of(context).textTheme;
    final items = [
      (Icons.child_care_outlined, t.onboarding.introChildTitle,
          t.onboarding.introChildBody),
      (Icons.local_offer_outlined, t.onboarding.introTagsTitle,
          t.onboarding.introTagsBody),
      (Icons.auto_awesome_outlined, t.onboarding.introPlanTitle,
          t.onboarding.introPlanBody),
    ];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SizedBox(height: 12),
        Text(t.onboarding.welcomeTitle, style: text.headlineSmall),
        const SizedBox(height: 8),
        Text(t.onboarding.welcomeBody, style: text.bodyMedium),
        const SizedBox(height: 20),
        for (final (icon, title, body) in items) ...[
          Card(
            margin: const EdgeInsets.only(bottom: 12),
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: colors.primary.withValues(alpha: .12),
                child: Icon(icon, color: colors.primary),
              ),
              title: Text(title),
              subtitle: Text(body),
            ),
          ),
        ],
        const SizedBox(height: 8),
        FilledButton(
          onPressed: busy ? null : onNext,
          child: Text(t.onboarding.start),
        ),
      ],
    );
  }
}

class _ChildStep extends StatelessWidget {
  const _ChildStep({
    required this.name,
    required this.diagnosis,
    required this.birthDate,
    required this.primaryFocus,
    required this.communicationLevel,
    required this.supportNeed,
    required this.busy,
    required this.onBirthDate,
    required this.onFocus,
    required this.onCommunication,
    required this.onSupport,
    required this.onNext,
  });

  final TextEditingController name;
  final TextEditingController diagnosis;
  final DateTime? birthDate;
  final String? primaryFocus;
  final String? communicationLevel;
  final String? supportNeed;
  final bool busy;
  final ValueChanged<DateTime?> onBirthDate;
  final ValueChanged<String?> onFocus;
  final ValueChanged<String?> onCommunication;
  final ValueChanged<String?> onSupport;
  final VoidCallback onNext;

  @override
  Widget build(BuildContext context) {
    final t = context.t;
    final text = Theme.of(context).textTheme;
    final date = birthDate;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SizedBox(height: 12),
        Text(t.onboarding.childTitle, style: text.titleLarge),
        const SizedBox(height: 6),
        Text(t.onboarding.childSubtitle, style: text.bodySmall),
        const SizedBox(height: 20),
        TextField(
          controller: name,
          textCapitalization: TextCapitalization.words,
          decoration: InputDecoration(
            labelText: t.onboarding.childNameLabel,
            hintText: t.onboarding.childNameHint,
            prefixIcon: const Icon(Icons.badge_outlined),
          ),
        ),
        const SizedBox(height: 16),
        InkWell(
          onTap: () async {
            final now = DateTime.now();
            final picked = await showDatePicker(
              context: context,
              initialDate: date ?? DateTime(now.year - 5, now.month, now.day),
              firstDate: DateTime(now.year - 25),
              lastDate: now,
            );
            if (picked != null) onBirthDate(picked);
          },
          child: InputDecorator(
            decoration: InputDecoration(
              labelText: t.onboarding.childBirthDateLabel,
              prefixIcon: const Icon(Icons.cake_outlined),
            ),
            child: Text(
              date == null
                  ? t.onboarding.childBirthDateHint
                  : '${date.day.toString().padLeft(2, '0')}.'
                        '${date.month.toString().padLeft(2, '0')}.${date.year}',
            ),
          ),
        ),
        const SizedBox(height: 16),
        TextField(
          controller: diagnosis,
          maxLines: 2,
          decoration: InputDecoration(
            labelText: t.onboarding.childDiagnosisLabel,
            hintText: t.onboarding.childDiagnosisHint,
            prefixIcon: const Icon(Icons.medical_information_outlined),
          ),
        ),
        const SizedBox(height: 20),
        _ChoiceGroup(
          title: t.onboarding.focusTitle,
          options: kOnboardingFocusOptions,
          selected: primaryFocus,
          onSelected: onFocus,
        ),
        const SizedBox(height: 16),
        _ChoiceGroup(
          title: t.onboarding.communicationTitle,
          options: kOnboardingCommunicationOptions,
          selected: communicationLevel,
          onSelected: onCommunication,
        ),
        const SizedBox(height: 16),
        _ChoiceGroup(
          title: t.onboarding.supportTitle,
          options: kOnboardingSupportOptions,
          selected: supportNeed,
          onSelected: onSupport,
        ),
        const SizedBox(height: 24),
        FilledButton(
          onPressed: busy ? null : onNext,
          child: busy
              ? const SizedBox(
                  height: 22,
                  width: 22,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : Text(t.onboarding.continueButton),
        ),
      ],
    );
  }
}

/// Tek seçimli çip grubu. Seçenek metinleri backend'e yazılan veridir,
/// çevrilmez (web `FOCUS_OPTIONS` vb. birebir).
class _ChoiceGroup extends StatelessWidget {
  const _ChoiceGroup({
    required this.title,
    required this.options,
    required this.selected,
    required this.onSelected,
  });

  final String title;
  final List<String> options;
  final String? selected;
  final ValueChanged<String?> onSelected;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: Theme.of(context).textTheme.labelLarge),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            for (final option in options)
              ChoiceChip(
                label: Text(option),
                selected: selected == option,
                onSelected: (isSelected) =>
                    onSelected(isSelected ? option : null),
              ),
          ],
        ),
      ],
    );
  }
}

class _TagsStep extends ConsumerWidget {
  const _TagsStep({
    required this.selected,
    required this.busy,
    required this.onToggle,
    required this.onBack,
    required this.onNext,
  });

  final Set<String> selected;
  final bool busy;
  final ValueChanged<String> onToggle;
  final VoidCallback onBack;
  final VoidCallback onNext;

  String _categoryLabel(Translations t, String category) {
    return switch (category) {
      'ILETISIM' => t.forum.catCommunication,
      'SOSYAL' => t.forum.catSocial,
      'DUYUSAL' => t.forum.catSensory,
      'DAVRANIS' => t.forum.catBehavior,
      'MOTOR' => t.forum.catMotor,
      'EGITIM' => t.forum.catEducation,
      _ => category,
    };
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = context.t;
    final colors = context.colors;
    final text = Theme.of(context).textTheme;
    final tagsAsync = ref.watch(forumTagsProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SizedBox(height: 12),
        Text(t.onboarding.tagsTitle, style: text.titleLarge),
        const SizedBox(height: 6),
        Text(t.onboarding.tagsSubtitle, style: text.bodySmall),
        const SizedBox(height: 20),
        tagsAsync.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (_, _) => Text(
            t.childDetail.tagsError,
            style: text.bodySmall?.copyWith(color: colors.error),
          ),
          data: (grouped) => Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              for (final entry in grouped.entries) ...[
                Text(
                  _categoryLabel(t, entry.key),
                  style: text.labelSmall?.copyWith(
                    color: colors.textTertiary,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 6),
                Wrap(
                  spacing: 6,
                  runSpacing: 6,
                  children: [
                    for (final tag in entry.value)
                      FilterChip(
                        label: Text(tag.name),
                        visualDensity: VisualDensity.compact,
                        selected: selected.contains(tag.id),
                        onSelected: busy ? null : (_) => onToggle(tag.id),
                      ),
                  ],
                ),
                const SizedBox(height: 14),
              ],
            ],
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: OutlinedButton(
                onPressed: busy ? null : onBack,
                child: Text(t.onboarding.back),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: FilledButton(
                onPressed: busy ? null : onNext,
                child: busy
                    ? const SizedBox(
                        height: 22,
                        width: 22,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : Text(
                        selected.isEmpty
                            ? t.onboarding.skipForNow
                            : t.onboarding.continueButton,
                      ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _PlanStep extends StatelessWidget {
  const _PlanStep({
    required this.busy,
    required this.childName,
    required this.onBack,
    required this.onFinish,
  });

  final bool busy;
  final String? childName;
  final VoidCallback onBack;
  final void Function([String? goTo]) onFinish;

  @override
  Widget build(BuildContext context) {
    final t = context.t;
    final colors = context.colors;
    final text = Theme.of(context).textTheme;
    // Web'in son adımdaki kısayolları (rota karşılıkları mobil rotalar).
    final shortcuts = [
      (
        Icons.event_note_outlined,
        t.onboarding.planTrackerTitle,
        t.onboarding.planTrackerBody,
        '/daily-tracker',
      ),
      (
        Icons.people_alt_outlined,
        t.onboarding.planExpertsTitle,
        t.onboarding.planExpertsBody,
        '/home',
      ),
      (
        Icons.menu_book_outlined,
        t.onboarding.planKnowledgeTitle,
        t.onboarding.planKnowledgeBody,
        '/knowledge',
      ),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SizedBox(height: 12),
        Text(
          childName == null
              ? t.onboarding.planTitle
              : t.onboarding.planTitleNamed(name: childName!),
          style: text.titleLarge,
        ),
        const SizedBox(height: 6),
        Text(t.onboarding.planSubtitle, style: text.bodySmall),
        const SizedBox(height: 20),
        for (final (icon, title, body, route) in shortcuts)
          Card(
            margin: const EdgeInsets.only(bottom: 12),
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: colors.primary.withValues(alpha: .12),
                child: Icon(icon, color: colors.primary),
              ),
              title: Text(title),
              subtitle: Text(body),
              trailing: const Icon(Icons.chevron_right),
              onTap: busy ? null : () => onFinish(route),
            ),
          ),
        const SizedBox(height: 4),
        Text(
          t.onboarding.planNote,
          style: text.bodySmall?.copyWith(color: colors.textTertiary),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: OutlinedButton(
                onPressed: busy ? null : onBack,
                child: Text(t.onboarding.back),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: FilledButton(
                onPressed: busy ? null : () => onFinish(),
                child: busy
                    ? const SizedBox(
                        height: 22,
                        width: 22,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : Text(t.onboarding.finish),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

/// Veli olmayan roller için kısa karşılama (mobil veli odaklı olduğundan
/// web'deki uzman/yönetici başlangıç kartları özetlenir).
class _RoleWelcome extends StatelessWidget {
  const _RoleWelcome({
    required this.user,
    required this.busy,
    required this.onStart,
  });

  final AppUser? user;
  final bool busy;
  final VoidCallback onStart;

  @override
  Widget build(BuildContext context) {
    final t = context.t;
    final text = Theme.of(context).textTheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SizedBox(height: 24),
        Text(
          t.onboarding.expertTitle(name: user?.displayName ?? ''),
          style: text.headlineSmall,
        ),
        const SizedBox(height: 8),
        Text(t.onboarding.expertBody, style: text.bodyMedium),
        const SizedBox(height: 24),
        FilledButton(
          onPressed: busy ? null : onStart,
          child: Text(t.onboarding.finish),
        ),
      ],
    );
  }
}
