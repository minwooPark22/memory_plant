import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NameProvider with ChangeNotifier {
  String _name = "guest"; // 초기 이름

  String get name => _name; // 이름 가져오기

  // 이름 업데이트
  Future<void> updateName(String newName) async {
    _name = newName;
    notifyListeners(); // 상태 변경 알림
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('user_name', newName); // 이름을 SharedPreferences에 저장
  }

  // SharedPreferences에서 이름 로드
  Future<void> loadName() async {
    final prefs = await SharedPreferences.getInstance();
    _name = prefs.getString('user_name') ?? ""; // 저장된 이름 불러오기
    notifyListeners(); // 상태 변경 알림
  }
}