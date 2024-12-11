import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class NameProvider with ChangeNotifier {
  String _name = "guest"; // 초기 이름

  String get name => _name; // 이름 가져오기

  // Firestore에서 이름 로드
  Future<void> loadName() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      try {
        final doc = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
        if (doc.exists) {
          _name = doc.data()?['nickname'] ?? "guest"; // nickname 로드
        }
      } catch (e) {
        print("Firestore에서 이름 로드 중 오류 발생: $e");
      }
    } else {
      _name = "guest";
    }
    notifyListeners(); // 상태 변경 알림
  }

  // Firestore에 이름 업데이트
  Future<void> updateName(String newName) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      try {
        await FirebaseFirestore.instance.collection('users').doc(user.uid).update({
          'nickname': newName,
        });
        _name = newName;
        notifyListeners(); // 상태 변경 알림
      } catch (e) {
        print("Firestore에 이름 업데이트 중 오류 발생: $e");
      }
    }
  }
}
