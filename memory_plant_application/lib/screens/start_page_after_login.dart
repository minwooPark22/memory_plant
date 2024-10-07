import 'package:flutter/material.dart';
import 'package:memory_plant_application/screens/start_page.dart';

class StartPageAfterLogin extends StatefulWidget {
  const StartPageAfterLogin({super.key});

  @override
  State<StartPageAfterLogin> createState() => _StartPageAfterLoginState();
}

class _StartPageAfterLoginState extends State<StartPageAfterLogin> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
      appBar: AppBar(
        title: Center(
            child: Text(
          StartPage.selectedLanguage == 'ko' ? '기억 발전소' : 'Memory Plant',
        )),
      ),
      body: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        Center(
          child: Text(
            '날짜', //여기 해야함
            style: const TextStyle(
              fontSize: 50,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Column(
          children: [
            Text('name'),
            Text('memory number'),

            const SizedBox(height: 50), // 간격 추가
            Text('눌러서시작'),
            const SizedBox(height: 20), // 간격 추가
            Image.asset(
              'assets/images/wind_power.png',
              height: 150,
              width: 150,
            )
          ],
        ),
      ]),
    ));
  }
}
