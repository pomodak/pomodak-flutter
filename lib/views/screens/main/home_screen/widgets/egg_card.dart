import 'package:flutter/material.dart';
import 'package:pomodak/models/domain/item_inventory_model.dart';
import 'package:pomodak/utils/format_util.dart';
import 'package:pomodak/utils/message_util.dart';

class EggCard extends StatelessWidget {
  final ItemInventoryModel itemInventory;

  const EggCard({
    super.key,
    required this.itemInventory,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      borderRadius: BorderRadius.circular(10),
      child: InkWell(
        onTap: () {
          MessageUtil.showErrorToast("아직 구현되지 않았습니다.");
        },
        borderRadius: BorderRadius.circular(10),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.network(itemInventory.item.imageUrl),
              Text(
                FormatUtil.formatSeconds(
                  itemInventory.item.requiredStudyTime ?? 0,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
