import 'package:flutter/material.dart';
import 'package:store_redirect/store_redirect.dart';

class AppUpdateDialog extends StatelessWidget {
  const AppUpdateDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('새로운 버전 출시'),
      content: const Text('중요한 변경으로 인해 업데이트를 해야만 앱을 이용할 수 있어요.'),
      surfaceTintColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      insetPadding: const EdgeInsets.symmetric(horizontal: 12),
      actions: [
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.black,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(6),
            ),
          ),
          onPressed: () async {
            // 앱 업데이트
            StoreRedirect.redirect(
                androidAppId: 'com.pomodak.twa', iOSAppId: 'none');
          },
          child: const Text(
            "업데이트",
            style: TextStyle(color: Colors.white),
          ),
        ),
      ],
    );
  }
}
