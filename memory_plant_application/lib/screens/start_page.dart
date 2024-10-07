import 'package:flutter/material.dart';

class StartPage extends StatefulWidget {
  const StartPage({super.key});

  @override
  State<StartPage> createState() => _StartPageState();
}

class _StartPageState extends State<StartPage> {
  String selectedLanguage = 'ko'; //나중에 우리 클린한거에서 받아올예정
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Memory Plant'),
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
              child: Text(
                selectedLanguage == 'ko' ? '기억 발전소' : 'Memory Plant',
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(height: 50), // 간격 추가
            Column(
              children: [
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      selectedLanguage = 'ko'; // 한국어로 설정
                    });
                  },
                  child: Text('한국어'),
                ),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      selectedLanguage = 'en'; // 영어로 설정
                    });
                  },
                  child: Text('English'),
                ),
              ],
            ),
            SizedBox(height: 20), // 간격 추가
            Text(
              '언어를 선택해주세요',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w300,
              ),
            ),
            Text(
              'Select your preferred languages',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w300,
              ),
            )
          ],
        ),
      ),
    );
  }
}
