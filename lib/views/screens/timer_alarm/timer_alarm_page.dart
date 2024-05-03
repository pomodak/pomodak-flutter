import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pomodak/models/timer/alarm_info.dart';
import 'package:pomodak/view_models/app_view_model.dart';
import 'package:pomodak/view_models/rewarded_ad_view_model.dart';
import 'package:pomodak/views/screens/timer_alarm/alarm_image_and_message.dart';
import 'package:pomodak/views/widgets/ads/ad_banner.dart';
import 'package:pomodak/views/widgets/custom_button.dart';
import 'package:provider/provider.dart';
import 'package:vibration/vibration.dart';

class TimerAlarmPage extends StatefulWidget {
  const TimerAlarmPage({super.key});

  @override
  State<TimerAlarmPage> createState() => _TimerAlarmPageState();
}

class _TimerAlarmPageState extends State<TimerAlarmPage> {
  late final AlarmInfo alarmInfo;

  @override
  void initState() {
    super.initState();
    alarmInfo = GoRouter.of(context).routerDelegate.currentConfiguration.extra
        as AlarmInfo;
    _triggerVibrationIfNeeded();
  }

  void _triggerVibrationIfNeeded() async {
    final appOptions = context.read<AppViewModel>();

    // 백그라운드에서 온 경우 이미 푸시 알림으로 진동이 울려서 또 진동을 울리지 않도록 함
    if (!alarmInfo.isEndedInBackground &&
        appOptions.vibration &&
        await Vibration.hasVibrator() == true) {
      Vibration.vibrate(duration: 400);
    }
  }

  @override
  Widget build(BuildContext context) {
    var rewardedAdViewModel = context.watch<RewardedAdViewModel>();
    return Scaffold(
      body: Column(
        children: <Widget>[
          Expanded(
            flex: 5,
            child: AlarmImageAndMessage(
              alarmInfo: alarmInfo,
            ),
          ),
          Expanded(
            flex: 4,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  if (alarmInfo.earnedPoints != null &&
                      alarmInfo.earnedPoints! > 0)
                    Text(
                      "${alarmInfo.earnedPoints} 포인트를 획득했습니다!",
                      style: const TextStyle(fontSize: 16),
                    ),
                  Column(
                    children: <Widget>[
                      if (alarmInfo.earnedPoints != null &&
                          alarmInfo.earnedPoints! > 0)
                        CustomButton(
                          icon: const Icon(Icons.ad_units, color: Colors.white),
                          onTap: () {
                            rewardedAdViewModel.showRewardedAd(
                                points: alarmInfo.earnedPoints!);
                          },
                          disabled: !rewardedAdViewModel.isAdReady,
                          backgroundColor: Colors.blue,
                          textColor: Colors.white,
                          text: rewardedAdViewModel.isAdReady
                              ? "광고보고 두배로 받기 !!"
                              : "광고 로딩중...",
                        ),
                      const SizedBox(height: 12),
                      CustomButton(
                        onTap: () {
                          context.go('/');
                        },
                        text: "확인",
                      ),
                    ],
                  ),
                  const AdBanner(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
