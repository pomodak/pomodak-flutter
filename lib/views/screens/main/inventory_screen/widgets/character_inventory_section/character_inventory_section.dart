import 'package:flutter/material.dart';
import 'package:pomodak/view_models/member_view_model.dart';
import 'package:pomodak/views/screens/main/inventory_screen/widgets/character_inventory_section/character_card.dart';
import 'package:pomodak/views/screens/main/inventory_screen/widgets/character_inventory_section/show_collection_modal.dart';
import 'package:provider/provider.dart';

class CharacterInventorySection extends StatelessWidget {
  const CharacterInventorySection({super.key});

  @override
  Widget build(BuildContext context) {
    final memberViewModel = Provider.of<MemberViewModel>(context);
    final characters = memberViewModel.characterInventory;

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "캐릭터",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              InkWell(
                onTap: () => showCollectionModal(context),
                borderRadius: BorderRadius.circular(8),
                child: const Padding(
                  padding: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                  child: Text("📚 도감 보기",
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
        ),
        characters.isEmpty
            ? const Padding(
                padding: EdgeInsets.all(40.0),
                child: Text('캐릭터 인벤토리가 비어있습니다.'),
              )
            : GridView.builder(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 4,
                  mainAxisSpacing: 10,
                  childAspectRatio: 0.7,
                ),
                itemCount: characters.length,
                itemBuilder: (context, index) {
                  return CharacterCard(characterInventory: characters[index]);
                },
              ),
      ],
    );
  }
}
