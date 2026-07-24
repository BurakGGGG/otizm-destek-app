import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/haptics.dart';
import '../../../core/network/api_exception.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/empty_state.dart';
import '../../../core/widgets/skeleton.dart';
import '../../../i18n/strings.g.dart';
import '../../children/data/child_repository.dart';
import '../../children/domain/child.dart';
import '../data/note_repository.dart';
import '../domain/development_note.dart';
import '../domain/note_categories.dart';
import 'note_form_screen.dart';

/// Not ruh hâli kodunun emoji + i18n etiketi (web `moods` birebir kod seti).
({String emoji, String label})? noteMoodDisplay(Translations t, String? mood) {
  return switch (mood) {
    'happy' => (emoji: '😄', label: t.noteForm.moodHappy),
    'neutral' => (emoji: '😐', label: t.noteForm.moodNeutral),
    'sad' => (emoji: '😢', label: t.noteForm.moodSad),
    _ => null,
  };
}

/// Notlarım — çocuğun tüm gelişim notları (web NotesPage birebir): sayfalı
/// liste, arama, kategori/ruh hâli filtresi, oluştur/düzenle/sil.
class NotesScreen extends ConsumerStatefulWidget {
  const NotesScreen({super.key, this.initialChildId});

  final String? initialChildId;

  @override
  ConsumerState<NotesScreen> createState() => _NotesScreenState();
}

class _NotesScreenState extends ConsumerState<NotesScreen> {
  String? _selectedChildId;
  final TextEditingController _search = TextEditingController();
  String _appliedSearch = '';
  String? _filterCategory;
  String? _filterMood;

  List<DevelopmentNote> _notes = const [];
  int _page = 0;
  int _totalPages = 1;
  bool _loading = false;
  bool _loadingMore = false;
  bool _error = false;
  String? _loadedChildId;

  @override
  void dispose() {
    _search.dispose();
    super.dispose();
  }

  Future<void> _load(String childId) async {
    setState(() {
      _loading = true;
      _error = false;
      _loadedChildId = childId;
    });
    try {
      final result =
          await ref.read(noteRepositoryProvider).getNotes(childId);
      if (!mounted || _loadedChildId != childId) return;
      setState(() {
        _notes = result.notes;
        _page = 0;
        _totalPages = result.totalPages;
        _loading = false;
      });
    } on ApiException {
      if (!mounted || _loadedChildId != childId) return;
      setState(() {
        _loading = false;
        _error = true;
      });
    }
  }

  Future<void> _loadMore() async {
    final childId = _loadedChildId;
    if (childId == null || _loadingMore || _page >= _totalPages - 1) return;
    setState(() => _loadingMore = true);
    try {
      final result = await ref
          .read(noteRepositoryProvider)
          .getNotes(childId, page: _page + 1);
      if (!mounted || _loadedChildId != childId) return;
      setState(() {
        _notes = [..._notes, ...result.notes];
        _page += 1;
        _totalPages = result.totalPages;
        _loadingMore = false;
      });
    } on ApiException catch (e) {
      if (!mounted) return;
      setState(() => _loadingMore = false);
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.message)));
    }
  }

  List<DevelopmentNote> get _filtered {
    final q = _appliedSearch.toLowerCase();
    return _notes.where((note) {
      if (_filterCategory != null && note.category != _filterCategory) {
        return false;
      }
      if (_filterMood != null && note.mood != _filterMood) return false;
      if (q.isEmpty) return true;
      return note.title.toLowerCase().contains(q) ||
          (note.content ?? '').toLowerCase().contains(q);
    }).toList();
  }

  Future<void> _openForm({DevelopmentNote? existing}) async {
    final childId = _loadedChildId;
    if (childId == null) return;
    final result = await Navigator.of(context).push<String>(
      MaterialPageRoute(
        builder: (_) => NoteFormScreen(childId: childId, existing: existing),
      ),
    );
    if (!mounted) return;
    if (result != null) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(result)));
      await _load(childId);
    }
  }

  Future<void> _deleteNote(DevelopmentNote note) async {
    final t = context.t;
    final childId = _loadedChildId;
    if (childId == null) return;
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(t.notesPage.deleteTitle),
        content: Text(t.notesPage.deleteConfirm),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: Text(t.notesPage.cancel),
          ),
          FilledButton(
            style: FilledButton.styleFrom(
                backgroundColor: context.colors.error),
            onPressed: () => Navigator.of(ctx).pop(true),
            child: Text(t.notesPage.delete),
          ),
        ],
      ),
    );
    if (ok != true || !mounted) return;
    try {
      await ref.read(noteRepositoryProvider).deleteNote(note.id);
      if (!mounted) return;
      Haptics.warning();
      ref.invalidate(recentNotesProvider(childId));
      setState(() => _notes = _notes.where((n) => n.id != note.id).toList());
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(t.notesPage.deleted)));
    } on ApiException catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.message)));
    }
  }

  @override
  Widget build(BuildContext context) {
    final t = context.t;
    final childrenAsync = ref.watch(childrenProvider);

    return Scaffold(
      appBar: AppBar(title: Text(t.notesPage.title)),
      body: SafeArea(
        child: childrenAsync.when(
          loading: () => const SkeletonList(count: 4),
          error: (e, _) =>
              ErrorRetry(onRetry: () => ref.invalidate(childrenProvider)),
          data: (children) {
            if (children.isEmpty) {
              return EmptyState(
                icon: Icons.child_care_outlined,
                message: t.notesPage.noChildren,
              );
            }
            final selectedId = _resolveChild(children);
            if (_loadedChildId != selectedId) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                if (mounted && _loadedChildId != selectedId) {
                  _load(selectedId);
                }
              });
            }
            return Column(
              children: [
                if (children.length > 1)
                  _ChildSelector(
                    children: children,
                    selectedId: selectedId,
                    onSelect: (id) {
                      setState(() => _selectedChildId = id);
                      _load(id);
                    },
                  ),
                _Filters(
                  search: _search,
                  category: _filterCategory,
                  mood: _filterMood,
                  onSearch: (v) => setState(() => _appliedSearch = v.trim()),
                  onCategory: (c) => setState(() => _filterCategory = c),
                  onMood: (m) => setState(() => _filterMood = m),
                ),
                Expanded(child: _buildList()),
              ],
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _openForm(),
        icon: const Icon(Icons.add),
        label: Text(t.notesPage.add),
      ),
    );
  }

  String _resolveChild(List<Child> children) {
    final selected = _selectedChildId ?? widget.initialChildId;
    if (selected != null && children.any((c) => c.id == selected)) {
      return selected;
    }
    return children.first.id;
  }

  Widget _buildList() {
    final t = context.t;
    if (_loading) return const SkeletonList(count: 4);
    if (_error) {
      return ErrorRetry(
        onRetry: () {
          final id = _loadedChildId;
          if (id != null) _load(id);
        },
      );
    }
    final filtered = _filtered;
    if (filtered.isEmpty) {
      final filtering = _appliedSearch.isNotEmpty ||
          _filterCategory != null ||
          _filterMood != null;
      return EmptyState(
        icon: Icons.sticky_note_2_outlined,
        message: filtering ? t.notesPage.noResults : t.notesPage.empty,
        actionLabel: filtering ? null : t.notesPage.add,
        actionIcon: filtering ? null : Icons.add,
        onAction: filtering ? null : () => _openForm(),
      );
    }
    return RefreshIndicator(
      onRefresh: () async {
        final id = _loadedChildId;
        if (id != null) await _load(id);
      },
      child: ListView.separated(
        padding: const EdgeInsets.fromLTRB(
            AppSpacing.margin, AppSpacing.sm, AppSpacing.margin, 96),
        itemCount: filtered.length + (_page < _totalPages - 1 ? 1 : 0),
        separatorBuilder: (_, _) => const SizedBox(height: 10),
        itemBuilder: (_, i) {
          if (i == filtered.length) {
            return Center(
              child: _loadingMore
                  ? const Padding(
                      padding: EdgeInsets.all(12),
                      child: SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      ),
                    )
                  : TextButton(
                      onPressed: _loadMore,
                      child: Text(t.notesPage.loadMore),
                    ),
            );
          }
          final note = filtered[i];
          return _NoteCard(
            key: ValueKey(note.id),
            note: note,
            onEdit: () => _openForm(existing: note),
            onDelete: () => _deleteNote(note),
          );
        },
      ),
    );
  }
}

class _Filters extends StatelessWidget {
  const _Filters({
    required this.search,
    required this.category,
    required this.mood,
    required this.onSearch,
    required this.onCategory,
    required this.onMood,
  });

  final TextEditingController search;
  final String? category;
  final String? mood;
  final ValueChanged<String> onSearch;
  final ValueChanged<String?> onCategory;
  final ValueChanged<String?> onMood;

  @override
  Widget build(BuildContext context) {
    final t = context.t;
    return Padding(
      padding: const EdgeInsets.fromLTRB(
          AppSpacing.margin, AppSpacing.sm, AppSpacing.margin, 0),
      child: Column(
        children: [
          TextField(
            controller: search,
            textInputAction: TextInputAction.search,
            onChanged: onSearch,
            decoration: InputDecoration(
              hintText: t.notesPage.searchHint,
              prefixIcon: const Icon(Icons.search, size: 18),
              isDense: true,
              suffixIcon: search.text.isEmpty
                  ? null
                  : IconButton(
                      icon: const Icon(Icons.close, size: 16),
                      onPressed: () {
                        search.clear();
                        onSearch('');
                      },
                    ),
            ),
          ),
          const SizedBox(height: 8),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                for (final moodCode in kNoteMoods)
                  Padding(
                    padding: const EdgeInsets.only(right: 6),
                    child: Builder(builder: (context) {
                      final display = noteMoodDisplay(t, moodCode)!;
                      return FilterChip(
                        label: Text('${display.emoji} ${display.label}'),
                        visualDensity: VisualDensity.compact,
                        selected: mood == moodCode,
                        onSelected: (_) =>
                            onMood(mood == moodCode ? null : moodCode),
                      );
                    }),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 6),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                for (final c in kNoteCategories)
                  Padding(
                    padding: const EdgeInsets.only(right: 6),
                    child: FilterChip(
                      // Kategori değerleri web ile paylaşılan veri — çevrilmez.
                      label: Text(c),
                      visualDensity: VisualDensity.compact,
                      selected: category == c,
                      onSelected: (_) =>
                          onCategory(category == c ? null : c),
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

class _NoteCard extends StatelessWidget {
  const _NoteCard({
    super.key,
    required this.note,
    required this.onEdit,
    required this.onDelete,
  });

  final DevelopmentNote note;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final t = context.t;
    final colors = context.colors;
    final text = Theme.of(context).textTheme;
    final mood = noteMoodDisplay(t, note.mood);
    final date = note.noteDate ?? note.createdAt;

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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (mood != null) ...[
                Text(mood.emoji, style: const TextStyle(fontSize: 18)),
                const SizedBox(width: 8),
              ],
              Expanded(
                child: Text(note.title, style: text.titleSmall),
              ),
              PopupMenuButton<String>(
                icon: Icon(Icons.more_vert,
                    size: 18, color: colors.textTertiary),
                onSelected: (v) => v == 'edit' ? onEdit() : onDelete(),
                itemBuilder: (_) => [
                  PopupMenuItem(
                    value: 'edit',
                    child: Row(children: [
                      const Icon(Icons.edit_outlined, size: 18),
                      const SizedBox(width: 12),
                      Text(t.notesPage.edit),
                    ]),
                  ),
                  PopupMenuItem(
                    value: 'delete',
                    child: Row(children: [
                      Icon(Icons.delete_outline, size: 18, color: colors.error),
                      const SizedBox(width: 12),
                      Text(t.notesPage.delete,
                          style: TextStyle(color: colors.error)),
                    ]),
                  ),
                ],
              ),
            ],
          ),
          if (note.content case final content? when content.trim().isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Text(
                content,
                style: text.bodySmall?.copyWith(color: colors.textSecondary),
              ),
            ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 6,
            runSpacing: 4,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              if (note.category case final category?
                  when category.isNotEmpty)
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: colors.secondary.withValues(alpha: .10),
                    borderRadius: BorderRadius.circular(AppRadius.sm),
                  ),
                  child: Text(
                    category,
                    style: text.labelSmall?.copyWith(
                      color: colors.secondary,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              if (date != null)
                Text(
                  '${date.day.toString().padLeft(2, '0')}.${date.month.toString().padLeft(2, '0')}.${date.year}',
                  style: text.labelSmall?.copyWith(color: colors.textTertiary),
                ),
            ],
          ),
        ],
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
