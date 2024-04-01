import 'package:flutter/material.dart';
import 'package:pomodak/config/constants/cdn_images.dart';
import 'package:pomodak/view_models/timer_options_view_model.dart';
import 'package:pomodak/view_models/timer_state_view_model.dart';
import 'package:provider/provider.dart';

class TimerImage extends StatelessWidget {
  const TimerImage({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final timerOptions =
        Provider.of<TimerOptionsViewModel>(context, listen: false);
    final timerState = Provider.of<TimerStateViewModel>(context, listen: false);
    String imageUrl;
    String message;

    if (!timerOptions.isPomodoroMode) {
      // 일반 타이머 모드
      imageUrl = CDNImages.mascot["animation_work"]!;
      message = "화이팅!!";
    } else {
      // 뽀모도로 타이머 모드
      switch (timerState.pomodoroMode) {
        case PomodoroMode.focus:
          imageUrl = CDNImages.mascot["animation_work"]!;
          message = "목표가 얼마 안남았닭...!";
          break;
        case PomodoroMode.rest:
          imageUrl = CDNImages.mascot["animation_sleep"]!;
          message = "잠깐! 휴식 시간이닭.";
          break;
        default:
          imageUrl = CDNImages.mascot["animation_work"]!;
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
  }
}
