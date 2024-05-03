import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

/// AdMob 헬퍼
///
class AdMobHelper {
  static String get bannerAdUnitId {
    if (Platform.isAndroid) {
      if (kDebugMode) {
        return 'ca-app-pub-3940256099942544/6300978111';
      }
      return dotenv.env['ANDROID_BANNER_AD_UNIT_ID'] ?? "";
    } else if (Platform.isIOS) {
      if (kDebugMode) {
        return 'ca-app-pub-3940256099942544/2934735716';
      }
      return "";
    } else {
      throw UnsupportedError('Unsupported platform');
    }
  }

  static String get rewardedAdUnitId {
    if (Platform.isAndroid) {
      if (kDebugMode) {
        return 'ca-app-pub-3940256099942544/5224354917';
      }
      return dotenv.env['ANDROID_REWARDED_AD_UNIT_ID'] ?? "";
    } else if (Platform.isIOS) {
      if (kDebugMode) {
        return 'ca-app-pub-3940256099942544/1712485313';
      }
      return "";
    } else {
      throw UnsupportedError('Unsupported platform');
    }
  }
}
