import 'package:flutter/material.dart';

Widget selectedCellBuilder(
  BuildContext context,
  DateTime day,
  DateTime focusedDay,
) {
  return Container(
    padding: const EdgeInsets.only(top: 4),
    child: Container(
      decoration: BoxDecoration(
        color: const Color.fromARGB(31, 113, 113, 113),
        borderRadius: BorderRadius.circular(6),
      ),
      child: SizedBox(
        width: 44,
        child: Column(
          children: [
            Text(
              '${day.day}',
              style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue.shade500),
            ),
          ],
        ),
      ),
    ),
  );
}
