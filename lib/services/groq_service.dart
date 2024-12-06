import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:memory_plant_application/providers/memory_log_provider.dart';
import 'package:memory_plant_application/services/memory_log.dart';
import 'package:provider/provider.dart';

class CohereService {
  final String apiKey =
      "rwuT6dbTLpwAdjfLI0hitujs1bgsSaSFFD8Yv9iu"; // Cohere에서 발급받은 API 키로 교체하세요.

  Future<String> sendMessage(
      BuildContext context, String messageContent) async {
    final url = Uri.parse("https://api.cohere.ai/generate");

    final memoryLogProvider =
        Provider.of<MemoryLogProvider>(context, listen: false);

    // MemoryList에서 isUser가 false인 메모리만 가져와 prompt 생성
    final nonUserMemories = memoryLogProvider.memoryList
        .where((memory) => memory.isUser == false)
        .toList();

    final summaryPrompt = _generateSummary(nonUserMemories);

    final requestBody = jsonEncode({
      "model": "command-r-08-2024", // 사용할 모델 (Cohere 제공 모델 중 선택)
      "prompt": """$summaryPrompt
Up to this point is the summary.
You should respond only when I ask a question in the main text,
basing your answers on the summary and general knowledge.
What follows is the main text: $messageContent""", // 사용자 입력 메시지
      "max_tokens": 200, // 생성할 최대 토큰 수 (필요에 따라 조정)
      "temperature": 0.7, // 텍스트의 창의성 정도 (0~1 사이 값)
    });

    final response = await http.post(
      url,
      headers: {
        "Authorization": "Bearer $apiKey", // 인증 토큰 추가
        "Content-Type": "application/json; charset=utf-8", // UTF-8 설정
      },
      body: requestBody,
    );

    if (response.statusCode == 200) {
      // UTF-8로 디코딩
      final decodedBody = utf8.decode(response.bodyBytes);
      final data = jsonDecode(decodedBody);
      // Cohere의 생성 텍스트 가져오기
      final generatedText = data['text'];
      return generatedText; // Cohere의 응답 반환
    } else {
      return "Error: Unable to fetch response (${response.statusCode})";
    }
  }

  Future<String> sendMemory(String messageContent) async {
    final url = Uri.parse("https://api.cohere.ai/generate");

    final requestBody = jsonEncode({
      "model": "command-r-08-2024", // 사용할 모델 (Cohere 제공 모델 중 선택)
      "prompt": messageContent, // 사용자 입력 메시지
      "max_tokens": 200, // 생성할 최대 토큰 수 (필요에 따라 조정)
      "temperature": 0.7, // 텍스트의 창의성 정도 (0~1 사이 값)
    });

    final response = await http.post(
      url,
      headers: {
        "Authorization": "Bearer $apiKey", // 인증 토큰 추가
        "Content-Type": "application/json; charset=utf-8", // UTF-8 설정
      },
      body: requestBody,
    );

    if (response.statusCode == 200) {
      // UTF-8로 디코딩
      final decodedBody = utf8.decode(response.bodyBytes);
      final data = jsonDecode(decodedBody);
      // Cohere의 생성 텍스트 가져오기
      final generatedText = data['text'];
      return generatedText; // Cohere의 응답 반환
    } else {
      return "Error: Unable to fetch response (${response.statusCode})";
    }
  }

  // 요약 Prompt 생성 함수
  String _generateSummary(List<MemoryLog> memoryLogs) {
    if (memoryLogs.isEmpty) {
      return "No memories available for summary.";
    }

    final summaryBuffer = StringBuffer();
    // 요약 내용을 생성
    for (var memory in memoryLogs) {
      summaryBuffer.writeln("${memory.title}\n${memory.contents}");
    }
    return summaryBuffer.toString();
  }
}
