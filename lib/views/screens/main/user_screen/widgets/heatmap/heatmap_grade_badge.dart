import 'package:flutter/material.dart';
import 'package:pomodak/models/domain/palette_model.dart';

class HeatMapGradeBadge extends StatelessWidget {
  final PaletteGrade grade;

  const HeatMapGradeBadge({
    super.key,
    required this.grade,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: _getBackgroundColor(grade),
        borderRadius: BorderRadius.circular(4),
        boxShadow: [
          BoxShadow(blurRadius: 6, color: Colors.black.withOpacity(0.2))
        ],
      ),
      child: Text(
        grade.toString().split('.').last,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: _getTextColor(grade),
        ),
      ),
    );
  }

  Color _getBackgroundColor(PaletteGrade grade) {
    switch (grade) {
      case PaletteGrade.common:
        return Colors.grey.shade200;
      case PaletteGrade.rare:
        return Colors.blue.shade500;
      case PaletteGrade.epic:
        return Colors.purple.shade500;
      case PaletteGrade.legendary:
        return Colors.red.shade500;
      default:
        return Colors.grey;
    }
  }

  Color _getTextColor(PaletteGrade grade) {
    return grade == PaletteGrade.common ? Colors.black : Colors.white;
  }
}
