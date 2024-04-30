import 'dart:async';
import 'package:flutter/material.dart';

class BaseTimer {
  Timer? _timer;
  bool isRunning = false;
  int elapsedSeconds = 0;

  /// 타이머 시작 (onUpdate: UI 업데이트 콜백)
  /// 타이머가 이미 실행 중일 경우 무시됨
  void start({required VoidCallback onUpdate}) {
    if (!isRunning) {
      _timer = Timer.periodic(const Duration(seconds: 1), (_) {
        tick();
        onUpdate(); // UI 업데이트를 위한 콜백 호출
        if (shouldEnd()) {
          endSession();
          onUpdate(); // 세션 종료 후 UI 업데이트를 위한 콜백 호출
        }
      });
      isRunning = true;
    }
  }

  /// 타이머 중지 (interuptSession() 호출)
  /// interuptSession가 수행된 후 reset()을 통해 상태 초기화
  void stop() {
    _timer?.cancel();
    isRunning = false;
    interuptSession();
    reset();
  }

  /// 타이머 일시정지 (elapsedSeconds는 유지하고 타이머만 중지)
  void pause() {
    if (isRunning) {
      _timer?.cancel();
      isRunning = false;
    }
  }

  /// elapsedSeconds 업데이트
  void tick() {
    elapsedSeconds++;
  }

  /// elapsedSeconds 초기화
  void reset() {
    elapsedSeconds = 0;
  }

  /// 타이머가 끝나야 하는지 확인
  /// tick() 호출 후 호출 되며 true일 경우 endSession() 호출
  bool shouldEnd() {
    return false;
  }

  /// 타이머 종료(shouldEnd) 후 처리할 작업 (알람, 다음 세션, 기록 저장 등)
  void endSession() {}

  /// 타이머 중단(stop) 후 처리할 작업 (알람, 다음 세션, 기록 저장 등)
  void interuptSession() {}
}
