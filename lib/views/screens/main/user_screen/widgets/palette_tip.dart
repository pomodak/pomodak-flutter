import 'package:flutter/material.dart';
import 'package:pomodak/models/domain/palette_model.dart';
import 'package:pomodak/views/widgets/palette_grade_badge.dart';

class PaletteTip extends StatelessWidget {
  final PaletteModel? palette;

  const PaletteTip({
    super.key,
    this.palette,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        PaletteGradeBadge(grade: palette?.grade ?? PaletteGrade.common),
        const SizedBox(width: 12),
        palette != null
            ? Text(
                '${palette?.name} 팔레트',
                style: const TextStyle(fontSize: 12),
              )
            : const Text("기본 팔레트"),
      ],
    );
  }
}
