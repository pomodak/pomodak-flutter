import 'package:flutter/material.dart';

enum CharacterGrade { common, rare, epic, legendary }

class CharacterGradeBadge extends StatelessWidget {
  final CharacterGrade grade;

  const CharacterGradeBadge({super.key, required this.grade});

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

  Color _getBackgroundColor(CharacterGrade grade) {
    switch (grade) {
      case CharacterGrade.common:
        return Colors.grey.shade200;
      case CharacterGrade.rare:
        return Colors.blue.shade500;
      case CharacterGrade.epic:
        return Colors.purple.shade500;
      case CharacterGrade.legendary:
        return Colors.red.shade500;
      default:
        return Colors.grey;
    }
  }

  Color _getTextColor(CharacterGrade grade) {
    return grade == CharacterGrade.common ? Colors.black : Colors.white;
  }
}
