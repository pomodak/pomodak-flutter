import 'package:flutter/material.dart';
import 'package:pomodak/data/repositories/member_repository.dart';
import 'package:pomodak/models/api/members/consume_item_response.dart';
import 'package:pomodak/models/domain/item_inventory_model.dart';
import 'package:pomodak/models/domain/palette_model.dart';
import 'package:pomodak/utils/color_util.dart';
import 'package:pomodak/utils/message_util.dart';
import 'package:pomodak/view_models/member_view_model.dart';
import 'package:provider/provider.dart';

void showPaletteAcquisitionDialog(
  BuildContext context,
  PaletteAcquisition result,
  ItemInventoryModel inventory,
) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      int localQuantity = inventory.quantity - 1; // 아이템의 수량
      PaletteModel newPalette = result.palette; // 뽑은 팔레트 정보

      return Dialog(
        surfaceTintColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        insetPadding: const EdgeInsets.symmetric(horizontal: 12),
        child: StatefulBuilder(
          builder: (context, setState) {
            void handleConfirm() {
              Navigator.of(context).pop();
            }

            void handleReConsume() async {
              if (localQuantity < 1) {
                MessageUtil.showErrorToast("개수가 부족합니다.");
                return;
              }
              final memberViewModel =
                  Provider.of<MemberViewModel>(context, listen: false);

              var data =
                  await memberViewModel.consumeItem(inventory.itemInventoryId);

              if (data?.result == acquisitionResults['palette']) {
                var result = data;
                setState(() {
                  localQuantity -= 1;
                  newPalette = result.palette;
                });
              }
            }

            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text('팔레트 변경',
                      style:
                          TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                          color: Color(HexColor.fromHex(newPalette.lightColor)),
                          width: 32,
                          height: 32),
                      const SizedBox(width: 8),
                      Container(
                          color:
                              Color(HexColor.fromHex(newPalette.normalColor)),
                          width: 32,
                          height: 32),
                      const SizedBox(width: 8),
                      Container(
                          color: Color(HexColor.fromHex(newPalette.darkColor)),
                          width: 32,
                          height: 32),
                      const SizedBox(width: 8),
                      Container(
                          color:
                              Color(HexColor.fromHex(newPalette.darkerColor)),
                          width: 32,
                          height: 32),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text('${newPalette.grade} 등급',
                      style: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  Text(newPalette.name,
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 16)),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            surfaceTintColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(6),
                            ),
                          ),
                          onPressed: handleReConsume,
                          child: Text(
                            "다시뽑기 x $localQuantity",
                          ),
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
                          onPressed: handleConfirm,
                          child: const Text(
                            "확인",
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            );
          },
        ),
      );
    },
  );
}
