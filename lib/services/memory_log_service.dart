import 'dart:io';
import 'dart:convert';
import 'package:memory_plant_application/services/memory_log.dart';
import 'package:path_provider/path_provider.dart';

class MemoryLogService {
  // JSON 파일 경로를 가져오는 메서드
  Future<String> _getLocalFilePath() async {
    late final Directory? directory;
    directory = await getApplicationDocumentsDirectory();
    return '${directory.path}/memories_log.json'; // 파일 이름 지정 // 파일 이름 지정
  }

  // 데이터 저장 메서드
  Future<void> saveMemoryLogs(List<MemoryLog> memories) async {
    final filePath = await _getLocalFilePath();
    final file = File(filePath);
    // List<MemoryLog>를 JSON 문자열로 변환하여 저장
    final jsonString = jsonEncode(memories.map((log) => log.toJson()).toList());
    await file.writeAsString(jsonString);
  }

  // 데이터 불러오기 메서드
  Future<List<MemoryLog>> loadMemoryLogs() async {
    final filePath = await _getLocalFilePath();
    final file = File(filePath);

    if (await file.exists()) {
      final jsonString = await file.readAsString();
      final List<dynamic> jsonResponse = jsonDecode(jsonString);
      return jsonResponse
          .map((json) => MemoryLog.fromJson(json))
          .toList(); // JSON을 MessageLog 객체로 변환
    } else {
      return []; // 파일이 없으면 빈 리스트 반환
    }
  }

  // 메모리 추가하기
  Future<void> addMemory(MemoryLog newMemory) async {
    List<MemoryLog> memories = await loadMemoryLogs();
    memories.add(newMemory);
    await saveMemoryLogs(memories);
  }
}
