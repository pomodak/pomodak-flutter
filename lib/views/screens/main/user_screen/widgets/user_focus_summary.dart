import 'package:flutter/material.dart';
import 'package:pomodak/view_models/timer_record_view_model.dart';
import 'package:provider/provider.dart';

class UserFocusSummary extends StatelessWidget {
  const UserFocusSummary({super.key});

  @override
  Widget build(BuildContext context) {
    DateTime now = DateTime.now();
    final timerRecordViewModel = Provider.of<TimerRecordViewModel>(context);
    final monthlyStatistics =
        timerRecordViewModel.getMonthlyStatistics(now.year, now.month);
    final todayRecord =
        timerRecordViewModel.getTimerRecordByDate(now.year, now.month, now.day);

    return SizedBox(
      height: 100,
      child: Row(
        children: [
          Expanded(
            flex: 1,
            child: SummaryCard(
              title: "Today Focus",
              focusCount: todayRecord?.totalCompleted ?? 0,
              focusMinutes: (todayRecord?.totalSeconds ?? 0) ~/ 60,
              isInversed: true,
            ),
          ),
          Expanded(
            flex: 1,
            child: SummaryCard(
              title: "Monthly Focus",
              focusCount: monthlyStatistics.totalCompleted,
              focusMinutes: monthlyStatistics.totalSeconds ~/ 60,
              isInversed: false,
            ),
          ),
        ],
      ),
    );
  }
}

class SummaryCard extends StatelessWidget {
  final String title;
  final int focusCount, focusMinutes;
  final bool isInversed;

  const SummaryCard({
    super.key,
    required this.title,
    required this.focusCount,
    required this.focusMinutes,
    required this.isInversed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: isInversed
            ? Theme.of(context).colorScheme.primary
            : Theme.of(context).colorScheme.onPrimary,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: isInversed
                    ? Theme.of(context).colorScheme.onPrimary
                    : Theme.of(context).colorScheme.primary,
              ),
            ),
            Text(
              "$focusCount",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: isInversed
                    ? Theme.of(context).colorScheme.onPrimary
                    : Theme.of(context).colorScheme.primary,
              ),
            ),
            Text(
              "$focusMinutes min",
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: isInversed
                    ? Theme.of(context).colorScheme.onPrimary
                    : Theme.of(context).colorScheme.primary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
