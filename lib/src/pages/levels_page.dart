import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:where_is_my_cheese/src/data/data.dart';
import 'package:where_is_my_cheese/src/utils/admob/banner_ad_widget.dart';

import 'game_page.dart';

const int maxFailedLoadAttempts = 3;

class LevelsPage extends StatefulWidget {
  LevelsPage({Key? key}) : super(key: key);

  @override
  _LevelsPageState createState() => _LevelsPageState();
}

class _LevelsPageState extends State<LevelsPage> {
  int currentLevel = 1;

  InterstitialAd? _interstitialAd;
  static final AdRequest request = AdRequest(
    keywords: <String>['game', 'maze', 'fun', 'arcade', 'mind'],
    nonPersonalizedAds: true,
  );
  int _numInterstitialLoadAttempts = 3;

  @override
  void initState() {
    super.initState();
    init();
  }

  init() async {
    _createInterstitialAd();
    final prefs = await SharedPreferences.getInstance();
    final int _currentLevel = prefs.getInt('currentLevel') ?? 1;
    setState(() {
      currentLevel = _currentLevel;
    });
  }

  reset() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setInt('currentLevel', 1);
    init();
  }

  void _createInterstitialAd() {
    InterstitialAd.load(
      adUnitId: "ca-app-pub-9000154121468885/2107456574",
      request: request,
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (InterstitialAd ad) {
          print('$ad loaded');
          _interstitialAd = ad;
          _numInterstitialLoadAttempts = 0;
        },
        onAdFailedToLoad: (LoadAdError error) {
          print('InterstitialAd failed to load: $error.');
          _numInterstitialLoadAttempts += 1;
          _interstitialAd = null;
          if (_numInterstitialLoadAttempts <= maxFailedLoadAttempts) {
            _createInterstitialAd();
          }
        },
      ),
    );
  }

  void _showInterstitialAd() {
    if (_interstitialAd == null) {
      print('Warning: attempt to show interstitial before loaded.');
      return;
    }
    _interstitialAd!.fullScreenContentCallback = FullScreenContentCallback(
      onAdShowedFullScreenContent: (InterstitialAd ad) =>
          print('ad onAdShowedFullScreenContent.'),
      onAdDismissedFullScreenContent: (InterstitialAd ad) {
        print('$ad onAdDismissedFullScreenContent.');
        ad.dispose();
        _createInterstitialAd();
      },
      onAdFailedToShowFullScreenContent: (InterstitialAd ad, AdError error) {
        print('$ad onAdFailedToShowFullScreenContent: $error');
        ad.dispose();
        _createInterstitialAd();
      },
    );
    _interstitialAd!.show();
    _interstitialAd = null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.only(
                left: 16,
                right: 16,
                top: 16,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    color: Theme.of(context).primaryColor,
                    margin: EdgeInsets.only(bottom: 15),
                    child: IconButton(
                        icon: Icon(Icons.arrow_back),
                        onPressed: () {
                          Navigator.pop(context);
                        }),
                  ),
                  GestureDetector(
                    onTap: () {},
                    child: Container(
                      color: Theme.of(context).backgroundColor,
                      margin: EdgeInsets.only(bottom: 15),
                      child: IconButton(
                          icon: Icon(Icons.delete),
                          onPressed: () {
                            showDialog(
                                context: context,
                                builder: (_) {
                                  return AlertDialog(
                                    title: Text("Warning"),
                                    content: Text(
                                        "Are you sure you want to rest your progress?"),
                                    actions: [
                                      TextButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                        child: Text("Cancel"),
                                      ),
                                      TextButton(
                                        style: TextButton.styleFrom(
                                          primary: Colors.red,
                                        ),
                                        onPressed: () {
                                          reset();
                                          Navigator.pop(context);
                                        },
                                        child: Text("Reset"),
                                      ),
                                    ],
                                  );
                                });
                          }),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: buildLevels(currentLevel),
              ),
            ),
            AdmobBannerAdWidget()
          ],
        ),
      ),
    );
  }

  Widget buildLevels(int currentLevel) {
    final orientation = MediaQuery.of(context).orientation;
    return Container(
      child: GridView.builder(
        shrinkWrap: true,
        itemCount: data.length,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: (orientation == Orientation.portrait) ? 3 : 6,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
        ),
        itemBuilder: (BuildContext context, int index) {
          return index + 1 <= currentLevel
              ? buildAvailableLevel(index)
              : buildLockedLevel(index);
        },
      ),
    );
  }

  Widget buildAvailableLevel(int index) {
    return GestureDetector(
      onTap: () async {
        _showInterstitialAd();
        bool? isCompleted = await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => GamePage(index: index),
          ),
        );
        if (isCompleted != null && isCompleted) {
          init();
          setState(() {});
        }
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
        ),
        child: GridTile(
          child: Container(
            color: (index + 1 < currentLevel)
                ? Theme.of(context).primaryColor.withOpacity(0.5)
                : Colors.green.withOpacity(0.25),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  "${index + 1}",
                  style: TextStyle(
                    color: Theme.of(context).scaffoldBackgroundColor,
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  "Level",
                  style: TextStyle(
                    color: Theme.of(context).scaffoldBackgroundColor,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildLockedLevel(int index) {
    return GestureDetector(
      onTap: () {
        ScaffoldMessenger.of(context).removeCurrentSnackBar();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
                "Do not be greedy.\n\nGet the CHEESE from Level $currentLevel to get here. "),
            duration: Duration(seconds: 3),
            behavior: SnackBarBehavior.floating,
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
        ),
        child: GridTile(
          child: Container(
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Stack(
              children: [
                Container(
                  padding: EdgeInsets.all(5),
                  child: Icon(Icons.lock),
                ),
                Align(
                  alignment: Alignment.center,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        "${index + 1}",
                        style: TextStyle(
                          color: Theme.of(context).scaffoldBackgroundColor,
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        "Level",
                        style: TextStyle(
                          color: Theme.of(context).scaffoldBackgroundColor,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
