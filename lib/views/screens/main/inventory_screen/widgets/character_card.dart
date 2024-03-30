import 'package:flutter/material.dart';
import 'package:pomodak/models/domain/character_inventory_model.dart';
import 'package:pomodak/views/screens/main/inventory_screen/widgets/grade_badge.dart';

class CharacterCard extends StatelessWidget {
  final CharacterInventoryModel characterInventory;

  const CharacterCard({super.key, required this.characterInventory});

  @override
  Widget build(BuildContext context) {
    return Material(
      borderRadius: BorderRadius.circular(10),
      child: InkWell(
        onTap: () {},
        borderRadius: BorderRadius.circular(10),
        child: Container(
          padding: const EdgeInsets.all(8),
          alignment: Alignment.center,
          child: AspectRatio(
            aspectRatio: 3 / 5,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                GrdaeBadge(grade: characterInventory.grade),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 2, horizontal: 4),
                  child: Image.network(
                    characterInventory.imageUrl,
                    fit: BoxFit.cover,
                  ),
                ),
                CharacterInfo(
                  name: characterInventory.name,
                  sellPrice: characterInventory.sellPrice,
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
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        Text('$sellPrice원 | $quantity개'),
      ],
    );
  }
}
