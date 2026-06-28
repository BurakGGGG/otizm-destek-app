import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/network/api_exception.dart';
import '../../../core/network/api_response.dart';
import '../../../core/providers.dart';
import '../../../i18n/strings.g.dart';
import '../domain/app_user.dart';

/// Başarılı kimlik doğrulama sonucu: kullanıcı + token çifti.
class AuthResult {
  const AuthResult({
    required this.user,
    required this.accessToken,
    required this.refreshToken,
  });

  final AppUser user;
  final String accessToken;
  final String refreshToken;

  factory AuthResult.fromData(Map<String, dynamic> data) {
    final userJson = data['user'];
    if (userJson is! Map<String, dynamic>) {
      throw ApiException(t.errors.noUserInResponse);
    }
    return AuthResult(
      user: AppUser.fromJson(userJson),
      accessToken: data['accessToken'] as String? ?? '',
      refreshToken: data['refreshToken'] as String? ?? '',
    );
  }
}

/// Backend JWT auth uç noktalarını saran depo (`/api/auth/*`).
class AuthRepository {
  AuthRepository(this._dio);

  final Dio _dio;

  static final _noAuth = Options(extra: {'skipAuth': true});

  Future<AuthResult> login(String email, String password) async {
    try {
      final res = await _dio.post(
        '/auth/login',
        data: {'email': email, 'password': password},
        options: _noAuth,
      );
      return AuthResult.fromData(ApiEnvelope.fromJson(res.data).requireMap());
    } on DioException catch (e) {
      throw ApiException.fromDio(e);
    }
  }

  Future<AuthResult> register({
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
    try {
      final res = await _dio.post(
        '/auth/register',
        data: {
          'email': email,
          'password': password,
          'fullName': fullName,
          'kvkkConsent': kvkkConsent,
          'role': role.backendValue,
          'phone': ?phone,
          'city': ?city,
          'expertTitle': ?expertTitle,
          'institution': ?institution,
          'licenseNumber': ?licenseNumber,
          'bio': ?bio,
          'specializations': ?specializations,
        },
        options: _noAuth,
      );
      return AuthResult.fromData(ApiEnvelope.fromJson(res.data).requireMap());
    } on DioException catch (e) {
      throw ApiException.fromDio(e);
    }
  }

  /// Mevcut oturumu doğrular (token geçerliyse kullanıcıyı döndürür).
  Future<AppUser> me() async {
    try {
      final res = await _dio.get('/auth/me');
      return AppUser.fromJson(ApiEnvelope.fromJson(res.data).requireMap());
    } on DioException catch (e) {
      throw ApiException.fromDio(e);
    }
  }

  /// Profili günceller — `PUT /api/users/me`. Yalnız verilen (null olmayan)
  /// alanlar değiştirilir; güncel kullanıcı döner.
  Future<AppUser> updateProfile({
    String? fullName,
    String? phone,
    String? city,
    String? expertTitle,
    String? institution,
    String? licenseNumber,
    String? bio,
  }) async {
    try {
      final res = await _dio.put(
        '/users/me',
        data: {
          'fullName': ?fullName,
          'phone': ?phone,
          'city': ?city,
          'expertTitle': ?expertTitle,
          'institution': ?institution,
          'licenseNumber': ?licenseNumber,
          'bio': ?bio,
        },
      );
      return AppUser.fromJson(ApiEnvelope.fromJson(res.data).requireMap());
    } on DioException catch (e) {
      throw ApiException.fromDio(e);
    }
  }

  /// Şifre sıfırlama bağlantısı ister (`POST /auth/forgot-password`).
  Future<void> forgotPassword(String email) async {
    try {
      await _dio.post(
        '/auth/forgot-password',
        data: {'email': email},
        options: _noAuth,
      );
    } on DioException catch (e) {
      throw ApiException.fromDio(e);
    }
  }

  /// Token + yeni şifre ile sıfırlar (`POST /auth/reset-password`).
  Future<void> resetPassword({
    required String token,
    required String password,
  }) async {
    try {
      await _dio.post(
        '/auth/reset-password',
        data: {'token': token, 'password': password},
        options: _noAuth,
      );
    } on DioException catch (e) {
      throw ApiException.fromDio(e);
    }
  }

  Future<void> logout(String refreshToken) async {
    try {
      await _dio.post('/auth/logout', data: {'refreshToken': refreshToken});
    } on DioException catch (_) {
      // Çıkışta sunucu hatası kullanıcıyı engellememeli.
    }
  }
}

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepository(ref.watch(dioProvider));
});
