import 'package:flutter/material.dart';
import 'package:memory_plant_application/providers/language_provider.dart';
import 'package:memory_plant_application/widgets/privacy.dart';
import 'package:provider/provider.dart';

class PrivacyPage extends StatelessWidget {
  const PrivacyPage({super.key});

  @override
  Widget build(BuildContext context) {
    final isKorean =
        context.watch<LanguageProvider>().currentLanguage == Language.ko;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          isKorean ? "개인정보 보호 안내" : "Privacy Notice",
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
              top: 10.0, // 상단 패딩 줄임
              bottom: 0.0, // 하단 패딩 줄임
              left: 10.0, // 기존 가로 패딩 유지
              right: 10.0, // 기존 가로 패딩 유지
            ),
            child: Privacy(isKorean: isKorean),
          ),
        ],
      ), // IntroCenter 위젯 사용
    );
  }
}
