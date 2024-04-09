import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:pomodak/config/constants/cdn_images.dart';
import 'package:pomodak/view_models/timer_options_view_model.dart';
import 'package:pomodak/view_models/timer_state_view_model/timer_state_view_model.dart';
import 'package:provider/provider.dart';

final List<String> focusMessages = [
  "뽀모도로 집중 모드 메세지 1",
  "뽀모도로 집중 모드 메세지 2",
  "뽀모도로 집중 모드 메세지 3",
];
final List<String> restMessages = [
  "뽀모도로 휴식 모드 메세지 1",
  "뽀모도로 휴식 모드 메세지 2",
  "뽀모도로 휴식 모드 메세지 3",
];
final List<String> normalMessages = [
  "일반 모드 메세지 1",
  "일반 모드 메세지 2",
  "일반 모드 메세지 3",
];

class MainCharacterDisplay extends StatefulWidget {
  const MainCharacterDisplay({super.key});

  @override
  State<MainCharacterDisplay> createState() => _MainCharacterDisplayState();
}

class _MainCharacterDisplayState extends State<MainCharacterDisplay> {
  Timer? _messageTimer;
  String _currentMessage = '';
  bool _showMessage = false;

  void _showRandomMessage(List<String> messages) {
    if (!mounted) return;
    setState(() {
      _currentMessage = messages[Random().nextInt(messages.length)];
      _showMessage = true;
    });
  }

  void _hideMessageAfterDelay() {
    Future.delayed(const Duration(seconds: 3), () {
      if (!mounted) return;
      setState(() => _showMessage = false);
    });
  }

  void _handleMessageDisplay() {
    final timerOptions =
        Provider.of<TimerOptionsViewModel>(context, listen: false);
    final timerState = Provider.of<TimerStateViewModel>(context, listen: false);

    List<String> messages = timerOptions.isPomodoroMode
        ? (timerState.pomodoroMode == PomodoroMode.focus
            ? focusMessages
            : restMessages)
        : normalMessages;

    _showRandomMessage(messages);
    _hideMessageAfterDelay();
  }

  @override
  void initState() {
    super.initState();
    _messageTimer = Timer.periodic(const Duration(seconds: 10), (timer) {
      if (!_showMessage && mounted) {
        _handleMessageDisplay();
      }
    });
  }

  @override
  void dispose() {
    _messageTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final timerState = Provider.of<TimerStateViewModel>(context);
    final imageUrl = timerState.pomodoroMode == PomodoroMode.focus
        ? CDNImages.mascot["normal"]!
        : CDNImages.mascot["exhausted"]!;

    return GestureDetector(
      onTap: () {
        if (!_showMessage) {
          _handleMessageDisplay();
        }
      },
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          Image.network(
            imageUrl,
            width: size.width / 2,
            fit: BoxFit.contain,
          ),
          if (_showMessage)
            Positioned(
              bottom: size.width / 2 - 20,
              left: 0,
              right: 0,
              child: Container(
                color: Colors.white.withAlpha(180),
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                child: Text(
                  _currentMessage,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
