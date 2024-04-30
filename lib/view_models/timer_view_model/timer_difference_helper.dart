/// pausedAt : 백그라운드로 전환된 시간
///
/// setPausedAt() : 현재 시간을 pausedAt에 저장
///
/// getTimerGapSeconds() : pausedAt와 현재 시간의 차이를 초 단위로 반환
///
/// (백그라운드 / 포그라운드 전환 시 사용)
class TimerDifferenceHelper {
  static late DateTime pausedAt;

  int getTimerGapSeconds() {
    final DateTime dateTimeNow = DateTime.now();
    final Duration gapTime = dateTimeNow.difference(pausedAt);
    final int gapSeconds = gapTime.inSeconds;
    return gapSeconds;
  }

  void setPuasedAt() {
    final DateTime dateTimeNow = DateTime.now();
    pausedAt = dateTimeNow;
  }
}
