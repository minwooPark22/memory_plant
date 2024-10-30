import 'package:flutter/material.dart';
import 'package:memory_plant_application/screens/bottom_nav_page.dart';
import 'package:memory_plant_application/screens/start_page.dart';
import 'package:shared_preferences/shared_preferences.dart';


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
    final isKorean = StartPage.selectedLanguage == 'ko';

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context); // go back
          },
        ),
        title: Text(isKorean ? "기억발전소" : "memory plant"), //일단 임티로 대체
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
                const Text('memory number'),
                const SizedBox(height: 50), // 간격 추가
                const Text('눌러서시작'),
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
    );
  }
}
