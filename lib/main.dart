// 파일: lib/main.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'screens/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // 필수!
  await MobileAds.instance.initialize(); // 광고 초기화
  runApp(const DecisionApp());
}

class DecisionApp extends StatelessWidget {
  const DecisionApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '고민 끝내기 버튼',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'Pretendard',
        scaffoldBackgroundColor: Colors.white,
        useMaterial3: true,
        textTheme: GoogleFonts.juaTextTheme(), // jua 폰트 전체 적용
      ),
      home: const SplashScreen(),
    );
  }
}
