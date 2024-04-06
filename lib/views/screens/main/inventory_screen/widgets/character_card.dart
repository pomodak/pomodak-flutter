import 'package:flutter/material.dart';
import 'package:pomodak/models/domain/character_inventory_model.dart';
import 'package:pomodak/views/screens/main/inventory_screen/widgets/character_grade_badge.dart';
import 'package:pomodak/views/screens/main/inventory_screen/widgets/show_sell_character_dialog.dart';

class CharacterCard extends StatelessWidget {
  final CharacterInventoryModel characterInventory;

  const CharacterCard({super.key, required this.characterInventory});
  @override
  Widget build(BuildContext context) {
    var character = characterInventory.character;
    return Material(
      borderRadius: BorderRadius.circular(10),
      child: InkWell(
        onTap: () {
          showSellCharacterDialog(
            context,
            characterInventory,
            characterInventory.quantity,
          );
        },
        borderRadius: BorderRadius.circular(10),
        child: Container(
          padding: const EdgeInsets.all(8),
          alignment: Alignment.center,
          child: AspectRatio(
            aspectRatio: 3 / 5,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CharacterGradeBadge(grade: character.grade),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 2, horizontal: 4),
                  child: Image.network(
                    character.imageUrl,
                    fit: BoxFit.cover,
                  ),
                ),
                CharacterInfo(
                  name: character.name,
                  sellPrice: character.sellPrice,
                  quantity: characterInventory.quantity,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class CharacterInfo extends StatelessWidget {
  final String name;
  final int sellPrice;
  final int quantity;

  const CharacterInfo({
    super.key,
    required this.name,
    required this.sellPrice,
    required this.quantity,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          name,
          textAlign: TextAlign.center,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 14,
          ),
        ),
        Text(
          '$sellPrice원 | $quantity개',
          style: const TextStyle(
            fontSize: 13,
          ),
        ),
      ],
    );
  }
}
