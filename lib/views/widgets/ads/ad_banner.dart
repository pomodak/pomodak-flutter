import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:pomodak/view_models/banner_ad_view_model.dart';
import 'package:provider/provider.dart';

class AdBanner extends StatelessWidget {
  const AdBanner({super.key});

  @override
  Widget build(BuildContext context) {
    var adViewModel = Provider.of<BannerAdViewModel>(context);
    return adViewModel.isBannerAdReady
        ? Container(
            alignment: Alignment.center,
            height: AdSize.banner.height.toDouble(),
            width: AdSize.banner.width.toDouble(),
            child: AdWidget(ad: adViewModel.bannerAd!),
          )
        : const SizedBox(height: 0); // 광고가 준비되지 않았다면 표시하지 않음
  }
}
