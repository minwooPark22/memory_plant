import 'package:flutter/material.dart';
import 'package:memory_plant_application/providers/language_provider.dart';
import 'package:memory_plant_application/styles/app_styles.dart';
import 'package:memory_plant_application/widgets/intro_center.dart';
import 'package:provider/provider.dart';

class LearningPage extends StatelessWidget {
  const LearningPage({super.key});

  @override
  Widget build(BuildContext context) {
    final isKorean =
        context.watch<LanguageProvider>().currentLanguage == Language.ko;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor:  Colors.white,
        title: Text(
          isKorean ? "기억발전소 알아보기" : "Learn About Memory Plant",
          style:
              const TextStyle(fontWeight: FontWeight.w700, color: Colors.black),
        ),
        centerTitle: true,
        iconTheme:
            const IconThemeData(color: Colors.black), // 뒤로가기 아이콘 색상을 흰색으로 설정
      ),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.only(
              top: 10.0,   // 상단 패딩 줄임
              bottom: 0.0, // 하단 패딩 줄임
              left: 10.0,  // 기존 가로 패딩 유지
              right: 10.0, // 기존 가로 패딩 유지
            ),
            child: IntroCenter(isKorean: isKorean),
          ),
        ],
      ), // IntroCenter 위젯 사용
    );
  }
}
