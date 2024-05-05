import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:pomodak/di.dart';
import 'package:pomodak/utils/admob_helper.dart';
import 'package:pomodak/utils/message_util.dart';
import 'package:pomodak/view_models/transaction_view_model.dart';

class RewardedAdViewModel extends ChangeNotifier {
  RewardedAd? _rewardedAd; // 보상형 광고 객체
  bool _rewardEarned = false; // 보상 획득 상태
  bool isAdReady = false; // 광고가 준비되었는지의 여부
  DateTime? _lastAdWatchTime; // 마지막 광고 시청 시간
  static const Duration cooldownDuration = Duration(minutes: 15); // 15분 쿨다운
  static const Duration autoReloadDelay = Duration(seconds: 10); // 15분 쿨다운
  Timer? _cooldownTimer; // 광고 로드 예약

  // 보상형 광고를 로드 (타이머 페이지에서 미리 호출)
  void loadRewardedAd() {
    if (_lastAdWatchTime != null &&
        DateTime.now().difference(_lastAdWatchTime!) < cooldownDuration) {
      if (_cooldownTimer != null) return; // 이미 로드 예약
      _startCooldownTimer();
      return;
    }

    RewardedAd.load(
      adUnitId: AdMobHelper.rewardedAdUnitId,
      request: const AdRequest(),
      rewardedAdLoadCallback: RewardedAdLoadCallback(
        onAdLoaded: (RewardedAd ad) {
          debugPrint('보상형 광고 로드 완료');
          _rewardedAd = ad;
          isAdReady = true;
          _cooldownTimer = null;
          notifyListeners();
        },
        onAdFailedToLoad: (LoadAdError error) {
          debugPrint('보상형 광고 로드 실패: ${error.message}');
          isAdReady = false;
          _cooldownTimer = null;
          notifyListeners();
        },
      ),
    );
  }

  // 준비된 광고 표시
  void showRewardedAd({int points = 0}) {
    if (_rewardedAd == null || !isAdReady) {
      debugPrint('광고 준비 안 됨.');
      return;
    }

    _rewardedAd!.fullScreenContentCallback = FullScreenContentCallback(
      onAdShowedFullScreenContent: (RewardedAd ad) => debugPrint('광고 표시됨.'),
      onAdDismissedFullScreenContent: (RewardedAd ad) {
        debugPrint('광고 닫힘');
        if (_rewardEarned) {
          MessageUtil.showSuccessToast("$points 포인트를 추가 획득하였습니다!!");
        }
        ad.dispose(); // 광고 닫힐 때 리소스 해제
        _rewardEarned = false;
        isAdReady = false;
        _rewardedAd = null;
        _lastAdWatchTime = DateTime.now(); // 광고 시청 시간 갱신
        notifyListeners();
      },
      onAdFailedToShowFullScreenContent: (RewardedAd ad, AdError error) {
        debugPrint('보상형 광고 표시 실패: ${error.message}');
        ad.dispose(); // 표시 실패시 리소스 해제
        _rewardEarned = false;
        isAdReady = false;
        _rewardedAd = null;
        notifyListeners();
      },
    );

    _rewardedAd!.show(
      onUserEarnedReward: (AdWithoutView ad, RewardItem reward) {
        debugPrint('보상 획득: ${reward.type}, 수량 ${reward.amount}');

        if (reward.type == 'double_points') {
          // 포인트 한번 더 적립
          getIt<TransactionViewModel>().rewardPoints(points);
          _rewardEarned = true; // 앱으로 돌아가 보상 획득 여부를 알리기 위한 플래그
        }
      },
    );
  }

// 쿨다운 타이머 시작
  void _startCooldownTimer() {
    _cooldownTimer?.cancel();
    final timeRemaining =
        cooldownDuration - DateTime.now().difference(_lastAdWatchTime!);
    debugPrint(
        "${timeRemaining.inSeconds + autoReloadDelay.inSeconds}초 후 광고가 로드됩니다.");
    _cooldownTimer = Timer(timeRemaining + autoReloadDelay, loadRewardedAd);
  }

  @override
  void dispose() {
    _rewardedAd?.dispose();
    super.dispose();
  }
}
