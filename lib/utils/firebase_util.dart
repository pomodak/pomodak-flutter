import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:pomodak/views/dialogs/alert_dialogs/alert_dialog_manager.dart';
import 'package:pub_semver/pub_semver.dart';

class FirebaseUtil {
  // 최신버전이 아니면 false을 반환하여 splash screen에서 앱 업데이트 다이얼로그를 띄우도록 함
  static Future<bool> checkAppVersion(BuildContext context) async {
    final remoteConfig = FirebaseRemoteConfig.instance;

    /* ##### 파이어베이스 매개변수 값 호출 ##### */
    await remoteConfig.setConfigSettings(RemoteConfigSettings(
      fetchTimeout: const Duration(minutes: 1),
      minimumFetchInterval: const Duration(hours: 1),
    ));
    await remoteConfig.fetchAndActivate();

    /* ##### 버전 정보 가져오기 ##### */
    // 파이어베이스 버전 정보 가져오기 : 매개변수명 latest_version
    String firebaseVersion = remoteConfig.getString("latest_version");

    // 앱 버전 정보 가져오기
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    String appVersion = packageInfo.version;

    if (kDebugMode) {
      print(
        "### Version Check : Latest Version : $firebaseVersion, App Version : $appVersion",
      );
    }

    /* ##### 버전 체크 ##### */
    // 최신 버전이 존재하면 버전 업데이트
    Version currentVersion = Version.parse(appVersion);
    Version latestVersion = Version.parse(firebaseVersion);

    if (latestVersion > currentVersion && context.mounted) {
      AlertDialogManager.showUpdateDialog(context);
      return false;
    }

    return true;
  }
}
