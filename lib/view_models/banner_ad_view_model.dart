import 'package:flutter/foundation.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:pomodak/utils/admob_helper.dart';

class BannerAdViewModel extends ChangeNotifier {
  BannerAd? _bannerAd;
  bool _isBannerAdReady = false;

  BannerAdViewModel() {
    _loadBannerAd();
  }

  bool get isBannerAdReady => _isBannerAdReady;

  BannerAd? get bannerAd => _isBannerAdReady ? _bannerAd : null;

  void _loadBannerAd() {
    _bannerAd = BannerAd(
      adUnitId: AdMobHelper.bannerAdUnitId,
      size: AdSize.banner,
      request: const AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (_) {
          _isBannerAdReady = true;
          notifyListeners();
        },
        onAdFailedToLoad: (ad, error) {
          debugPrint('Failed to load a banner ad: ${error.message}');
          _isBannerAdReady = false;
          ad.dispose();
          notifyListeners();
        },
      ),
    );
    _bannerAd!.load();
  }

  @override
  void dispose() {
    _bannerAd?.dispose();
    super.dispose();
  }
}
