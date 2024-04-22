import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pomodak/view_models/timer_state_view_model/timer_state_view_model.dart';
import 'package:provider/provider.dart';

enum StopTimerDialogType {
  stop, // 일반 타이머를 멈출 때
  giveUp, // 포모도로 모드에서 포커스 타이머를 포기할 때
  pass, // 포모도로 모드에서 휴식 타이머를 넘길 때
}

class StopTimerDialog extends StatelessWidget {
  final StopTimerDialogType dialogType;

  const StopTimerDialog({
    super.key,
    required this.dialogType,
  });

  @override
  Widget build(BuildContext context) {
    final timerState = Provider.of<TimerStateViewModel>(context, listen: false);
    return AlertDialog(
      title: const Text(
        "정말 멈추시겠습니까?",
        style: TextStyle(fontSize: 24),
      ),
      surfaceTintColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      actions: <Widget>[
        TextButton(
          child: const Text("취소"),
          onPressed: () => Navigator.of(context).pop(),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.black,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(6),
            ),
          ),
          onPressed: () {
            if (dialogType == StopTimerDialogType.giveUp) {
              timerState.pomodoroGiveUp();
            } else if (dialogType == StopTimerDialogType.pass) {
              timerState.pomodoroPass();
              context.go("/");
            } else if (dialogType == StopTimerDialogType.stop) {
              timerState.normalEnd();
            }
            Navigator.of(context).pop();
          },
          child: const Text(
            "확인",
            style: TextStyle(color: Colors.white),
          ),
        ),
      ],
    );
  }
}
