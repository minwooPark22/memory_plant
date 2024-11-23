import 'package:flutter/material.dart';
import 'package:memory_plant_application/providers/language_provider.dart';
import 'package:memory_plant_application/providers/memory_log_provider.dart';
import 'package:provider/provider.dart';
import 'package:memory_plant_application/screens/bottom_nav_page.dart';
import 'package:memory_plant_application/screens/name_input_page.dart';
import 'package:memory_plant_application/screens/setting_page.dart';
import 'package:memory_plant_application/screens/start_page.dart';
import 'package:memory_plant_application/screens/start_page_after_login.dart';
import 'package:memory_plant_application/providers/navigation_provider.dart'; // NavigationProvider import
import 'package:memory_plant_application/providers/name_provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => NavigationProvider()),
        ChangeNotifierProvider(
            create: (_) => MemoryLogProvider()..loadMemoryLogs()),
        ChangeNotifierProvider(create: (_) => NameProvider()..loadName()),
        ChangeNotifierProvider(create: (_) => LanguageProvider()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        routes: {
          "/": (context) => const StartPage(),
          "/nameInputPage": (context) => const NameInputPage(),
          "/startPageAfterLogin": (context) => const StartPageAfterLogin(),
          "/bottomNavPage": (context) => const BottomNavPage(),
          "/settingPage": (context) => const SettingPage(),
        },
      ),
    );
  }
}
