import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/network/api_exception.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../i18n/strings.g.dart';
import '../../data/wall_repository.dart';
import '../../domain/wall_post.dart';

/// Dertleşme paylaşımı oluşturma/düzenleme alt sayfası. `existing` verilirse
/// düzenleme modu (anonimlik değiştirilemez — backend güncellemede korunur).
class WallPostSheet extends ConsumerStatefulWidget {
  const WallPostSheet({super.key, this.existing});

  final WallPost? existing;

  @override
  ConsumerState<WallPostSheet> createState() => _WallPostSheetState();
}

class _WallPostSheetState extends ConsumerState<WallPostSheet> {
  late final TextEditingController _title =
      TextEditingController(text: widget.existing?.title ?? '');
  late final TextEditingController _content =
      TextEditingController(text: widget.existing?.content ?? '');
  late bool _anonymous = widget.existing?.anonymous ?? true;
  bool _saving = false;

  bool get _isEdit => widget.existing != null;

  @override
  void dispose() {
    _title.dispose();
    _content.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    final t = context.t;
    final content = _content.text.trim();
    if (content.isEmpty) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(t.wall.errorContent)));
      return;
    }
    // Backend başlık zorunlu tutar; boşsa web ile aynı varsayılan başlığı gönder.
    final title = _title.text.trim().isEmpty
        ? t.wall.addTitle
        : _title.text.trim();
    setState(() => _saving = true);
    try {
      final repo = ref.read(wallRepositoryProvider);
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
          anonymous: _anonymous,
        );
      }
      if (mounted) Navigator.of(context).pop(true);
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
              _isEdit ? t.wall.editTitle : t.wall.addTitle,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _title,
              textInputAction: TextInputAction.next,
              decoration: InputDecoration(
                labelText: t.wall.titleLabel,
                hintText: t.wall.titleHint,
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _content,
              autofocus: !_isEdit,
              minLines: 3,
              maxLines: 6,
              textCapitalization: TextCapitalization.sentences,
              decoration: InputDecoration(
                labelText: t.wall.contentLabel,
                hintText: t.wall.contentHint,
                alignLabelWithHint: true,
              ),
            ),
            if (!_isEdit) ...[
              const SizedBox(height: 4),
              SwitchListTile(
                contentPadding: EdgeInsets.zero,
                value: _anonymous,
                onChanged: (v) => setState(() => _anonymous = v),
                title: Text(t.wall.anonymous),
                secondary: Icon(
                  Icons.visibility_off_outlined,
                  color: context.colors.primary,
                ),
              ),
            ],
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                onPressed: _saving ? null : _save,
                icon: _saving
                    ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Icon(Icons.send_outlined, size: 18),
                label: Text(_isEdit ? t.wall.save : t.wall.post),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
