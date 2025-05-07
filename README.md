# 🙋‍♀️ 고민 해결 - 1초 컷

**"고민될 땐 버튼만 눌러!"**  
병맛 스타일로 YES/NO를 대신 정해주는 ✨ 단순하지만 유쾌한 Flutter 앱입니다.

![app_icon](assets/icon.png) <!-- 앱 아이콘 이미지 경로는 GitHub에 올린 후 맞춰줘 -->

---

## 🧠 주요 기능

- ✅ 고민 리스트에서 선택만 하면
- 🎲 랜덤하게 긍정/부정 결과 출력!
- 😂 병맛 스타일의 결과 문구
- 😈 부정 결과일 땐 귀여운 캐릭터 + 눈물 + 비 오는 연출
- 📱 전면 광고로 수익화 (종료 시 팝업과 함께 노출)
- 💜 귀엽고 연보라톤 감성 UI

---

## 📱 스크린샷

| 홈 화면 | 결과 화면 | 종료 팝업 |
|--------|-----------|------------|
| ![홈](assets/screens/home.png) | ![결과](assets/screens/result.png) | ![종료](assets/screens/exit.png) |

---

## 🛠️ 기술 스택

- Flutter 3.19+
- Dart
- Google Mobile Ads (배너/전면광고)
- Google Fonts
- 상태 관리: setState (단순 구조)

---

## 🚫 민감 정보 관리

광고 ID는 `.gitignore` 처리된 `lib/secrets.dart` 파일에 별도 분리하여 관리합니다.

```dart
// lib/secrets.dart
class Secrets {
  static const String realBannerAdId = 'your-real-banner-id';
  static const String realInterstitialAdId = 'your-real-interstitial-id';
}
