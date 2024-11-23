import 'package:flutter/material.dart';
import 'package:memory_plant_application/providers/language_provider.dart';
import 'package:memory_plant_application/screens/start_page.dart';
import 'package:memory_plant_application/widgets/edit_name.dart';
import 'package:memory_plant_application/styles/app_styles.dart';
import 'package:memory_plant_application/widgets/language.dart';
import 'package:memory_plant_application/screens/learning_page.dart';
import 'package:provider/provider.dart';
import 'package:memory_plant_application/providers/name_provider.dart';

class SettingsList extends StatefulWidget {
  const SettingsList({super.key});

  @override
  State<SettingsList> createState() => _SettingsListState();
}

class _SettingsListState extends State<SettingsList> {
  void _showEditNameDialog(String currentName) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return EditNameDialog(
          currentName: currentName,
          onNameSaved: (newName) {
            final nameProvider =
                Provider.of<NameProvider>(context, listen: true);
            nameProvider.updateName(newName); // 새로운 이름 저장
          },
        );
      },
    );
  }

  // 로그아웃 처리
  Future<void> _logout() async {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const StartPage()),
      (Route<dynamic> route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    final isKorean =
        context.watch<LanguageProvider>().currentLanguage == Language.ko;
    final nameProvider = Provider.of<NameProvider>(context, listen: true);

    return Container(
      decoration: BoxDecoration(
        color: Colors.white, // 배경 색상
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      margin: const EdgeInsets.all(16), // 전체 여백
      padding: const EdgeInsets.all(16), // 내부 여백
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 사용자 이름 및 아이콘
          Row(
            children: [
              Icon(Icons.account_circle,
                  size: 40, color: AppStyles.primaryColor), // 프로필 아이콘
              const SizedBox(width: 8), // 아이콘과 이름 사이 간격
              Text(
                nameProvider.name, // NameProvider에서 이름 가져오기
                style: TextStyle(
                  color: AppStyles.maindeepblue,
                  fontSize: 20,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
          const SizedBox(height: 25), // 여백 추가

          // 계정 설정
          Text(
            isKorean ? "계정 설정" : "Account Settings",
            style: TextStyle(color: AppStyles.textColor, fontSize: 14),
          ),
          const Divider(color: Color(0xFFCACACA), thickness: 0.5),

          // 이름 수정
          ListTile(
            title: Text(
              isKorean ? "이름 수정" : "Edit Name",
              style: TextStyle(color: AppStyles.mainblack, fontSize: 14),
            ),
            onTap: () {
              _showEditNameDialog(nameProvider.name);
            },
          ),

          // 언어 토글
          ListTile(
            title: Text(
              "ENG/KOR",
              style: TextStyle(color: AppStyles.mainblack, fontSize: 14),
            ),
            trailing: LanguageToggleSwitch(
              onToggle: (isKorean) {
                setState(() {
                  // 필요 시 언어 설정 업데이트
                });
              },
            ),
          ),

          // 로그아웃
          ListTile(
            title: Text(
              isKorean ? "로그아웃" : "Log-out",
              style: TextStyle(color: AppStyles.mainblack, fontSize: 14),
            ),
            onTap: _logout,
          ),

          // 계정 삭제
          ListTile(
            title: Text(
              isKorean ? "내 계정 삭제" : "Delete My Account",
              style: TextStyle(color: AppStyles.mainblack, fontSize: 14),
            ),
            onTap: () {
              // 계정 삭제 기능 구현
            },
          ),

          const Divider(color: Colors.grey, thickness: 0.5),

          // 더 보기 섹션
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Text(
              isKorean ? "더 보기" : "More",
              style: TextStyle(color: AppStyles.textColor, fontSize: 14),
            ),
          ),

          // 학습 페이지 이동
          ListTile(
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
        ],
      ),
    );
  }
}
