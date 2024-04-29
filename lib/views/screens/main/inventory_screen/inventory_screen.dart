import 'package:flutter/material.dart';
import 'package:pomodak/view_models/member_view_model.dart';
import 'package:pomodak/views/screens/main/inventory_screen/widgets/character_inventory_section/character_inventory_section.dart';
import 'package:pomodak/views/screens/main/inventory_screen/widgets/item_inventory_section/item_inventory_section.dart';
import 'package:provider/provider.dart';

class InventoryScreen extends StatelessWidget {
  const InventoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          "인벤토리",
          style: TextStyle(fontSize: 18),
        ),
        surfaceTintColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Consumer<MemberViewModel>(
            builder: (context, memberViewModel, child) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Column(
              children: [
                ItemInventorySection(
                    inventory: memberViewModel.consumableInventory),
                CharacterInventorySection(
                    inventory: memberViewModel.characterInventory),
              ],
            ),
          );
        }),
      ),
    );
  }
}
