import 'package:flutter/material.dart';
import 'package:fluentui_icons/fluentui_icons.dart';
import 'package:memory_plant_application/screens/home_page.dart';

class AddPage extends StatefulWidget {
  const AddPage({super.key});

  @override
  State<AddPage> createState() => _AddPageState();
}

class _AddPageState extends State<AddPage> {
  final appScreens = [
    const HomePage(), // 여기가 저장소 class를 불러올꺼
    const Center(child: Text("Add")),
    const Center(child: Text("chatting"))
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
                onPressed: () {}, // search 버튼 눌리면 이동할 곳
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
