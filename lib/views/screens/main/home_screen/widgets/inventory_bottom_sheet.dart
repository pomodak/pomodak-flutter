import 'package:flutter/material.dart';
import 'package:pomodak/view_models/member_view_model.dart';
import 'package:pomodak/views/screens/main/home_screen/widgets/egg_add_card.dart';
import 'package:pomodak/views/screens/main/home_screen/widgets/egg_card.dart';
import 'package:provider/provider.dart';

class EggInventoryBottomSheet extends StatelessWidget {
  final VoidCallback onNavigateToShop;
  const EggInventoryBottomSheet({super.key, required this.onNavigateToShop});

  @override
  Widget build(BuildContext context) {
    final eggs = context.select((MemberViewModel vm) => vm.foodInventory);

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      height: 300,
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
      child: Column(
        children: [
          const Text(
            "보유중인 알",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          const Text("최대 4개까지 보관할 수 있습니다."),
          const Text("(버릴 수 없어요. 끝까지 책임져주세요!)"),
          const SizedBox(height: 16),
          Expanded(
            child: GridView.count(
              crossAxisSpacing: 4,
              crossAxisCount: 4,
              childAspectRatio: 3 / 4.5,
              children: List.generate(
                4,
                (index) => index < eggs.length
                    ? EggCard(itemInventory: eggs[index])
                    : EggAddCard(onNavigateToShop: onNavigateToShop),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
