import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:pomodak/models/api/members/consume_item_response.dart';
import 'package:pomodak/models/domain/character_model.dart';
import 'package:pomodak/views/screens/main/inventory_screen/widgets/character_inventory_section/character_grade_badge.dart';

void showCharacterAcquisitionDialog(
  BuildContext context,
  CharacterAcquisition result,
) {
  showDialog(
    context: context,
    barrierDismissible: false,
    barrierColor: Colors.white,
    builder: (BuildContext context) => CharacterAcquisitionDialog(
      result: result,
    ),
  );
}

class CharacterAcquisitionDialog extends StatefulWidget {
  final CharacterAcquisition result;

  const CharacterAcquisitionDialog({super.key, required this.result});

  @override
  State<CharacterAcquisitionDialog> createState() =>
      _CharacterAcquisitionDialogState();
}

class _CharacterAcquisitionDialogState
    extends State<CharacterAcquisitionDialog> {
  late ConfettiController confettiController;
  late int confettiduration;
  late double emissionFrequency;
  late double minBlastForce;
  late double maxBlastForce;

  @override
  void initState() {
    super.initState();
    setConfettiProperties(widget.result.character);
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

  void setConfettiProperties(CharacterModel character) {
    switch (character.grade) {
      case CharacterGrade.rare:
        emissionFrequency = 0.02;
        minBlastForce = 3;
        maxBlastForce = 3.1;
        confettiduration = 2;
        break;
      case CharacterGrade.epic:
        emissionFrequency = 0.03;
        minBlastForce = 6;
        maxBlastForce = 10;
        confettiduration = 4;
        break;
      case CharacterGrade.legendary:
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
        Dialog.fullscreen(
          backgroundColor: Colors.white,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 56, horizontal: 24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              mainAxisSize: MainAxisSize.min,
              children: [
                _CharacterDetails(character: widget.result.character),
                _ConfirmButton(),
              ],
            ),
          ),
        ),
        ConfettiWidget(
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

class _CharacterDetails extends StatelessWidget {
  final CharacterModel character;

  const _CharacterDetails({required this.character});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Text('캐릭터 획득',
            style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
        const SizedBox(height: 20),
        Image.network(character.imageUrl,
            height: MediaQuery.of(context).size.height * 0.3),
        const SizedBox(height: 20),
        CharacterGradeBadge(grade: character.grade),
        const SizedBox(height: 20),
        Text(character.name,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        const SizedBox(height: 20),
        Text(character.description,
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
