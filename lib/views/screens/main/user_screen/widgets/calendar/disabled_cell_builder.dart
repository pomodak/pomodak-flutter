import 'package:flutter/material.dart';

Widget disabledCellBuilder(
  BuildContext context,
  DateTime day,
  DateTime focusedDay,
) {
  return Container(
    padding: const EdgeInsets.only(top: 4),
    child: SizedBox(
      child: Column(
        children: [
          Text(
            '${day.day}',
            style: TextStyle(
              fontSize: 14,
              color: day.weekday == 6 || day.weekday == 7
                  ? Colors.red.shade100
                  : Colors.black38,
            ),
          ),
        ],
      ),
    ),
  );
}
