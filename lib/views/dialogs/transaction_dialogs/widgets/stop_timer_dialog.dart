import 'package:flutter/material.dart';
import 'package:pomodak/di.dart';
import 'package:pomodak/view_models/timer_view_model/timer_view_model.dart';

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
            getIt<TimerViewModel>().timerStop();
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
