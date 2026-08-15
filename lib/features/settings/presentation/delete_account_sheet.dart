import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/network/api_exception.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_theme.dart';
import '../../../i18n/strings.g.dart';
import '../../auth/presentation/auth_controller.dart';
import '../data/settings_repository.dart';

/// Hesap silme — `DELETE /users/me` (gövdede mevcut şifre).
///
/// Geri alınamaz olduğu için hem şifre hem de onay metni istenir; başarıdan
/// sonra oturum kapatılır.
class DeleteAccountSheet extends ConsumerStatefulWidget {
  const DeleteAccountSheet({super.key});

  @override
  ConsumerState<DeleteAccountSheet> createState() => _DeleteAccountSheetState();
}

class _DeleteAccountSheetState extends ConsumerState<DeleteAccountSheet> {
  final _password = TextEditingController();
  final _confirm = TextEditingController();
  bool _busy = false;
  String? _error;

  /// Onay için yazılması gereken kelime — veri değil, kullanıcı arayüzü metni.
  String _confirmWord(BuildContext context) => context.t.settings.deleteKeyword;

  @override
  void dispose() {
    _password.dispose();
    _confirm.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final t = context.t;
    if (_password.text.isEmpty) {
      setState(() => _error = t.settings.errorCurrentPasswordRequired);
      return;
    }
    if (_confirm.text.trim().toUpperCase() !=
        _confirmWord(context).toUpperCase()) {
      setState(() => _error = t.settings.errorDeleteConfirm);
      return;
    }
    setState(() {
      _error = null;
      _busy = true;
    });
    try {
      await ref
          .read(settingsRepositoryProvider)
          .deleteAccount(_password.text);
      if (!mounted) return;
      Navigator.of(context).pop();
      await ref.read(authControllerProvider.notifier).signOut();
    } on ApiException catch (e) {
      if (mounted) {
        setState(() {
          _error = e.message;
          _busy = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final t = context.t;
    final colors = context.colors;
    final text = Theme.of(context).textTheme;

    return Padding(
      padding: EdgeInsets.only(
        left: AppSpacing.margin,
        right: AppSpacing.margin,
        top: AppSpacing.lg,
        bottom: MediaQuery.viewInsetsOf(context).bottom + AppSpacing.lg,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Icon(Icons.warning_amber_outlined, color: colors.error),
              const SizedBox(width: 10),
              Expanded(
                child: Text(t.settings.deleteAccount, style: text.titleMedium),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(t.settings.deleteAccountWarning, style: text.bodySmall),
          const SizedBox(height: 16),
          TextField(
            controller: _password,
            obscureText: true,
            decoration: InputDecoration(
              labelText: t.settings.currentPasswordLabel,
              prefixIcon: const Icon(Icons.lock_outline),
            ),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _confirm,
            textCapitalization: TextCapitalization.characters,
            decoration: InputDecoration(
              labelText: t.settings.deleteConfirmLabel(
                keyword: _confirmWord(context),
              ),
              prefixIcon: const Icon(Icons.edit_outlined),
              errorText: _error,
              errorMaxLines: 3,
            ),
          ),
          const SizedBox(height: 20),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: colors.error),
            onPressed: _busy ? null : _submit,
            child: _busy
                ? const SizedBox(
                    height: 22,
                    width: 22,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : Text(t.settings.deleteAccountSubmit),
          ),
          const SizedBox(height: 8),
          TextButton(
            onPressed: _busy ? null : () => Navigator.of(context).pop(),
            child: Text(t.common.cancel),
          ),
        ],
      ),
    );
  }
}
