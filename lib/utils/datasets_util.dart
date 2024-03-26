import 'package:flutter/material.dart';

class DatasetsUtil {
  static int getMaxValue(Map<DateTime, int>? datasets) {
    int result = 0;

    datasets?.forEach((date, value) {
      if (value > result) {
        result = value;
      }
    });

    return result;
  }

  static Color? getColor(Map<int, Color>? colorsets, int? dataValue) {
    int result = 0;

    colorsets?.forEach((key, value) {
      if (key <= (dataValue ?? 0)) result = key;
    });

    return colorsets?[result];
  }
}
