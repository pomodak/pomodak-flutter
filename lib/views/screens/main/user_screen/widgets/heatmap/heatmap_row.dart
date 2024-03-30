import 'package:flutter/material.dart';
import 'package:pomodak/utils/datasets_util.dart';
import 'package:pomodak/utils/date_util.dart';
import 'package:pomodak/views/screens/main/user_screen/widgets/heatmap/heatmap_container.dart';

class HeatMapRow extends StatelessWidget {
  final List<Widget> dayContainers;

  final List<Widget> emptySpace;

  final DateTime startDate;

  final DateTime endDate;

  final double? size;

  final Color? defaultColor;

  final Map<DateTime, int>? datasets;

  final Color? textColor;

  final Map<int, Color>? colorsets;

  final double? borderRadius;

  final EdgeInsets? margin;

  final Function(DateTime)? onClick;

  final int? maxValue;

  final int numDays;

  HeatMapRow({
    super.key,
    required this.startDate,
    required this.endDate,
    required this.numDays,
    this.size,
    this.defaultColor,
    this.datasets,
    this.textColor,
    this.borderRadius,
    this.margin,
    this.colorsets,
    this.onClick,
    this.maxValue,
  })  : dayContainers = List.generate(
          numDays,
          (i) => HeatMapContainer(
            date: DateUtil.changeDay(startDate, i),
            backgroundColor: defaultColor,
            size: size,
            borderRadius: borderRadius,
            margin: margin,
            onClick: onClick,
            selectedColor: DatasetsUtil.getColor(
              colorsets,
              datasets?[DateTime(
                startDate.year,
                startDate.month,
                startDate.day + i - (startDate.weekday % 7),
              )],
            ),
          ),
        ),
        emptySpace = (numDays != 7)
            ? List.generate(
                7 - numDays,
                (i) => Container(
                    margin: margin ?? const EdgeInsets.all(2),
                    width: size ?? 42,
                    height: size ?? 42),
              )
            : [];

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[...dayContainers, ...emptySpace],
    );
  }
}
