import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/network/api_exception.dart';
import '../../../core/network/api_response.dart';
import '../../../core/providers.dart';
import '../domain/milestone.dart';

/// `/api/milestones` deposu — kilometre taşı CRUD (web milestoneService
/// birebir). Tedavi Paneli'ndeki hızlı kayıt da aynı POST ucunu kullanır.
class MilestoneRepository {
  MilestoneRepository(this._dio);
  final Dio _dio;

  Future<List<Milestone>> getByChild(String childId) async {
    try {
      final res = await _dio.get('/milestones/child/$childId');
      return ApiEnvelope.fromJson(res.data)
          .requireList()
          .whereType<Map<String, dynamic>>()
          .map(Milestone.fromJson)
          .toList();
    } on DioException catch (e) {
      throw ApiException.fromDio(e);
    }
  }

  Map<String, dynamic> _writeBody({
    required String title,
    String? description,
    String? category,
    String? achievedDate,
    String? childId,
  }) {
    return {
      'title': title.trim(),
      if (description != null && description.trim().isNotEmpty)
        'description': description.trim(),
      if (category != null && category.isNotEmpty) 'category': category,
      'achievedDate': ?achievedDate,
      'childId': ?childId,
    };
  }

  Future<Milestone> create({
    required String childId,
    required String title,
    String? description,
    String? category,
    String? achievedDate,
  }) async {
    try {
      final res = await _dio.post(
        '/milestones',
        data: _writeBody(
          title: title,
          description: description,
          category: category,
          achievedDate: achievedDate,
          childId: childId,
        ),
      );
      return Milestone.fromJson(ApiEnvelope.fromJson(res.data).requireMap());
    } on DioException catch (e) {
      throw ApiException.fromDio(e);
    }
  }

  Future<Milestone> update(
    String id, {
    required String title,
    String? description,
    String? category,
    String? achievedDate,
  }) async {
    try {
      final res = await _dio.put(
        '/milestones/$id',
        data: _writeBody(
          title: title,
          description: description,
          category: category,
          achievedDate: achievedDate,
        ),
      );
      return Milestone.fromJson(ApiEnvelope.fromJson(res.data).requireMap());
    } on DioException catch (e) {
      throw ApiException.fromDio(e);
    }
  }

  Future<void> delete(String id) async {
    try {
      await _dio.delete('/milestones/$id');
    } on DioException catch (e) {
      throw ApiException.fromDio(e);
    }
  }
}

final milestoneRepositoryProvider = Provider<MilestoneRepository>((ref) {
  return MilestoneRepository(ref.watch(dioProvider));
});

/// Çocuğun kilometre taşları.
final milestonesProvider =
    FutureProvider.family<List<Milestone>, String>((ref, childId) {
  return ref.watch(milestoneRepositoryProvider).getByChild(childId);
});
