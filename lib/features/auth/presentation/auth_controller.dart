import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/network/api_exception.dart';
import '../../../core/providers.dart';
import '../../../core/storage/secure_storage.dart';
import '../../../i18n/strings.g.dart';
import '../data/auth_repository.dart';
import '../domain/app_user.dart';

/// Oturum durumu.
enum AuthStatus { unknown, authenticated, unauthenticated }

/// Kayıt sonucu. Backend her kayıtta oturum açmaz: e-posta doğrulaması
/// istendiğinde ya da uzman hesabı yönetici onayı beklediğinde token dönmez.
class RegisterOutcome {
  const RegisterOutcome({
    this.error,
    this.signedIn = false,
    this.pendingEmailVerification = false,
    this.pendingApproval = false,
  });

  final String? error;
  final bool signedIn;
  final bool pendingEmailVerification;
  final bool pendingApproval;
}

class AuthState {
  const AuthState({required this.status, this.user, this.isBusy = false});

  final AuthStatus status;
  final AppUser? user;
  final bool isBusy;

  AuthState copyWith({AuthStatus? status, AppUser? user, bool? isBusy}) {
    return AuthState(
      status: status ?? this.status,
      user: user ?? this.user,
      isBusy: isBusy ?? this.isBusy,
    );
  }

  static const initial = AuthState(status: AuthStatus.unknown);
}

/// Backend JWT auth ile oturum kontrolcüsü.
/// Başarısız giriş sonucu — mesaj ve sunucunun hız sınırına takılıp
/// takılmadığı (arayüz buna göre bekleme uyguluyor).
class AuthFailure {
  const AuthFailure(this.message, {this.isRateLimited = false});

  final String message;
  final bool isRateLimited;
}

class AuthController extends Notifier<AuthState> {
  AuthRepository get _repo => ref.read(authRepositoryProvider);
  SecureStorage get _storage => ref.read(secureStorageProvider);

  @override
  AuthState build() {
    _restore();
    return AuthState.initial;
  }

  /// Açılışta: depolanan token varsa /me ile oturumu geri yükle.
  Future<void> _restore() async {
    try {
      final token = await _storage.readAccessToken();
      if (token == null || token.isEmpty) {
        state = const AuthState(status: AuthStatus.unauthenticated);
        return;
      }
      final user = await _repo.me();
      state = AuthState(status: AuthStatus.authenticated, user: user);
    } catch (_) {
      try {
        await _storage.clear();
      } catch (_) {}
      state = const AuthState(status: AuthStatus.unauthenticated);
    }
  }

  /// Giriş. Başarılıysa `null`, hatadaysa kullanıcıya gösterilecek mesaj döner.
  Future<AuthFailure?> signIn(String email, String password) async {
    state = state.copyWith(isBusy: true);
    try {
      final result = await _repo.login(email.trim(), password);
      if (!result.hasSession) {
        // Token'sız yanıt: iki adımlı doğrulama (mobilde henüz yok) ya da
        // beklenmedik bir durum. Boş token'la "giriş yapıldı" sanılmamalı.
        state = const AuthState(status: AuthStatus.unauthenticated);
        return AuthFailure(
          result.mfaRequired
              ? t.auth.errorMfaRequired
              : t.errors.unexpectedResponse,
        );
      }
      await _storage.saveTokens(
        accessToken: result.accessToken,
        refreshToken: result.refreshToken,
      );
      state = AuthState(status: AuthStatus.authenticated, user: result.user);
      return null;
    } on ApiException catch (e) {
      state = const AuthState(status: AuthStatus.unauthenticated);
      return AuthFailure(e.message, isRateLimited: e.isRateLimited);
    }
  }

  /// Kayıt (Veli/Uzman). Oturum açıldıysa `signedIn`, açılmadıysa hangi
  /// beklemenin geçerli olduğunu ([RegisterOutcome]) döner.
  Future<RegisterOutcome> register({
    required String email,
    required String password,
    required String fullName,
    required bool kvkkConsent,
    UserRole role = UserRole.parent,
    String? phone,
    String? city,
    String? expertTitle,
    String? institution,
    String? licenseNumber,
    String? bio,
    List<String>? specializations,
  }) async {
    state = state.copyWith(isBusy: true);
    try {
      final result = await _repo.register(
        email: email.trim(),
        password: password,
        fullName: fullName.trim(),
        kvkkConsent: kvkkConsent,
        role: role,
        phone: phone,
        city: city,
        expertTitle: expertTitle,
        institution: institution,
        licenseNumber: licenseNumber,
        bio: bio,
        specializations: specializations,
      );
      if (!result.hasSession) {
        state = const AuthState(status: AuthStatus.unauthenticated);
        return RegisterOutcome(
          pendingEmailVerification: result.pendingEmailVerification,
          pendingApproval: result.pendingApproval,
          error: (result.pendingEmailVerification || result.pendingApproval)
              ? null
              : t.errors.unexpectedResponse,
        );
      }
      await _storage.saveTokens(
        accessToken: result.accessToken,
        refreshToken: result.refreshToken,
      );
      state = AuthState(status: AuthStatus.authenticated, user: result.user);
      return const RegisterOutcome(signedIn: true);
    } on ApiException catch (e) {
      state = const AuthState(status: AuthStatus.unauthenticated);
      return RegisterOutcome(error: e.message);
    }
  }

  /// Profili günceller. Başarılıysa `null`, hatadaysa mesaj döner.
  Future<String?> updateProfile({
    String? fullName,
    String? phone,
    String? city,
    String? expertTitle,
    String? institution,
    String? licenseNumber,
    String? bio,
    String? profileImageUrl,
    bool? allowDirectMessages,
    bool? allowFamilyMessages,
    bool? hideOnlineStatus,
    bool? approximateLocationOnly,
    List<String>? communicationPreferences,
    List<String>? supportIntents,
  }) async {
    try {
      final updated = await _repo.updateProfile(
        fullName: fullName,
        phone: phone,
        city: city,
        expertTitle: expertTitle,
        institution: institution,
        licenseNumber: licenseNumber,
        bio: bio,
        profileImageUrl: profileImageUrl,
        allowDirectMessages: allowDirectMessages,
        allowFamilyMessages: allowFamilyMessages,
        hideOnlineStatus: hideOnlineStatus,
        approximateLocationOnly: approximateLocationOnly,
        communicationPreferences: communicationPreferences,
        supportIntents: supportIntents,
      );
      state = state.copyWith(user: updated);
      return null;
    } on ApiException catch (e) {
      return e.message;
    }
  }

  /// İlk giriş sihirbazını tamamlar. Kalıcı kaynak sunucudur; eski backend
  /// sürümlerinde uç nokta yoksa (404) kullanıcı akışta kilitlenmesin diye
  /// yalnızca yerel durum güncellenir (web authStore ile aynı davranış).
  Future<String?> completeOnboarding() async {
    try {
      final updated = await _repo.completeOnboarding();
      state = state.copyWith(user: updated);
      return null;
    } on ApiException catch (e) {
      if (e.statusCode == 404) {
        final user = state.user;
        if (user != null) {
          state = state.copyWith(user: user.copyWith(onboardingCompleted: true));
        }
        return null;
      }
      return e.message;
    }
  }

  Future<void> signOut() async {
    final rt = await _storage.readRefreshToken();
    if (rt != null && rt.isNotEmpty) {
      await _repo.logout(rt);
    }
    await _storage.clear();
    state = const AuthState(status: AuthStatus.unauthenticated);
  }

  /// Refresh interceptor yenilemeyi başaramazsa çağrılır.
  void onSessionExpired() {
    state = const AuthState(status: AuthStatus.unauthenticated);
  }
}

final authControllerProvider = NotifierProvider<AuthController, AuthState>(
  AuthController.new,
);
