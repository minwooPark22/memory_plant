import 'dart:convert';
import 'package:http/http.dart' as http;

class CohereService {
  final String apiKey =
      "rwuT6dbTLpwAdjfLI0hitujs1bgsSaSFFD8Yv9iu"; // Cohere에서 발급받은 API 키로 교체하세요.

  Future<String> sendMessage(String messageContent) async {
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

    print(
        "${response} ######################################################3");
    if (response.statusCode == 200) {
      // UTF-8로 디코딩
      final decodedBody = utf8.decode(response.bodyBytes);
      final data = jsonDecode(decodedBody);
      print(data);
      // Cohere의 생성 텍스트 가져오기
      final generatedText = data['text'];
      return generatedText; // Cohere의 응답 반환
    } else {
      return "Error: Unable to fetch response (${response.statusCode})";
    }
  }
}
