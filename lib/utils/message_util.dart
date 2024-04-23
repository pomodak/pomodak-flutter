import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:pomodak/router/app_router.dart';

class MessageUtil {
  static toastMessage(String message) {
    showSuccessToast(message);
  }

  static void showErrorToast(String message) {
    FToast fToast = FToast();
    fToast.init(navigatorKey.currentContext!);
    fToast.removeCustomToast();

    Widget toast = Container(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 10.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8.0),
        color: Colors.redAccent,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(message,
              style: const TextStyle(
                  color: Colors.white, fontSize: 14, letterSpacing: 1.2)),
        ],
      ),
    );

    fToast.showToast(
      child: toast,
      gravity: ToastGravity.BOTTOM,
      toastDuration: const Duration(seconds: 2),
    );
  }

  static void showSuccessToast(String message) {
    FToast fToast = FToast();
    fToast.init(navigatorKey.currentContext!);
    fToast.removeCustomToast();

    Widget toast = Container(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 10.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8.0),
        color: Colors.black,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(message,
              style: const TextStyle(
                  color: Colors.white, fontSize: 14, letterSpacing: 1.2)),
        ],
      ),
    );

    fToast.showToast(
      child: toast,
      gravity: ToastGravity.BOTTOM,
      toastDuration: const Duration(seconds: 2),
    );
  }
}
