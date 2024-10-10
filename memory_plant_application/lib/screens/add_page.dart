import 'package:flutter/material.dart';
import 'package:fluentui_icons/fluentui_icons.dart';
import 'package:memory_plant_application/screens/home_page.dart';
import 'package:memory_plant_application/screens/chat_bot.dart'; // Chatbot 화면 import
import 'package:memory_plant_application/screens/setting_page.dart';

class AddPage extends StatefulWidget {
  const AddPage({super.key});

  @override
  State<AddPage> createState() => _AddPageState();
}

class _AddPageState extends State<AddPage> {
  final appScreens = [
    const HomePage(), // 여기가 저장소 class를 불러올꺼
    const Center(child: Text("Add")),
  ];

  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _openChatbot() {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => const Chatbot()),
    ).then((value) {
      // 채팅 화면에서 돌아오면 상태를 초기화 (필요시)
      setState(() {
        _selectedIndex = 0; // 기본 인덱스로 되돌림
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("기억저장소"),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const SettingPage(),
                ),
              );
            },
            icon: const Icon(FluentSystemIcons.ic_fluent_settings_regular),
          ),
        ],
      ),
      body: _selectedIndex == 2 ? const SizedBox() : appScreens[_selectedIndex], // 2번 인덱스일 때는 빈 공간
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) {
          if (index == 2) {
            _openChatbot(); // 2번 인덱스 클릭 시 챗봇 열기
          } else {
            _onItemTapped(index); // 다른 인덱스 클릭 시 상태 변경
          }
        },
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
