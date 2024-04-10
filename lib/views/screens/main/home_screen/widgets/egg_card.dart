import 'package:flutter/material.dart';
import 'package:pomodak/data/repositories/member_repository.dart';
import 'package:pomodak/models/domain/item_inventory_model.dart';
import 'package:pomodak/utils/format_util.dart';
import 'package:pomodak/utils/message_util.dart';
import 'package:pomodak/view_models/member_view_model.dart';
import 'package:pomodak/views/screens/main/inventory_screen/widgets/show_character_acquisition_dialog.dart';
import 'package:pomodak/views/screens/main/inventory_screen/widgets/show_item_acquisition_dialog.dart';
import 'package:pomodak/views/screens/main/inventory_screen/widgets/show_palette_acquisition_dialog.dart';
import 'package:pomodak/views/screens/main/inventory_screen/widgets/show_point_acquisition_dialog.dart';
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

    final memberViewModel =
        Provider.of<MemberViewModel>(context, listen: false);
    var data = await memberViewModel.consumeItem(itemInventory.itemInventoryId);

    if (data.result != null) {
      if (context.mounted) _handleConsumeItemResult(context, data);
      await memberViewModel.loadFoodInventory();
    }
  }

  void _handleConsumeItemResult(BuildContext context, dynamic data) {
    if (data.result == acquisitionResults['consumableItem']) {
      showItemAcquisitionDialog(context, data);
    } else if (data.result == acquisitionResults['character']) {
      showCharacterAcquisitionDialog(context, data);
    } else if (data.result == acquisitionResults['palette']) {
      showPaletteAcquisitionDialog(context, data, itemInventory);
    } else if (data.result == acquisitionResults['point']) {
      showPointAcquisitionDialog(context, data);
    }
  }
}
