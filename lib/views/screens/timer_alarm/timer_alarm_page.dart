import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pomodak/config/constants/cdn_images.dart';
import 'package:pomodak/utils/format_util.dart';
import 'package:pomodak/view_models/app_view_model.dart';
import 'package:pomodak/views/widgets/custom_button.dart';
import 'package:provider/provider.dart';
import 'package:vibration/vibration.dart';

class TimerAlarmPage extends StatelessWidget {
  const TimerAlarmPage({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final state = GoRouter.of(context).routerDelegate.currentConfiguration;
    final alarmInfo = state.extra as AlarmInfo;

    void triggerVibration() async {
      var appOptions = Provider.of<AppViewModel>(context, listen: false);
      if (await Vibration.hasVibrator() == true && appOptions.vibration) {
        Vibration.vibrate(duration: 1000);
      }
    }

    // 백그라운드에서 온 경우 이미 푸시 알림으로 진동이 울림
    if (!alarmInfo.isEndedInBackground) {
      triggerVibration();
    }

    final String imageUrl;
    final String message;

    if (alarmInfo.alarmType == AlarmType.work) {
      imageUrl = CDNImages.mascot["exhausted"]!;
      message = "닭이 지쳤습니다. 잠시 휴식을 취해주세요!";
    } else if (alarmInfo.alarmType == AlarmType.rest) {
      imageUrl = CDNImages.mascot["wakeup"]!;
      message = "닭이 잠에서 깨어났습니다. 다시 집중해주세요!!";
    } else if (alarmInfo.alarmType == AlarmType.finish) {
      imageUrl = CDNImages.mascot["finish"]!;
      message = "한 섹션을 마무리했습니다. 충분한 휴식을 취해주세요!";
    } else if (alarmInfo.alarmType == AlarmType.giveup) {
      imageUrl = CDNImages.mascot["exhausted"]!;
      message = "닭이 포기했습니다 ㅜㅜ 다시 화이팅해서 도전해보세요!";
    } else {
      // normal & 그 외
      imageUrl = CDNImages.mascot["finish"]!;
      if (alarmInfo.time < 60) {
        message = "이야~~ ${alarmInfo.time}초나 집중하다니 정말 대단해!!";
      } else {
        message =
            "이야~~ ${FormatUtil.formatSeconds(alarmInfo.time)}만큼 집중하다니 정말 대단해!!";
      }
    }

    return Scaffold(
      body: Column(
        children: <Widget>[
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                SizedBox(
                  width: size.width / 2,
                  child: Image.network(
                    imageUrl,
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 40),
                  child: Text(
                    message,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 16,
                    ),
                    softWrap: true,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  CustomButton(
                    onTap: () {
                      context.go('/');
                    },
                    text: "확인",
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

enum AlarmType { work, rest, finish, normal, giveup }

class AlarmInfo {
  final AlarmType alarmType;
  final int time;
  final bool isEndedInBackground;

  AlarmInfo({
    required this.alarmType,
    required this.time,
    required this.isEndedInBackground,
  });
}
