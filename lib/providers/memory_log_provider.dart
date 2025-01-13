import 'package:flutter/material.dart';
import 'package:memory_plant_application/services/memory_log.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class MemoryLogProvider with ChangeNotifier {
  List<MemoryLog> memoryList = [];
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // 메모리 정렬
  void _sortMemoryList() {
    memoryList.sort((a, b) {
      final dateA = DateTime.parse(a.timestamp!);
      final dateB = DateTime.parse(b.timestamp!);
      return dateB.compareTo(dateA);
    });
  }

  // 메모리 추가
  Future<void> addMemory(MemoryLog newMemory) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final currentYear = DateTime.now().year.toString();
      final docRef = _firestore
          .collection('users')
          .doc(user.uid)
          .collection('memories')
          .doc(currentYear);

      final docSnapshot = await docRef.get();
      if (docSnapshot.exists) {
        try {
          await docRef.update({
            'memorylists': FieldValue.arrayUnion([newMemory.toJson()])
          });
        } catch (e) {
          // print("메모리 추가 중 오류 발생: $e");
        }
      } else {
        // 해당 연도의 문서가 없는 경우
        await docRef.set({
          'memorylists': [newMemory.toJson()]
        });
      }
      // 메모리를 리스트에 추가
      memoryList.insert(0, newMemory);
      _sortMemoryList();
      notifyListeners();
    }
  }

  // 메모리 삭제
  Future<void> deleteMemory(MemoryLog memory) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final memoryYear = DateTime.parse(memory.timestamp!).year.toString();
      final docRef = _firestore
          .collection('users')
          .doc(user.uid)
          .collection('memories')
          .doc(memoryYear);

      final docSnapshot = await docRef.get();
      if (docSnapshot.exists) {
        await docRef.update({
          'memorylists': FieldValue.arrayRemove([memory.toJson()])
        });
      }

      memoryList.removeWhere((m) =>
          m.title == memory.title &&
          m.contents == memory.contents &&
          m.timestamp == memory.timestamp &&
          m.isUser == memory.isUser);
      notifyListeners();
    }
  }

// 메모리 수정
  Future<void> editMemory(MemoryLog memory, MemoryLog updatedMemory) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final memoryYear = DateTime.parse(memory.timestamp!).year.toString();
      final docRef = _firestore
          .collection('users')
          .doc(user.uid)
          .collection('memories')
          .doc(memoryYear);

      try {
        // Firestore 문서 가져오기
        final docSnapshot = await docRef.get();
        if (docSnapshot.exists) {
          // 기존 메모리를 배열에서 제거
          await docRef.update({
            'memorylists': FieldValue.arrayRemove([memory.toJson()])
          });

          // 새로운 메모리를 배열에 추가
          await docRef.update({
            'memorylists': FieldValue.arrayUnion([updatedMemory.toJson()])
          });
        }

        // 로컬 리스트에서 메모리 업데이트
        final index = memoryList.indexWhere((m) =>
            m.title == memory.title &&
            m.contents == memory.contents &&
            m.timestamp == memory.timestamp &&
            m.isUser == memory.isUser);
        if (index != -1) {
          memoryList[index] = updatedMemory;
          notifyListeners(); // UI 갱신
        }
      } catch (e) {
        // print("Failed to edit memory: $e");
      }
    }
  }

  // 메모리 로드
  Future<void> loadMemoryLogs() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      try {
        // memories 컬렉션에서 데이터 가져오기
        final memoriesSnapshot = await _firestore
            .collection('users')
            .doc(user.uid)
            .collection('memories')
            .get();

        List<MemoryLog> loadedMemories = [];

        for (var doc in memoriesSnapshot.docs) {
          final memoryLists = doc.data()['memorylists'] as List<dynamic>;
          for (var memory in memoryLists) {
            loadedMemories.add(MemoryLog.fromJson(memory));
          }
        }

        memoryList = loadedMemories;

        _sortMemoryList();
        notifyListeners();
      } catch (e) {
        // print("Memory logs 로드 중 오류 발생: $e");
      }
    } else {
      // print("사용자가 로그인되지 않았습니다.");
    }
  }

  // 일기 요약 생성 또는 업데이트
  Future<void> updateOrCreateMonthlySummary(
      String monthSummaryTitle, String newContent, String timestamp) async {
    final adjustedTimestamp =
        _getSummaryTimestamp(timestamp); // 요약에 사용할 타임스탬프 계산

    final newMemory = MemoryLog(
      title: monthSummaryTitle,
      contents: '- Day ${DateTime.parse(timestamp).day} $newContent',
      timestamp: adjustedTimestamp,
      isUser: false,
    );

    final user = FirebaseAuth.instance.currentUser; // 현재 사용자 가져오기

    if (user == null) {
      // print("사용자가 인증되지 않았습니다.");
      return;
    }

    try {
      final index = memoryList.indexWhere(
          (m) => m.timestamp == adjustedTimestamp && m.isUser == false);
      if (index != -1) {
        //이미 요약존재재
        final targetMemory = memoryList[index];
        final existingContent = targetMemory.contents;
        final updatedContent =
            '$existingContent\n\n- Day ${DateTime.parse(timestamp).day} $newContent';
        final updatedMemory = MemoryLog(
          title: monthSummaryTitle,
          contents: updatedContent,
          timestamp: adjustedTimestamp,
          isUser: false,
        );
        editMemory(targetMemory, updatedMemory);
      } else {
        addMemory(newMemory);
      }
    } catch (e) {
      // print("월간 요약 업데이트 오류: $e");
    }
  }

  // 요약 타임스탬프 생성
  String _getSummaryTimestamp(String timestamp) {
    final date = DateTime.parse(timestamp);
    final lastDayOfMonth = DateTime(date.year, date.month + 1, 0);
    final adjustedDate = DateTime(lastDayOfMonth.year, lastDayOfMonth.month,
        lastDayOfMonth.day, 23, 59, 59);
    return adjustedDate.toIso8601String();
  }
}
