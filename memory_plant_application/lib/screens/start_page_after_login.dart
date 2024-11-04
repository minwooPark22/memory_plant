import 'package:flutter/material.dart';
import 'package:memory_plant_application/screens/bottom_nav_page.dart';
import 'package:memory_plant_application/screens/start_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:memory_plant_application/styles/app_styles.dart';

class StartPageAfterLogin extends StatefulWidget {
  const StartPageAfterLogin({super.key});

  @override
  State<StartPageAfterLogin> createState() => _StartPageAfterLoginState();
}

class _StartPageAfterLoginState extends State<StartPageAfterLogin> {
  String? userName; // 이름 담을 변수

  @override
  void initState() {
    super.initState();
    _loadUserName(); // 사용자 이름 로드
  }

  Future<void> _loadUserName() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      userName = prefs.getString('user_name') ?? 'Guest'; // 저장된 이름 불러오기
    });
  }

  @override
  Widget build(BuildContext context) {
    final locale = Localizations.localeOf(context);
    final isKorean = StartPage.selectedLanguage == 'ko'; // -> 이렇게 하면 언어가 안바껴

    return WillPopScope(
      onWillPop: () async {
        _loadUserName(); // 이전 페이지에서 돌아올 때 이름 재로드
        return true; // 페이지가 정상적으로 돌아갈 수 있도록 true 반환
      },
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Text(isKorean ? "기억발전소" : "memory plant"),
        ),
        body: GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const BottomNavPage()),
            );
          },
          child: Stack(
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Center(
                    child: Text(
                      '${DateTime.now().month}/${DateTime.now().day}', //날짜 표기
                      style: TextStyle(
                        fontSize: 60,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                  Text(userName ?? 'name'),
                  const Text('memory number'), // 여기 memory num 추가 해야함
                  const SizedBox(height: 50), // 간격 추가
                  Text(
                    isKorean ? "눌러서 시작" : "Tap to start",
                    style: TextStyle(color: AppStyles.maindeepblue),
                  ),
                  const SizedBox(height: 20), // 간격 추가
                  Image.asset(
                    'assets/images/wind_power.png',
                    height: 150,
                    width: 150,
                  ),
                ],
              ),
              Positioned.fill(
                child: Container(
                  color: Colors.transparent, // 투명한 레이어를 추가하여 Gesture 인식
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
