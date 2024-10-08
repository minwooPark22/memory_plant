import 'package:flutter/material.dart';
import 'package:memory_plant_application/screens/start_page.dart';
import 'package:memory_plant_application/screens/start_page_after_login.dart';

class NameInputPage extends StatefulWidget {
  const NameInputPage({super.key});

  @override
  State<NameInputPage> createState() => _NameInputPageState();
}

class _NameInputPageState extends State<NameInputPage> {
  @override
  Widget build(BuildContext context) {
    final TextEditingController languageController = TextEditingController();
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
              Container(
                height: 50, // 원하는 높이 설정
                width: 250, // 원하는 가로 길이 설정
                child: TextField(
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: StartPage.selectedLanguage == 'ko'
                        ? '이름'
                        : 'name', // 라벨 텍스트
                  ),
                ),
              ),

              const SizedBox(height: 20), // 간격 추가
              OutlinedButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const StartPageAfterLogin()));
                  },
                  style: OutlinedButton.styleFrom(
                    minimumSize: const Size(250, 50), // 버튼 크기 지정
                  ),
                  child: Text(
                      StartPage.selectedLanguage == 'ko' ? '제출' : 'submit')),
            ],
          ),
          const SizedBox(height: 20), // 간격 추가
          Text(
            StartPage.selectedLanguage == 'ko'
                ? '이름을 설정해주세요'
                : 'setting your name',
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w300,
            ),
          ),
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
