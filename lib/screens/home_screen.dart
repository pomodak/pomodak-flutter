import 'package:flutter/material.dart';
import 'package:pomodak/widgets/main_character_display.dart';
import 'package:pomodak/widgets/show_egg_inventory_button.dart';
import 'package:pomodak/widgets/start_button.dart';
import 'package:pomodak/widgets/show_user_guide_button.dart';
import 'package:pomodak/widgets/target_timer_display.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    double widthHalf = MediaQuery.of(context).size.width / 2;

    return Scaffold(
      appBar: AppBar(
        actions: const <Widget>[ShowUserGuideButton()],
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            flex: 1,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  Expanded(
                    flex: 1,
                    child: MainCharacterDisplay(width: widthHalf),
                  ),
                  const TargetTimerDisplay()
                ],
              ),
            ),
          ),
          const Expanded(
            flex: 1,
            child: Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ShowEggInventoryButton(),
                  SizedBox(width: 20),
                  StartButton(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
