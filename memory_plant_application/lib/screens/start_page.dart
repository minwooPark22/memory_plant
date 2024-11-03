import 'package:flutter/material.dart';
import 'package:memory_plant_application/screens/name_input_page.dart';

class StartPage extends StatefulWidget {
  static var selectedLanguage = 'ko';

  const StartPage({super.key});

  @override
  State<StartPage> createState() => _StartPageState();
}

class _StartPageState extends State<StartPage> {
  bool isLoginButtonVisible = false; // 구글 로그인 버튼의 표시 여부
  int currentButtonIndex = 0; // 현재 버튼 인덱스

  final List<List<String>> buttonTexts = [
    ['한국어', 'English'], // 첫 번째 버튼 텍스트
    ['Sign in with Google', 'Sign in with Apple'], // 두 번째 버튼 텍스트
  ];

  void changeButton() {
    setState(() {
      if (currentButtonIndex < buttonTexts.length - 1) {
        currentButtonIndex++; // 인덱스를 증가시켜 다음 버튼으로 변경
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: Text(
              StartPage.selectedLanguage == 'ko' ? '기억 발전소' : 'Memory Plant',
              style: const TextStyle(
                fontSize: 50,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 30), // 간격 추가
          Column(
            children: [
              OutlinedButton(
                onPressed: () {
                  // 버튼 클릭 시 동작
                  if (currentButtonIndex == 0) {
                    setState(() {
                      StartPage.selectedLanguage = 'ko';
                    });
                  } else if (currentButtonIndex == 1) {
                    // 구글 로그인
                    setState(() {});
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const NameInputPage()),
                    );
                  }
                  changeButton();
                },
                style: OutlinedButton.styleFrom(
                  minimumSize: const Size(250, 50),
                ),
                child: Text(buttonTexts[currentButtonIndex][0]),
              ),
              const SizedBox(height: 20), // 간격 추가
              OutlinedButton(
                onPressed: () {
                  // 버튼 클릭 시 동작
                  if (currentButtonIndex == 0) {
                    setState(() {
                      StartPage.selectedLanguage = 'en'; // 영어로 설정
                    });
                  } else if (currentButtonIndex == 1) {
                    // 애플 로그인
                    setState(() {});
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const NameInputPage()),
                    );
                  }
                  changeButton(); // 버튼 인덱스 변경
                },
                style: OutlinedButton.styleFrom(
                  minimumSize: const Size(250, 50),
                ),
                child: Text(buttonTexts[currentButtonIndex][1]),
              ),
            ],
          ),
          const SizedBox(height: 20), // 간격 추가
          if (currentButtonIndex == 0) ...[
            const Text(
              '언어를 선택해주세요',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w300,
              ),
            ),
            const Text(
              'Select your preferred languages',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w300,
              ),
            ),
          ] else ...[
            // 언어 선택 후 메시지 표시
            Text(
              StartPage.selectedLanguage == 'ko'
                  ? '로그인할 계정을 선택해주세요'
                  : 'Select the account to log in',
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w300,
              ),
            ),
          ],
          const SizedBox(height: 20), // 간격 추가
          Image.asset(
            'assets/images/wind_power.png',
            height: 150,
            width: 150,
          )
        ],
      ),
    );
  }
}

