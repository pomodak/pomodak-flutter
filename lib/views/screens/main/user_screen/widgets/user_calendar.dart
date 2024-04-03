import 'package:flutter/material.dart';
import 'package:pomodak/view_models/timer_record_view_model.dart';
import 'package:pomodak/views/screens/main/user_screen/widgets/calendar/calendar.dart';
import 'package:provider/provider.dart';

class UserCalendar extends StatelessWidget {
  const UserCalendar({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final timerRecordViewModel = Provider.of<TimerRecordViewModel>(context);
    final datasets = timerRecordViewModel.recordDatasets;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: ListView(
        shrinkWrap: true,
        children: [
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Calendar(
                datasets: datasets,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
