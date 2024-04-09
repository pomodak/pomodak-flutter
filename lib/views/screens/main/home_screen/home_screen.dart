import 'package:flutter/material.dart';
import 'package:pomodak/utils/local_notification_util.dart';
import 'package:pomodak/view_models/timer_options_view_model.dart';
import 'package:pomodak/views/screens/main/home_screen/widgets/show_user_guide_button.dart';
import 'package:pomodak/views/screens/main/home_screen/widgets/main_character_display.dart';
import 'package:pomodak/views/screens/main/home_screen/widgets/show_egg_inventory_button.dart';
import 'package:pomodak/views/screens/main/home_screen/widgets/timer_start_button.dart';
import 'package:pomodak/views/screens/main/home_screen/widgets/timer_section_counter.dart';
import 'package:pomodak/views/screens/main/home_screen/widgets/timer_target_display.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatelessWidget {
  final VoidCallback onNavigateToShop;
  const HomeScreen({super.key, required this.onNavigateToShop});

  @override
  Widget build(BuildContext context) {
    final timerOptionsViewModel = Provider.of<TimerOptionsViewModel>(context);

    return Scaffold(
      appBar: AppBar(
        actions: const <Widget>[ShowUserGuideButton()],
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  const Expanded(
                    flex: 1,
                    child: MainCharacterDisplay(),
                  ),
                  const TimerTargetDisplay(),
                  const SizedBox(
                    height: 10,
                  ),
                  if (timerOptionsViewModel.isPomodoroMode)
                    const TimerSectionCounter(),
                ],
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ShowEggInventoryButton(onNavigateToShop: onNavigateToShop),
                  const SizedBox(
                    width: 10,
                  ),
                  const TimerStartButton(),
                  GestureDetector(
                    onTap: () {
                      LocalNotificationUtil.test();
                    },
                    child: const Icon(Icons.notifications),
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
