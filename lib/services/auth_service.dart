import 'dart:async';
import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:pomodak/models/account_model.dart';
import 'package:http/http.dart' as http;
import 'package:pomodak/models/api/api_response_model.dart';
import 'package:pomodak/models/api/auth_response_model.dart';

class AuthService {
  final String _nestApiEndpoint = dotenv.env['NEST_API_ENDPOINT']!;
  AccountModel? _account;

  AndroidOptions _getAndroidOptions() => const AndroidOptions(
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

  Future<bool> loginWithEmail(String email, String password) async {
    final url = Uri.parse('$_nestApiEndpoint/auth/email/login');
    final headers = {'Content-Type': 'application/json'};
    final body = jsonEncode({'email': email, 'password': password});
    try {
      var response = await http.post(
        url,
        headers: headers,
        body: body,
      );
      if (response.statusCode == 200) {
        var data =
            AuthResponseData.fromJson(json.decode(response.body)["data"]);
        await _storeTokens(data.accessToken, data.refreshToken);
        _account = data.account;
        _onAuthStateChange.add(true); // 로그인 성공 알림
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

  // 로그아웃 완료 후 구독자들에게 스트림으로 알림
  Future<void> logOut() async {
    await _storage.delete(key: 'accessToken', aOptions: _getAndroidOptions());
    await _storage.delete(key: 'refreshToken', aOptions: _getAndroidOptions());
    _account = null;
    _onAuthStateChange.add(false); // 로그아웃 알림
  }

  void dispose() {
    _onAuthStateChange.close();
  }

  Future<void> _storeTokens(String accessToken, String refreshToken) async {
    await _storage.write(
        key: 'accessToken', value: accessToken, aOptions: _getAndroidOptions());
    await _storage.write(
        key: 'refreshToken',
        value: refreshToken,
        aOptions: _getAndroidOptions());
  }
}
