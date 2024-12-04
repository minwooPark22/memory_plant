/*import 'package:flutter/material.dart';
import 'package:memory_plant_application/providers/language_provider.dart';
import 'package:memory_plant_application/styles/app_styles.dart';
import 'package:memory_plant_application/widgets/primary_box.dart';
import 'package:provider/provider.dart';
import 'package:memory_plant_application/providers/name_provider.dart';

class NameInputPage extends StatefulWidget {
  const NameInputPage({super.key});

  @override
  State<NameInputPage> createState() => _NameInputPageState();
}

class _NameInputPageState extends State<NameInputPage> {
  final TextEditingController nameController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  String? _errorMessage;
  double primaryBoxTopPosition = -230; // 초기 위치를 화면 위쪽으로 설정

  @override
  void initState() {
    super.initState();
    // 화면 빌드 후 애니메이션 시작
    Future.delayed(Duration.zero, () {
      setState(() {
        primaryBoxTopPosition = 0; // 최종 위치로 업데이트
      });
    });
  }

  @override
  void dispose() {
    nameController.dispose(); // 메모리 누수 방지
    super.dispose();
  }

  void _submitName() {
    if (_formKey.currentState!.validate()) {
      // Provider를 통해 이름 상태 업데이트
      final nameProvider = Provider.of<NameProvider>(context, listen: false);
      nameProvider.updateName(nameController.text);

      // 다음 페이지로 이동
      Navigator.pushNamed(context, "/startPageAfterLogin");
    }
  }

  @override
  Widget build(BuildContext context) {
    final isKorean =
        context.watch<LanguageProvider>().currentLanguage == Language.ko;
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // 애니메이션 적용된 PrimaryBox
          AnimatedPositioned(
            duration: const Duration(milliseconds: 1000),
            curve: Curves.easeOut,
            top: primaryBoxTopPosition,
            left: 0,
            right: 0,
            child: const PrimaryBox(height: 230),
          ),
          // 콘텐츠를 PrimaryBox 아래에 배치
          Positioned(
            top: 150, // PrimaryBox 아래로 공간 확보
            left: 0,
            right: 0,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // 제목
                Text(
                  isKorean ? '기억 발전소' : 'Memory Plant',
                  style: const TextStyle(
                    fontSize: 50,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 100),
                // 이름 입력 폼
                Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 5),
                      SizedBox(
                        width: 250,
                        child: TextFormField(
                          controller: nameController,
                          maxLength: 20,
                          decoration: InputDecoration(
                            labelText: isKorean ? '이름' : 'Full Name',
                            labelStyle: TextStyle(
                              color: AppStyles.maindeepblue,
                            ),
                            border: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: AppStyles.maindeepblue, width: 1.5),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: AppStyles.maindeepblue, width: 1.5),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: AppStyles.maindeepblue, width: 1.5),
                            ),
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                            counterStyle: TextStyle(
                              color: AppStyles.maindeepblue,
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              setState(() {
                                _errorMessage = isKorean
                                    ? '이름을 작성해주세요!'
                                    : 'Please enter your name!';
                              });
                              return '';
                            }
                            setState(() {
                              _errorMessage = null;
                            });
                            return null;
                          },
                        ),
                      ),
                      const SizedBox(height: 1),
                      if (_errorMessage != null)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 8.0),
                          child: Text(
                            _errorMessage!,
                            style: const TextStyle(
                                color: Colors.red, fontSize: 12),
                          ),
                        ),
                      const SizedBox(height: 10),
                      // 제출 버튼
                      SizedBox(
                        width: 250,
                        child: ElevatedButton(
                          onPressed: _submitName,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppStyles.maindeepblue,
                            minimumSize: const Size(250, 50),
                          ),
                          child: Text(
                            isKorean ? '제출' : 'Submit',
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                // 하단 텍스트
                Text(
                  isKorean ? '이름을 설정해주세요' : 'Setting your name',
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w300,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
*/
import 'package:flutter/material.dart';
import 'package:memory_plant_application/providers/language_provider.dart';
import 'package:memory_plant_application/styles/app_styles.dart';
import 'package:provider/provider.dart';
import 'package:memory_plant_application/providers/name_provider.dart';

class NameInputPage extends StatefulWidget {
  const NameInputPage({super.key});

  @override
  State<NameInputPage> createState() => _NameInputPageState();
}

class _NameInputPageState extends State<NameInputPage>
    with SingleTickerProviderStateMixin {
  final TextEditingController nameController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  String? _errorMessage;

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
    nameController.dispose(); // 메모리 누수 방지
    super.dispose();
  }

  void _submitName() {
    if (_formKey.currentState!.validate()) {
      // Provider를 통해 이름 상태 업데이트
      final nameProvider = Provider.of<NameProvider>(context, listen: false);
      nameProvider.updateName(nameController.text);

      // 다음 페이지로 이동
      Navigator.pushNamed(context, "/startPageAfterLogin");
    }
  }

  @override
  Widget build(BuildContext context) {
    final isKorean =
        context.watch<LanguageProvider>().currentLanguage == Language.ko;
    return Scaffold(
      backgroundColor: AppStyles.maindeepblue,
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
                const SizedBox(height: 180),
                Text(
                  isKorean
                      ? '기억 발전소에 오신 것을\n환영합니다!'
                      : 'Welcome to\nMemory Plant!',
                  textAlign: TextAlign.center, // 텍스트 가운데 정렬
                  style: const TextStyle(
                    fontSize: 35,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    fontFamily: 'NanumFontSetup_TTF_SQUARE_Bold',
                  ),
                ),
                const SizedBox(height: 60),
                // 이름 입력 폼
                Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: 250,
                        child: SizedBox(
                          width: 250,
                          child: TextFormField(
                            controller: nameController,
                            maxLength: 20,
                            decoration: InputDecoration(
                              hintText: isKorean ? '이름을 입력하세요' : 'Enter your full name please', // 힌트 메시지 추가
                              hintStyle: TextStyle(
                                color: AppStyles.maindeepblue.withOpacity(0.7), // 힌트 텍스트 색상 설정
                                fontSize: 15,
                                fontWeight: FontWeight.w400,
                                fontFamily: 'NanumFontSetup_TTF_SQUARE',
                              ),
                              filled: true, // 배경 채우기 활성화
                              fillColor: Colors.white, // 배경색을 흰색으로 설정
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(50),
                                borderSide:
                                BorderSide(color: AppStyles.maindeepblue, width: 1.5),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(50),
                                borderSide:
                                BorderSide(color: AppStyles.maindeepblue, width: 1.5),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(50),
                                borderSide:
                                BorderSide(color: AppStyles.maindeepblue, width: 1.5),
                              ),
                              floatingLabelBehavior: FloatingLabelBehavior.always,
                              counterStyle: TextStyle(
                                color: AppStyles.maindeepblue,
                              ),
                            ),
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                setState(() {
                                  _errorMessage = isKorean
                                      ? '이름을 작성해주세요!'
                                      : 'Please enter your name!';
                                });
                                return '';
                              }
                              setState(() {
                                _errorMessage = null;
                              });
                              return null;
                            },
                          ),
                        ),
                      ),
                      if (_errorMessage != null)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 8.0),
                          child: Text(
                            _errorMessage!,
                            style: const TextStyle(
                                color: Colors.red, fontSize: 12),
                          ),
                        ),
                      //const SizedBox(height: 10),
                      // 제출 버튼
                      SizedBox(
                        width: 250,
                        child: ElevatedButton(
                          onPressed: _submitName,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            minimumSize: const Size(250, 50),
                          ),
                          child: Text(
                            isKorean ? '제출' : 'Submit',
                            style: TextStyle(
                              color: AppStyles.maindeepblue,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'NanumFontSetup_TTF_SQUARE_Bold',
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                // 하단 텍스트
                Text(
                  isKorean ? '이름을 설정해주세요' : 'Setting your name',
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w300,
                    color: Colors.white,
                    fontFamily: 'NanumFontSetup_TTF_SQUARE',
                  ),
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
