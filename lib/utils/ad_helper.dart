// lib/utils/ad_helper.dart
import 'package:flutter/foundation.dart';
import '../secrets.dart'; // 이 파일은 .gitignore에 포함시킴

class AdHelper {
  static String get bannerAdUnitId {
    return kReleaseMode
        ? Secrets.realBannerAdId
        : 'ca-app-pub-3940256099942544/6300978111';
  }

  static String get interstitialAdUnitId {
    return kReleaseMode
        ? Secrets.realInterstitialAdId
        : 'ca-app-pub-3940256099942544/1033173712';
  }
}
