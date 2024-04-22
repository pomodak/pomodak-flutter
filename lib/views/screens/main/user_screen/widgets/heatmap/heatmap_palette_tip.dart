import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:pomodak/config/constants/heatmap_color.dart';
import 'package:pomodak/models/domain/palette_model.dart';
import 'package:pomodak/utils/color_util.dart';
import 'package:pomodak/views/screens/main/user_screen/widgets/heatmap/heatmap_grade_badge.dart';

class HeatMapPaletteTip extends StatelessWidget {
  final PaletteModel? palette;

  const HeatMapPaletteTip({
    super.key,
    this.palette,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              HeatMapGradeBadge(grade: palette?.grade ?? PaletteGrade.common),
              const SizedBox(height: 6),
              palette != null
                  ? Text(
                      '${palette?.name} 팔레트',
                      style: const TextStyle(fontSize: 12),
                    )
                  : const Text("기본 팔레트"),
            ],
          ),
          _PaletteDisplay(palette: palette),
        ],
      ),
    );
  }
}

class _PaletteDisplay extends StatelessWidget {
  final PaletteModel? palette;

  const _PaletteDisplay({this.palette});
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        for (var item in [
          HeatMapPaletteTipItem(
            color: palette?.lightColor != null
                ? Color(HexColor.fromHex(palette?.lightColor as String))
                : HeatMapColor.defaultLightColor,
            text: "0~2",
          ),
          HeatMapPaletteTipItem(
            color: palette?.normalColor != null
                ? Color(HexColor.fromHex(palette?.normalColor as String))
                : HeatMapColor.defaultNormalColor,
            text: "2~4",
          ),
          HeatMapPaletteTipItem(
            color: palette?.darkColor != null
                ? Color(HexColor.fromHex(palette?.darkColor as String))
                : HeatMapColor.defaultDarkColor,
            text: "4~6",
          ),
          HeatMapPaletteTipItem(
            color: palette?.darkerColor != null
                ? Color(HexColor.fromHex(palette?.darkerColor as String))
                : HeatMapColor.defaultDarkerColor,
            text: "6~",
          ),
        ])
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: Column(
              children: [
                Container(color: item.color, width: 20, height: 20),
                item.text != null
                    ? Text(
                        item.text!,
                        style: const TextStyle(fontSize: 12),
                      )
                    : const SizedBox()
              ],
            ),
          ),
      ],
    );
  }
}

class HeatMapPaletteTipItem {
  final Color color;
  final String? text;

  const HeatMapPaletteTipItem({required this.color, this.text});
}
