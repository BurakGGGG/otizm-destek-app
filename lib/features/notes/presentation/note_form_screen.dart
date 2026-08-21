import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/haptics.dart';
import '../../../core/network/api_exception.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/unsaved_changes_guard.dart';
import '../../../i18n/strings.g.dart';
import '../domain/development_note.dart';
import '../domain/note_categories.dart';
import '../data/note_repository.dart';

/// Gelişim notu formu — `POST /notes` (oluştur) ya da `PUT /notes/{id}`
/// (düzenle). Kategori ve ruh hâli değerleri web ile birebir paylaşılan
/// VERİdir ([kNoteCategories] / [kNoteMoods]); çevrilmez.
class NoteFormScreen extends ConsumerStatefulWidget {
  const NoteFormScreen({super.key, required this.childId, this.existing});
  final String childId;

  /// Doluysa düzenleme modu.
  final DevelopmentNote? existing;

  @override
  ConsumerState<NoteFormScreen> createState() => _NoteFormScreenState();
}

class _NoteFormScreenState extends ConsumerState<NoteFormScreen> {
  late final TextEditingController _title;
  late final TextEditingController _content;
  String? _category;
  String? _mood; // happy | neutral | sad — web ile birebir
  late DateTime _date;
  bool _saving = false;
  String? _titleError;
  late final String _initial;

  bool get _isEdit => widget.existing != null;

  @override
  void initState() {
    super.initState();
    final existing = widget.existing;
    _title = TextEditingController(text: existing?.title ?? '');
    _content = TextEditingController(text: existing?.content ?? '');
    _category = existing?.category;
    _mood = existing?.mood;
    _date = existing?.noteDate ?? DateTime.now();
    _initial = _snapshot();
  }

  @override
  void dispose() {
    _title.dispose();
    _content.dispose();
    super.dispose();
  }

  String _iso(DateTime d) =>
      '${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';

  Future<void> _pickDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: _date,
      firstDate: DateTime(now.year - 2),
      lastDate: now,
    );
    if (picked != null) setState(() => _date = picked);
  }

  Future<void> _save() async {
    final t = context.t;
    if (_title.text.trim().isEmpty) {
      setState(() => _titleError = t.noteForm.errorTitle);
      return;
    }
    setState(() {
      _titleError = null;
      _saving = true;
    });
    try {
      final repo = ref.read(noteRepositoryProvider);
      if (_isEdit) {
        await repo.updateNote(
          id: widget.existing!.id,
          childId: widget.childId,
          title: _title.text,
          content: _content.text,
          category: _category,
          mood: _mood,
          noteDateIso: _iso(_date),
        );
      } else {
        await repo.createNote(
          childId: widget.childId,
          title: _title.text,
          content: _content.text,
          category: _category,
          mood: _mood,
          noteDateIso: _iso(_date),
        );
      }
      ref.invalidate(recentNotesProvider(widget.childId));
      if (!mounted) return;
      Haptics.success();
      Navigator.of(context)
          .pop(_isEdit ? t.noteForm.updated : t.noteForm.created);
    } on ApiException catch (e) {
      if (!mounted) return;
      setState(() => _saving = false);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(e.message)));
    }
  }

  /// Form açıldığındaki hâlden farklı mı?
  /// (Onaysız çıkışta veri kaybını engellemek için.)
  bool get _isDirty => _snapshot() != _initial;

  String _snapshot() => [
        _title.text,
        _content.text,
        _category ?? '',
        _mood ?? '',
        _iso(_date),
      ].join('\u0000');

  @override
  Widget build(BuildContext context) {
    return UnsavedChangesGuard(
      hasChanges: () => _isDirty,
      child: _form(context),
    );
  }

  Widget _form(BuildContext context) {
    final t = context.t;
    final moods = <({String value, String emoji, String label})>[
      (value: 'happy', emoji: '😄', label: t.noteForm.moodHappy),
      (value: 'neutral', emoji: '😐', label: t.noteForm.moodNeutral),
      (value: 'sad', emoji: '😢', label: t.noteForm.moodSad),
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text(_isEdit ? t.noteForm.editTitle : t.noteForm.title),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(AppSpacing.margin),
          children: [
            TextField(
              controller: _title,
              textCapitalization: TextCapitalization.sentences,
              decoration: InputDecoration(
                labelText: t.noteForm.nameLabel,
                hintText: t.noteForm.nameHint,
                errorText: _titleError,
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _content,
              minLines: 3,
              maxLines: 6,
              decoration: InputDecoration(
                labelText: t.noteForm.contentLabel,
                hintText: t.noteForm.contentHint,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              t.noteForm.moodLabel,
              style: Theme.of(context).textTheme.labelLarge,
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              children: [
                for (final m in moods)
                  ChoiceChip(
                    label: Text('${m.emoji} ${m.label}'),
                    selected: _mood == m.value,
                    showCheckmark: false,
                    selectedColor: context.colors.primary.withValues(
                      alpha: 0.16,
                    ),
                    onSelected: (_) => setState(
                      () => _mood = _mood == m.value ? null : m.value,
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 20),
            Text(
              t.noteForm.categoryLabel,
              style: Theme.of(context).textTheme.labelLarge,
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                for (final c in kNoteCategories)
                  ChoiceChip(
                    label: Text(c),
                    selected: _category == c,
                    showCheckmark: false,
                    selectedColor: context.colors.primary.withValues(
                      alpha: 0.16,
                    ),
                    onSelected: (_) =>
                        setState(() => _category = _category == c ? null : c),
                  ),
              ],
            ),
            const SizedBox(height: 20),
            Text(
              t.noteForm.dateLabel,
              style: Theme.of(context).textTheme.labelLarge,
            ),
            const SizedBox(height: 8),
            OutlinedButton.icon(
              onPressed: _pickDate,
              icon: const Icon(Icons.calendar_today_outlined, size: 18),
              label: Text(
                '${_date.day} ${t.common.monthsShort[_date.month - 1]} ${_date.year}',
              ),
            ),
            const SizedBox(height: 28),
            FilledButton(
              onPressed: _saving ? null : _save,
              child: _saving
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : Text(t.noteForm.save),
            ),
          ],
        ),
      ),
    );
  }
}
