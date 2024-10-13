import 'package:flutter/material.dart';
import 'package:fluentui_icons/fluentui_icons.dart';
import 'package:memory_plant_application/screens/add_page.dart';
import 'package:memory_plant_application/screens/home_page.dart';
import 'package:memory_plant_application/screens/setting_page.dart';

import 'chattingbot.dart';

class BottomNavPage extends StatefulWidget {
  const BottomNavPage({super.key});

  @override
  State<BottomNavPage> createState() => _BottomNavPageState();
}

class _BottomNavPageState extends State<BottomNavPage> {
  final appScreens = [
    const HomePage(), // 여기가 저장소 class를 불러올꺼
    const AddPage(),
    const Chatbot()
  ];

  int _selectedIndex = 0;
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("기억저장소"),
          actions: [
            IconButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const SettingPage(),
                    ),
                  );
                }, // search 버튼 눌리면 이동할 곳
                icon: const Icon(FluentSystemIcons.ic_fluent_settings_regular)),
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
                  label: "Home"),
              BottomNavigationBarItem(
                  icon: Icon(FluentSystemIcons.ic_fluent_add_regular),
                  activeIcon: Icon(FluentSystemIcons.ic_fluent_add_filled),
                  label: "Add"),
              BottomNavigationBarItem(
                  icon: Icon(FluentSystemIcons.ic_fluent_chat_regular),
                  activeIcon: Icon(FluentSystemIcons.ic_fluent_chat_filled),
                  label: "Chatting"),
            ]));
  }
}
