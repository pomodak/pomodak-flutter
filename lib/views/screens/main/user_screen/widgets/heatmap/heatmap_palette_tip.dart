import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:pomodak/models/domain/palette_model.dart';
import 'package:pomodak/utils/color_util.dart';

class HeatMapPaletteTip extends StatelessWidget {
  final PaletteModel? palette;

  const HeatMapPaletteTip({
    super.key,
    this.palette,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(width: 32),
        Text(
          '${palette?.grade ?? "common"}',
          style: const TextStyle(
            fontSize: 14,
          ),
        ),
        const SizedBox(width: 8),
        palette != null ? Text('${palette?.name} 팔레트') : const Text("기본 팔레트"),
        const SizedBox(width: 8),
        _PaletteDisplay(
          palette: palette,
        ),
      ],
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
        for (var color in [
          palette?.lightColor != null
              ? Color(HexColor.fromHex(palette?.lightColor as String))
              : Colors.green.shade100,
          palette?.normalColor != null
              ? Color(HexColor.fromHex(palette?.normalColor as String))
              : Colors.green.shade300,
          palette?.darkColor != null
              ? Color(HexColor.fromHex(palette?.darkColor as String))
              : Colors.green.shade500,
          palette?.darkerColor != null
              ? Color(HexColor.fromHex(palette?.darkerColor as String))
              : Colors.green.shade700,
        ])
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: Container(color: color, width: 20, height: 20),
          ),
      ],
    );
  }
}
