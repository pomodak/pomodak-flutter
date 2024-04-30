import 'package:flutter/material.dart';
import 'package:pomodak/view_models/app_view_model.dart';
import 'package:pomodak/views/screens/timer/widgets/timer_setting_toggle.dart';
import 'package:provider/provider.dart';

class TimerSettingsRow extends StatelessWidget {
  const TimerSettingsRow({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AppViewModel>(
      builder: (context, vm, child) {
        return Row(
          children: [
            SettingToggle(
              isActive: vm.vibration,
              icon: Icons.vibration,
              label: "진동",
              onTap: () => vm.vibration = !vm.vibration,
            ),
            const SizedBox(width: 16),
            SettingToggle(
              isActive: vm.keepScreenOn,
              icon: Icons.remove_red_eye_outlined,
              label: "화면",
              onTap: () => vm.keepScreenOn = !vm.keepScreenOn,
            ),
          ],
        );
      },
    );
  }
}
