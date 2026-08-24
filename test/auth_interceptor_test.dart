import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:otizm_destek_app/core/network/auth_interceptor.dart';

/// Bearer token yalnızca kendi backend'imize gitmeli.
class _CaptureHandler extends RequestInterceptorHandler {
  RequestOptions? forwarded;
  @override
  void next(RequestOptions options) => forwarded = options;
}

Future<RequestOptions> _run(
  AuthInterceptor interceptor,
  RequestOptions options,
) async {
  final handler = _CaptureHandler();
  await interceptor.onRequest(options, handler);
  return handler.forwarded!;
}

void main() {
  const backend = 'https://otizm-backend.onrender.com';
  final interceptor = AuthInterceptor(() async => 'TOKEN', allowedHost: backend);

  test('göreli isteğe token eklenir', () async {
    final out = await _run(interceptor, RequestOptions(path: '/children'));
    expect(out.headers['Authorization'], 'Bearer TOKEN');
  });

  test('backend mutlak adresine token eklenir', () async {
    final out = await _run(
      interceptor,
      RequestOptions(path: '$backend/api/upload/x.jpg'),
    );
    expect(out.headers['Authorization'], 'Bearer TOKEN');
  });

  test('yabancı host\'a token EKLENMEZ', () async {
    final out = await _run(
      interceptor,
      RequestOptions(path: 'https://evil.example.com/steal'),
    );
    expect(out.headers.containsKey('Authorization'), isFalse);
  });

  test('alt alan adı hilesi token almaz', () async {
    final out = await _run(
      interceptor,
      RequestOptions(
        path: 'https://otizm-backend.onrender.com.evil.net/x',
      ),
    );
    expect(out.headers.containsKey('Authorization'), isFalse);
  });

  test('skipAuth verilen istekte token yok', () async {
    final out = await _run(
      interceptor,
      RequestOptions(path: '/auth/login', extra: {'skipAuth': true}),
    );
    expect(out.headers.containsKey('Authorization'), isFalse);
  });
}
