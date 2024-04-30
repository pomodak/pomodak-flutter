import 'package:flutter/material.dart';
import 'package:pomodak/data/repositories/timer_options_repository.dart';
import 'package:pomodak/di.dart';
import 'package:pomodak/view_models/timer_view_model/timer_view_model.dart';

class TimerOptionsViewModel with ChangeNotifier {
  TimerOptionsRepository repository;
  // 변경 시 타이머 초기화
  late bool _isPomodoroMode;
  late int _workTime;
  late int _restTime;
  late int _sections;

  // 변경 시 타이머 초기화 X
  bool _isFocusTogetherMode = false;
  // bool _isScreenAwakeEnabled = false; // 화면 꺼짐 방지 (예정)
  // bool _isVibrationAlarmEnabled = false; // 진동 on/off (예정)

  // 임시 옵션 값 (취소 시 복구를 위해 임시 저장)
  late bool _tempIsPomodoroMode;
  late int _tempWorkTime;
  late int _tempRestTime;
  late int _tempSections;
  late bool _tempIsFocusTogetherMode;

  // 옵션값 Getter
  bool get isPomodoroMode => _isPomodoroMode;
  int get workTime => _workTime;
  int get restTime => _restTime;
  int get sections => _sections;
  bool get isFocusTogetherMode => _isFocusTogetherMode;

  bool get tempIsPomodoroMode => _tempIsPomodoroMode;
  int get tempWorkTime => _tempWorkTime;
  int get tempRestTime => _tempRestTime;
  int get tempSections => _tempSections;
  bool get tempIsFocusTogetherMode => _tempIsFocusTogetherMode;

  TimerOptionsViewModel({required this.repository}) {
    loadOptions();
  }

  void loadOptions() {
    _isPomodoroMode = _tempIsPomodoroMode = repository.getIsPomodoroMode();
    _workTime = _tempWorkTime = repository.getTargetWorkTime();
    _restTime = _tempRestTime = repository.getTargetRestTime();
    _sections = _tempSections = repository.getTargetSections();
    _isFocusTogetherMode =
        _tempIsFocusTogetherMode = repository.getIsFocusTogetherMode();

    notifyListeners();
  }

  // 옵션값 Setter
  set tempIsPomodoroMode(bool value) {
    _tempIsPomodoroMode = value;
    notifyListeners();
  }

  set tempWorkTime(int value) {
    _tempWorkTime = value;
    notifyListeners();
  }

  set tempRestTime(int value) {
    _tempRestTime = value;
    notifyListeners();
  }

  set tempSections(int value) {
    _tempSections = value;
    notifyListeners();
  }

  set tempIsFocusTogetherMode(bool value) {
    _tempIsFocusTogetherMode = value;
    notifyListeners();
  }

  void saveOptions() async {
    // 타이머 초기화 여부 검사 (isFocusTogetherMode를 제외한 나머지 옵션 변경 시 타이머 초기화)
    bool shouldInitTimer = false;
    if (_tempIsPomodoroMode != _isPomodoroMode ||
        _tempWorkTime != _workTime ||
        _tempRestTime != _restTime ||
        _tempSections != _sections) {
      shouldInitTimer = true;
    }

    // 실제 옵션 변경 적용
    _isPomodoroMode = _tempIsPomodoroMode;
    _workTime = _tempWorkTime;
    _restTime = _tempRestTime;
    _sections = _tempSections;
    _isFocusTogetherMode = _tempIsFocusTogetherMode;

    repository.saveTimerOptions(
      isPomodoroMode: _isPomodoroMode,
      isFocusTogetherMode: _isFocusTogetherMode,
      workTime: _workTime,
      restTime: _restTime,
      sections: _sections,
    );

    // 리스너들에게 변경 이벤트 전달
    notifyListeners();
    // notifyListeners()를 통해 timerOptionsViewModel의 변경사항을 적용 후 타이머 초기화
    if (shouldInitTimer) {
      if (isPomodoroMode) {
        getIt<TimerViewModel>().switchPomodoroMode();
      } else {
        getIt<TimerViewModel>().switchNormalMode();
      }
    }
  }

  void cancelChanges() {
    // 임시 옵션값을 현재 옵션값으로 리셋
    _tempIsPomodoroMode = _isPomodoroMode;
    _tempWorkTime = _workTime;
    _tempRestTime = _restTime;
    _tempSections = _sections;
    _tempIsFocusTogetherMode = _isFocusTogetherMode;
    notifyListeners();
  }
}
