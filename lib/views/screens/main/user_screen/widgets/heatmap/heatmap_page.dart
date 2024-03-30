import 'dart:math';

import 'package:flutter/material.dart';
import 'package:pomodak/utils/datasets_util.dart';
import 'package:pomodak/utils/date_util.dart';
import 'package:pomodak/views/screens/main/user_screen/widgets/heatmap/heatmap_row.dart';
import 'package:pomodak/views/screens/main/user_screen/widgets/heatmap/heatmap_month_text.dart';
import 'package:pomodak/views/screens/main/user_screen/widgets/heatmap/heatmap_week_text.dart';

class HeatMapPage extends StatelessWidget {
  final List<int> _firstDayInfos = [];

  final int _dateDifferent;

  final DateTime startDate;

  final DateTime endDate;

  final double? size;

  final double? fontSize;

  final Map<DateTime, int>? datasets;

  final EdgeInsets? margin;

  final Color? defaultColor;

  final Color? textColor;

  final Map<int, Color>? colorsets;

  final double? borderRadius;

  final int? maxValue;

  final Function(DateTime)? onClick;

  HeatMapPage({
    super.key,
    required this.startDate,
    required this.endDate,
    this.size,
    this.fontSize,
    this.datasets,
    this.defaultColor,
    this.textColor,
    this.colorsets,
    this.borderRadius,
    this.onClick,
    this.margin,
  })  : _dateDifferent = endDate.difference(startDate).inDays,
        maxValue = DatasetsUtil.getMaxValue(datasets);

  List<Widget> _heatmapRowList() {
    List<Widget> rows = [];

    for (int datePos = 0 - (startDate.weekday % 7);
        datePos <= _dateDifferent;
        datePos += 7) {
      DateTime firstDay = DateUtil.changeDay(startDate, datePos);

      rows.add(HeatMapRow(
        startDate: firstDay,
        endDate: datePos <= _dateDifferent - 7
            ? DateUtil.changeDay(startDate, datePos + 6)
            : endDate,
        numDays: min(endDate.difference(firstDay).inDays + 1, 7),
        size: size,
        defaultColor: defaultColor,
        colorsets: colorsets,
        borderRadius: borderRadius,
        margin: margin,
        maxValue: maxValue,
        onClick: onClick,
        datasets: datasets,
      ));

      _firstDayInfos.add(firstDay.month);
    }

    return rows.reversed.toList();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            HeatMapMonthText(
              firstDayInfos: _firstDayInfos,
              margin: margin,
              fontSize: fontSize,
              fontColor: textColor,
              size: size,
            ),
            const SizedBox(
              width: 10,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                HeatMapWeekText(
                  margin: margin,
                  fontSize: fontSize,
                  size: size,
                  fontColor: textColor,
                ),
                const SizedBox(height: 10),
                Column(
                  children: <Widget>[..._heatmapRowList()],
                ),
              ],
            ),
            SizedBox(
              width: size != null ? size! - 4 : 0,
            ),
          ],
        ),
      ],
    );
  }
}
