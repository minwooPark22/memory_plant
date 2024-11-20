import 'package:flutter/material.dart';
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
    notifyListeners();  // 호출시 ui업데이트
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
    notifyListeners();  // ui 반영
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
}
