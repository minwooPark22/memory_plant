import 'dart:convert';
import 'package:http/http.dart' as http;

class GroqService {
  final String apiKey = "apikey 넣을곳"; // Replace with your actual API key

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
        "Content-Type": "application/json",
      },
      body: requestBody,
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final botMessage = data['choices'][0]['message']['content']; // 응답 메시지 가져오기
      return botMessage; // 봇의 응답 반환
    } else {
      // print("Error: ${response.statusCode} - ${response.reasonPhrase}");
      return "Error: Unable to fetch response";
    }
  }
}
