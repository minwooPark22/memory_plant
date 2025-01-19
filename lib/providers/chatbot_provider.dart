import 'package:flutter/material.dart';
import 'package:memory_plant_application/services/message_log.dart';
import 'package:memory_plant_application/services/message_log_service.dart';
import 'package:memory_plant_application/services/groq_service.dart';

class ChatProvider with ChangeNotifier {
  List<MessageLog> messageList = [];
  final MessageLogService messageLogService = MessageLogService();
  TextEditingController controller = TextEditingController();
  FocusNode focusNode = FocusNode();
  bool _isTyping = false;
  final CohereService cohereService = CohereService();
  MessageLog helpMessage = MessageLog(
    content: '''
안녕하세요! 저는 여러분의 일상을 기록하고 관리해 드리는 기억발전소 소장입니다.
기억발전소는 하루하루의 소중한 순간들을 한곳에 정리하고, 한 달 단위로 특별한 요약 보고서를 제공하는 공간입니다.
과거의 기억이나 미래의 계획을 작성하셨다면, 그 내용을 기반으로 과거에 어떤 일을 했는지, 앞으로 무엇을 해야 할지 함께 정리하고 이야기 나눌 수 있어요.
저는 단순한 기록 관리자를 넘어, 여러분과 대화하며 기쁨, 슬픔, 고민까지 함께 나누는 AI 친구이기도 합니다.
여러분의 이야기를 듣고 공감하며 새로운 시각을 제시해 드리겠습니다.\n\n <ai 요약을 체크하지 않은 기억에 대해서는 답변해 드릴 수 없어요.>''',
    timestamp: DateTime.now().toIso8601String(),
    isSentByMe: false,
  );
  // 타이핑 상태 접근자
  bool get isTyping => _isTyping;

  // 타이핑 상태 변경
  void setTyping(bool value) {
    _isTyping = value;
    notifyListeners();
  }

  // Firestore에서 메시지 불러오기
  Future<void> loadMessages() async {
    try {
      final loadedMessages = await messageLogService.loadMessageLogs();
      messageList = [helpMessage, ...loadedMessages]; // Firestore 데이터 가져오기
      notifyListeners();
    } catch (e) {
      debugPrint("Failed to load messages: $e");
    }
  }

  // Firestore에 메시지 저장
  Future<void> addMessage(MessageLog message) async {
    try {
      await messageLogService.saveMessageLog(message); // Firestore에 저장
      messageList.insert(0, message);
      notifyListeners();
    } catch (e) {
      debugPrint("Failed to save message: $e");
    }
  }

  // 메시지 삭제
  Future<void> deleteMessage(MessageLog message) async {
    try {
      await messageLogService.deleteMessage(message); // Firestore에서 삭제
      messageList.removeWhere((msg) => msg.timestamp == message.timestamp);
      notifyListeners();
    } catch (e) {
      debugPrint("Failed to delete message: $e");
    }
  }

  // 메시지 전송
  Future<void> sendMessage(BuildContext context) async {
    if (controller.text.isEmpty) return;

    final userMessage = MessageLog(
      content: controller.text,
      timestamp: DateTime.now().toIso8601String(),
      isSentByMe: true,
    );

    // Firestore에 사용자 메시지 추가
    await addMessage(userMessage);
    controller.clear();
    focusNode.unfocus();

    // 봇 응답 처리
    await _handleBotResponse(context, userMessage);
  }

  // 봇 응답 처리
  Future<void> _handleBotResponse(
      BuildContext context, MessageLog userMessage) async {
    setTyping(true);

    try {
      // Cohere API 호출
      final response =
          await cohereService.sendMessage(context, userMessage.content ?? "");

      // 타이핑 상태 비활성화
      setTyping(false);

      // 응답 메시지 추가
      final botMessage = MessageLog(
        content: response.isNotEmpty ? response : "Error: No response received",
        timestamp: DateTime.now().toIso8601String(),
        isSentByMe: false,
      );
      addMessage(botMessage);
    } catch (e) {
      // API 호출 실패 처리
      setTyping(false);
      debugPrint("Failed to fetch bot response: $e");

      final errorMessage = MessageLog(
        content: "Error: Unable to fetch response",
        timestamp: DateTime.now().toIso8601String(),
        isSentByMe: false,
      );
      addMessage(errorMessage);
    }
  }
}
