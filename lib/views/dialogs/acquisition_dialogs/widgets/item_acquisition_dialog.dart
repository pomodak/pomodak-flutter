import 'package:flutter/material.dart';
import 'package:pomodak/models/api/members/consume_item_response.dart';
import 'package:pomodak/models/domain/item_model.dart';

class ItemAcquisitionDialog extends StatelessWidget {
  final ConsumableItemAcquisition result;

  const ItemAcquisitionDialog({super.key, required this.result});

  @override
  Widget build(BuildContext context) {
    return Dialog.fullscreen(
      backgroundColor: Colors.white,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 56, horizontal: 24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          mainAxisSize: MainAxisSize.min,
          children: [
            _ItemDetails(
              item: result.item,
              quantity: result.count,
            ),
            _ConfirmButton(),
          ],
        ),
      ),
    );
  }
}

class _ItemDetails extends StatelessWidget {
  final ItemModel item;
  final int? quantity;

  const _ItemDetails({required this.item, this.quantity});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Text('아이템 획득',
            style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
        const SizedBox(height: 20),
        Image.network(item.imageUrl,
            height: MediaQuery.of(context).size.height * 0.3),
        const SizedBox(height: 20),
        Text('${item.name}${quantity != null ? ' x $quantity' : ""}',
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        const SizedBox(height: 20),
        Text(item.description,
            textAlign: TextAlign.center, style: const TextStyle(fontSize: 16)),
        const SizedBox(height: 20),
      ],
    );
  }
}

class _ConfirmButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6))),
            onPressed: () => Navigator.of(context).pop(),
            child: const Text("확인", style: TextStyle(color: Colors.white)),
          ),
        ),
      ],
    );
  }
}
