import 'package:flutter/material.dart';
import 'package:pomodak/models/domain/item_inventory_model.dart';
import 'package:pomodak/views/screens/main/inventory_screen/widgets/item_inventory_section/item_inventory_card.dart';

class ItemInventorySection extends StatelessWidget {
  final List<ItemInventoryModel> inventory;
  const ItemInventorySection({super.key, required this.inventory});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 20),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text(
              "아이템",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
        ),
        inventory.isEmpty
            ? const Padding(
                padding: EdgeInsets.all(40.0),
                child: Text('아이템 인벤토리가 비어있습니다.'),
              )
            : SizedBox(
                height: 160,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: inventory.length,
                  itemBuilder: (context, index) {
                    return ItemInventoryCard(itemInventory: inventory[index]);
                  },
                ),
              ),
      ],
    );
  }
}
