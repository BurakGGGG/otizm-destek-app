import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_theme.dart';
import '../../../i18n/strings.g.dart';
import '../domain/app_user.dart';
import 'auth_controller.dart';

/// Kayıt ekranı (Veli / Uzman). Backend `/api/auth/register`'a bağlanır.
class RegisterScreen extends ConsumerStatefulWidget {
  const RegisterScreen({super.key, this.initialRole = UserRole.parent});

  final UserRole initialRole;

  @override
  ConsumerState<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends ConsumerState<RegisterScreen> {
  late UserRole _role = widget.initialRole;
  bool _obscure = true;
  bool _kvkk = false;

  final _fullName = TextEditingController();
  final _email = TextEditingController();
  final _password = TextEditingController();
  final _phone = TextEditingController();
  final _city = TextEditingController();
  final _expertTitle = TextEditingController();
  final _institution = TextEditingController();
  final _licenseNumber = TextEditingController();
  final _bio = TextEditingController();
  final _specializations = TextEditingController();

  @override
  void dispose() {
    for (final c in [
      _fullName,
      _email,
      _password,
      _phone,
      _city,
      _expertTitle,
      _institution,
      _licenseNumber,
      _bio,
      _specializations,
    ]) {
      c.dispose();
    }
    super.dispose();
  }

  bool get _isExpert => _role == UserRole.expert;

  @override
  Widget build(BuildContext context) {
    final t = context.t;
    final text = Theme.of(context).textTheme;
    final isBusy = ref.watch(authControllerProvider).isBusy;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          _isExpert ? t.register.titleExpert : t.register.titleParent,
        ),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(AppSpacing.margin),
          children: [
            Text(t.register.roleQuestion, style: text.titleMedium),
            const SizedBox(height: 12),
            SegmentedButton<UserRole>(
              segments: [
                ButtonSegment(
                  value: UserRole.parent,
                  icon: const Icon(Icons.person_outline),
                  label: Text(t.roles.parent),
                ),
                ButtonSegment(
                  value: UserRole.expert,
                  icon: const Icon(Icons.work_outline),
                  label: Text(t.roles.expert),
                ),
              ],
              selected: {_role},
              showSelectedIcon: false,
              onSelectionChanged: (s) => setState(() => _role = s.first),
            ),
            const SizedBox(height: 20),

            _Field(
              label: t.register.fullNameLabel,
              hint: t.register.fullNameHint,
              controller: _fullName,
              icon: Icons.badge_outlined,
              textCapitalization: TextCapitalization.words,
            ),
            const SizedBox(height: 16),
            _Field(
              label: t.auth.emailLabel,
              hint: t.auth.emailHint,
              controller: _email,
              icon: Icons.mail_outline,
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 16),
            _Field(
              label: t.auth.passwordLabel,
              hint: t.auth.passwordHint,
              controller: _password,
              icon: Icons.lock_outline,
              obscure: _obscure,
              trailing: IconButton(
                onPressed: () => setState(() => _obscure = !_obscure),
                icon: Icon(
                  _obscure
                      ? Icons.visibility_outlined
                      : Icons.visibility_off_outlined,
                  color: context.colors.textTertiary,
                ),
              ),
            ),
            const SizedBox(height: 16),
            _Field(
              label: t.register.phoneLabel,
              hint: t.register.phoneHint,
              controller: _phone,
              icon: Icons.phone_outlined,
              keyboardType: TextInputType.phone,
            ),
            const SizedBox(height: 16),
            _Field(
              label: t.register.cityLabel,
              hint: t.register.cityHint,
              controller: _city,
              icon: Icons.location_city_outlined,
              textCapitalization: TextCapitalization.words,
            ),

            // Uzman alanları
            if (_isExpert) ...[
              const SizedBox(height: 16),
              _Field(
                label: t.register.expertTitleLabel,
                hint: t.register.expertTitleHint,
                controller: _expertTitle,
                icon: Icons.school_outlined,
              ),
              const SizedBox(height: 16),
              _Field(
                label: t.register.institutionLabel,
                hint: t.register.institutionHint,
                controller: _institution,
                icon: Icons.business_outlined,
              ),
              const SizedBox(height: 16),
              _Field(
                label: t.register.licenseNumberLabel,
                hint: t.register.licenseNumberHint,
                controller: _licenseNumber,
                icon: Icons.verified_outlined,
              ),
              const SizedBox(height: 16),
              _Field(
                label: t.register.specializationsLabel,
                hint: t.register.specializationsHint,
                controller: _specializations,
                icon: Icons.interests_outlined,
              ),
              const SizedBox(height: 16),
              _Field(
                label: t.register.bioLabel,
                hint: t.register.bioHint,
                controller: _bio,
                icon: Icons.notes_outlined,
                maxLines: 3,
              ),
            ],

            const SizedBox(height: 8),
            CheckboxListTile(
              value: _kvkk,
              onChanged: (v) => setState(() => _kvkk = v ?? false),
              controlAffinity: ListTileControlAffinity.leading,
              contentPadding: EdgeInsets.zero,
              title: Text(t.register.kvkkConsent, style: text.bodySmall),
            ),
            const SizedBox(height: 8),
            FilledButton(
              onPressed: isBusy ? null : _onSubmit,
              child: isBusy
                  ? const SizedBox(
                      height: 22,
                      width: 22,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : Text(t.register.submit),
            ),
            const SizedBox(height: 12),
            TextButton(
              onPressed: isBusy ? null : () => context.go('/login'),
              child: Text(t.register.haveAccount),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _onSubmit() async {
    final t = context.t;
    final email = _email.text.trim();

    // İstemci tarafı doğrulama (backend de doğrular).
    if (_fullName.text.trim().isEmpty) {
      return _showError(t.register.errorFullNameRequired);
    }
    if (email.isEmpty) return _showError(t.register.errorEmailRequired);
    if (!email.contains('@') || !email.contains('.')) {
      return _showError(t.register.errorEmailInvalid);
    }
    if (_password.text.length < 8) {
      return _showError(t.register.errorPasswordShort);
    }
    if (_isExpert && _expertTitle.text.trim().isEmpty) {
      return _showError(t.register.errorExpertTitleRequired);
    }
    if (!_kvkk) return _showError(t.register.errorKvkkRequired);

    final specializations = _specializations.text
        .split(',')
        .map((e) => e.trim())
        .where((e) => e.isNotEmpty)
        .toList();

    final error = await ref
        .read(authControllerProvider.notifier)
        .register(
          email: email,
          password: _password.text,
          fullName: _fullName.text,
          kvkkConsent: _kvkk,
          role: _role,
          phone: _emptyToNull(_phone.text),
          city: _emptyToNull(_city.text),
          expertTitle: _isExpert ? _emptyToNull(_expertTitle.text) : null,
          institution: _isExpert ? _emptyToNull(_institution.text) : null,
          licenseNumber: _isExpert ? _emptyToNull(_licenseNumber.text) : null,
          bio: _isExpert ? _emptyToNull(_bio.text) : null,
          specializations: _isExpert && specializations.isNotEmpty
              ? specializations
              : null,
        );
    if (error != null) _showError(error);
    // Başarılıysa router otomatik /home'a yönlendirir.
  }

  String? _emptyToNull(String s) => s.trim().isEmpty ? null : s.trim();

  void _showError(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }
}

class _Field extends StatelessWidget {
  const _Field({
    required this.label,
    required this.controller,
    required this.icon,
    this.hint,
    this.obscure = false,
    this.keyboardType,
    this.textCapitalization = TextCapitalization.none,
    this.maxLines = 1,
    this.trailing,
  });

  final String label;
  final TextEditingController controller;
  final IconData icon;
  final String? hint;
  final bool obscure;
  final TextInputType? keyboardType;
  final TextCapitalization textCapitalization;
  final int maxLines;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: Theme.of(context).textTheme.labelMedium),
        const SizedBox(height: 6),
        TextField(
          controller: controller,
          obscureText: obscure,
          keyboardType: keyboardType,
          textCapitalization: textCapitalization,
          maxLines: obscure ? 1 : maxLines,
          decoration: InputDecoration(
            hintText: hint,
            prefixIcon: Icon(icon, color: context.colors.textTertiary),
            suffixIcon: trailing,
            fillColor: context.colors.surfaceVariant,
          ),
        ),
      ],
    );
  }
}
