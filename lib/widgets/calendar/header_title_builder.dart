import 'package:flutter/material.dart';

Widget? headerTitleBuilder(
  BuildContext context,
  DateTime day,
) {
  return Center(
    child: Text(
      '${day.year}년 ${day.month}월',
      style: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
      ),
    ),
  );
}
