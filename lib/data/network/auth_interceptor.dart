import 'package:dio/dio.dart';
import 'package:pomodak/data/storagies/auth_storage.dart';

class AuthInterceptor extends Interceptor {
  final AuthStorage storage;
  final Future<String?> Function() refreshToken;

  AuthInterceptor({
    required this.storage,
    required this.refreshToken,
  });

  @override
  void onRequest(
      RequestOptions options, RequestInterceptorHandler handler) async {
    final accessToken = await storage.getAccessToken();
    options.headers['Authorization'] = 'Bearer $accessToken';
    super.onRequest(options, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    if (err.response?.statusCode == 401) {
      if (err.requestOptions.extra['retry'] == true) {
        // 이미 재요청한 경우는 더 이상 처리하지 않음
        return handler.next(err);
      }

      RequestOptions options = err.requestOptions;
      final accessToken = await refreshToken();

      // 토큰이 없어도 더 이상 처리하지 않음
      if (accessToken == null) {
        return handler.next(err);
      }

      options.headers['Authorization'] = 'Bearer $accessToken';
      options.extra['retry'] = true; // 재시도 플래그 설정
      // 요청 재시도
      RequestOptions updatedOptions = err.requestOptions.copyWith(
        headers: {
          ...err.requestOptions.headers,
          'Authorization': 'Bearer $accessToken',
        },
      );
      try {
        final response = await Dio().fetch(updatedOptions);
        handler.resolve(response);
      } catch (e) {
        handler.reject(err);
      }
    } else {
      super.onError(err, handler);
    }
  }
}
