import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:school_schedule/config/config.dart';

class AdLayout extends StatelessWidget {
  final double? height;

  const AdLayout({super.key, this.height});

  @override
  Widget build(BuildContext context) {
    TargetPlatform os = Theme.of(context).platform;

    BannerAd banner = BannerAd(
      size: AdSize.banner,
      adUnitId: os == TargetPlatform.iOS
          ? config.adMobIosAdUnitId
          : config.adMobAosAdUnitId,
      listener: const BannerAdListener(),
      request: const AdRequest(),
    )..load();

    return SizedBox(
      height: height ?? 100,
      child: AdWidget(
        ad: banner,
      ),
    );
  }
}
