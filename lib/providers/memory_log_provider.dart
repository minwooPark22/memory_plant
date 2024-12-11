/*import 'package:flutter/material.dart';
import 'package:memory_plant_application/services/memory_log.dart';
import 'package:memory_plant_application/services/memory_log_service.dart'; // MemoryLogService를 추가합니다.

class MemoryLogProvider with ChangeNotifier {
  List<MemoryLog> memoryList = [];
  final MemoryLogService memoryLogService =
      MemoryLogService(); // MemoryLogService 인스턴스를 생성 / 데이터 저장, 불러오는 역할

  // 메모리 추가
  void addMemory(MemoryLog memory) {
    memoryList.insert(0, memory); // 새로운 메모리를 리스트 맨 앞에 추가
    _sortMemoryList();
    _saveMemoryLogs(); // 메모리를 저장
    notifyListeners(); // 호출시 ui업데이트
  }

  // 메모리 삭제
  void deleteMemory(int index) {
    memoryList.removeAt(index);
    _saveMemoryLogs(); // 삭제 후 저장
    notifyListeners(); //ui 반영
  }

  // 메모리 수정
  void editMemory(int index, MemoryLog updatedMemory) {
    memoryList[index] = updatedMemory;
    _sortMemoryList();
    _saveMemoryLogs(); // 수정 후 저장
    notifyListeners(); // ui 반영
  }

  // 메모리 정렬
  void _sortMemoryList() {
    memoryList.sort((a, b) {
      final dateA = DateTime.parse(a.timestamp!);
      final dateB = DateTime.parse(b.timestamp!);
      return dateB.compareTo(dateA);
    });
  }

  // 메모리 로드
  Future<void> loadMemoryLogs() async {
    // MemoryLogService에서 메모리 로그를 로드
    final memories = await memoryLogService.loadMemoryLogs();
    memoryList = memories;
    _sortMemoryList(); // 불러온 메모리 데이터를 정렬
    notifyListeners(); // 상태 변경을 알리기 위해 notifyListeners 호출
  }

  // 메모리 목록 저장
  Future<void> _saveMemoryLogs() async {
    await memoryLogService.saveMemoryLogs(memoryList); // 메모리 목록 저장
  }

  // 일기 요약 시키기
  void updateOrCreateMonthlySummary(
      String monthSummaryTitle, String newContent, String timestamp) {
    // 월별 마지막 날짜를 계산
    final adjustedTimestamp = _getSummaryTimestamp(timestamp);

    // 월별 기억 요약을 검색
    final index = memoryList
        .indexWhere((memory) => memory.timestamp == adjustedTimestamp);

    if (index != -1) {
      // 기존 요약이 있을 경우, 내용을 갱신
      final existingMemory = memoryList[index];
      final updatedContent =
          '${existingMemory.contents}\n\n- Day ${DateTime.parse(timestamp).day} $newContent';
      final updatedMemory = MemoryLog(
        title: monthSummaryTitle,
        contents: updatedContent,
        timestamp: adjustedTimestamp,
        isUser: false,
      );
      editMemory(index, updatedMemory);
    } else {
      // 기존 요약이 없을 경우, 새로 생성
      final newMemory = MemoryLog(
        title: monthSummaryTitle,
        contents: '- Day ${DateTime.parse(timestamp).day} $newContent',
        timestamp: adjustedTimestamp,
        isUser: false,
      );
      addMemory(newMemory);
    }
  }

  String _getSummaryTimestamp(String timestamp) {
    final date = DateTime.parse(timestamp);
    // 해당 월의 마지막 날짜를 구한다.
    final lastDayOfMonth = DateTime(date.year, date.month + 1, 0);
    // 마지막 날짜에서 하루를 빼서 요약 일기의 날짜를 설정하고 시간을 23:59:59로 설정
    final adjustedDate = DateTime(lastDayOfMonth.year, lastDayOfMonth.month,
        lastDayOfMonth.day, 23, 59, 59);
    return adjustedDate.toIso8601String(); // ISO 형식으로 반환
  }
}*/
import 'package:flutter/material.dart';
import 'package:memory_plant_application/services/memory_log.dart';
import 'package:memory_plant_application/services/memory_log_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class MemoryLogProvider with ChangeNotifier {
  List<MemoryLog> memoryList = [];
  final MemoryLogService memoryLogService = MemoryLogService();
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
      final docRef = await FirebaseFirestore.instance.collection('users').doc(user.uid).collection('memories').add({
        'userId': user.uid,
        'title': newMemory.title,
        'contents': newMemory.contents,
        'timestamp': newMemory.timestamp,
        'isUser': newMemory.isUser,
      });

      // 추가한 메모리에 memoryId 설정
      newMemory.memoryId = docRef.id;

      // 메모리를 리스트에 추가
      memoryList.insert(0, newMemory);
      _sortMemoryList();
      notifyListeners();
    }
  }

  // 메모리 삭제
  Future<void> deleteMemory(String memoryId) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      await FirebaseFirestore.instance.collection('users').doc(user.uid).collection('memories').doc(memoryId).delete();

      memoryList.removeWhere((memory) => memory.memoryId == memoryId);
      notifyListeners();
    }
  }

  // 메모리 수정
  Future<void> editMemory(String memoryId, MemoryLog updatedMemory) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .collection('memories')
          .doc(memoryId)
          .update(updatedMemory.toJson());

      final index = memoryList.indexWhere((memory) => memory.memoryId == memoryId);
      if (index != -1) {
        memoryList[index] = updatedMemory;
        notifyListeners();
      }
    }
  }

  Future<void> editSummary(String memoryId, MemoryLog updatedMemory) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .collection('summarized')
          .doc(memoryId)
          .update(updatedMemory.toJson());

      final index = memoryList.indexWhere((memory) => memory.memoryId == memoryId);
      if (index != -1) {
        memoryList[index] = updatedMemory;
        notifyListeners();
      }
    }
  }

  // 메모리 로드
  Future<void> loadMemoryLogs() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      try {
        // memories 컬렉션에서 데이터 가져오기
        final memoriesSnapshot = await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .collection('memories')
            .get();

        final memories = memoriesSnapshot.docs
            .map((doc) => MemoryLog.fromJson(doc.data(), doc.id)) // doc.id 사용
            .toList();

        // summarized 컬렉션에서 데이터 가져오기
        final summarizedSnapshot = await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .collection('summarized')
            .get();

        final summarized = summarizedSnapshot.docs
            .map((doc) => MemoryLog.fromJson(doc.data(), doc.id)) // doc.id 사용
            .toList();

        // 두 리스트를 병합
        memoryList = [...memories, ...summarized];

        // 정렬 (타임스탬프 기준 내림차순)
        _sortMemoryList();

        // 상태 알림
        notifyListeners();
      } catch (e) {
        print("Memory logs 로드 중 오류 발생: $e");
      }
    } else {
      print("사용자가 로그인되지 않았습니다.");
    }
  }


  // 일기 요약 생성 또는 업데이트
  Future<void> updateOrCreateMonthlySummary(
      String monthSummaryTitle, String newContent, String timestamp) async {
    final adjustedTimestamp = _getSummaryTimestamp(timestamp); // 요약에 사용할 타임스탬프 계산
    final monthKey = _getMonthKey(timestamp); // 요약의 월별 키 생성

    final newMemory = MemoryLog(
      memoryId: monthKey,
      title: monthSummaryTitle,
      contents: '- Day ${DateTime.parse(timestamp).day} $newContent',
      timestamp: adjustedTimestamp,
      isUser: false,
    );

    final user = FirebaseAuth.instance.currentUser; // 현재 사용자 가져오기


    if (user == null) {
      print("사용자가 인증되지 않았습니다.");
      return;
    }

    try {
      // 요약 데이터의 기존 문서 검색
      final doc = await _firestore.collection('users').doc(user.uid).collection('summarized').doc(monthKey).get();


      if (doc.exists) {
        // 기존 요약이 있다면 내용을 갱신
        final existingContent = doc.data()?['contents'] ?? "";
        final updatedContent =
            '$existingContent\n\n- Day ${DateTime.parse(timestamp).day} $newContent';

        await _firestore.collection('users').doc(user.uid).collection('summarized').doc(monthKey).update({
          'title': monthSummaryTitle,
          'contents': updatedContent,
          'timestamp' : adjustedTimestamp,
          'isUser': false
        });
        newMemory.memoryId = monthKey;
        newMemory.contents = updatedContent;
        editSummary(monthKey, newMemory);
      } else {
        // 기존 요약이 없다면 새로 생성
        await _firestore.collection('users').doc(user.uid).collection('summarized').doc(monthKey).set({
          'title': monthSummaryTitle,
          'contents': '- Day ${DateTime.parse(timestamp).day} $newContent',
          'timestamp' : adjustedTimestamp,
          'isUser': false
        });
        memoryList.insert(0, newMemory);
      }
    } catch (e) {
      print("월간 요약 업데이트 오류: $e");
    }

    _sortMemoryList();
    notifyListeners(); // 상태 변경 알림
  }

  // 타임스탬프를 월별 키로 변환
  String _getMonthKey(String timestamp) {
    final date = DateTime.parse(timestamp);
    return '${date.year}-${date.month.toString().padLeft(2, '0')}'; // 예: 2024-12
  }

  // 요약 타임스탬프 생성
  String _getSummaryTimestamp(String timestamp) {
    final date = DateTime.parse(timestamp);
    final lastDayOfMonth = DateTime(date.year, date.month + 1, 0);
    final adjustedDate = DateTime(lastDayOfMonth.year, lastDayOfMonth.month,
        lastDayOfMonth.day, 23, 59, 59);
    return adjustedDate.toIso8601String(); // ISO 형식으로 반환
  }
}
