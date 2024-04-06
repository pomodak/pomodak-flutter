import 'package:flutter/material.dart';
import 'package:pomodak/models/api/members/consume_item_response.dart';
import 'package:pomodak/models/domain/character_model.dart';
import 'package:pomodak/views/screens/main/inventory_screen/widgets/grade_badge.dart';

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

class CharacterAcquisitionDialog extends StatelessWidget {
  final CharacterAcquisition result;

  const CharacterAcquisitionDialog({super.key, required this.result});

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
            _CharacterDetails(character: result.character),
            _ConfirmButton(),
          ],
        ),
      ),
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
