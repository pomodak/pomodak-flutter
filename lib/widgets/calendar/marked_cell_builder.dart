import 'package:flutter/material.dart';
import 'package:pomodak/constants/cdn_images.dart';

Widget markedCellBuilder(
    BuildContext context, DateTime day, List<Object?> events) {
  if (events.isNotEmpty) {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: events.length,
      itemBuilder: (context, index) {
        return Column(
          children: [
            const SizedBox(height: 20),
            Image.network(
              CDNImages.mascot["normal"]!,
              width: 24,
              height: 24,
            ),
            const Text(
              "12h 53m",
              style: TextStyle(
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
