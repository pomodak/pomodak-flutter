import 'package:flutter/material.dart';
import 'package:pomodak/utils/date_util.dart';

class HeatMapMonthText extends StatelessWidget {
  final List<int>? firstDayInfos;
  final double? size;
  final double? fontSize;
  final Color? fontColor;
  final EdgeInsets? margin;

  const HeatMapMonthText({
    super.key,
    this.firstDayInfos,
    this.fontSize,
    this.fontColor,
    this.size,
    this.margin,
  });

  List<Widget> _labels() {
    List<Widget> items = [];

    bool write = false;

    for (int label = 0; label < (firstDayInfos?.length ?? 0); label++) {
      if (label == 0 ||
          (label > 0 && firstDayInfos![label] != firstDayInfos![label - 1])) {
        write = true;
        items.add(
          firstDayInfos!.length == 1 ||
                  (label == 0 &&
                      firstDayInfos![label] != firstDayInfos![label + 1])
              ? _renderText(DateUtil.shortMonthLabel[firstDayInfos![label]])
              : Container(
                  height: (((size ?? 20) + (margin?.horizontal ?? 2)) * 2),
                  margin: EdgeInsets.only(
                      top: margin?.top ?? 2, bottom: margin?.bottom ?? 2),
                  child: _renderText(
                      DateUtil.shortMonthLabel[firstDayInfos![label]]),
                ),
        );
      } else if (write) {
        write = false;
      } else {
        items.add(Container(
          margin: EdgeInsets.only(
              top: margin?.top ?? 2, bottom: margin?.bottom ?? 2),
          height: size ?? 20,
        ));
      }
    }

    return items.reversed.toList();
  }

  Widget _renderText(String text) {
    return Text(
      text,
      style: TextStyle(
        color: fontColor,
        fontSize: fontSize,
      ),
      textAlign: TextAlign.center,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: _labels(),
    );
  }
}
