import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:pomodak/config/constants/cdn_images.dart';
import 'package:pomodak/view_models/timer_options_view_model.dart';
import 'package:pomodak/view_models/timer_view_model/pomodoro_timer.dart';
import 'package:pomodak/view_models/timer_view_model/timer_view_model.dart';
import 'package:provider/provider.dart';

final List<String> commonMessages = [
  '저를 클릭해보세요!',
  '날씨가 좋네요~',
  '오늘도 화이팅!',
  '다양한 캐릭터를 수집해보세요!',
  '함께 공부할까요?',
  '알을 구매하고 키워보세요!',
];

final List<String> focusMessages = [
  ...commonMessages,
  '준비되셨나요?',
  '집중력을 보여 주세요!',
  '딴 짓 하지 마세요!',
  '집중하면 뭐든 할 수 있어요!',
];
final List<String> restMessages = [
  ...commonMessages,
  '쉬는 시간이에요!',
  '조금만 쉬어요~~',
  '잠깐 쉴래요 ㅜㅜ',
  '지쳤어요 ㅜㅜ',
  '윽!! 쓰러졌다!',
  '조금만 쉬고 다시 화이팅해요!',
];
final List<String> normalMessages = [
  ...focusMessages,
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
    final timerState = Provider.of<TimerViewModel>(context);
    final imageUrl = timerState.pomodoroPhase == PomodoroPhase.focus
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
              bottom: size.width / 2 - 30,
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
    final isPomodoroMode = context.read<TimerOptionsViewModel>().isPomodoroMode;
    final pomodoroPhase = context.read<TimerViewModel>().pomodoroPhase;

    List<String> messages = isPomodoroMode
        ? (pomodoroPhase == PomodoroPhase.focus ? focusMessages : restMessages)
        : normalMessages;

    _showRandomMessage(messages);
    _hideMessageAfterDelay();
  }
}
