/// setPausedAt() 을 호출하면 현재 시간을 pausedAt 에 저장하고
/// getTimerGapSeconds() 를 호출하면 pausedAt 에 저장된 시간과 현재 시간의 차이를 초 단위로 반환한다.
class TimerDifferenceHandler {
  static late DateTime pausedAt;

  static final TimerDifferenceHandler _instance = TimerDifferenceHandler();

  static TimerDifferenceHandler get instance => _instance;

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
