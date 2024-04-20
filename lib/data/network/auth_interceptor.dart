import 'package:dio/dio.dart';
import 'package:pomodak/data/datasources/local/auth_local_datasource.dart';

class AuthInterceptor extends Interceptor {
  final AuthLocalDataSource authLocalDataSource;
  final Future<AuthTokens> Function(String rToken) refreshToken;

  AuthInterceptor({
    required this.authLocalDataSource,
    required this.refreshToken,
  });

  @override
  void onRequest(
      RequestOptions options, RequestInterceptorHandler handler) async {
    final tokens = await authLocalDataSource.getTokens();

    if (tokens != null) {
      options.headers['Authorization'] = 'Bearer ${tokens.accessToken}';
    }
    super.onRequest(options, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    if (err.response?.statusCode == 401) {
      if (err.requestOptions.extra['retry'] == true) {
        // 이미 재요청한 경우 더 이상 처리하지 않음
        return handler.next(err);
      }

      AuthTokens? tokens = await authLocalDataSource.getTokens();
      String? rToken = tokens?.refreshToken;
      if (rToken == null) {
        // refreshToken이 없는 경우 더 이상 처리하지 않음
        return handler.next(err);
      }

      final AuthTokens newTokens = await refreshToken(rToken);

      // 요청 재시도
      RequestOptions updatedOptions = err.requestOptions.copyWith(
        headers: {
          ...err.requestOptions.headers,
          'Authorization': 'Bearer ${newTokens.accessToken}',
          "retry": true,
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
