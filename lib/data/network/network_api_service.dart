import 'dart:developer' as developer;
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:pomodak/data/app_exceptions.dart';
import 'package:pomodak/data/network/auth_interceptor.dart';
import 'package:pomodak/data/network/base_api_services.dart';
import 'package:pomodak/data/storagies/auth_storage.dart';
import 'package:pomodak/models/api/base_api_response.dart';
import 'package:pomodak/models/api/refresh_response.dart';

class NetworkApiService extends BaseApiServices {
  final Dio _dio = Dio();
  final String _nestApiEndpoint = dotenv.env['NEST_API_ENDPOINT']!;
  final AuthStorage storage;

  NetworkApiService({required this.storage}) {
    _dio.interceptors.add(AuthInterceptor(
      storage: storage,
      refreshToken: refreshToken,
    ));
  }

  @override
  Future<dynamic> getGetApiResponse(String url) async {
    try {
      final response = await _dio.get(url);
      return response.data;
    } on DioException catch (dioError) {
      _handleDioError(dioError);
    }
  }

  @override
  Future<dynamic> getPostApiResponse(String url, dynamic data) async {
    try {
      final response = await _dio.post(url, data: data);
      return response.data;
    } on DioException catch (dioError) {
      _handleDioError(dioError);
    }
  }

  @override
  Future<dynamic> getPatchApiResponse(String url, dynamic data) async {
    try {
      final response = await _dio.patch(url, data: data);
      return response.data;
    } on DioException catch (dioError) {
      _handleDioError(dioError);
    }
  }

  @override
  Future<dynamic> getDeleteApiResponse(String url, dynamic data) async {
    try {
      final response = await _dio.delete(url, data: data);
      return response.data;
    } on DioException catch (dioError) {
      _handleDioError(dioError);
    }
  }

  Future<String?> refreshToken() async {
    final refreshToken = await storage.getRefreshToken();
    if (refreshToken == null) {
      // 리프레시 토큰이 없다면 로그아웃 처리
      await storage.deleteAllData();
      return null;
    }

    try {
      // Dio를 사용하여 리프레시 토큰으로 새 액세스 토큰 요청
      var responseJson = await Dio().post(
        '$_nestApiEndpoint/auth/refresh',
        options: Options(headers: {
          "Authorization": 'Bearer $refreshToken',
          'Content-Type': 'application/json'
        }),
      );
      BaseApiResponse<RefreshResponse> response = BaseApiResponse.fromJson(
        responseJson.data,
        (json) => RefreshResponse.fromJson(json as Map<String, dynamic>),
      );
      var data = response.data;
      if (data != null) {
        // 새 토큰 저장
        await storage.storeTokens(
          data.accessToken,
          refreshToken: data.refreshToken,
        );

        return data.accessToken;
      } else {
        // 토큰 갱신 실패 시 로그아웃 처리
        await storage.deleteAllData();
        return null;
      }
    } on DioException catch (dioError) {
      // 네트워크 오류나 기타 예외 처리
      await storage.deleteAllData();
      _handleDioError(dioError);
    }
    return null;
  }

  void _handleDioError(DioException dioError) {
    String userFriendlyErrorMessage = 'Something went wrong. Please try again.';

    if (dioError.error is SocketException) {
      userFriendlyErrorMessage =
          'No Internet Connection. Please check your connection and try again.';
    } else if (dioError.response != null) {
      if (dioError.response!.data != null &&
          dioError.response!.data['message'] != null) {
        // 서버에서 내려주는 에러메세지가 존재하는 경우

        if (dioError.response!.data['message'] is List) {
          userFriendlyErrorMessage = dioError.response!.data['message'][0];
        } else {
          userFriendlyErrorMessage = dioError.response!.data['message'];
        }
      } else if (dioError.response!.statusCode == 401) {
        userFriendlyErrorMessage = 'Session expired. Please login again.';
      } else if (dioError.response!.statusCode == 500) {
        userFriendlyErrorMessage = 'Server error. We are working on it.';
      } else if (dioError.response!.data != null &&
          dioError.response!.data['message'] != null) {
        userFriendlyErrorMessage = dioError.response!.data['message'];
      } else if (dioError.response!.statusCode! >= 400 &&
          dioError.response!.statusCode! < 500) {
        userFriendlyErrorMessage = 'Something went wrong. Please try again.';
      }
    }

    // 디버그 모드에서만 로깅
    if (kDebugMode) {
      developer.log(
        'DioError: ${dioError.message}',
        name: 'NetworkApiService._handleDioError',
      );
      if (dioError.response != null) {
        developer.log(
          'Response data: ${dioError.response!.data}',
          name: 'NetworkApiService._handleDioError',
        );
      }
    }

    throw FetchCustomException(userFriendlyErrorMessage);
  }
}
