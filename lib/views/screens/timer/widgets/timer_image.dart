import 'package:flutter/material.dart';
import 'package:pomodak/config/constants/cdn_images.dart';
import 'package:pomodak/view_models/timer_options_view_model.dart';
import 'package:pomodak/view_models/timer_view_model/timer_view_model.dart';
import 'package:provider/provider.dart';

class TimerImage extends StatelessWidget {
  const TimerImage({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    // 초마다 변경되는 timerState의 elapsedSeconds 값에
    // 이미지 렌더링이 반복되지 않도록 최적화
    return Selector<TimerViewModel, TimerStateInfo>(
      selector: (_, timerState) =>
          TimerStateInfo(timerState.isRunning, timerState.pomodoroMode),
      builder: (_, timerStateInfo, __) {
        final timerOptions =
            Provider.of<TimerOptionsViewModel>(context, listen: false);
        String imageUrl;
        String message;

        if (!timerOptions.isPomodoroMode) {
          // 일반 타이머 모드
          imageUrl = timerStateInfo.isRunning
              ? CDNImages.mascot["animation_work"]!
              : CDNImages.mascot["freeze_work"]!;
          message = "화이팅!!";
        } else {
          // 뽀모도로 타이머 모드
          switch (timerStateInfo.pomodoroMode) {
            case PomodoroMode.focus:
              imageUrl = timerStateInfo.isRunning
                  ? CDNImages.mascot["animation_work"]!
                  : CDNImages.mascot["freeze_work"]!;
              message = "목표가 얼마 안남았닭...!";
              break;
            case PomodoroMode.rest:
              imageUrl = timerStateInfo.isRunning
                  ? CDNImages.mascot["animation_sleep"]!
                  : CDNImages.mascot["freeze_sleep"]!;
              message = "잠깐! 휴식 시간이닭.";
              break;
            default:
              imageUrl = timerStateInfo.isRunning
                  ? CDNImages.mascot["animation_work"]!
                  : CDNImages.mascot["freeze_work"]!;
              message = "목표가 얼마 안남았닭...!";
              break;
          }
        }

        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                SizedBox(
                  width: size.width / 1.6,
                  child: Image.network(
                    imageUrl,
                  ),
                ),
                Text(
                  message,
                  style: const TextStyle(
                    fontSize: 16,
                  ),
                )
              ],
            ),
          ],
        );
      },
    );
  }
}

class TimerStateInfo {
  final bool isRunning;
  final PomodoroMode pomodoroMode;

  TimerStateInfo(this.isRunning, this.pomodoroMode);

  // selector에서 변화를 감지할때 해시코드로 비교(identical)하기 때문에
  // hashCode를 오버라이드하여 감지할 값으로 일관된 해시코드 값을 가지도록 해야함
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is TimerStateInfo &&
        other.isRunning == isRunning &&
        other.pomodoroMode == pomodoroMode;
  }

  @override
  int get hashCode => isRunning.hashCode ^ pomodoroMode.hashCode;
}
