import 'package:flutter/material.dart';
import 'package:memory_plant_application/screens/start_page.dart';
import 'package:memory_plant_application/screens/start_page_after_login.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:memory_plant_application/styles/app_styles.dart';
import 'package:memory_plant_application/widgets/primary_box.dart';

class NameInputPage extends StatefulWidget {
  const NameInputPage({super.key});

  @override
  State<NameInputPage> createState() => _NameInputPageState();
}

class _NameInputPageState extends State<NameInputPage> {
  final TextEditingController languageController = TextEditingController();
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
    languageController.dispose(); // 메모리 누수 방지용
    super.dispose();
  }

  Future<void> saveName() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('user_name', languageController.text); // 이름 저장
  }

  void _submitName() {
    if (_formKey.currentState!.validate()) {
      saveName(); // 이름 저장
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const StartPageAfterLogin(),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // PrimaryBox를 화면 상단에 배치하고 애니메이션 적용
          AnimatedPositioned(
            duration: const Duration(milliseconds: 1000),
            curve: Curves.easeOut,
            top: primaryBoxTopPosition,
            left: 0,
            right: 0,
            child: const PrimaryBox(height: 230),
          ),
          // 콘텐츠를 PrimaryBox 아래에 배치하도록 Positioned 사용
          Positioned(
            top: 150, // PrimaryBox 아래로 공간 확보
            left: 0,
            right: 0,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  StartPage.selectedLanguage == 'ko' ? '기억 발전소' : 'Memory Plant',
                  style: const TextStyle(
                    fontSize: 50,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 100),
                Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 5),
                      SizedBox(
                        width: 250,
                        child: TextFormField(
                          controller: languageController,
                          maxLength: 20,
                          decoration: InputDecoration(
                            labelText: StartPage.selectedLanguage == 'ko' ? '이름' : 'full name',
                            labelStyle: TextStyle(
                              color: AppStyles.maindeepblue,
                            ),
                            border: OutlineInputBorder(
                              borderSide: BorderSide(color: AppStyles.maindeepblue, width: 1.5),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: AppStyles.maindeepblue, width: 1.5),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: AppStyles.maindeepblue, width: 1.5),
                            ),
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                            counterStyle: TextStyle(
                              color: AppStyles.maindeepblue,
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              setState(() {
                                _errorMessage = StartPage.selectedLanguage == 'ko'
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
                            style: const TextStyle(color: Colors.red, fontSize: 12),
                          ),
                        ),
                      const SizedBox(height: 10),
                      SizedBox(
                        width: 250,
                        child: ElevatedButton(
                          onPressed: _submitName,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppStyles.maindeepblue,
                            minimumSize: const Size(250, 50),
                          ),
                          child: Text(
                            StartPage.selectedLanguage == 'ko' ? '제출' : 'submit',
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
                Text(
                  StartPage.selectedLanguage == 'ko'
                      ? '이름을 설정해주세요'
                      : 'Setting your name',
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