import 'package:flutter/material.dart';
import 'package:memory_plant_application/providers/language_provider.dart';
import 'package:memory_plant_application/styles/app_styles.dart';
import 'package:provider/provider.dart';

class StartPage extends StatefulWidget {
  static var selectedLanguage = 'ko';

  const StartPage({super.key});

  @override
  State<StartPage> createState() => _StartPageState();
}

class _StartPageState extends State<StartPage>
    with SingleTickerProviderStateMixin {
  int currentButtonIndex = 0;
  late AnimationController _controller;
  late Animation<double> _animation;

  final List<List<String>> buttonTexts = [
    ['한국어', 'English'],
    ['Sign in with Google', 'Sign in with Apple'],
  ];

  @override
  void initState() {
    super.initState();

    // AnimationController 설정
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat(reverse: true);

    // Animation 정의
    _animation = Tween<double>(begin: 0, end: 1).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void changeButton() {
    setState(() {
      if (currentButtonIndex < buttonTexts.length - 1) {
        currentButtonIndex++;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final isKorean =
        context.watch<LanguageProvider>().currentLanguage == Language.ko;
    return Scaffold(
      backgroundColor: AppStyles.maindeepblue, // 배경을 maindeepblue로 설정
      body: Stack(
        children: [
          // 다층 흰색 울렁이는 배경 애니메이션 추가
          AnimatedBuilder(
            animation: _animation,
            builder: (context, child) {
              return Stack(
                children: [
                  Positioned.fill(
                    child: ClipPath(
                      clipper: WaveClipper(1, _animation.value),
                      child: Container(
                        color: Colors.white.withOpacity(0.3),
                      ),
                    ),
                  ),
                  Positioned.fill(
                    child: ClipPath(
                      clipper: WaveClipper(2, _animation.value),
                      child: Container(
                        color: Colors.white.withOpacity(0.2),
                      ),
                    ),
                  ),
                  Positioned.fill(
                    child: ClipPath(
                      clipper: WaveClipper(3, _animation.value),
                      child: Container(
                        color: Colors.white.withOpacity(0.15),
                      ),
                    ),
                  ),
                  Positioned.fill(
                    child: ClipPath(
                      clipper: WaveClipper(4, _animation.value),
                      child: Container(
                        color: Colors.white.withOpacity(0.1),
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
          // 메인 콘텐츠
          Center(
            child: Column(
              //mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 180),
                Text(
                  'AI for\nrecording life',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 50,
                    fontFamily: 'NanumFontSetup_TTF_SQUARE',
                    fontWeight: FontWeight.w900,
                    color: Colors.white,
                    shadows: [
                      Shadow(
                        offset: const Offset(3.0, 3.0),
                        blurRadius: 6.0,
                        color: Colors.black.withOpacity(0.05),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 60),
                Text(
                  currentButtonIndex == 0
                      ? 'Please select your preferred language'
                      : isKorean
                          ? '로그인할 계정을 선택해주세요'
                          : 'Select the account to log in',
                  style: const TextStyle(
                    fontSize: 18,
                    fontFamily: 'NanumFontSetup_TTF_SQUARE',
                    fontWeight: FontWeight.w400,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 30),
                Column(
                  children: [
                    OutlinedButton(
                      onPressed: () {
                        if (currentButtonIndex == 0) {
                          context
                              .read<LanguageProvider>()
                              .setLanguage(Language.ko);
                        } else if (currentButtonIndex == 1) {
                          Navigator.pushNamed(context, "/nameInputPage");
                        }
                        changeButton();
                      },
                      style: OutlinedButton.styleFrom(
                        minimumSize: const Size(250, 50),
                        backgroundColor: Colors.white, // 버튼 배경을 흰색으로 설정
                        side: const BorderSide(color: Colors.white),
                      ),
                      child: Text(
                        buttonTexts[currentButtonIndex][0],
                        style: TextStyle(
                            color: AppStyles
                                .maindeepblue), // 텍스트 색상을 maindeepblue로 설정
                      ),
                    ),
                    const SizedBox(height: 20),
                    OutlinedButton(
                      onPressed: () {
                        if (currentButtonIndex == 0) {
                          context
                              .read<LanguageProvider>()
                              .setLanguage(Language.en);
                        } else if (currentButtonIndex == 1) {
                          Navigator.pushNamed(context, "/nameInputPage");
                        }
                        changeButton();
                      },
                      style: OutlinedButton.styleFrom(
                        minimumSize: const Size(250, 50),
                        backgroundColor: Colors.white,
                        side: const BorderSide(color: Colors.white),
                      ),
                      child: Text(
                        buttonTexts[currentButtonIndex][1],
                        style: TextStyle(
                            color: AppStyles
                                .maindeepblue), // 텍스트 색상을 maindeepblue로 설정
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class WaveClipper extends CustomClipper<Path> {
  final int waveLevel;
  final double animationValue;

  WaveClipper(this.waveLevel, this.animationValue);

  @override
  Path getClip(Size size) {
    var path = Path();
    double waveHeight =
        50.0 * waveLevel * (1 + 0.1 * animationValue); // 애니메이션 값에 따라 높이 조정

    path.lineTo(0, size.height - waveHeight);

    // 곡선 효과 추가
    path.quadraticBezierTo(
      size.width * 0.25,
      size.height - (waveHeight + 30),
      size.width * 0.5,
      size.height - waveHeight,
    );
    path.quadraticBezierTo(
      size.width * 0.75,
      size.height - (waveHeight - 30),
      size.width,
      size.height - waveHeight,
    );

    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);

    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => true;
}
