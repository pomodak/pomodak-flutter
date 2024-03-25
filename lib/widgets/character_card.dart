import 'package:flutter/material.dart';
import 'package:pomodak/models/character_inventory.dart';
import 'package:pomodak/widgets/grade_badge.dart';

class CharacterCard extends StatelessWidget {
  final CharacterInventory characterInventory;

  const CharacterCard({super.key, required this.characterInventory});

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    int crossAxisCount = 3;
    double cardWidth = (screenWidth / crossAxisCount) - 50;

    return Material(
      borderRadius: BorderRadius.circular(10),
      child: InkWell(
        onTap: () {},
        borderRadius: BorderRadius.circular(10),
        child: Container(
          padding: const EdgeInsets.all(8),
          alignment: Alignment.center,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              GrdaeBadge(grade: characterInventory.grade),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 4),
                child: Image.network(
                  characterInventory.imageUrl,
                  width: cardWidth,
                  height: cardWidth,
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
