import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/haptics.dart';
import '../../../core/network/api_exception.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_theme.dart';
import '../../../i18n/strings.g.dart';
import '../data/auth_repository.dart';

/// E-posta doğrulama ekranı (web `/eposta-dogrula` karşılığı).
///
/// Kayıt sonrası backend `pendingEmailVerification` döndüğünde buraya
/// yönlendirilir. E-postadaki bağlantı web'i açar; uygulamadan çıkmak
/// istemeyen kullanıcı bağlantıdaki kodu buraya yapıştırıp doğrulayabilir.
/// Uzman kaydında ayrıca yönetici onayı beklendiği bilgisi gösterilir.
class VerifyEmailScreen extends ConsumerStatefulWidget {
  const VerifyEmailScreen({
    super.key,
    this.email,
    this.token,
    this.pendingApproval = false,
  });

  final String? email;

  /// Deep-link / sorgu parametresiyle gelen doğrulama kodu (varsa otomatik
  /// doğrulanır).
  final String? token;

  /// Uzman kaydı: e-posta doğrulansa da yönetici onayı gerekiyor.
  final bool pendingApproval;

  @override
  ConsumerState<VerifyEmailScreen> createState() => _VerifyEmailScreenState();
}

enum _Status { waiting, verifying, verified }

class _VerifyEmailScreenState extends ConsumerState<VerifyEmailScreen> {
  late final TextEditingController _token;
  _Status _status = _Status.waiting;
  bool _resending = false;
  String? _error;
  String? _info;

  @override
  void initState() {
    super.initState();
    _token = TextEditingController(text: widget.token ?? '');
    if ((widget.token ?? '').trim().isNotEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) => _verify());
    }
  }

  @override
  void dispose() {
    _token.dispose();
    super.dispose();
  }

  Future<void> _verify() async {
    final t = context.t;
    final token = _token.text.trim();
    if (token.isEmpty) {
      setState(() => _error = t.verifyEmail.errorTokenRequired);
      return;
    }
    setState(() {
      _error = null;
      _info = null;
      _status = _Status.verifying;
    });
    try {
      await ref.read(authRepositoryProvider).verifyEmail(token);
      if (!mounted) return;
      Haptics.success();
      setState(() {
        _status = _Status.verified;
        _info = t.verifyEmail.success;
      });
    } on ApiException catch (e) {
      if (!mounted) return;
      setState(() {
        _status = _Status.waiting;
        _error = e.message;
      });
    }
  }

  Future<void> _resend() async {
    final t = context.t;
    final email = widget.email?.trim() ?? '';
    if (email.isEmpty) {
      setState(() => _error = t.verifyEmail.errorEmailRequired);
      return;
    }
    setState(() {
      _resending = true;
      _error = null;
      _info = null;
    });
    try {
      await ref.read(authRepositoryProvider).resendVerification(email);
      if (!mounted) return;
      setState(() => _info = t.verifyEmail.resent);
    } on ApiException catch (e) {
      if (mounted) setState(() => _error = e.message);
    } finally {
      if (mounted) setState(() => _resending = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final t = context.t;
    final colors = context.colors;
    final text = Theme.of(context).textTheme;
    final email = widget.email?.trim() ?? '';
    final verified = _status == _Status.verified;

    return Scaffold(
      appBar: AppBar(title: Text(t.verifyEmail.title)),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(AppSpacing.margin),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 420),
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(AppSpacing.lg),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CircleAvatar(
                        radius: 28,
                        backgroundColor: (verified ? colors.success : colors.primary)
                            .withValues(alpha: .12),
                        child: Icon(
                          verified
                              ? Icons.mark_email_read_outlined
                              : Icons.mail_outline,
                          color: verified ? colors.success : colors.primary,
                          size: 28,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        verified
                            ? t.verifyEmail.success
                            : t.verifyEmail.waitingTitle,
                        textAlign: TextAlign.center,
                        style: text.titleMedium,
                      ),
                      if (!verified) ...[
                        const SizedBox(height: 8),
                        Text(
                          email.isEmpty
                              ? t.verifyEmail.waitingBody
                              : t.verifyEmail.waitingBodyWithEmail(email: email),
                          textAlign: TextAlign.center,
                          style: text.bodySmall,
                        ),
                        const SizedBox(height: 6),
                        Text(
                          t.verifyEmail.spamHint,
                          textAlign: TextAlign.center,
                          style: text.bodySmall?.copyWith(
                            color: colors.textTertiary,
                          ),
                        ),
                      ],
                      if (widget.pendingApproval) ...[
                        const SizedBox(height: 16),
                        _Notice(
                          icon: Icons.verified_user_outlined,
                          title: t.verifyEmail.approvalTitle,
                          body: t.verifyEmail.approvalBody,
                        ),
                      ],
                      if (_info case final info?) ...[
                        const SizedBox(height: 12),
                        Text(
                          info,
                          textAlign: TextAlign.center,
                          style: text.bodySmall?.copyWith(color: colors.success),
                        ),
                      ],
                      if (_error case final error?) ...[
                        const SizedBox(height: 12),
                        Text(
                          error,
                          textAlign: TextAlign.center,
                          style: text.bodySmall?.copyWith(color: colors.error),
                        ),
                      ],
                      if (!verified) ...[
                        const SizedBox(height: 20),
                        TextField(
                          controller: _token,
                          textInputAction: TextInputAction.done,
                          onSubmitted: (_) {
                            if (_status != _Status.verifying) _verify();
                          },
                          decoration: InputDecoration(
                            labelText: t.verifyEmail.tokenLabel,
                            hintText: t.verifyEmail.tokenHint,
                            helperText: t.verifyEmail.tokenHelp,
                            helperMaxLines: 2,
                            prefixIcon: const Icon(Icons.vpn_key_outlined),
                          ),
                        ),
                        const SizedBox(height: 16),
                        FilledButton(
                          onPressed: _status == _Status.verifying ? null : _verify,
                          child: _status == _Status.verifying
                              ? const SizedBox(
                                  height: 22,
                                  width: 22,
                                  child: CircularProgressIndicator(strokeWidth: 2),
                                )
                              : Text(t.verifyEmail.verifyButton),
                        ),
                        const SizedBox(height: 8),
                        OutlinedButton.icon(
                          onPressed: _resending ? null : _resend,
                          icon: _resending
                              ? const SizedBox(
                                  height: 16,
                                  width: 16,
                                  child: CircularProgressIndicator(strokeWidth: 2),
                                )
                              : const Icon(Icons.refresh),
                          label: Text(t.verifyEmail.resendButton),
                        ),
                      ],
                      const SizedBox(height: 8),
                      TextButton(
                        onPressed: () => context.go('/login'),
                        child: Text(t.verifyEmail.backToLogin),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _Notice extends StatelessWidget {
  const _Notice({required this.icon, required this.title, required this.body});

  final IconData icon;
  final String title;
  final String body;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final text = Theme.of(context).textTheme;
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: colors.warning.withValues(alpha: .10),
        borderRadius: BorderRadius.circular(AppRadius.md),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: colors.warning, size: 20),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: text.labelLarge?.copyWith(fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 2),
                Text(body, style: text.bodySmall),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
