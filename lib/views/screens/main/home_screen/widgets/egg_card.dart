import 'package:flutter/material.dart';
import 'package:pomodak/models/domain/item_inventory_model.dart';
import 'package:pomodak/utils/format_util.dart';
import 'package:pomodak/utils/message_util.dart';
import 'package:pomodak/view_models/transaction_view_model.dart';
import 'package:pomodak/views/dialogs/acquisition_dialogs/acquisition_dialog_manager.dart';
import 'package:provider/provider.dart';

class EggCard extends StatelessWidget {
  final ItemInventoryModel itemInventory;

  const EggCard({
    super.key,
    required this.itemInventory,
  });

  @override
  Widget build(BuildContext context) {
    var isActive = itemInventory.progress <= 0;

    return Material(
      child: InkWell(
        onTap: () => _handleConsumeItem(context),
        borderRadius: BorderRadius.circular(10),
        child: Container(
          decoration: BoxDecoration(
            border: isActive
                ? Border.all(
                    color: Colors.black12,
                    width: 1,
                  )
                : null,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                isActive ? const Text("open") : const Text(""),
                Image.network(itemInventory.item.imageUrl),
                Text(
                  FormatUtil.formatSeconds(
                    0 < itemInventory.progress ? itemInventory.progress : 0,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _handleConsumeItem(BuildContext context) async {
    if (0 < itemInventory.progress) {
      MessageUtil.showErrorToast('아직 아이템을 사용할 수 없습니다.');
      return;
    }

    var data = await context.read<TransactionViewModel>().consumeItem(
          inventoryId: itemInventory.itemInventoryId,
          isFood: true,
        );

    if (data.result != null) {
      if (context.mounted) _handleConsumeItemResult(context, data);
    }
  }

  void _handleConsumeItemResult(BuildContext context, dynamic data) {
    AcquisitionDialogManager.showAcquisitionDialog(
      context,
      data,
      itemInventory,
    );
  }
}
