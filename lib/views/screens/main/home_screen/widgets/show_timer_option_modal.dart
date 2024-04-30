import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pomodak/view_models/timer_options_view_model.dart';

void showTimerOptionsModal(BuildContext context) {
  showDialog(
    barrierDismissible: false,
    context: context,
    builder: (context) => const TimerOptionsModal(),
  );
}

class TimerOptionsModal extends StatefulWidget {
  const TimerOptionsModal({super.key});

  @override
  State<TimerOptionsModal> createState() => _TimerOptionsModalState();
}

class _TimerOptionsModalState extends State<TimerOptionsModal> {
  List<int> availableFocusOptions = [
    1,
    5,
    10,
    15,
    20,
    25,
    30,
    40,
    50,
    60,
    90,
    120
  ];
  List<int> availableRestOptions = [1, 3, 5, 10, 15, 20, 25, 30];
  List<int> availableSectionOptions = [2, 3, 4, 5, 6, 7, 8];

  @override
  Widget build(BuildContext context) {
    final timerOptionsViewModel = Provider.of<TimerOptionsViewModel>(context);

    return Dialog(
      surfaceTintColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      insetPadding: const EdgeInsets.symmetric(horizontal: 16),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("타이머 설정",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 2),
            TimerOptionAdjuster(
              label: "집중 시간",
              currentValue: timerOptionsViewModel.tempWorkTime,
              availableOptions: availableFocusOptions,
              isEnabled: timerOptionsViewModel.tempIsPomodoroMode,
              onAdjust: (newValue) =>
                  setState(() => timerOptionsViewModel.tempWorkTime = newValue),
            ),
            const SizedBox(height: 2),
            TimerOptionAdjuster(
              label: "쉬는 시간",
              currentValue: timerOptionsViewModel.tempRestTime,
              availableOptions: availableRestOptions,
              isEnabled: timerOptionsViewModel.tempIsPomodoroMode,
              onAdjust: (newValue) =>
                  setState(() => timerOptionsViewModel.tempRestTime = newValue),
            ),
            const SizedBox(height: 2),
            TimerOptionAdjuster(
              label: "집중 세션",
              postFix: " 집중",
              currentValue: timerOptionsViewModel.tempSections,
              availableOptions: availableSectionOptions,
              isEnabled: timerOptionsViewModel.tempIsPomodoroMode,
              onAdjust: (newValue) =>
                  setState(() => timerOptionsViewModel.tempSections = newValue),
            ),
            const SizedBox(height: 2),
            _buildToggleSwitch(
              "뽀모도로 모드",
              timerOptionsViewModel.tempIsPomodoroMode,
              (newValue) => setState(
                  () => timerOptionsViewModel.tempIsPomodoroMode = newValue),
            ),
            const SizedBox(height: 2),
            _buildToggleSwitch(
              "함께 집중하기 모드",
              timerOptionsViewModel.tempIsFocusTogetherMode,
              (newValue) => setState(() =>
                  timerOptionsViewModel.tempIsFocusTogetherMode = newValue),
            ),
            const SizedBox(height: 12),
            _buildActionButtons(context),
          ],
        ),
      ),
    );
  }

  Widget _buildToggleSwitch(
      String label, bool currentValue, Function(bool) onChanged) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: const TextStyle(fontSize: 14)),
        SizedBox(
          width: 150,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Switch(value: currentValue, onChanged: onChanged),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    final timerOptionsViewModel =
        Provider.of<TimerOptionsViewModel>(context, listen: false);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              surfaceTintColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(6),
              ),
            ),
            onPressed: () {
              timerOptionsViewModel.cancelChanges();
              Navigator.of(context).pop();
            },
            child: const Text("취소"),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.black,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(6),
              ),
            ),
            onPressed: () {
              timerOptionsViewModel.saveOptions();
              Navigator.of(context).pop();
            },
            child: const Text(
              "저장",
              style: TextStyle(color: Colors.white),
            ),
          ),
        ),
      ],
    );
  }
}

class TimerOptionAdjuster extends StatelessWidget {
  final String label;
  final int currentValue;
  final List<int> availableOptions;
  final Function(int) onAdjust;
  final bool isEnabled;
  final String? postFix;

  const TimerOptionAdjuster({
    super.key,
    required this.label,
    required this.currentValue,
    required this.availableOptions,
    required this.onAdjust,
    this.isEnabled = true,
    this.postFix = "분",
  });

  @override
  Widget build(BuildContext context) {
    int currentIndex = availableOptions.indexOf(currentValue);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
            child: Text(
          label,
          style: TextStyle(fontSize: 14, color: isEnabled ? null : Colors.grey),
        )),
        Row(
          children: [
            IconButton(
              icon: Icon(
                Icons.remove,
                color: isEnabled ? null : Colors.grey,
              ),
              onPressed: isEnabled && currentIndex > 0
                  ? () => onAdjust(availableOptions[currentIndex - 1])
                  : null,
            ),
            SizedBox(
              width: 50,
              child: Text(
                "$currentValue$postFix",
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 14, color: isEnabled ? null : Colors.grey),
              ),
            ),
            IconButton(
              icon: Icon(
                Icons.add,
                color: isEnabled ? null : Colors.grey,
              ),
              onPressed: isEnabled && currentIndex < availableOptions.length - 1
                  ? () => onAdjust(availableOptions[currentIndex + 1])
                  : null,
            ),
          ],
        ),
      ],
    );
  }
}
