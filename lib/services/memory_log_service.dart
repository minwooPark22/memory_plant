import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:memory_plant_application/services/memory_log.dart';

class MemoryLogService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // 메모리 저장
  Future<void> saveMemoryLog(MemoryLog memory) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final memoriesCollection = _firestore.collection('memories');
      await memoriesCollection.add(memory.toJson()); // 새로운 메모리를 Firestore에 추가
    }
  }

  // 메모리 불러오기
  Future<List<MemoryLog>> loadMemoryLogs() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final memoriesCollection = _firestore
          .collection('memories')
          .orderBy('timestamp', descending: true);
      final querySnapshot = await memoriesCollection.get();

      return querySnapshot.docs.map((doc) {
        final data = doc.data();
        return MemoryLog.fromJson(data); // 문서 데이터와 ID를 함께 전달
      }).toList();
    } else {
      return [];
    }
  }

  // 메모리 삭제
  Future<void> deleteMemory(String memoryId) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final memoriesCollection = _firestore.collection('memories');
      await memoriesCollection.doc(memoryId).delete();
    }
  }

  // 메모리 업데이트
  Future<void> updateMemory(String memoryId, MemoryLog updatedMemory) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final memoriesCollection = _firestore.collection('memories');
      await memoriesCollection.doc(memoryId).update(updatedMemory.toJson());
    }
  }
}
