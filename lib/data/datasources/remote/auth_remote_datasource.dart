import 'dart:async';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:pomodak/data/network/base_api_services.dart';
import 'package:pomodak/models/api/base_api_response.dart';
import 'package:pomodak/models/api/login_response.dart';

abstract class AuthRemoteDataSource {
  // 이메일로 로그인
  Future<BaseApiResponse<LoginResponse>> emailLoginApi({
    required String email,
    required String password,
  });

  // 이메일로 회원가입
  Future<BaseApiResponse<LoginResponse>> emailRegisterApi({
    required String email,
    required String password,
    required String code,
  });

  // 이메일 확인 메일 발송
  Future<void> checkEmailApi({
    required String email,
  });

  // 구글 OAuth 로그인
  Future<BaseApiResponse<LoginResponse>> googleLoginApi({
    required String idToken,
  });

  // 카카오 OAuth 로그인
  Future<BaseApiResponse<LoginResponse>> kakaoLoginApi({
    required String accessToken,
  });

  // 계정 탈퇴
  Future<void> deleteAccountApi();
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final String _nestApiEndpoint = dotenv.env['NEST_API_ENDPOINT']!;
  late BaseApiServices apiService;

  AuthRemoteDataSourceImpl({required this.apiService});

  @override
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

      return response;
    } catch (e) {
      rethrow;
    }
  }

  @override
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

      return response;
    } catch (e) {
      rethrow;
    }
  }

  @override
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

  @override
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

      return response;
    } catch (e) {
      rethrow;
    }
  }

  @override
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

      return response;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> deleteAccountApi() async {
    try {
      await apiService.getDeleteApiResponse('$_nestApiEndpoint/auth/me', {});
    } catch (e) {
      rethrow;
    }
  }
}
