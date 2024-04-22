import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:pomodak/data/datasources/remote/transaction_remote_datasource.dart';
import 'package:pomodak/models/domain/item_inventory_model.dart';
import 'package:pomodak/models/domain/palette_model.dart';
import 'package:pomodak/utils/color_util.dart';
import 'package:pomodak/utils/message_util.dart';
import 'package:pomodak/view_models/transaction_view_model.dart';
import 'package:pomodak/views/widgets/palette_grade_badge.dart';
import 'package:provider/provider.dart';

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
  late int quantityLeft;
  late PaletteModel newPalette;
  Key _confettiKey = UniqueKey(); // 재뽑기 시 confetti widget 초기화를 위한 키
  late ConfettiController confettiController;
  late int confettiduration;
  late double emissionFrequency;
  late double minBlastForce;
  late double maxBlastForce;

  @override
  void initState() {
    super.initState();
    quantityLeft = widget.inventory.quantity - 1;
    newPalette = widget.initialPalette;
    setConfettiProperties(newPalette);
    confettiController = ConfettiController(
      duration: Duration(seconds: confettiduration),
    );
    confettiController.play();
  }

  @override
  void dispose() {
    confettiController.dispose();
    super.dispose();
  }

  void handleConfirm() => Navigator.of(context).pop();

  void handleReConsume() async {
    if (quantityLeft < 1) {
      MessageUtil.showErrorToast("개수가 부족합니다.");
      return;
    }

    final transactionViewModel =
        Provider.of<TransactionViewModel>(context, listen: false);
    var data = await transactionViewModel.consumeItem(
      inventoryId: widget.inventory.itemInventoryId,
    );

    if (data?.result == acquisitionResults['palette']) {
      setState(() {
        quantityLeft -= 1;
        newPalette = data.palette;
        _confettiKey = UniqueKey();
      });
      setConfettiProperties(newPalette);
      confettiController = ConfettiController(
        duration: Duration(seconds: confettiduration),
      );
      confettiController.play();
    }
  }

  void setConfettiProperties(PaletteModel palette) {
    switch (palette.grade) {
      case PaletteGrade.rare:
        emissionFrequency = 0.02;
        minBlastForce = 2;
        maxBlastForce = 2.1;
        confettiduration = 1;
        break;
      case PaletteGrade.epic:
        emissionFrequency = 0.03;
        minBlastForce = 6;
        maxBlastForce = 10;
        confettiduration = 3;
        break;
      case PaletteGrade.legendary:
        emissionFrequency = 0.04;
        minBlastForce = 6;
        maxBlastForce = 20;
        confettiduration = 8;
        break;
      default:
        emissionFrequency = 0.01;
        minBlastForce = 1;
        maxBlastForce = 1.1;
        confettiduration = 1;
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.topCenter,
      children: [
        Dialog(
          surfaceTintColor: Colors.white,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
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
                PaletteDisplay(palette: newPalette),
                const SizedBox(height: 16),
                PaletteGradeBadge(grade: newPalette.grade),
                const SizedBox(height: 8),
                Text(newPalette.name,
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 16)),
                const SizedBox(height: 16),
                ActionButtons(
                  quantityLeft: quantityLeft,
                  onReConsume: handleReConsume,
                  onConfirm: handleConfirm,
                ),
              ],
            ),
          ),
        ),
        ConfettiWidget(
          key: _confettiKey, // 재생성을 위해 새로운 키 사용
          confettiController: confettiController,
          shouldLoop: false,
          blastDirectionality: BlastDirectionality.explosive,
          emissionFrequency: emissionFrequency,
          minBlastForce: minBlastForce,
          maxBlastForce: maxBlastForce,
        )
      ],
    );
  }
}

class PaletteDisplay extends StatelessWidget {
  final PaletteModel palette;

  const PaletteDisplay({super.key, required this.palette});

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

class ActionButtons extends StatelessWidget {
  final int quantityLeft;
  final VoidCallback onReConsume;
  final VoidCallback onConfirm;

  const ActionButtons({
    super.key,
    required this.quantityLeft,
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
            child: Text("다시뽑기 x $quantityLeft"),
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
