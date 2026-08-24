import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/network/api_exception.dart';
import '../../../core/providers.dart';

/// Hesap ayarları uç noktaları (`/api/users/*`).
class SettingsRepository {
  SettingsRepository(this._dio);

  final Dio _dio;

  /// Şifre değiştirir — `POST /users/change-password`.
  Future<void> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    try {
      await _dio.post(
        '/users/change-password',
        data: {
          'currentPassword': currentPassword,
          'newPassword': newPassword,
        },
      );
    } on DioException catch (e) {
      throw ApiException.fromDio(e);
    }
  }

  /// KVKK veri taşınabilirliği: hesabın tüm verisini JSON olarak indirir.
  /// Bu uç nokta zarfsızdır (`GET /users/data` ham JSON döner).
  Future<String> downloadAccountData() async {
    try {
      final res = await _dio.get<dynamic>('/users/data');
      const encoder = JsonEncoder.withIndent('  ');
      return encoder.convert(res.data);
    } on DioException catch (e) {
      throw ApiException.fromDio(e);
    }
  }

  /// Hesabı kalıcı olarak siler — `DELETE /users/me` (gövdede mevcut şifre).
  Future<void> deleteAccount(String currentPassword) async {
    try {
      await _dio.delete(
        '/users/me',
        data: {'currentPassword': currentPassword},
      );
    } on DioException catch (e) {
      throw ApiException.fromDio(e);
    }
  }
}

final settingsRepositoryProvider = Provider<SettingsRepository>((ref) {
  return SettingsRepository(ref.watch(dioProvider));
});
