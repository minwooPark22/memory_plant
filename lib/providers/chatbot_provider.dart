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
      messageList = loadedMessages; // Firestore 데이터 가져오기
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
  Future<void> deleteMessage(String messageId) async {
    try {
      await messageLogService.deleteMessage(messageId); // Firestore에서 삭제
      messageList.removeWhere((msg) => msg.id == messageId);
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
      date: DateTime.now().toIso8601String(),
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
        date: DateTime.now().toIso8601String(),
        isSentByMe: false,
      );
      addMessage(botMessage);
    } catch (e) {
      // API 호출 실패 처리
      setTyping(false);
      debugPrint("Failed to fetch bot response: $e");

      final errorMessage = MessageLog(
        content: "Error: Unable to fetch response",
        date: DateTime.now().toIso8601String(),
        isSentByMe: false,
      );
      addMessage(errorMessage);
    }
  }
}