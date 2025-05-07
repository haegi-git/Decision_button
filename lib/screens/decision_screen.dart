import 'package:decision_button/widgerts/banner_ad_widget.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:confetti/confetti.dart';
import 'dart:math';

import '../data/worry_messages.dart';

class DecisionScreen extends StatefulWidget {
  final String worry;

  const DecisionScreen({super.key, required this.worry});

  @override
  State<DecisionScreen> createState() => _DecisionScreenState();
}

class _DecisionScreenState extends State<DecisionScreen>
    with TickerProviderStateMixin {
  String? result;
  final player = AudioPlayer();
  ConfettiController? _confettiController;
  double _mouthControlY = 0;
  bool isPositiveResult = false;

  AnimationController? _shakeController;
  Animation<double>? _shakeAnimation;

  bool showTear = false;

  final List<String> positiveSounds = [
    'sounds/mixkit-birthday-crowd-party-cheer-531.wav',
    'sounds/mixkit-cartoon-sad-party-horn-527.wav',
  ];

  final List<String> negativeSounds = [
    'sounds/mixkit-cartoon-girl-saying-no-no-no-2257.wav',
    'sounds/mixkit-lost-kid-sobbing-474.wav',
  ];

  @override
  void initState() {
    super.initState();
    _confettiController =
        ConfettiController(duration: const Duration(seconds: 2));
    _shakeController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 300));
    _shakeAnimation = Tween<double>(begin: -10, end: 10)
        .chain(CurveTween(curve: Curves.elasticIn))
        .animate(_shakeController!);
  }

  @override
  void dispose() {
    _confettiController?.dispose();
    player.dispose();
    _shakeController?.dispose();
    super.dispose();
  }

  void decide() async {
    final isPositive = Random().nextBool();
    final worry = widget.worry;

    final newResult = isPositive
        ? (positiveMessagesMap[worry] ?? ["응원해!"])[
            Random().nextInt((positiveMessagesMap[worry] ?? ["응원해!"]).length)]
        : (negativeMessagesMap[worry] ?? ["다시 생각해봐"])[Random()
            .nextInt((negativeMessagesMap[worry] ?? ["다시 생각해봐"]).length)];

    final selectedSound = isPositive
        ? positiveSounds[Random().nextInt(positiveSounds.length)]
        : negativeSounds[Random().nextInt(negativeSounds.length)];

    setState(() {
      result = newResult;
      isPositiveResult = isPositive;
      _mouthControlY = isPositive ? 20 : -20;
      showTear = !isPositive;
    });

    if (isPositive) {
      _confettiController?.play();
    } else {
      _shakeController?.forward(from: 0);
    }

    await player.stop();
    await player.play(AssetSource(selectedSound));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF8F0),
      appBar: AppBar(
        title: Text(
          widget.worry,
          style: GoogleFonts.jua(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: AnimatedBuilder(
              animation: _shakeAnimation ?? AlwaysStoppedAnimation(0.0),
              builder: (context, child) {
                return Transform.translate(
                  offset: isPositiveResult
                      ? Offset.zero
                      : Offset(_shakeAnimation?.value ?? 0, 0),
                  child: Stack(
                    children: [
                      if (showTear)
                        Positioned(
                          top: MediaQuery.of(context).size.height / 2 - 220,
                          left: MediaQuery.of(context).size.width / 2 - 40,
                          child: Icon(Icons.cloud,
                              size: 100, color: Colors.grey.withOpacity(0.6)),
                        ),
                      if (showTear)
                        Positioned(
                          top: MediaQuery.of(context).size.height / 2 - 30,
                          left: MediaQuery.of(context).size.width / 2 - 8,
                          child: TweenAnimationBuilder(
                            tween: Tween<double>(begin: 0, end: 60),
                            duration: const Duration(seconds: 1),
                            builder: (context, value, child) {
                              return Opacity(
                                opacity: 1 - (value / 60),
                                child: Transform.translate(
                                  offset: Offset(0, value),
                                  child: Container(
                                    width: 12,
                                    height: 12,
                                    decoration: BoxDecoration(
                                      color: Colors.blueAccent,
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          TweenAnimationBuilder(
                            tween: Tween<double>(begin: 0, end: _mouthControlY),
                            duration: const Duration(milliseconds: 500),
                            builder: (context, value, child) {
                              return Center(
                                child: CustomPaint(
                                  size: const Size(120, 120),
                                  painter: FacePainter(controlY: value),
                                ),
                              );
                            },
                          ),
                          const SizedBox(height: 24),
                          if (result != null)
                            Text(
                              result!,
                              style: GoogleFonts.jua(fontSize: 26),
                              textAlign: TextAlign.center,
                            ),
                          const SizedBox(height: 32),
                          Center(
                            child: ElevatedButton(
                              onPressed: decide,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.purple,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(24),
                                ),
                                padding: const EdgeInsets.symmetric(
                                  vertical: 16,
                                  horizontal: 32,
                                ),
                              ),
                              child: Text(
                                result == null ? '고민 끝내기 버튼' : '다시 결정하기',
                                style: GoogleFonts.jua(
                                    fontSize: 20, color: Colors.white),
                              ),
                            ),
                          ),
                        ],
                      ),
                      if (_confettiController != null)
                        ConfettiWidget(
                          confettiController: _confettiController!,
                          blastDirectionality: BlastDirectionality.explosive,
                          shouldLoop: false,
                          numberOfParticles: 30,
                          gravity: 0.2,
                          emissionFrequency: 0.05,
                          colors: const [
                            Colors.purple,
                            Colors.blue,
                            Colors.orange,
                            Colors.pink,
                            Colors.yellow
                          ],
                        ),
                    ],
                  ),
                );
              },
            ),
          ),
          const BannerAdWidget(),
        ],
      ),
    );
  }
}

class FacePainter extends CustomPainter {
  final double controlY;
  FacePainter({required this.controlY});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.black
      ..strokeWidth = 4
      ..style = PaintingStyle.stroke;

    final center = Offset(size.width / 2, size.height / 2);
    canvas.drawCircle(center, 50, paint);
    canvas.drawCircle(Offset(center.dx - 20, center.dy - 20), 4, paint);
    canvas.drawCircle(Offset(center.dx + 20, center.dy - 20), 4, paint);

    final mouthStart = Offset(center.dx - 20, center.dy + 20);
    final mouthEnd = Offset(center.dx + 20, center.dy + 20);
    final control = Offset(center.dx, center.dy + 20 + controlY);
    final path = Path()
      ..moveTo(mouthStart.dx, mouthStart.dy)
      ..quadraticBezierTo(control.dx, control.dy, mouthEnd.dx, mouthEnd.dy);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant FacePainter oldDelegate) {
    return oldDelegate.controlY != controlY;
  }
}
