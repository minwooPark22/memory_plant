import 'dart:io';
import 'dart:convert';
import 'package:memory_plant_application/services/message_log.dart';
import 'package:path_provider/path_provider.dart';

class MessageLogLogService {
  // JSON 파일 경로를 가져오는 메서드
  Future<String> _getLocalFilePath() async {
    final directory = await getExternalStorageDirectory();
    return '${directory!.path}/chatting_log.json'; // 파일 이름 지정 // 파일 이름 지정
  }

  // 데이터 저장 메서드
  Future<void> saveMessageLogs(List<MessageLog> messages) async {
    final filePath = await _getLocalFilePath();
    final file = File(filePath);
    // List<MessageLog>를 JSON 문자열로 변환하여 저장
    final jsonString =
        jsonEncode(messages.map((log) => log.toJson()).toList());
    await file.writeAsString(jsonString);
  }

  // 데이터 불러오기 메서드
  Future<List<MessageLog>> loadMessageLogs() async {
    final filePath = await _getLocalFilePath();
    final file = File(filePath);

    if (await file.exists()) {
      final jsonString = await file.readAsString();
      final List<dynamic> jsonResponse = jsonDecode(jsonString);
      return jsonResponse
          .map((json) => MessageLog.fromJson(json))
          .toList(); // JSON을 MessageLog 객체로 변환
    } else {
      return []; // 파일이 없으면 빈 리스트 반환
    }
  }
}
