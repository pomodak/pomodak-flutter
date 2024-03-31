import 'dart:async';
import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:pomodak/data/app_exceptions.dart';
import 'package:pomodak/models/api/base_api_response.dart';
import 'package:pomodak/data/network/base_api_services.dart';
import 'package:pomodak/data/network/network_api_service.dart';
import 'package:pomodak/models/api/login_response.dart';
import 'package:pomodak/models/api/refresh_response.dart';
import 'package:pomodak/models/domain/account_model.dart';
import 'package:http/http.dart' as http;

class AuthRepository {
  final String _nestApiEndpoint = dotenv.env['NEST_API_ENDPOINT']!;
  final BaseApiServices _apiServices = NetworkApiService();

  // 캐시 저장소
  final FlutterSecureStorage _storage = const FlutterSecureStorage();
  final AndroidOptions _androidOptions = const AndroidOptions(
    encryptedSharedPreferences: true,
  );

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
      Map<String, dynamic> responseJson = await _apiServices.getPostApiResponse(
        '$_nestApiEndpoint/auth/email/login',
        body,
      );
      BaseApiResponse<LoginResponse> response = BaseApiResponse.fromJson(
        responseJson,
        (json) => LoginResponse.fromJson(json as Map<String, dynamic>),
      );

      var data = response.data;
      if (data != null) {
        await _storeTokens(data.accessToken, data.refreshToken, data.expiresIn);
        await _storeAccount(data.account);
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
      dynamic responseJson = await _apiServices.getPostApiResponse(
        '$_nestApiEndpoint/auth/email/register',
        body,
      );
      BaseApiResponse<LoginResponse> response = BaseApiResponse.fromJson(
        responseJson,
        (json) => LoginResponse.fromJson(json as Map<String, dynamic>),
      );

      var data = response.data;

      if (data != null) {
        await _storeTokens(data.accessToken, data.refreshToken, data.expiresIn);
        await _storeAccount(data.account);
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
      await _apiServices.getPostApiResponse(
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
      dynamic responseJson = await _apiServices.getPostApiResponse(
        '$_nestApiEndpoint/auth/google/login/v2',
        body,
      );
      BaseApiResponse<LoginResponse> response = BaseApiResponse.fromJson(
        responseJson,
        (json) => LoginResponse.fromJson(json as Map<String, dynamic>),
      );

      var data = response.data;
      if (data != null) {
        await _storeTokens(data.accessToken, data.refreshToken, data.expiresIn);
        await _storeAccount(data.account);
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
      dynamic responseJson = await _apiServices.getPostApiResponse(
        '$_nestApiEndpoint/auth/kakao/login/v2',
        body,
      );
      BaseApiResponse<LoginResponse> response = BaseApiResponse.fromJson(
        responseJson,
        (json) => LoginResponse.fromJson(json as Map<String, dynamic>),
      );

      var data = response.data;
      if (data != null) {
        await _storeTokens(data.accessToken, data.refreshToken, data.expiresIn);
        await _storeAccount(data.account);
      }

      return response;
    } catch (e) {
      logOut();
      rethrow;
    }
  }

  // 저장소를 확인하여 계정 반환 (에러 발생시 저장소 초기화)
  Future<AccountModel?> loadAccount() async {
    try {
      final accountJson =
          await _storage.read(key: 'account', aOptions: _androidOptions);
      if (accountJson != null) {
        return AccountModel.fromJson(json.decode(accountJson));
      }
    } catch (e) {
      await logOut();
    }
    return null;
  }

  // 리프레시 필요 시 리프레시 후 accessToken 반환
  // headers에 다른 값이 담김으로 NetworkApiService대신 http 사용
  Future<String?> refreshTokenIfNeeded() async {
    final refreshToken =
        await _storage.read(key: 'refreshToken', aOptions: _androidOptions);
    final expiresInStr =
        await _storage.read(key: 'expiresIn', aOptions: _androidOptions);
    final now = DateTime.now().millisecondsSinceEpoch;
    final expiresIn = int.tryParse(expiresInStr ?? '0') ?? 0;

    if (now >= expiresIn) {
      try {
        final responseJson = await http.post(
          Uri.parse('$_nestApiEndpoint/auth/refresh'),
          headers: {
            "Authorization": 'Bearer $refreshToken',
          },
        );

        if (responseJson.statusCode == 200) {
          BaseApiResponse<RefreshResponse> response = BaseApiResponse.fromJson(
            json.decode(responseJson.body),
            (json) => RefreshResponse.fromJson(json as Map<String, dynamic>),
          );

          var data = response.data;
          if (data != null) {
            await _storeTokens(
              data.accessToken,
              data.refreshToken,
              data.expiresIn,
            );
          }
          return data?.accessToken;
        } else {
          // 로그아웃 처리
          await logOut();
          return null;
        }
      } catch (e) {
        throw FetchDataException('No Internet Connection');
      }
    }

    return await _storage.read(key: 'accessToken', aOptions: _androidOptions);
  }

  // 스토리지(토큰, 계정) 비우기
  Future<void> logOut() async {
    await _storage.deleteAll(aOptions: _androidOptions);
  }

  // 스토리지에 토큰 정보 저장
  Future<void> _storeTokens(
      String accessToken, String refreshToken, int expiresIn) async {
    await _storage.write(
        key: 'accessToken', value: accessToken, aOptions: _androidOptions);
    await _storage.write(
        key: 'refreshToken', value: refreshToken, aOptions: _androidOptions);
    await _storage.write(
        key: 'expiresIn',
        value: expiresIn.toString(),
        aOptions: _androidOptions);
  }

  // 스토리지에 계정 정보 저장
  Future<void> _storeAccount(AccountModel account) async {
    await _storage.write(
      key: 'account',
      value: jsonEncode(account.toJson()),
      aOptions: _androidOptions,
    );
  }
}
