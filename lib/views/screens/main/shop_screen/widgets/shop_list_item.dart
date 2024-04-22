import 'package:flutter/material.dart';
import 'package:pomodak/models/domain/item_model.dart';
import 'package:pomodak/views/dialogs/transaction_dialogs/transaction_dialog_manager.dart';

class ShopListItem extends StatelessWidget {
  final ItemModel item;

  const ShopListItem({
    super.key,
    required this.item,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: InkWell(
        onTap: () {
          TransactionDialogManager.showBuyItemDialog(
              context, item, item.itemType == "Food" ? 4 : 20);
        },
        borderRadius: BorderRadius.circular(10),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 6),
          child: Row(
            children: [
              Image.network(
                item.imageUrl,
                width: 70,
                height: 70,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.name,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      "${item.cost}원",
                      style: const TextStyle(
                        fontSize: 13,
                      ),
                    ),
                    if (item.requiredStudyTime != null)
                      Text(
                        "⌛️ ${(item.requiredStudyTime! / 60).floor()}분",
                        style: const TextStyle(
                          fontSize: 13,
                        ),
                      )
                  ],
                ),
              ),
              const SizedBox(width: 10),
              const Icon(
                Icons.chevron_right,
              )
            ],
          ),
        ),
      ),
    );
  }
}
