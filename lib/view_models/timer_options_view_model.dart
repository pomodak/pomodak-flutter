import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

const defaultPomodoroMode = true;
const defaultWorkTime = 25;
const defaultRestTime = 5;
const defaultSections = 4;

class TimerOptionsViewModel with ChangeNotifier {
  late final SharedPreferences sharedPreferences;

  // 변경 시 타이머 초기화
  bool _isPomodoroMode = defaultPomodoroMode;
  int _workTime = defaultWorkTime;
  int _restTime = defaultWorkTime;
  int _sections = defaultWorkTime;

  // 변경 시 타이머 초기화 X
  bool _isFocusTogetherMode = false;
  // bool _isScreenAwakeEnabled = false; // 화면 꺼짐 방지 (예정)
  // bool _isVibrationAlarmEnabled = false; // 진동 on/off (예정)

  // 임시 옵션 값 (취소 시 복구를 위해 임시 저장)
  bool _tempIsPomodoroMode = defaultPomodoroMode;
  int _tempWorkTime = defaultWorkTime;
  int _tempRestTime = defaultWorkTime;
  int _tempSections = defaultWorkTime;
  bool _tempIsFocusTogetherMode = false;

  // 옵션값 Getter
  bool get isPomodoroMode => _isPomodoroMode;
  int get workTime => _workTime;
  int get restTime => _restTime;
  int get sections => _sections;
  bool get isFocusTogetherMode => _isFocusTogetherMode;

  // 최근 변경 된 옵션(타이머 초기화 여부 확인용)
  TimerOptionsChangedEvent? _lastEvent;
  TimerOptionsChangedEvent? get lastEvent => _lastEvent;

  TimerOptionsViewModel({required this.sharedPreferences}) {
    loadOptions();
  }

  // 옵션값 Setter
  set isPomodoroMode(bool value) {
    _tempIsPomodoroMode = value;
    _lastEvent = null; // temp 값의 변화로인해 timerState가 리셋되지 않도록 함
    notifyListeners();
  }

  set workTime(int value) {
    _tempWorkTime = value;
    _lastEvent = null;
    notifyListeners();
  }

  set restTime(int value) {
    _tempRestTime = value;
    _lastEvent = null;
    notifyListeners();
  }

  set sections(int value) {
    _tempSections = value;
    _lastEvent = null;
    notifyListeners();
  }

  set isFocusTogetherMode(bool value) {
    _tempIsFocusTogetherMode = value;
    _lastEvent = null;
    notifyListeners();
  }

  void saveOptions() async {
    // 실제 옵션 변경 적용
    _isPomodoroMode = _tempIsPomodoroMode;
    _workTime = _tempWorkTime;
    _restTime = _tempRestTime;
    _sections = _tempSections;
    _isFocusTogetherMode = _tempIsFocusTogetherMode;

    await sharedPreferences.setBool("isPomodoroMode", _isPomodoroMode);
    await sharedPreferences.setInt("workTime", _workTime);
    await sharedPreferences.setInt("restTime", _restTime);
    await sharedPreferences.setInt("sections", _sections);
    await sharedPreferences.setBool(
        "isFocusTogetherMode", _isFocusTogetherMode);

    // 변경사항 검사
    _lastEvent = TimerOptionsChangedEvent(
      isPomodoroModeChanged: _tempIsPomodoroMode != _isPomodoroMode,
      workTimeChanged: _tempWorkTime != _workTime,
      restTimeChanged: _tempRestTime != _restTime,
      sectionsChanged: _tempSections != _sections,
      isFocusTogetherModeChanged:
          _tempIsFocusTogetherMode != _isFocusTogetherMode,
    );

    // 리스너들에게 변경 이벤트 전달
    notifyListeners();
  }

  void loadOptions() {
    _isPomodoroMode =
        sharedPreferences.getBool("isPomodoroMode") ?? defaultPomodoroMode;
    _workTime = sharedPreferences.getInt("workTime") ?? defaultWorkTime;
    _restTime = sharedPreferences.getInt("restTime") ?? defaultRestTime;
    _sections = sharedPreferences.getInt("sections") ?? defaultSections;
    _isFocusTogetherMode =
        sharedPreferences.getBool("isFocusTogetherMode") ?? false;

    notifyListeners();
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

class TimerOptionsChangedEvent {
  final bool isPomodoroModeChanged;
  final bool workTimeChanged;
  final bool restTimeChanged;
  final bool sectionsChanged;
  final bool isFocusTogetherModeChanged;

  TimerOptionsChangedEvent({
    this.isPomodoroModeChanged = false,
    this.workTimeChanged = false,
    this.restTimeChanged = false,
    this.sectionsChanged = false,
    this.isFocusTogetherModeChanged = false,
  });
}
