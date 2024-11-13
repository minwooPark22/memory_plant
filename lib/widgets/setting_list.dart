import 'package:flutter/material.dart';
import 'package:memory_plant_application/screens/start_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:memory_plant_application/widgets/edit_name.dart';
import 'package:memory_plant_application/styles/app_styles.dart';
import 'package:memory_plant_application/widgets/language.dart';

class SettingsList extends StatefulWidget {
  const SettingsList({super.key});

  @override
  State<SettingsList> createState() => _SettingsListState();
}

class _SettingsListState extends State<SettingsList> {
  String userName = 'Guest'; //  이름을 저장할 변수

  @override
  void initState() {
    super.initState();
    _loadUserName(); //이름 로드
  }

  Future<void> _loadUserName() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      userName = prefs.getString('user_name') ?? 'Guest';
    });
  }

  Future<void> _saveUserName(String newName) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('user_name', newName); // 새로운 이름 저장
  }

  void _showEditNameDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return EditNameDialog(
          currentName: userName,
          onNameSaved: (newName) {
            setState(() {
              userName = newName;
            });
          },
        );
      },
    );
  }

  // 로그아웃띠
  Future<void> _logout() async {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const StartPage()),
      (Route<dynamic> route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    final isKorean = StartPage.selectedLanguage == 'ko';

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
          Row(
            children: [
              Icon(Icons.account_circle,
                  size: 40, color: AppStyles.primaryColor), // 프로필 아이콘
              const SizedBox(width: 8), // 아이콘과 이름 사이 간격
              Text(
                userName, // 사용자 이름 표시
                style: TextStyle(
                  color: AppStyles.maindeepblue,
                  fontSize: 20,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
          const SizedBox(height: 25), // 여백 추가
          Text(
            isKorean ? "계정 설정" : "Account Settings",
            style: TextStyle(color: AppStyles.textColor, fontSize: 14),
          ),
          const Divider(color: Color(0xFFCACACA), thickness: 0.5),
          ListTile(
            title: Text(
              isKorean ? "이름 수정" : "Edit Name",
              style: TextStyle(color: AppStyles.mainblack, fontSize: 14),
            ),
            onTap: () {
              _showEditNameDialog();
              _loadUserName();
            },
          ),
          ListTile(
            title: Text(
              "ENG/KOR",
              style: TextStyle(color: AppStyles.mainblack, fontSize: 14),
            ),
            trailing: LanguageToggleSwitch(
              onToggle: (isKorean) {
                setState(() {
                  // 필요 시 전체 앱 언어 설정을 업데이트할 수 있음
                });
              },
            ),
          ),

          ListTile(
            title: Text(
              isKorean ? "로그아웃" : "Log-out",
              style: TextStyle(color: AppStyles.mainblack, fontSize: 14),
            ),
            onTap: _logout,
          ),

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
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Text(
              isKorean ? "더 보기" : "More",
              style: TextStyle(color: AppStyles.textColor, fontSize: 14),
            ),
          ),

          ListTile(
            title: Text(
              isKorean ? "센터에 대해 배우기" : "Learn About Centers",
              style: TextStyle(color: AppStyles.mainblack, fontSize: 14),
            ),
            onTap: () {
              // 센터에 대해 배우기 기능 구현
            },
          ),
        ],
      ),
    );
  }
}