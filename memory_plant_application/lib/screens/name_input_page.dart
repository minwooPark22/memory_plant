import 'package:flutter/material.dart';
import 'package:memory_plant_application/screens/start_page.dart';
import 'package:memory_plant_application/screens/start_page_after_login.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:memory_plant_application/styles/app_styles.dart';

class NameInputPage extends StatefulWidget {
  const NameInputPage({super.key});

  @override
  State<NameInputPage> createState() => _NameInputPageState();
}

class _NameInputPageState extends State<NameInputPage> {
  final TextEditingController languageController = TextEditingController();

  @override
  void dispose(){
    languageController.dispose();   //메모리 누수 방지용
    super.dispose();
  }
  Future<void> saveName() async{
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('user_name', languageController.text); // 이름 저장
  }
  @override
  Widget build(BuildContext context) {
    //final TextEditingController languageController = TextEditingController();
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: Text(
              StartPage.selectedLanguage == 'ko' ? '기억 발전소' : 'Memory Plant',
              style: const TextStyle(
                fontSize: 50,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 30), // 간격 추가
          /*Column(
            children: [
              Container(
                height: 50, // 원하는 높이 설정
                width: 250, // 원하는 가로 길이 설정
                child: TextField(
                  controller: languageController, // TextEditingController 연결
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: StartPage.selectedLanguage == 'ko'
                        ? '이름'
                        : 'name', // 라벨 텍스트
                  ),
                ),
              ),*/
          Column(
            children: [
              Container(
                height: 50,
                width: 250,
                child: TextField(
                  controller: languageController, // TextEditingController 연결
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.transparent,
                    border: OutlineInputBorder(
                      borderSide: BorderSide(color: AppStyles.maindeepblue),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: AppStyles.maindeepblue),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: AppStyles.maindeepblue),
                    ),
                    hintText: StartPage.selectedLanguage == 'ko' ? '이름' : 'name', // 라벨 텍스트
                  ),
                ),
              ),

              const SizedBox(height: 20), // 간격 추가
              OutlinedButton(
                  onPressed: () async {
                    await saveName(); //이름 저장
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const StartPageAfterLogin()));
                  },
                  style: OutlinedButton.styleFrom(
                    minimumSize: const Size(250, 50), // 버튼 크기 지정
                  ),
                  child: Text(
                      StartPage.selectedLanguage == 'ko' ? '제출' : 'submit',
                    style: TextStyle(color: AppStyles.maindeepblue),)
              ),
            ],
          ),
          const SizedBox(height: 20), // 간격 추가
          Text(
            StartPage.selectedLanguage == 'ko'
                ? '이름을 설정해주세요'
                : 'setting your name',
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w300,
            ),
          ),
          const SizedBox(height: 20), // 간격 추가
          Image.asset(
            'assets/images/wind_power.png',
            height: 150,
            width: 150,
          )
        ],
      ),
    );
  }
}
