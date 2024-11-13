import 'package:flutter/material.dart';
import 'package:fluentui_icons/fluentui_icons.dart';
import 'package:memory_plant_application/screens/add_page.dart';
import 'package:memory_plant_application/screens/home_page.dart';
import 'package:memory_plant_application/screens/start_page.dart';
import 'chattingbot.dart';
import 'package:memory_plant_application/styles/app_styles.dart';

class BottomNavPage extends StatefulWidget {
  const BottomNavPage({super.key});

  @override
  State<BottomNavPage> createState() => _BottomNavPageState();
}

class _BottomNavPageState extends State<BottomNavPage> {
  final appScreens = [
    const HomePage(),
    const AddPage(),
    const Chatbot(), // Chatbot 페이지는 자체 AppBar를 사용
  ];

  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final isKorean = StartPage.selectedLanguage == 'ko';
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _selectedIndex == 2 // Chatbot 페이지에서는 AppBar를 숨김
          ? null
          : AppBar(
              backgroundColor: Colors.white,
              title: Text(
                isKorean ? "기억발전소" : "Memory Plant",
                style: const TextStyle(fontWeight: FontWeight.w700),
              ),
              centerTitle: true,
              actions: [
                IconButton(
                  icon: const Icon(
                    FluentSystemIcons.ic_fluent_settings_regular,
                    color: Colors.black,
                  ),
                  onPressed: () {
                    Navigator.pushNamed(context, "/settingPage");
                  },
                ),
              ],
            ),
      body: appScreens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: AppStyles.primaryColor,
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        selectedItemColor: AppStyles.maindeepblue,
        unselectedItemColor: AppStyles.textColor,
        showSelectedLabels: true,
        selectedFontSize: 10, // 선택된 아이템의 글씨 크기 줄임
        unselectedFontSize: 10,
        items: const [
          BottomNavigationBarItem(
            icon: Padding(
              padding: EdgeInsets.only(top: 12.0), // 아이콘 위에 12.0 만큼의 여백 추가
              child: Icon(FluentSystemIcons.ic_fluent_home_regular),
            ),
            activeIcon: Padding(
              padding: EdgeInsets.only(top: 12.0), // 아이콘 위에 12.0 만큼의 여백 추가
              child: Icon(FluentSystemIcons.ic_fluent_home_filled),
            ),
            label: "Home",
          ),
          BottomNavigationBarItem(
            icon: Padding(
              padding: EdgeInsets.only(top: 12.0), // 아이콘 위에 12.0 만큼의 여백 추가
              child: Icon(FluentSystemIcons.ic_fluent_add_regular),
            ),
            activeIcon: Padding(
              padding: EdgeInsets.only(top: 12.0), // 아이콘 위에 12.0 만큼의 여백 추가
              child: Icon(FluentSystemIcons.ic_fluent_add_filled),
            ),
            label: "Add",
          ),
          BottomNavigationBarItem(
            icon: Padding(
              padding: EdgeInsets.only(top: 12.0), // 아이콘 위에 12.0 만큼의 여백 추가
              child: Icon(FluentSystemIcons.ic_fluent_chat_regular),
            ),
            activeIcon: Padding(
              padding: EdgeInsets.only(top: 12.0), // 아이콘 위에 12.0 만큼의 여백 추가
              child: Icon(FluentSystemIcons.ic_fluent_chat_filled),
            ),
            label: "Chatting",
          ),
        ],
      ),
    );
  }
}
