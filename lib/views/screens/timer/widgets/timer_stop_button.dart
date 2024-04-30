import 'package:flutter/material.dart';
import 'package:pomodak/view_models/timer_options_view_model.dart';
import 'package:pomodak/view_models/timer_view_model/timer_view_model.dart';
import 'package:pomodak/views/dialogs/transaction_dialogs/transaction_dialog_manager.dart';
import 'package:pomodak/views/dialogs/transaction_dialogs/widgets/stop_timer_dialog.dart';
import 'package:provider/provider.dart';

class TimerStopButton extends StatelessWidget {
  const TimerStopButton({super.key});

  @override
  Widget build(BuildContext context) {
    String text;
    final timerOptions = Provider.of<TimerOptionsViewModel>(context);
    final timerState = Provider.of<TimerViewModel>(context, listen: false);

    final StopTimerDialogType dialogType;
    if (!timerOptions.isPomodoroMode) {
      dialogType = StopTimerDialogType.stop;
      text = "Stop";
    } else {
      if (timerState.pomodoroMode == PomodoroMode.focus) {
        dialogType = StopTimerDialogType.giveUp;
        text = "Give up";
      } else {
        dialogType = StopTimerDialogType.pass;
        text = "Pass";
      }
    }

    return ElevatedButton(
      onPressed: () => TransactionDialogManager.showStopTimerDialog(
        context,
        dialogType,
      ),
      style: ElevatedButton.styleFrom(
        minimumSize: const Size(160, 48),
        backgroundColor: Theme.of(context).colorScheme.onPrimary,
        foregroundColor: Theme.of(context).colorScheme.primary,
        elevation: 0,
      ),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
