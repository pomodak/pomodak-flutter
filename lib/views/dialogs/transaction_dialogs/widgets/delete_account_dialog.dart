import 'package:flutter/material.dart';
import 'package:pomodak/view_models/auth_view_model.dart';
import 'package:provider/provider.dart';

class DeleteAccountDialog extends StatelessWidget {
  const DeleteAccountDialog({super.key});

  @override
  Widget build(BuildContext context) {
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
                const Text(
                  "정말 계정을 삭제하시겠습니까?",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const Text(
                  "서버에 저장된 모든 데이터가 삭제되며 데이터를 복구할 수 없습니다.",
                  style: TextStyle(fontSize: 14, color: Colors.red),
                ),
                const SizedBox(height: 16),
                _buildActionButtons(context),
              ],
            );
          })),
    );
  }
}

Widget _buildActionButtons(BuildContext context) {
  return StatefulBuilder(
    builder: (BuildContext context, StateSetter setState) {
      final authViewModel = Provider.of<AuthViewModel>(context, listen: false);

      void handleDeleteAccount() async {
        await authViewModel.deleteAccount();
        (mounted) {
          Navigator.of(context).pop(); // 현재 대화상자를 닫음
        };
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
              onPressed: handleDeleteAccount,
              child: const Text(
                "확인",
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
        ],
      );
    },
  );
}
