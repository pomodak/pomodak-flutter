import 'package:pomodak/widgets/grade_badge.dart';

class CharacterInventory {
  final int id;
  final CharacterGrade grade;
  final String imageUrl;
  final String name;
  final int sellPrice;
  final int quantity;

  CharacterInventory({
    required this.id,
    required this.grade,
    required this.imageUrl,
    required this.name,
    required this.sellPrice,
    required this.quantity,
  });
}
