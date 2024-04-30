abstract class TimerMode {
  void start(); // 타이머 시작
  void stop(); // 타이머 중지
  void pause(); // 타이머 일시정지
  void tick(); // 시간 업데이트
  void resume(); // 타이머 재개
  void reset(); // 타이머 초기화
  bool shouldEnd(); // 타이머가 끝나야 하는지 확인 (뽀모도로 종료 체크)
  void endSession(); // 타이머 종료 후 처리
  void interuptSession(); // 타이머 임의 종료 후 처리
}
