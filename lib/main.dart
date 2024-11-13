import 'package:flutter/material.dart';
import 'package:memory_plant_application/screens/bottom_nav_page.dart';
import 'package:memory_plant_application/screens/name_input_page.dart';
import 'package:memory_plant_application/screens/setting_page.dart';
import 'package:memory_plant_application/screens/start_page.dart';
import 'package:memory_plant_application/screens/start_page_after_login.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      routes: {
        "/": (context) => const StartPage(),
        "/nameInputPage": (context) => const NameInputPage(),
        "/startPageAfterLogin": (context) => const StartPageAfterLogin(),
        "/bottomNavPage": (context) => const BottomNavPage(),
        "/settingPage": (context) => const SettingPage()
      },
    );
  }
}
