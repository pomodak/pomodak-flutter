import 'package:flutter/material.dart';
import 'package:pomodak/utils/date_util.dart';
import 'package:pomodak/widgets/heatmap/heatmap_page.dart';

class HeatMap extends StatefulWidget {
  final DateTime? startDate;
  final DateTime? endDate;
  final Map<DateTime, int>? datasets;
  final Color? defaultColor;
  final Color? textColor;
  final double? size;
  final double? fontSize;
  final Map<int, Color> colorsets;
  final Function(DateTime)? onClick;
  final EdgeInsets? margin;
  final double? borderRadius;

  const HeatMap({
    super.key,
    required this.colorsets,
    this.startDate,
    this.endDate,
    this.textColor,
    this.size = 20,
    this.fontSize,
    this.onClick,
    this.margin,
    this.borderRadius,
    this.datasets,
    this.defaultColor,
  });

  @override
  State<HeatMap> createState() => _HeatMapState();
}

class _HeatMapState extends State<HeatMap> {
  @override
  Widget build(BuildContext context) {
    final endDate = widget.endDate ?? DateTime.now();
    final startDate = widget.startDate ?? DateUtil.oneYearBefore(endDate);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        HeatMapPage(
          endDate: endDate,
          startDate: startDate,
          size: widget.size,
          datasets: widget.datasets,
          defaultColor: widget.defaultColor,
          textColor: widget.textColor,
          colorsets: widget.colorsets,
          borderRadius: widget.borderRadius,
          onClick: widget.onClick,
          margin: widget.margin,
        ),
      ],
    );
  }
}
