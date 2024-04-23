import 'package:flutter/material.dart';
import 'package:pomodak/views/dialogs/alert_dialogs/widgets/app_update_dialog.dart';

class AlertDialogManager {
  static void showUpdateDialog(BuildContext context) {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return const PopScope(
            canPop: false,
            child: AppUpdateDialog(),
          );
        });
  }
}
