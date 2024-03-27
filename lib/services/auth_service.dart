import 'dart:async';
import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:pomodak/models/account_model.dart';
import 'package:http/http.dart' as http;
import 'package:pomodak/models/api/api_response_model.dart';
import 'package:pomodak/models/api/auth_response_model.dart';
import 'package:pomodak/utils/api_util.dart';

class AuthService {
  final String _nestApiEndpoint = dotenv.env['NEST_API_ENDPOINT']!;
  AccountModel? _account;

  final AndroidOptions _androidOptions = const AndroidOptions(
    encryptedSharedPreferences: true,
  );
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  // broadcast 스트림 컨트롤러 생성 (여러 리스너가 동일한 스트림에 구독 가능하게 됨)
  final StreamController<bool> _onAuthStateChange =
      StreamController.broadcast();
  // 외부에서 스트림에 접근할 수 있도록 getter제공
  // (로그인 상태 리스닝)
  Stream<bool> get onAuthStateChange => _onAuthStateChange.stream;

  // 계정 정보에 접근하기 위한 getter
  AccountModel? get account => _account;

  AuthService() {
    _loadAccount();
  }

  Future<void> _loadAccount() async {
    try {
      final accountJson =
          await _storage.read(key: 'account', aOptions: _androidOptions);
      if (accountJson != null) {
        _account = AccountModel.fromJson(json.decode(accountJson));
        _onAuthStateChange.add(_account != null);
      }
    } catch (e) {
      // 에러 존재 시 잘못된 데이터임으로 정리
      logOut();
    }
  }

  Future<bool> loginWithEmail(String email, String password) async {
    try {
      var response = await ApiUtil.postData(
        '$_nestApiEndpoint/auth/email/login',
        {'email': email, 'password': password},
      );
      if (response.statusCode == 200) {
        var data =
            AuthResponseData.fromJson(json.decode(response.body)["data"]);

        await _storeTokens(data.accessToken, data.refreshToken, data.expiresIn);
        await _storeAccount(data.account);
        _onAuthStateChange.add(true); // 스트림에 알림

        return true;
      } else {
        var data = ApiFailResponse.fromJson(json.decode(response.body));
        print(data.message); // 에러 메세지
        _account = null;
        _onAuthStateChange.add(false);
        return false;
      }
    } catch (e) {
      _account = null;
      _onAuthStateChange.add(false);
      return false;
    }
  }

  // 리프레시 필요 시 리프레시 후 accessToken 반환
  Future<String?> refreshTokenIfNeeded() async {
    final refreshToken = await _storage.read(key: 'refreshToken');
    final expiresInStr = await _storage.read(key: 'expiresIn');
    final now = DateTime.now().millisecondsSinceEpoch;
    final expiresIn = int.tryParse(expiresInStr ?? '0') ?? 0;

    if (now >= expiresIn) {
      final response = await http.post(
        Uri.parse('$_nestApiEndpoint/auth/refresh'),
        headers: {
          "Authorization": 'Bearer $refreshToken',
        },
      );

      if (response.statusCode == 200) {
        var data =
            RefreshResponseData.fromJson(json.decode(response.body)["data"]);
        await _storeTokens(data.accessToken, data.refreshToken, data.expiresIn);
        // 새로운 expiresIn 계산 및 저장
        return data.accessToken;
      } else {
        // 로그아웃 처리
        await logOut();
        return null;
      }
    }

    return await _storage.read(key: 'accessToken');
  }

  // 로그아웃 완료 후 구독자들에게 스트림으로 알림
  Future<void> logOut() async {
    await _storage.deleteAll(aOptions: _androidOptions);
    _account = null;
    _onAuthStateChange.add(false); // 로그아웃 알림
  }

  void dispose() {
    _onAuthStateChange.close();
  }

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

  Future<void> _storeAccount(AccountModel account) async {
    _account = account;
    await _storage.write(
      key: 'account',
      value: jsonEncode(account.toJson()),
      aOptions: _androidOptions,
    );
  }
}
