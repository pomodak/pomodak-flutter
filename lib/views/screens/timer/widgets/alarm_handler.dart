import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pomodak/models/timer/alarm_info.dart';
import 'package:pomodak/view_models/timer_alarm_view_model.dart';

void checkForAlarm(BuildContext context, TimerAlarmViewModel viewModel) {
  final alarmInfo = viewModel.lastAlarmInfo;
  if (alarmInfo != null) {
    context.go(
      "/timer-alarm",
      extra: AlarmInfo(
        alarmType: alarmInfo.alarmType, // 마지막 알람 타입
        time: alarmInfo.time, // 경과 시간
        isEndedInBackground: alarmInfo.isEndedInBackground, // 백그라운드에서 종료됐는지 여부
      ),
    );
    viewModel.reset();
  }
}
