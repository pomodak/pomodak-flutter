import 'package:flutter/material.dart';
import 'package:pomodak/config/constants/cdn_images.dart';
import 'package:pomodak/utils/format_util.dart';

Widget markedCellBuilder(
    BuildContext context, DateTime day, List<Object?> events) {
  if (events.isNotEmpty) {
    String time = FormatUtil.formatSecondsForMark(events[0] as int);

    return ListView.builder(
      shrinkWrap: true,
      itemCount: events.length,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        return Column(
          children: [
            const SizedBox(height: 20),
            Image.network(
              CDNImages.mascot["normal"]!,
              width: 24,
              height: 24,
            ),
            Text(
              time,
              style: const TextStyle(
                fontSize: 12,
              ),
            )
          ],
        );
      },
    );
  }
  return const SizedBox(
    height: 76,
  );
}
