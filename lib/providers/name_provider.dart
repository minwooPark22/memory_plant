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
  Future<void> saveNameToFirestore(String newName) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      await FirebaseFirestore.instance.collection('users').doc(user.uid).update({
        'nickname': newName, // Firestore의 nickname 필드 업데이트
      });
    }
  }

  // SharedPreferences에서 이름 로드
  Future<void> loadName() async {
    try {
      await _loadNameFromFirestore(); // Firestore에서 먼저 로드
    } catch (e) {
      print("Firestore에서 이름 로드 실패: $e");
    }
  }
}