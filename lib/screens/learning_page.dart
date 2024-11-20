import 'package:flutter/material.dart';
import 'package:memory_plant_application/styles/app_styles.dart';
import 'package:memory_plant_application/screens/start_page.dart';
import 'package:memory_plant_application/widgets/intro_center.dart';

class LearningPage extends StatelessWidget {
  const LearningPage({super.key});

  @override
  Widget build(BuildContext context) {
    final isKorean = StartPage.selectedLanguage == 'ko';
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: AppStyles.maindeepblue,
        title: Text(
          isKorean ? "설정" : "Settings",
          style: const TextStyle(fontWeight: FontWeight.w700, color: Colors.white),
        ),
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white), // 뒤로가기 아이콘 색상을 흰색으로 설정
      ),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 32.0),
            child: IntroCenter(isKorean: isKorean),
          ),
        ],
      ), // IntroCenter 위젯 사용
    );
  }
}
