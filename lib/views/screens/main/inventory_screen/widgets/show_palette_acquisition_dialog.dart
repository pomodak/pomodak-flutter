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
    builder: (BuildContext context) => PaletteAcquisitionDialog(
      inventory: inventory,
      initialPalette: result.palette,
    ),
  );
}

class PaletteAcquisitionDialog extends StatefulWidget {
  final ItemInventoryModel inventory;
  final PaletteModel initialPalette;

  const PaletteAcquisitionDialog({
    super.key,
    required this.inventory,
    required this.initialPalette,
  });

  @override
  State<PaletteAcquisitionDialog> createState() =>
      _PaletteAcquisitionDialogState();
}

class _PaletteAcquisitionDialogState extends State<PaletteAcquisitionDialog> {
  late int localQuantity;
  late PaletteModel newPalette;

  @override
  void initState() {
    super.initState();
    localQuantity = widget.inventory.quantity - 1;
    newPalette = widget.initialPalette;
  }

  void handleConfirm() => Navigator.of(context).pop();

  void handleReConsume() async {
    if (localQuantity < 1) {
      MessageUtil.showErrorToast("개수가 부족합니다.");
      return;
    }

    final memberViewModel =
        Provider.of<MemberViewModel>(context, listen: false);
    var data = await memberViewModel.consumeItem(
      widget.inventory.itemInventoryId,
    );

    if (data?.result == acquisitionResults['palette']) {
      setState(() {
        localQuantity -= 1;
        newPalette = data.palette;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      surfaceTintColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      insetPadding: const EdgeInsets.symmetric(horizontal: 12),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              '팔레트 변경',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            _PaletteDisplay(palette: newPalette),
            const SizedBox(height: 16),
            Text(
              '${newPalette.grade} 등급',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(newPalette.name,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 16),
            _ActionButtons(
              localQuantity: localQuantity,
              onReConsume: handleReConsume,
              onConfirm: handleConfirm,
            ),
          ],
        ),
      ),
    );
  }
}

class _PaletteDisplay extends StatelessWidget {
  final PaletteModel palette;

  const _PaletteDisplay({required this.palette});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        for (var color in [
          palette.lightColor,
          palette.normalColor,
          palette.darkColor,
          palette.darkerColor
        ])
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: Container(
                color: Color(HexColor.fromHex(color)), width: 32, height: 32),
          ),
      ],
    );
  }
}

class _ActionButtons extends StatelessWidget {
  final int localQuantity;
  final VoidCallback onReConsume;
  final VoidCallback onConfirm;

  const _ActionButtons({
    required this.localQuantity,
    required this.onReConsume,
    required this.onConfirm,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
                surfaceTintColor: Colors.white,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6))),
            onPressed: onReConsume,
            child: Text("다시뽑기 x $localQuantity"),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6))),
            onPressed: onConfirm,
            child: const Text("확인", style: TextStyle(color: Colors.white)),
          ),
        ),
      ],
    );
  }
}