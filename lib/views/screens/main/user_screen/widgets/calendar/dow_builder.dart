import 'package:flutter/material.dart';

Widget? dowBuilder(
  BuildContext context,
  DateTime day,
) {
  switch (day.weekday) {
    case 1:
      return const Center(
        child: Text(
          '월',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      );
    case 2:
      return const Center(
        child: Text(
          '화',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      );
    case 3:
      return const Center(
        child: Text(
          '수',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      );
    case 4:
      return const Center(
        child: Text(
          '목',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      );
    case 5:
      return const Center(
        child: Text(
          '금',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      );
    case 6:
      return const Center(
        child: Text(
          '토',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      );
    case 7:
      return const Center(
        child: Text(
          '일',
          style: TextStyle(
            color: Colors.red,
            fontWeight: FontWeight.bold,
          ),
        ),
      );
  }
  return null;
}
