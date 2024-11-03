import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:memory_plant_application/screens/start_page.dart';
import 'package:memory_plant_application/widgets/time_setting.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest_all.dart' as tz;

final FlutterLocalNotificationsPlugin localNotificationsPlugin = FlutterLocalNotificationsPlugin();

Future<void> initializeNotifications() async {
  const AndroidInitializationSettings initializationSettingsAndroid = AndroidInitializationSettings('@mipmap/ic_launcher');
  const InitializationSettings initializationSettings = InitializationSettings(android: initializationSettingsAndroid);

  await localNotificationsPlugin.initialize(initializationSettings); //알림 초기화

  tz.initializeTimeZones(); //타임존 데이터 초기화
}

// 알람 설정시 쓰는 클래스
Future<void> scheduleDailyNotification(int hour, int minute,bool isKorean) async {

  String title = isKorean ? '기억발전소를 가동할 시간이에요!' : 'It’s time to activate the Memory Plant!';
  String body = isKorean ? '일기를 작성해주세요📝' : 'Please write your diary📝';

  const AndroidNotificationDetails androidPlatformChannelSpecifics =
  AndroidNotificationDetails(
    'your_channel_id',
    'your_channel_name',
    //'your_channel_description',
    importance: Importance.max,
    priority: Priority.high,
  );

  const NotificationDetails platformChannelSpecifics = NotificationDetails(android: androidPlatformChannelSpecifics);

  // 현재시간과 비교해서 알람시간 계산
  final now = tz.TZDateTime.now(tz.local);
  final scheduledTime = tz.TZDateTime(tz.local, now.year, now.month, now.day, hour, minute);

  // 알람 시간이 지났으면 다음날로 설정
  final notificationTime = scheduledTime.isBefore(now)
      ? scheduledTime.add(const Duration(days: 1))
      : scheduledTime;



  await localNotificationsPlugin.zonedSchedule(
    0,
    isKorean ? '기억발전소를 가동할 시간이에요!' : 'It’s time to activate the Memory Plant!', // 제목
    isKorean ? '일기를 작성해주세요📝' : 'Please write your diary📝',  // 내용
    notificationTime,
    platformChannelSpecifics,
    androidAllowWhileIdle: true,
    uiLocalNotificationDateInterpretation:
    UILocalNotificationDateInterpretation.absoluteTime,
    matchDateTimeComponents: DateTimeComponents.time, // 매일 반복
  );
}
