import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:pomodak/data/app_exceptions.dart';
import 'package:pomodak/data/storagies/auth_storage.dart';
import 'package:pomodak/models/api/base_api_response.dart';
import 'package:pomodak/data/network/network_api_service.dart';
import 'package:pomodak/models/api/login_response.dart';
import 'package:pomodak/models/api/refresh_response.dart';
import 'package:pomodak/models/domain/account_model.dart';

class AuthRepository {
  final String _nestApiEndpoint = dotenv.env['NEST_API_ENDPOINT']!;
  final NetworkApiService apiService;
  final AuthStorage storage;

  AuthRepository({required this.apiService, required this.storage});

  // 이메일로 로그인
  Future<BaseApiResponse<LoginResponse>> emailLoginApi({
    required String email,
    required String password,
  }) async {
    try {
      Map body = {
        "email": email,
        "password": password,
      };
      Map<String, dynamic> responseJson = await apiService.getPostApiResponse(
        '$_nestApiEndpoint/auth/email/login',
        body,
      );
      BaseApiResponse<LoginResponse> response = BaseApiResponse.fromJson(
        responseJson,
        (json) => LoginResponse.fromJson(json as Map<String, dynamic>),
      );

      var data = response.data;
      if (data != null) {
        await storage.storeTokens(data.accessToken,
            refreshToken: data.refreshToken);
        await storage.storeAccount(data.account);
      }

      return response;
    } catch (e) {
      logOut();
      rethrow;
    }
  }

  // 이메일로 회원가입
  Future<BaseApiResponse<LoginResponse>> emailRegisterApi({
    required String email,
    required String password,
    required String code,
  }) async {
    try {
      Map body = {
        "email": email,
        "password": password,
        "code": code,
      };
      dynamic responseJson = await apiService.getPostApiResponse(
        '$_nestApiEndpoint/auth/email/register',
        body,
      );
      BaseApiResponse<LoginResponse> response = BaseApiResponse.fromJson(
        responseJson,
        (json) => LoginResponse.fromJson(json as Map<String, dynamic>),
      );

      var data = response.data;

      if (data != null) {
        await storage.storeTokens(data.accessToken,
            refreshToken: data.refreshToken);
        await storage.storeAccount(data.account);
      }

      return response;
    } catch (e) {
      logOut();
      rethrow;
    }
  }

  // 이메일 확인 메일 발송
  Future<void> checkEmailApi({
    required String email,
  }) async {
    try {
      Map body = {
        "email": email,
      };
      await apiService.getPostApiResponse(
        '$_nestApiEndpoint/auth/email/check',
        body,
      );
    } catch (e) {
      rethrow;
    }
  }

  // 구글 OAuth 로그인
  Future<BaseApiResponse<LoginResponse>> googleLoginApi({
    required String idToken,
  }) async {
    try {
      Map body = {
        "idToken": idToken,
      };
      dynamic responseJson = await apiService.getPostApiResponse(
        '$_nestApiEndpoint/auth/google/login/v2',
        body,
      );
      BaseApiResponse<LoginResponse> response = BaseApiResponse.fromJson(
        responseJson,
        (json) => LoginResponse.fromJson(json as Map<String, dynamic>),
      );

      var data = response.data;
      if (data != null) {
        await storage.storeTokens(data.accessToken,
            refreshToken: data.refreshToken);
        await storage.storeAccount(data.account);
      }

      return response;
    } catch (e) {
      logOut();
      rethrow;
    }
  }

  // 카카오 OAuth 로그인
  Future<BaseApiResponse<LoginResponse>> kakaoLoginApi({
    required String accessToken,
  }) async {
    try {
      Map body = {
        "access_token": accessToken,
      };
      dynamic responseJson = await apiService.getPostApiResponse(
        '$_nestApiEndpoint/auth/kakao/login/v2',
        body,
      );
      BaseApiResponse<LoginResponse> response = BaseApiResponse.fromJson(
        responseJson,
        (json) => LoginResponse.fromJson(json as Map<String, dynamic>),
      );

      var data = response.data;
      if (data != null) {
        await storage.storeTokens(data.accessToken,
            refreshToken: data.refreshToken);
        await storage.storeAccount(data.account);
      }

      return response;
    } catch (e) {
      logOut();
      rethrow;
    }
  }

  // 저장소를 확인하여 계정 반환 (에러 발생시 저장소 초기화)
  Future<AccountModel?> getAccount() async {
    try {
      return storage.getAccount();
    } catch (e) {
      await logOut();
    }
    return null;
  }

  Future<String?> refreshToken() async {
    final refreshToken = await storage.getRefreshToken();

    if (refreshToken == null) {
      // 리프레시 토큰이 없다면 로그아웃 처리
      await logOut();
      return null;
    }

    try {
      // Dio를 사용하여 리프레시 토큰으로 새 액세스 토큰 요청
      var response = await Dio().post(
        '$_nestApiEndpoint/auth/refresh',
        options: Options(headers: {"Authorization": 'Bearer $refreshToken'}),
      );

      if (response.statusCode == 200) {
        var data = RefreshResponse.fromJson(response.data);
        // 새 토큰 저장
        await storage.storeTokens(
          data.accessToken,
          refreshToken: data.refreshToken,
        );

        return data.accessToken;
      } else {
        // 토큰 갱신 실패 시 로그아웃 처리
        await logOut();
        return null;
      }
    } catch (e) {
      // 네트워크 오류나 기타 예외 처리
      await logOut();
      throw FetchDataException(
          'Failed to refresh token. No Internet Connection or Server Error');
    }
  }

  // 스토리지(토큰, 계정) 비우기
  Future<void> logOut() async {
    await storage.deleteAllData();
  }
}
