import 'dart:convert';
import 'package:http/http.dart' as http;

class GroqService {
  final String apiKey =
      "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"; // Replace with your actual API key

  Future<String> sendMessage(String messageContent) async {
    final url = Uri.parse("https://api.groq.com/openai/v1/chat/completions");

    final requestBody = jsonEncode({
      "model": "llama3-8b-8192", // 사용할 모델
      "messages": [
        {"role": "user", "content": messageContent}
      ]
    });

    final response = await http.post(
      url,
      headers: {
        "Authorization": "Bearer $apiKey",
        "Content-Type": "application/json; charset=utf-8", // UTF-8 설정 추가
      },
      body: requestBody,
    );

    if (response.statusCode == 200) {
      // UTF-8로 디코딩
      final decodedBody = utf8.decode(response.bodyBytes);
      final data = jsonDecode(decodedBody);

      final botMessage =
          data['choices'][0]['message']['content']; // 응답 메시지 가져오기
      return botMessage; // 봇의 응답 반환
    } else {
      return "Error: Unable to fetch response (${response.statusCode})";
    }
  }
}
