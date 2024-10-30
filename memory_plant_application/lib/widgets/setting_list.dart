import 'package:flutter/material.dart';
import 'package:memory_plant_application/screens/start_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsList extends StatefulWidget {
  const SettingsList({super.key});

  @override
  State<SettingsList> createState() => _SettingsListState();
}

class _SettingsListState extends State<SettingsList> {
  String userName = ''; //  이름을 저장할 변수

  @override
  void initState() {
    super.initState();
    _loadUserName(); //이름 로드
  }

  Future<void> _loadUserName() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      userName = prefs.getString('user_name') ?? '사용자 이름';
    });
  }

  @override
  Widget build(BuildContext context) {
    final locale = Localizations.localeOf(context);
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: const Text(
                "사용자 이름",
                style: TextStyle(color: Colors.black54, fontSize: 25)),
          ),
          // 사용자 이름 표시
          Text(
            userName, // 여기서 userName 표시
            style: const TextStyle(color: Colors.black54, fontSize: 18),
          ),
          const SizedBox(height: 10), // 여백 추가
          Text(
            isKorean ? "계정 설정" : "Account Settings",
            style: TextStyle(color: Colors.grey, fontSize: 14),
          ),
          const Divider(color: Color(0xFFCACACA), thickness: 0.5),
          ListTile(
            title: Text(
              isKorean ? "이름 수정" : "Edit Name",
              style: TextStyle(color: Colors.black54, fontSize: 14),
            ),
            onTap: () {
              // 이름 수정 기능 구현
            },
          ),

          ListTile(
            title: Text(
              isKorean ? "알람 시간 설정" : "Set an Alarm",
              style: TextStyle(color: Colors.black54, fontSize: 14),
            ),
            onTap: () {
            },
          ),

          ListTile(
            title: Text(
              "KOR/ENG",
              style: TextStyle(color: Colors.black54, fontSize: 14),
            ),
            onTap: () {
            },
          ),

          ListTile(
            title: Text(
              isKorean ? "로그아웃" : "Log-out",
              style: TextStyle(color: Colors.black54, fontSize: 14),
            ),
            onTap: () {
              // 로그아웃 기능 구현
            },
          ),

          ListTile(
            title: Text(
              isKorean ? "내 계정 삭제" : "Delete My Account",
              style: TextStyle(color: Colors.black54, fontSize: 14),
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
              style: TextStyle(color: Colors.grey, fontSize: 14),
            ),
          ),

          ListTile(
            title: Text(
              isKorean ? "센터에 대해 배우기" : "Learn About Centers",
              style: TextStyle(color: Colors.black54),
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
