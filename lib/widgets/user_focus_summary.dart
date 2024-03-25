import 'package:flutter/material.dart';

class UserFocusSummary extends StatelessWidget {
  const UserFocusSummary({super.key});

  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      height: 110,
      child: Row(
        children: [
          Expanded(
            flex: 1,
            child: SummaryCard(
              title: "Today Focus",
              focusCount: 4,
              focusMinutes: 100,
              isInversed: true,
            ),
          ),
          Expanded(
            flex: 1,
            child: SummaryCard(
              title: "Monthly Focus",
              focusCount: 22,
              focusMinutes: 2331,
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
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: isInversed
                    ? Theme.of(context).colorScheme.onPrimary
                    : Theme.of(context).colorScheme.primary,
              ),
            ),
            Text(
              "$focusCount",
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
                color: isInversed
                    ? Theme.of(context).colorScheme.onPrimary
                    : Theme.of(context).colorScheme.primary,
              ),
            ),
            Text(
              "$focusMinutes min",
              style: TextStyle(
                fontSize: 16,
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
