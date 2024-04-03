import 'package:flutter/material.dart';
import 'package:pomodak/utils/date_util.dart';

class HeatMapWeekText extends StatelessWidget {
  final EdgeInsets? margin;

  final double? fontSize;

  final double? size;

  final Color? fontColor;

  const HeatMapWeekText({
    super.key,
    this.margin,
    this.fontSize,
    this.size,
    this.fontColor,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        for (String label in DateUtil.weekLabel)
          SizedBox(
            width: size == null ? 44 : (size! + 5),
            child: Text(
              label,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: fontSize ?? 14,
                color: label == "일" ? Colors.red : fontColor,
              ),
            ),
          ),
      ],
    );
  }
}
