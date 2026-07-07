import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/haptics.dart';
import '../../../core/network/api_exception.dart';
import '../../../core/theme/app_theme.dart';
import '../../../i18n/strings.g.dart';
import '../data/routine_repository.dart';

/// Yeni rutin formu — `POST /routines`.
class RoutineFormScreen extends ConsumerStatefulWidget {
  const RoutineFormScreen({super.key, required this.childId});
  final String childId;

  @override
  ConsumerState<RoutineFormScreen> createState() => _RoutineFormScreenState();
}

class _RoutineFormScreenState extends ConsumerState<RoutineFormScreen> {
  final _name = TextEditingController();
  final _description = TextEditingController();
  bool _saving = false;
  String? _nameError;

  @override
  void dispose() {
    _name.dispose();
    _description.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    final t = context.t;
    if (_name.text.trim().isEmpty) {
      setState(() => _nameError = t.routineForm.errorName);
      return;
    }
    setState(() {
      _nameError = null;
      _saving = true;
    });
    try {
      await ref.read(routineRepositoryProvider).createRoutine(
            childId: widget.childId,
            name: _name.text,
            description: _description.text,
          );
      ref.invalidate(routinesProvider(widget.childId));
      if (!mounted) return;
      Haptics.success();
      Navigator.of(context).pop(t.routines.created);
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
    return Scaffold(
      appBar: AppBar(title: Text(t.routineForm.title)),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(AppSpacing.margin),
          children: [
            TextField(
              controller: _name,
              textCapitalization: TextCapitalization.sentences,
              decoration: InputDecoration(
                labelText: t.routineForm.nameLabel,
                hintText: t.routineForm.nameHint,
                errorText: _nameError,
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _description,
              minLines: 2,
              maxLines: 4,
              decoration: InputDecoration(
                labelText: t.routineForm.descriptionLabel,
                hintText: t.routineForm.descriptionHint,
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
                  : Text(t.routineForm.save),
            ),
          ],
        ),
      ),
    );
  }
}
