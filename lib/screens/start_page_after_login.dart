import 'package:flutter/material.dart';
import 'package:memory_plant_application/providers/language_provider.dart';
import 'package:memory_plant_application/styles/app_styles.dart';
import 'package:provider/provider.dart';
import 'package:memory_plant_application/providers/name_provider.dart';
import 'package:memory_plant_application/providers/memory_log_provider.dart';

class StartPageAfterLogin extends StatefulWidget {
  const StartPageAfterLogin({super.key});

  @override
  State<StartPageAfterLogin> createState() => _StartPageAfterLoginState();
}

class _StartPageAfterLoginState extends State<StartPageAfterLogin>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

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

  String _getMonthAbbreviation(int month) {
    const months = [
      'jan',
      'feb',
      'mar',
      'apr',
      'may',
      'jun',
      'jul',
      'aug',
      'sep',
      'oct',
      'nov',
      'dec'
    ];
    return months[month - 1];
  }

  @override
  Widget build(BuildContext context) {
    final nameProvider = Provider.of<NameProvider>(context, listen: true);
    final memoryLogProvider =
    Provider.of<MemoryLogProvider>(context); // MemoryLogProvider 가져오기
    final isKorean =
        context.watch<LanguageProvider>().currentLanguage == Language.ko;
    final memoryCount = memoryLogProvider.memoryList
        .where((memory) => memory.isUser == true)
        .length; // 내가 쓴 메모리 개수

    return GestureDetector(
      onTap: () {
        // 화면 탭 시 다음 페이지로 이동
        Navigator.pushNamed(context, "/bottomNavPage");
      },
      child: Scaffold(
        backgroundColor: AppStyles.maindeepblue,
        appBar: AppBar(
          backgroundColor: AppStyles.maindeepblue,
          elevation: 0,
          automaticallyImplyLeading: false,
          title: const Text(
            "",
            style: TextStyle(fontWeight: FontWeight.w700, color: Colors.white),
          ),
          centerTitle: true,
        ),
        body: Stack(
          children: [
            // 파도 애니메이션 배경
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
                children: [
                  const SizedBox(height: 5),
                  Padding(
                    padding: const EdgeInsets.only(left: 35),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        '${DateTime.now().year}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontFamily: 'NanumFontSetup_TTF_SQUARE_Bold',
                          fontSize: 64,
                          fontWeight: FontWeight.w900,
                          height: 1,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.only(left: 35),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        '${_getMonthAbbreviation(DateTime.now().month)} ${DateTime.now().day}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontFamily: 'NanumFontSetup_TTF_SQUARE_Bold',
                          fontSize: 50,
                          fontWeight: FontWeight.w600,
                          height: 1,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Padding(
                    padding: const EdgeInsets.only(left: 35),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        isKorean
                            ? '${nameProvider.name}님 환영합니다!'
                            : "Welcome ${nameProvider.name}!",
                        style: const TextStyle(
                          color: Colors.white,
                          fontFamily: 'NanumFontSetup_TTF_SQUARE_Bold',
                          fontSize: 18,
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 35),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        isKorean
                            ? "$memoryCount개의 일기" // 메모리 개수 표시
                            : "$memoryCount Journals",
                        style: const TextStyle(
                          color: Colors.white,
                          fontFamily: 'NanumFontSetup_TTF_SQUARE_Bold',
                          fontWeight: FontWeight.w600,
                          fontSize: 30,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 80),
                  Text(
                    isKorean ? "화면을 탭하여 시작하기" : "Tap the screen to start",
                    style: TextStyle(
                      color: AppStyles.primaryColor,
                      fontFamily: 'NanumFontSetup_TTF_SQUARE_Bold',
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// 파도 애니메이션을 위한 클리퍼
class WaveClipper extends CustomClipper<Path> {
  final int waveLevel;
  final double animationValue;

  WaveClipper(this.waveLevel, this.animationValue);

  @override
  Path getClip(Size size) {
    var path = Path();
    double waveHeight = 50.0 * waveLevel * (1 + 0.1 * animationValue);

    path.lineTo(0, size.height - waveHeight);

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
