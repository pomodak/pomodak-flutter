import 'dart:async';

class TimerManager {
  Timer? _timer;
  bool isRunning = false;
  int elapsedSeconds = 0;

  // 타이머를 시작하거나 재개
  void startOrResume({required Function(int) onTickCallback}) {
    if (!isRunning) {
      _timer = Timer.periodic(const Duration(seconds: 1), (_) {
        elapsedSeconds++;
        onTickCallback(elapsedSeconds);
      });
      isRunning = true;
    }
  }

  // 타이머 시간 추가 (포그라운드 전환 시 호출)
  void addTime(int seconds) {
    elapsedSeconds += seconds;
  }

  // 타이머를 일시 정지
  void pause() {
    if (isRunning) {
      _timer?.cancel();
      isRunning = false;
    }
  }

  // 타이머를 정지하고 초기화
  void stop() {
    _timer?.cancel();
    isRunning = false;
    elapsedSeconds = 0;
  }
}
