import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

/// returns the admob banner ad widget if it is ready
class AdmobBannerAdWidget extends StatefulWidget {
  AdmobBannerAdWidget({Key? key}) : super(key: key);

  @override
  _AdmobBannerAdWidgetState createState() => _AdmobBannerAdWidgetState();
}

class _AdmobBannerAdWidgetState extends State<AdmobBannerAdWidget> {
  /// check if the ads is loading or not
  bool loadingAnchoredBanner = false;

  ///banner ad variable
  BannerAd? anchoredBanner;

  /// adrequest object
  static final AdRequest request = AdRequest(
    keywords: <String>['quiz', 'driving', 'license', 'funny', 'utility'],
    nonPersonalizedAds: true,
  );

  @override
  void initState() {
    super.initState();
  }

  /// create banner ad
  Future<void> createAnchoredBanner(BuildContext context) async {
    final AnchoredAdaptiveBannerAdSize? size =
        await AdSize.getAnchoredAdaptiveBannerAdSize(
      Orientation.portrait,
      MediaQuery.of(context).size.width.truncate(),
    );

    if (size == null) {
      print('Unable to get height of anchored banner.');
      return;
    }

    final BannerAd banner = BannerAd(
      size: size,
      request: request,
      adUnitId: "ca-app-pub-9000154121468885/9826805122",
      listener: BannerAdListener(
        onAdLoaded: (Ad ad) {
          print('$BannerAd loaded.');
          setState(() {
            anchoredBanner = ad as BannerAd?;
          });
        },
        onAdFailedToLoad: (Ad ad, LoadAdError error) {
          print('$BannerAd failedToLoad: $error');
          ad.dispose();
        },
        onAdOpened: (Ad ad) => print('$BannerAd onAdOpened.'),
        onAdClosed: (Ad ad) => print('$BannerAd onAdClosed.'),
      ),
    );
    return banner.load();
  }

  @override
  void dispose() {
    anchoredBanner?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Builder(builder: (BuildContext context) {
      if (!loadingAnchoredBanner) {
        createAnchoredBanner(context);
        loadingAnchoredBanner = true;
      }
      return Container(
        child: (anchoredBanner != null)
            ? Container(
                margin: EdgeInsets.symmetric(vertical: 10),
                color: Colors.white,
                width: anchoredBanner?.size.width.toDouble(),
                height: anchoredBanner?.size.height.toDouble(),
                child: AdWidget(ad: anchoredBanner!),
              )
            : Container(),
      );
    });
  }
}
