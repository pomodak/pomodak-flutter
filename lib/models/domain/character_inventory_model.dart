import 'package:pomodak/views/screens/main/inventory_screen/widgets/grade_badge.dart';

// 임시
class CharacterInventoryModel {
  final int id;
  final CharacterGrade grade;
  final String imageUrl;
  final String name;
  final int sellPrice;
  final int quantity;

  CharacterInventoryModel({
    required this.id,
    required this.grade,
    required this.imageUrl,
    required this.name,
    required this.sellPrice,
    required this.quantity,
  });
}
