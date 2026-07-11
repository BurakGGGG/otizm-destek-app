import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/network/api_exception.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../i18n/strings.g.dart';
import '../../data/forum_repository.dart';
import '../../domain/forum_post.dart';
import '../forum_screen.dart';

/// Forum gönderisi oluşturma/düzenleme sayfası (web create modalı birebir):
/// tip seçici, başlık, içerik, semptom etiketleri (yalnızca oluşturma),
/// anonimlik ve gizlilik ayarları. Başarıda `true` döndürür.
class ForumPostSheet extends ConsumerStatefulWidget {
  const ForumPostSheet({super.key, this.initialType = 'DENEYIM', this.existing});

  final String initialType;

  /// Doluysa düzenleme modu — web gibi yalnızca başlık+içerik güncellenir.
  final ForumPost? existing;

  @override
  ConsumerState<ForumPostSheet> createState() => _ForumPostSheetState();
}

class _ForumPostSheetState extends ConsumerState<ForumPostSheet> {
  late final TextEditingController _title;
  late final TextEditingController _content;
  late String _type;
  final Set<String> _tagIds = {};
  bool _anonymous = false;

  /// Web `defaultPrivacy` birebir.
  final Map<String, bool> _privacy = {
    'showRealName': true,
    'showChildAge': true,
    'showSymptoms': true,
    'showDiagnosis': false,
    'allowMatching': true,
  };
  bool _saving = false;

  bool get _isEdit => widget.existing != null;

  @override
  void initState() {
    super.initState();
    _title = TextEditingController(text: widget.existing?.title ?? '');
    _content = TextEditingController(text: widget.existing?.content ?? '');
    _type = widget.existing?.postType ?? widget.initialType;
  }

  @override
  void dispose() {
    _title.dispose();
    _content.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    final title = _title.text.trim();
    final content = _content.text.trim();
    if (title.isEmpty || content.isEmpty) return;
    setState(() => _saving = true);
    try {
      final repo = ref.read(forumRepositoryProvider);
      if (_isEdit) {
        await repo.updatePost(
          widget.existing!.id,
          title: title,
          content: content,
        );
      } else {
        await repo.createPost(
          title: title,
          content: content,
          postType: _type,
          tagIds: _tagIds.toList(),
          anonymous: _anonymous,
          privacySettings: {
            ..._privacy,
            if (_anonymous) 'showRealName': false,
            if (_anonymous) 'showDiagnosis': false,
          },
        );
      }
      if (!mounted) return;
      Navigator.of(context).pop(true);
    } on ApiException catch (e) {
      if (!mounted) return;
      setState(() => _saving = false);
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.message)));
    }
  }

  @override
  Widget build(BuildContext context) {
    final t = context.t;
    final colors = context.colors;
    final text = Theme.of(context).textTheme;
    final tagsAsync = ref.watch(forumTagsProvider);

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
            Text(
              _isEdit ? t.forum.editPost : t.forum.newPost,
              style: text.titleMedium,
            ),
            const SizedBox(height: 12),
            if (!_isEdit) ...[
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    for (final type in kForumPostTypes) ...[
                      ChoiceChip(
                        label: Text(forumTypeLabel(t, type)),
                        selected: _type == type,
                        onSelected: _saving
                            ? null
                            : (_) => setState(() => _type = type),
                      ),
                      const SizedBox(width: 6),
                    ],
                  ],
                ),
              ),
              const SizedBox(height: 12),
            ],
            TextField(
              controller: _title,
              enabled: !_saving,
              decoration: InputDecoration(
                labelText: t.forum.titleLabel,
                hintText: _type == 'QUESTION'
                    ? t.forum.titleHintQuestion
                    : t.forum.titleHint,
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _content,
              enabled: !_saving,
              minLines: 4,
              maxLines: 8,
              decoration: InputDecoration(labelText: t.forum.contentLabel),
            ),
            if (!_isEdit) ...[
              const SizedBox(height: 12),
              Text(
                t.forum.tagsLabel,
                style:
                    text.labelMedium?.copyWith(color: colors.textSecondary),
              ),
              const SizedBox(height: 6),
              tagsAsync.when(
                loading: () => const LinearProgressIndicator(minHeight: 2),
                error: (e, _) => const SizedBox.shrink(),
                data: (grouped) => ConstrainedBox(
                  constraints: const BoxConstraints(maxHeight: 180),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        for (final entry in grouped.entries) ...[
                          Text(
                            forumTagCategoryLabel(t, entry.key),
                            style: text.labelSmall?.copyWith(
                              color: colors.textTertiary,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Wrap(
                            spacing: 6,
                            runSpacing: 6,
                            children: [
                              for (final tag in entry.value)
                                FilterChip(
                                  label: Text(tag.name),
                                  visualDensity: VisualDensity.compact,
                                  selected: _tagIds.contains(tag.id),
                                  onSelected: _saving
                                      ? null
                                      : (_) => setState(() {
                                            if (!_tagIds.add(tag.id)) {
                                              _tagIds.remove(tag.id);
                                            }
                                          }),
                                ),
                            ],
                          ),
                          const SizedBox(height: 8),
                        ],
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 4),
              SwitchListTile(
                value: _anonymous,
                onChanged:
                    _saving ? null : (v) => setState(() => _anonymous = v),
                contentPadding: EdgeInsets.zero,
                title: Text(t.forum.anonymousTitle, style: text.bodyMedium),
                subtitle:
                    Text(t.forum.anonymousBody, style: text.bodySmall),
              ),
              ExpansionTile(
                tilePadding: EdgeInsets.zero,
                title: Text(t.forum.privacyTitle, style: text.bodyMedium),
                children: [
                  for (final (key, label) in [
                    ('showRealName', t.forum.privacyRealName),
                    ('showChildAge', t.forum.privacyChildAge),
                    ('showSymptoms', t.forum.privacySymptoms),
                    ('showDiagnosis', t.forum.privacyDiagnosis),
                    ('allowMatching', t.forum.privacyMatching),
                  ])
                    CheckboxListTile(
                      value: _privacy[key],
                      dense: true,
                      contentPadding: EdgeInsets.zero,
                      controlAffinity: ListTileControlAffinity.leading,
                      onChanged: _saving
                          ? null
                          : (v) =>
                              setState(() => _privacy[key] = v ?? false),
                      title: Text(label, style: text.bodySmall),
                    ),
                ],
              ),
            ],
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                onPressed: _saving ? null : _save,
                icon: _saving
                    ? const SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Icon(Icons.send, size: 16),
                label: Text(_isEdit ? t.forum.save : t.forum.share),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
