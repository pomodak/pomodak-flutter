import 'package:flutter/material.dart';
import 'package:pomodak/constants/cdn_images.dart';
import 'package:pomodak/models/character_inventory.dart';
import 'package:pomodak/widgets/character_card.dart';
import 'package:pomodak/widgets/grade_badge.dart';

class InventoryScreen extends StatelessWidget {
  const InventoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final List<CharacterInventory> characters = [
      CharacterInventory(
          id: 1,
          grade: CharacterGrade.common,
          imageUrl: CDNImages.mascot["finish"]!,
          name: '초보닭',
          sellPrice: 1234,
          quantity: 1),
      CharacterInventory(
          id: 1,
          grade: CharacterGrade.rare,
          imageUrl: CDNImages.mascot["finish"]!,
          name: '초보닭',
          sellPrice: 1234,
          quantity: 1),
      CharacterInventory(
          id: 1,
          grade: CharacterGrade.epic,
          imageUrl: CDNImages.mascot["finish"]!,
          name: '초보닭',
          sellPrice: 1234,
          quantity: 1),
      CharacterInventory(
          id: 1,
          grade: CharacterGrade.legendary,
          imageUrl: CDNImages.mascot["finish"]!,
          name: '초보닭',
          sellPrice: 1234,
          quantity: 1),
    ];
    // 임시
    final List<CharacterInventory> eggs = [
      CharacterInventory(
          id: 1,
          grade: CharacterGrade.common,
          imageUrl: CDNImages.mascot["finish"]!,
          name: '초보닭',
          sellPrice: 1234,
          quantity: 1),
      CharacterInventory(
          id: 1,
          grade: CharacterGrade.rare,
          imageUrl: CDNImages.mascot["finish"]!,
          name: '초보닭',
          sellPrice: 1234,
          quantity: 1),
      CharacterInventory(
          id: 1,
          grade: CharacterGrade.epic,
          imageUrl: CDNImages.mascot["finish"]!,
          name: '초보닭',
          sellPrice: 1234,
          quantity: 1),
      CharacterInventory(
          id: 1,
          grade: CharacterGrade.legendary,
          imageUrl: CDNImages.mascot["finish"]!,
          name: '초보닭',
          sellPrice: 1234,
          quantity: 1),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('인벤토리'),
        surfaceTintColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Column(
            children: [
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 12),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "아이템",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 200,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: eggs.length,
                  itemBuilder: (context, index) {
                    return CharacterCard(characterInventory: eggs[index]);
                  },
                ),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "캐릭터",
                    style: TextStyle(
                      fontSize: 20,
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
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  childAspectRatio: 0.75,
                ),
                itemCount: characters.length,
                itemBuilder: (context, index) {
                  return CharacterCard(characterInventory: characters[index]);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
