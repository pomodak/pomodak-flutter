import 'package:flutter/material.dart';
import 'package:pomodak/data/repositories/member_repository.dart';
import 'package:pomodak/models/api/members/consume_item_response.dart';
import 'package:pomodak/models/domain/item_inventory_model.dart';
import 'package:pomodak/view_models/member_view_model.dart';
import 'package:pomodak/views/screens/main/inventory_screen/widgets/show_character_acquisition_dialog.dart';
import 'package:pomodak/views/screens/main/inventory_screen/widgets/show_palette_acquisition_dialog.dart';
import 'package:provider/provider.dart';

void showConsumeItemDialog(
  BuildContext context,
  ItemInventoryModel inventory,
) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
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
                  _buildDialogTitle(inventory.item.name),
                  const SizedBox(height: 4),
                  Text(inventory.item.description,
                      style: const TextStyle(fontSize: 14)),
                  const SizedBox(height: 16),
                  _buildActionButtons(context, inventory),
                ],
              );
            })),
      );
    },
  );
}

Widget _buildDialogTitle(String name) {
  return Text(
    "$name을 사용하시겠습니까?",
    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
  );
}

Widget _buildActionButtons(BuildContext context, ItemInventoryModel inventory) {
  return StatefulBuilder(
    builder: (BuildContext context, StateSetter setState) {
      final memberViewModel =
          Provider.of<MemberViewModel>(context, listen: false);

      void handleConsumeItemResult(dynamic data) {
        Navigator.of(context).pop(); // 현재 대화상자를 닫음

        // 결과에 따라 적절한 모달 열기
        if (data.result == acquisitionResults['consumableItem']) {
          var result = (data as ConsumableItemAcquisition);
          // showConsumableItemAcquisitionDialog(context, result);
        } else if (data.result == acquisitionResults['character']) {
          var result = (data as CharacterAcquisition);
          showCharacterAcquisitionDialog(context, result);
        } else if (data.result == acquisitionResults['palette']) {
          var result = (data as PaletteAcquisition);
          showPaletteAcquisitionDialog(context, result, inventory);
        } else if (data.result == acquisitionResults['point']) {
          var result = (data as PointAcquisition);
          // showPointAcquisitionDialog(context, result);
        }
      }

      void handleConsumeItem() async {
        // // 캐릭터 획득 테스트용
        // Navigator.of(context).pop(); // 현재 대화상자를 닫음
        // showCharacterAcquisitionDialog(
        //     context,
        //     CharacterAcquisition.fromJson({
        //       "result": "Character Acquisition",
        //       "character": {
        //         "name": "발레닭",
        //         "description": "쭉 뻗은 다리! 활짝 핀 날개!",
        //         "grade": "Common",
        //         "character_id": 33,
        //         "image_url":
        //             "https://d2quahb2ygxiv.cloudfront.net/12d0c0f11899f4bf1284c.png",
        //         "sell_price": 400
        //       },
        //       "character_inventory_id": 70
        //     }));
        // return;
        var data = await memberViewModel.consumeItem(inventory.itemInventoryId);

        handleConsumeItemResult(data);
      }

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
              onPressed: handleConsumeItem,
              child: const Text(
                "사용",
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
        ],
      );
    },
  );
}
