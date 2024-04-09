import 'package:flutter/material.dart';
import 'package:pomodak/view_models/member_view_model.dart';
import 'package:pomodak/views/screens/main/inventory_screen/widgets/character_card.dart';
import 'package:provider/provider.dart';

void showCollectionModal(BuildContext context) {
  showDialog(
    context: context,
    barrierDismissible: false,
    barrierColor: Colors.white,
    builder: (BuildContext context) {
      var memberViewModel = Provider.of<MemberViewModel>(context);
      return Dialog.fullscreen(
        child: Scaffold(
          appBar: AppBar(
            surfaceTintColor: Colors.white,
            leading: GestureDetector(
              onTap: () => Navigator.pop(context),
              child: const Icon(Icons.chevron_left, size: 32),
            ),
            title: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "📚 도감",
                )
              ],
            ),
          ),
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Common",
                          style: TextStyle(fontSize: 24),
                        ),
                        Text(
                          "10/16",
                          style: TextStyle(fontSize: 24),
                        ),
                      ],
                    ),
                  ),
                  GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 4,
                      crossAxisSpacing: 4,
                      mainAxisSpacing: 4,
                      childAspectRatio: 0.7,
                    ),
                    itemCount: memberViewModel.characterInventory.length,
                    itemBuilder: (context, index) {
                      return Image.network(
                        memberViewModel
                            .characterInventory[index].character.imageUrl,
                      );
                    },
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Rare",
                          style: TextStyle(fontSize: 24),
                        ),
                        Text(
                          "10/16",
                          style: TextStyle(fontSize: 24),
                        ),
                      ],
                    ),
                  ),
                  GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 4,
                      crossAxisSpacing: 4,
                      mainAxisSpacing: 4,
                      childAspectRatio: 0.7,
                    ),
                    itemCount: memberViewModel.characterInventory.length,
                    itemBuilder: (context, index) {
                      return Image.network(
                        memberViewModel
                            .characterInventory[index].character.imageUrl,
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    },
  );
}
