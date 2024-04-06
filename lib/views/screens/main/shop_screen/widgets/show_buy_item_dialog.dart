import 'package:flutter/material.dart';
import 'package:pomodak/models/domain/item_model.dart';
import 'package:pomodak/view_models/shop_view_model.dart';
import 'package:provider/provider.dart';

void showBuyItemDialog(BuildContext context, ItemModel item, int maxCount) {
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
                  _buildDialogTitle(item.name),
                  const SizedBox(height: 4),
                  Text(item.description, style: const TextStyle(fontSize: 14)),
                  const SizedBox(height: 16),
                  _buildQuantitySelector(context, count, maxCount, item.cost,
                      (newCount) => count = newCount, setState),
                  _buildTotalCost(item.cost * count),
                  const SizedBox(height: 16),
                  _buildActionButtons(context, item, count),
                ],
              );
            })),
      );
    },
  );
}

Widget _buildDialogTitle(String name) {
  return Text(
    "$name 구매",
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

Widget _buildActionButtons(BuildContext context, ItemModel item, int count) {
  return StatefulBuilder(
    builder: (BuildContext context, StateSetter setState) {
      final shopViewModel = Provider.of<ShopViewModel>(context, listen: false);

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
                shopViewModel.buyItem(item.itemId, count);
                Navigator.of(context).pop();
              },
              child: const Text(
                "구매",
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
        ],
      );
    },
  );
}
