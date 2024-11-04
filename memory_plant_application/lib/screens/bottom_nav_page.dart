import 'package:flutter/material.dart';
import 'package:fluentui_icons/fluentui_icons.dart';
import 'package:memory_plant_application/screens/add_page.dart';
import 'package:memory_plant_application/screens/home_page.dart';
import 'package:memory_plant_application/screens/setting_page.dart';
import 'package:memory_plant_application/screens/start_page.dart';
import 'chattingbot.dart';

class BottomNavPage extends StatefulWidget {
  const BottomNavPage({super.key});


  @override
  State<BottomNavPage> createState() => _BottomNavPageState();
}

class _BottomNavPageState extends State<BottomNavPage> {
  final appScreens = [
    const HomePage(),
    const AddPage(),
    const Chatbot() // Chatbot 페이지는 자체 AppBar를 사용
    //여기에 void updateName(){ _loadUserName();} 이 내용 추가? 🎃
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
      appBar: _selectedIndex == 2 // Chatbot 페이지에서는 AppBar를 숨김
          ? null
          : AppBar(
        title: Text(isKorean ? "기억발전소" : "memory plant"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context); // 이전 페이지로 이동
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(FluentSystemIcons.ic_fluent_settings_regular),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const SettingPage(),
                ),
              );
            },
          ),
        ],
      ),
      body: appScreens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        selectedItemColor: Colors.blueGrey,
        unselectedItemColor: const Color(0xFF526400),
        showSelectedLabels: false,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(FluentSystemIcons.ic_fluent_home_regular),
            activeIcon: Icon(FluentSystemIcons.ic_fluent_home_filled),
            label: "Home",
          ),
          BottomNavigationBarItem(
            icon: Icon(FluentSystemIcons.ic_fluent_add_regular),
            activeIcon: Icon(FluentSystemIcons.ic_fluent_add_filled),
            label: "Add",
          ),
          BottomNavigationBarItem(
            icon: Icon(FluentSystemIcons.ic_fluent_chat_regular),
            activeIcon: Icon(FluentSystemIcons.ic_fluent_chat_filled),
            label: "Chatting",
          ),
        ],
      ),
    );
  }
}
