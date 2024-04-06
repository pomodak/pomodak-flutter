import 'package:flutter/material.dart';
import 'package:pomodak/models/api/members/consume_item_response.dart';

void showPointAcquisitionDialog(
  BuildContext context,
  PointAcquisition result,
) {
  showDialog(
    context: context,
    builder: (BuildContext context) => PointAcquisitionDialog(
      result: result,
    ),
  );
}

class PointAcquisitionDialog extends StatelessWidget {
  final PointAcquisition result;

  const PointAcquisitionDialog({super.key, required this.result});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      surfaceTintColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      insetPadding: const EdgeInsets.symmetric(horizontal: 12),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          mainAxisSize: MainAxisSize.min,
          children: [
            _ResultDetails(pointAcquisitionMember: result.member),
            _ConfirmButton(),
          ],
        ),
      ),
    );
  }
}

class _ResultDetails extends StatelessWidget {
  final PointAcquisitionMember pointAcquisitionMember;

  const _ResultDetails({required this.pointAcquisitionMember});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Text('포인트 획득',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
        const SizedBox(height: 20),
        Text(
          '${pointAcquisitionMember.point} 포인트를 획득했습니다!',
          style: const TextStyle(fontSize: 18),
        ),
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
