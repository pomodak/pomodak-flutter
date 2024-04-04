import 'package:flutter/material.dart';
import 'package:pomodak/view_models/member_view_model.dart';
import 'package:pomodak/views/screens/main/inventory_screen/widgets/character_card.dart';
import 'package:pomodak/views/screens/main/inventory_screen/widgets/item_inventory_card.dart';
import 'package:provider/provider.dart';

class InventoryScreen extends StatelessWidget {
  const InventoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('인벤토리'),
        surfaceTintColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Consumer<MemberViewModel>(
            builder: (context, memberViewModel, child) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Column(
              children: [
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 20),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "아이템",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 180,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: memberViewModel.consumableInventory.length,
                    itemBuilder: (context, index) {
                      return ItemInventoryCard(
                          itemInventory:
                              memberViewModel.consumableInventory[index]);
                    },
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 20),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "캐릭터",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                GridView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 4,
                    mainAxisSpacing: 10,
                    childAspectRatio: 0.7,
                  ),
                  itemCount: memberViewModel.characterInventory.length,
                  itemBuilder: (context, index) {
                    return CharacterCard(
                      characterInventory:
                          memberViewModel.characterInventory[index],
                    );
                  },
                ),
              ],
            ),
          );
        }),
      ),
    );
  }
}
