import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:pomodak/view_models/timer_state_view_model.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class LocalNotificationUtil {
  static const pomodoroNotificationId = 1;

  static final FlutterLocalNotificationsPlugin _local =
      FlutterLocalNotificationsPlugin();

  static void permissionWithNotification() async {
    if (await Permission.notification.isDenied &&
        !await Permission.notification.isPermanentlyDenied) {
      await [Permission.notification].request();
    }
  }

  static void initialization() async {
    AndroidInitializationSettings android =
        const AndroidInitializationSettings("@mipmap/ic_launcher");
    DarwinInitializationSettings ios = const DarwinInitializationSettings(
      requestSoundPermission: false,
      requestBadgePermission: false,
      requestAlertPermission: false,
    );
    InitializationSettings settings =
        InitializationSettings(android: android, iOS: ios);
    await _local.initialize(settings);
  }

  static void schedulePomodoroNotification({
    PomodoroMode? pomodoroMode, // null이면 모든 섹션 완료
    required int seconds,
  }) async {
    final String title;
    final String message;

    if (pomodoroMode == PomodoroMode.focus) {
      title = "닭이 지쳤어요!";
      message = "잠시 휴식을 취해주세요.";
    } else if (pomodoroMode == PomodoroMode.rest) {
      title = "닭이 잠에서 깨어났어요!";
      message = "다시 집중해주세요.";
    } else {
      title = "모든 섹션을 완료했어요!";
      message = "충분히 쉬고나서 다시 시작해주세요.";
    }

    NotificationDetails details = const NotificationDetails(
      iOS: DarwinNotificationDetails(
        presentAlert: true,
        presentBadge: true,
        presentSound: true,
      ),
      android: AndroidNotificationDetails(
        "show_test",
        "show_test",
        importance: Importance.max,
        priority: Priority.high,
      ),
    );
    tz.initializeTimeZones();
    tz.TZDateTime schedule =
        tz.TZDateTime.now(tz.local).add(Duration(seconds: seconds));

    await _local.zonedSchedule(
      pomodoroNotificationId,
      title,
      message,
      schedule,
      details,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: null,
    );
  }

  static void canclePomodoroNotification() async {
    _local.cancel(pomodoroNotificationId);
  }
}
