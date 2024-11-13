import 'package:flutter/material.dart';
import 'package:memory_plant_application/screens/name_input_page.dart';
import 'package:memory_plant_application/styles/app_styles.dart';
import 'package:memory_plant_application/widgets/primary_box.dart';

/*
class StartPage extends StatefulWidget {
  static var selectedLanguage = 'ko';

  const StartPage({super.key});

  @override
  State<StartPage> createState() => _StartPageState();
}

class _StartPageState extends State<StartPage> {
  bool isLoginButtonVisible = false;
  int currentButtonIndex = 0;
  double primaryBoxTopPosition = -250; // 시작 위치 (화면 위)


  final List<List<String>> buttonTexts = [
    ['한국어', 'English'],
    ['Sign in with Google', 'Sign in with Apple'],
  ];

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      setState(() {
        primaryBoxTopPosition = -35; // 최종 위치 (화면에 표시될 위치)
      });
    });
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
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // PrimaryBox 애니메이션 추가
          AnimatedPositioned(
            duration: const Duration(milliseconds: 900),
            curve: Curves.easeOut,
            top: primaryBoxTopPosition,
            left: 0,
            right: 0,
            child: const PrimaryBox(height: 280),
          ),


          // 메인 콘텐츠
          Column(
            //mainAxisAlignment: MainAxisAlignment.center,

            children: [
              const SizedBox(height: 100),
              /*Center(
                child: Column(
                  children: [
                    Text(
                      'Wellcome to our',
                      style: const TextStyle(fontSize: 30, fontWeight: FontWeight.w600,color: Colors.white),
                    ),
                  ],
                ),
              ),
              Center(
                child: Text(
                  'Memory Plant',
                  style: const TextStyle(
                    fontSize: 50,
                    fontWeight: FontWeight.bold,
                    color:Colors.white,
                  ),
                ),
              ),*/
              const SizedBox(height: 20),
              if (currentButtonIndex == 0) ...[
                const Text(
                  'Please select your preferred languages',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600,color: Colors.white),
                ),
              ] else ...[
                Text(
                  StartPage.selectedLanguage == 'ko'
                      ? '로그인할 계정을 선택해주세요\n'
                      : 'Select the account to log in\n',
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600,color: Colors.white),
                ),
              ],
              const SizedBox(height: 0), // 간격 추가
              Center(
                child: Column(
                  children: [
                    Text(
                      '',
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600,color: Colors.white),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 170),
              Column(
                children: [
                  OutlinedButton(
                    onPressed: () {
                      if (currentButtonIndex == 0) {
                        setState(() {
                          StartPage.selectedLanguage = 'ko';
                        });
                      } else if (currentButtonIndex == 1) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const NameInputPage()),
                        );
                      }
                      changeButton();
                    },
                    style: OutlinedButton.styleFrom(
                      minimumSize: const Size(250, 50),
                    ),
                    child: Text(
                      buttonTexts[currentButtonIndex][0],
                      style: TextStyle(color: AppStyles.maindeepblue),
                    ),
                  ),
                  const SizedBox(height: 20),
                  OutlinedButton(
                    onPressed: () {
                      if (currentButtonIndex == 0) {
                        setState(() {
                          StartPage.selectedLanguage = 'en';
                        });
                      } else if (currentButtonIndex == 1) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const NameInputPage()),
                        );
                      }
                      changeButton();
                    },
                    style: OutlinedButton.styleFrom(
                      minimumSize: const Size(250, 50),
                    ),
                    child: Text(
                      buttonTexts[currentButtonIndex][1],
                      style: TextStyle(color: AppStyles.maindeepblue),
                    ),
                  ),
                ],
              ),/*
              const SizedBox(height: 20),
              if (currentButtonIndex == 0) ...[
                const Text(
                  '언어를 선택해주세요',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w300),
                ),
                const Text(
                  'Select your preferred languages',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w300),
                ),
              ] else ...[
                Text(
                  StartPage.selectedLanguage == 'ko'
                      ? '로그인할 계정을 선택해주세요\n'
                      : 'Select the account to log in\n',
                  style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w300),
                ),
              ],*/
              const SizedBox(height: 20),
              /*Image.asset(
                'assets/images/wind_power.png',
                height: 150,
                width: 150,
              ),*/
            ],
          ),
        ],
      ),
    );
  }
}*/

class StartPage extends StatefulWidget {
  static var selectedLanguage = 'ko';

  const StartPage({super.key});

  @override
  State<StartPage> createState() => _StartPageState();
}

class _StartPageState extends State<StartPage> with SingleTickerProviderStateMixin {
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
                Text('AI for\nrecording life',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 50,
                    fontWeight: FontWeight.w900,
                    color: Colors.white,
                    shadows: [
                      Shadow(
                        offset: Offset(3.0, 3.0),
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
                      : StartPage.selectedLanguage == 'ko'
                      ? '로그인할 계정을 선택해주세요'
                      : 'Select the account to log in',
                  style: TextStyle(
                    fontSize: 18,
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
                          setState(() {
                            StartPage.selectedLanguage = 'ko';
                          });
                        } else if (currentButtonIndex == 1) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const NameInputPage()),
                          );
                        }
                        changeButton();
                      },
                      style: OutlinedButton.styleFrom(
                        minimumSize: const Size(250, 50),
                        backgroundColor: Colors.white, // 버튼 배경을 흰색으로 설정
                        side: BorderSide(color: Colors.white),
                      ),
                      child: Text(
                        buttonTexts[currentButtonIndex][0],
                        style: TextStyle(color: AppStyles.maindeepblue), // 텍스트 색상을 maindeepblue로 설정
                      ),
                    ),
                    const SizedBox(height: 20),
                    OutlinedButton(
                      onPressed: () {
                        if (currentButtonIndex == 0) {
                          setState(() {
                            StartPage.selectedLanguage = 'en';
                          });
                        } else if (currentButtonIndex == 1) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const NameInputPage()),
                          );
                        }
                        changeButton();
                      },
                      style: OutlinedButton.styleFrom(
                        minimumSize: const Size(250, 50),
                        backgroundColor: Colors.white,
                        side: BorderSide(color: Colors.white),
                      ),
                      child: Text(
                        buttonTexts[currentButtonIndex][1],
                        style: TextStyle(color: AppStyles.maindeepblue), // 텍스트 색상을 maindeepblue로 설정
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
    double waveHeight = 50.0 * waveLevel * (1 + 0.1 * animationValue); // 애니메이션 값에 따라 높이 조정

    path.lineTo(0, size.height - waveHeight);

    // 곡선 효과 추가
    path.quadraticBezierTo(
      size.width * 0.25, size.height - (waveHeight + 30),
      size.width * 0.5, size.height - waveHeight,
    );
    path.quadraticBezierTo(
      size.width * 0.75, size.height - (waveHeight - 30),
      size.width, size.height - waveHeight,
    );

    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);

    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => true;
}