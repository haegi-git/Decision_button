import 'package:decision_button/screens/decision_screen.dart';
import 'package:decision_button/widgerts/banner_ad_widget.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import '../utils/ad_helper.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  InterstitialAd? _interstitialAd;

  final List<String> worries = [
    "야식 먹을까?",
    "운동 갈까?",
    "공부할까?",
    "지를까 말까?",
    "한다 만다?",
    "퇴사할까?",
    "나갈까?",
    "잘까?",
    "다이어트 할까?",
  ];

  @override
  void initState() {
    super.initState();
    _loadInterstitialAd();
  }

  void _loadInterstitialAd() {
    InterstitialAd.load(
      adUnitId: AdHelper.interstitialAdUnitId,
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (InterstitialAd ad) {
          _interstitialAd = ad;
        },
        onAdFailedToLoad: (LoadAdError error) {
          debugPrint('InterstitialAd failed to load: $error');
        },
      ),
    );
  }

  void _showExitDialog() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("앱 종료"),
        content: const Text("정말 종료하시겠어요?"),
        actions: [
          TextButton(
            child: const Text("취소"),
            onPressed: () {
              Navigator.of(ctx).pop();
            },
          ),
          TextButton(
            child: const Text("종료"),
            onPressed: () {
              _interstitialAd?.show();
              _interstitialAd?.dispose();
              Navigator.of(ctx).pop();
              Future.delayed(const Duration(milliseconds: 500), () {
                Navigator.of(context).pop();
              });
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        _showExitDialog();
        return false;
      },
      child: Scaffold(
        backgroundColor: const Color(0xFFFFF7ED),
        appBar: AppBar(
          title: Text(
            '고민 리스트',
            style: GoogleFonts.jua(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          centerTitle: true,
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        body: ListView.builder(
          padding: const EdgeInsets.all(20),
          itemCount: worries.length,
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          DecisionScreen(worry: worries[index]),
                    ),
                  );
                },
                borderRadius: BorderRadius.circular(16),
                splashColor: Colors.purple.withOpacity(0.1),
                child: Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFFF8F0FF),
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 8,
                        offset: const Offset(2, 4),
                      ),
                    ],
                  ),
                  padding: const EdgeInsets.symmetric(
                    vertical: 20,
                    horizontal: 24,
                  ),
                  child: Text(
                    worries[index],
                    style: GoogleFonts.jua(
                      fontSize: 18,
                      color: Colors.black87,
                    ),
                  ),
                ),
              ),
            );
          },
        ),
        bottomNavigationBar: const BannerAdWidget(),
      ),
    );
  }
}
