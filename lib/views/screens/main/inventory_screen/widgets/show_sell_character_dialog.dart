import 'package:flutter/material.dart';
import 'package:pomodak/models/domain/character_inventory_model.dart';
import 'package:pomodak/view_models/transaction_view_model.dart';
import 'package:provider/provider.dart';

void showSellCharacterDialog(
  BuildContext context,
  CharacterInventoryModel inventory,
  int maxCount,
) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      int count = 1;

      return Dialog(
        surfaceTintColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        insetPadding: const EdgeInsets.symmetric(horizontal: 12),
        child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            child: StatefulBuilder(
                builder: (BuildContext context, StateSetter setState) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildDialogTitle(inventory.character.name),
                  const SizedBox(height: 4),
                  Text(inventory.character.description,
                      style: const TextStyle(fontSize: 14)),
                  const SizedBox(height: 16),
                  _buildQuantitySelector(
                      context,
                      count,
                      maxCount,
                      inventory.character.sellPrice,
                      (newCount) => count = newCount,
                      setState),
                  _buildTotalCost(inventory.character.sellPrice * count),
                  const SizedBox(height: 16),
                  _buildActionButtons(context, inventory, count),
                ],
              );
            })),
      );
    },
  );
}

Widget _buildDialogTitle(String name) {
  return Text(
    "$name 판매",
    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
  );
}

Widget _buildTotalCost(int totalCost) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Text(
        "$totalCost원",
        textAlign: TextAlign.center,
        style: const TextStyle(fontSize: 18),
      ),
    ],
  );
}

Widget _buildQuantitySelector(BuildContext context, int count, int maxCount,
    int cost, Function(int) onCountChanged, setState) {
  return Column(
    children: [
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            icon: const Icon(Icons.remove),
            onPressed: () => setState(() {
              if (count > 1) onCountChanged(--count);
            }),
          ),
          Text("$count",
              style:
                  const TextStyle(fontSize: 32, fontWeight: FontWeight.bold)),
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => setState(() {
              if (count < maxCount) onCountChanged(++count);
            }),
          ),
        ],
      ),
    ],
  );
}

Widget _buildActionButtons(
    BuildContext context, CharacterInventoryModel inventory, int count) {
  return StatefulBuilder(
    builder: (BuildContext context, StateSetter setState) {
      final transactionViewModel =
          Provider.of<TransactionViewModel>(context, listen: false);

      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                surfaceTintColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(6),
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text("취소"),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(6),
                ),
              ),
              onPressed: () {
                transactionViewModel.sellCharacter(
                    inventory.characterInventoryId, count);
                Navigator.of(context).pop();
              },
              child: const Text(
                "판매",
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
        ],
      );
    },
  );
}
