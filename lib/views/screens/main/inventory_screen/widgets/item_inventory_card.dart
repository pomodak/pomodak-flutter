import 'package:flutter/material.dart';
import 'package:pomodak/models/domain/item_inventory_model.dart';

class ItemInventoryCard extends StatelessWidget {
  final ItemInventoryModel itemInventory;

  const ItemInventoryCard({super.key, required this.itemInventory});

  @override
  Widget build(BuildContext context) {
    var character = itemInventory.item;
    return Material(
      borderRadius: BorderRadius.circular(10),
      child: InkWell(
        onTap: () {},
        borderRadius: BorderRadius.circular(10),
        child: Container(
          padding: const EdgeInsets.all(8),
          alignment: Alignment.center,
          child: AspectRatio(
            aspectRatio: 3 / 4,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 2, horizontal: 4),
                  child: Image.network(
                    character.imageUrl,
                    fit: BoxFit.cover,
                  ),
                ),
                ItemInventoryInfo(
                  name: character.name,
                  cost: character.cost,
                  quantity: itemInventory.quantity,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class ItemInventoryInfo extends StatelessWidget {
  final String name;
  final int cost;
  final int quantity;

  const ItemInventoryInfo({
    super.key,
    required this.name,
    required this.cost,
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
          '$quantity개',
          style: const TextStyle(
            fontSize: 13,
          ),
        ),
      ],
    );
  }
}
