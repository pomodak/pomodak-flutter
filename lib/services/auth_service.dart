import 'dart:async';

class AuthService {
  // broadcast 스트림 컨트롤러 생성 (여러 리스너가 동일한 스트림에 구독 가능하게 됨)
  final StreamController<bool> _onAuthStateChange =
      StreamController.broadcast();

  // 외부에서 스트림에 접근할 수 있도록 getter제공
  // (로그인 상태 리스닝)
  Stream<bool> get onAuthStateChange => _onAuthStateChange.stream;

  // 로그인 완료 후 구독자들에게 스트림으로 알림
  Future<bool> login() async {
    await Future.delayed(const Duration(seconds: 1));

    _onAuthStateChange.add(true);
    return true;
  }

  // 로그아웃 완료 후 구독자들에게 스트림으로 알림
  void logOut() {
    _onAuthStateChange.add(false);
  }
}
