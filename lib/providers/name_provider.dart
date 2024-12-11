import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class NameProvider with ChangeNotifier {
  String _name = "guest"; // 초기 이름

  String get name => _name; // 이름 가져오기

  // Firestore에서 이름 로드
  Future<void> _loadNameFromFirestore() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final doc = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
      if (doc.exists) {
        _name = doc.data()?['nickname'] ?? "guest"; // Firestore에서 이름 가져오기
        notifyListeners();
      }
    }
  }

  // Firestore에 이름 저장
  Future<void> _saveNameToFirestore(String newName) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      await FirebaseFirestore.instance.collection('users').doc(user.uid).update({
        'nickname': newName, // Firestore의 nickname 필드 업데이트
      });
    }
  }

  // 이름 업데이트
  Future<void> updateName(String newName) async {
    _name = newName;
    notifyListeners(); // 상태 변경 알림

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('user_name', newName); // 이름을 SharedPreferences에 저장

    // Firestore에 저장
    await _saveNameToFirestore(newName);
  }

  // SharedPreferences에서 이름 로드
  Future<void> _loadNameFromPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    _name = prefs.getString('user_name') ?? "guest"; // 저장된 이름 불러오기
    notifyListeners();
  }

  // SharedPreferences에서 이름 로드
  Future<void> loadName() async {
    try {
      await _loadNameFromFirestore(); // Firestore에서 먼저 로드
    } catch (e) {
      print("Firestore에서 이름 로드 실패: $e");
      await _loadNameFromPreferences(); // 실패하면 SharedPreferences에서 로드
    }
  }
}