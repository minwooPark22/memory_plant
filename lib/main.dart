import 'package:flutter/material.dart';
import 'package:memory_plant_application/providers/chatbot_provider.dart';
import 'package:memory_plant_application/providers/language_provider.dart';
import 'package:memory_plant_application/providers/memory_log_provider.dart';
import 'package:provider/provider.dart';
import 'package:memory_plant_application/screens/bottom_nav_page.dart';
import 'package:memory_plant_application/screens/setting_page.dart';
import 'package:memory_plant_application/screens/start_page.dart';
import 'package:memory_plant_application/screens/start_page_after_login.dart';
import 'package:memory_plant_application/providers/navigation_provider.dart'; // NavigationProvider import
import 'package:memory_plant_application/providers/name_provider.dart';
import 'package:flutter/services.dart';
import 'package:firebase_core/firebase_core.dart';

void  main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(); // Firebase 초기화
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,   // 세로 모드
    DeviceOrientation.portraitDown, // 세로 모드 (거꾸로)
  ]).then((_) {
    runApp(const MyApp());
  });
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => NavigationProvider()),
        ChangeNotifierProvider(
            create: (_) => MemoryLogProvider()),
        ChangeNotifierProvider(create: (_) => NameProvider()),
        ChangeNotifierProvider(create: (_) => LanguageProvider()),
        ChangeNotifierProvider(create: (_) => ChatProvider()..loadMessages()), // ChatbotProvider 추가
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        routes: {
          "/": (context) => const StartPage(),
          "/startPageAfterLogin": (context) => const StartPageAfterLogin(),
          "/bottomNavPage": (context) => const BottomNavPage(),
          "/settingPage": (context) => const SettingPage(),
        },
      ),
    );
  }
}
