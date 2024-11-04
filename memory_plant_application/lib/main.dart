import 'package:flutter/material.dart';
import 'package:memory_plant_application/screens/start_page.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:memory_plant_application/widgets/alarm.dart';

final FlutterLocalNotificationsPlugin localNotificationsPlugin =
FlutterLocalNotificationsPlugin();

void main() {
  runApp(const MyApp());
}
/*
void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Flutter 엔진 초기화
  await initializeNotifications(); // 알림 초기화
  runApp(const MyApp()); // 앱 실행
}
 */

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: StartPage(),
    );
  }
}
