import '../../i18n/strings.g.dart';
import 'api_exception.dart';

/// Backend'in `ApiResponse<T>` zarfı: `{ success, message, data }`.
class ApiEnvelope {
  const ApiEnvelope({required this.success, this.message, this.data});

  final bool success;
  final String? message;
  final dynamic data;

  factory ApiEnvelope.fromJson(dynamic json) {
    if (json is Map<String, dynamic>) {
      return ApiEnvelope(
        success: json['success'] as bool? ?? true,
        message: json['message'] as String?,
        data: json['data'],
      );
    }
    // Zarf yoksa veriyi olduğu gibi kabul et.
    return ApiEnvelope(success: true, data: json);
  }

  /// `data`'yı Map olarak döndürür; başarısızsa [ApiException] fırlatır.
  Map<String, dynamic> requireMap() {
    if (!success) throw ApiException(message ?? t.errors.operationFailed);
    final d = data;
    if (d is Map<String, dynamic>) return d;
    throw ApiException(t.errors.unexpectedResponse);
  }

  /// `data`'yı liste olarak döndürür.
  List<dynamic> requireList() {
    if (!success) throw ApiException(message ?? t.errors.operationFailed);
    final d = data;
    if (d is List) return d;
    throw ApiException(t.errors.unexpectedResponse);
  }
}
