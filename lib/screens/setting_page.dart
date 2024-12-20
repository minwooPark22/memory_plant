import 'package:flutter/material.dart';
import 'package:memory_plant_application/providers/language_provider.dart';
import 'package:memory_plant_application/screens/editname_page.dart';
import 'package:memory_plant_application/styles/app_styles.dart';
import 'package:memory_plant_application/widgets/language.dart';
import 'package:memory_plant_application/screens/learning_page.dart';
import 'package:provider/provider.dart';
import 'package:memory_plant_application/providers/name_provider.dart';
import 'package:memory_plant_application/screens/privacy_page.dart';

class SettingPage extends StatefulWidget {
  const SettingPage({super.key});

  @override
  State<SettingPage> createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  void _showEditNameDialog(String currentName) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditNamePage(
          currentName: currentName,
          onNameSaved: (newName) {
            final nameProvider =
                Provider.of<NameProvider>(context, listen: false);
            nameProvider.updateName(newName); // 새로운 이름 저장
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isKorean =
        context.watch<LanguageProvider>().currentLanguage == Language.ko;
    final nameProvider = Provider.of<NameProvider>(context, listen: true);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.only(
          top: 0.0, // 상단 패딩 줄임
          bottom: 8.0, // 하단 패딩 줄임
          left: 16.0, // 기존 가로 패딩 유지
          right: 16.0, // 기존 가로 패딩 유지
        ),
        children: [
          // 상단 Settings 제목
          Text(
            isKorean ? '설정' : 'Settings',
            style: TextStyle(
              fontSize: 32, // 큰 폰트 크기
              fontWeight: FontWeight.w700,
              color: AppStyles.mainblack,
            ),
          ),
          const SizedBox(height: 8),
          // Account Section
          _buildSectionTitle(isKorean ? "계정" : "Account"),

          ListTile(
            leading: Icon(
              Icons.person, // 공장을 나타내는 아이콘
              color: AppStyles.mainblack,
            ),
            title: Text(
              isKorean ? "계정 관리" : "My Account",
              style: TextStyle(color: AppStyles.mainblack, fontSize: 14),
            ),
            trailing: const Icon(Icons.chevron_right, color: Colors.grey),
            onTap: () {
              _showEditNameDialog(nameProvider.name);
            },
          ),
          const Divider(),

          // Notifications Section
          _buildSectionTitle(isKorean ? "언어" : "language"),

          ListTile(
            leading: Icon(
              Icons.language, // 언어 아이콘 추가
              color: AppStyles.mainblack,
            ),
            title: Text(
              "ENG/KOR",
              style: TextStyle(color: AppStyles.mainblack, fontSize: 14),
            ),
            trailing: LanguageToggleSwitch(
              onToggle: (isKorean) {
                setState(() {
                  // 필요 시 언어 업데이트 처리
                });
              },
            ),
          ),
          const Divider(),

          // More Section
          _buildSectionTitle(isKorean ? "더 보기" : "More"),
          ListTile(
            leading: Icon(
              Icons.business, // 공장을 나타내는 아이콘
              color: AppStyles.mainblack,
            ),
            title: Text(
              isKorean ? "센터에 대해 배우기" : "Learn About Centers",
              style: TextStyle(color: AppStyles.mainblack, fontSize: 14),
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const LearningPage()),
              );
            },
          ),
          ListTile(
            leading: Icon(
              Icons.security,
              color: AppStyles.mainblack,
            ),
            title: Text(
              isKorean ? "개인정보 보호 안내" : "Privacy Notice",
              style: TextStyle(color: AppStyles.mainblack, fontSize: 14),
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const PrivacyPage()),
              );
            },
          ),
        ],
      ),
    );
  }

  // Section Title Widget
  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: Text(
        title,
        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
      ),
    );
  }
}
