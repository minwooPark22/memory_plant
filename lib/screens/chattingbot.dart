import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:memory_plant_application/providers/language_provider.dart';
import 'package:memory_plant_application/providers/navigation_provider.dart';
import 'package:memory_plant_application/services/groq_service.dart';
import 'package:memory_plant_application/services/message_log_service.dart';
import 'package:memory_plant_application/styles/app_styles.dart';
import 'package:provider/provider.dart';
import '../services/message_log.dart';
import 'package:animated_text_kit/animated_text_kit.dart';

class Chatbot extends StatefulWidget {
  const Chatbot({super.key});

  @override
  State<Chatbot> createState() => _ChatbotState();
}

class _ChatbotState extends State<Chatbot> {
  final List<MessageLog> messages = [];
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  final MessageLogService _logService = MessageLogService();
  final CohereService _groqService = CohereService();
  bool isTyping = false; // 타이핑 애니메이션 표시 상태
  @override
  void initState() {
    super.initState();
    _loadMessages();
  }

  // 메시지 로드
  Future<void> _loadMessages() async {
    try {
      final loadedMessages = await _logService.loadMessageLogs();
      setState(() {
        messages.addAll(loadedMessages);
      });
    } catch (e) {
      debugPrint("Failed to load messages: $e");
    }
  }

  // 메시지 저장
  Future<void> _saveMessages() async {
    try {
      await _logService.saveMessageLogs(messages);
    } catch (e) {
      debugPrint("Failed to save messages: $e");
    }
  }

  // 메시지 보내기
  void _sendMessage() async {
    if (_controller.text.isNotEmpty) {
      final now = DateTime.now();
      final newMessage = MessageLog(
        content: _controller.text,
        time: DateFormat('hh:mm a').format(now),
        date: DateFormat('yyyy-MM-dd').format(now),
        isSentByMe: true,
      );

      setState(() {
        messages.add(newMessage);
        _controller.clear();
        isTyping = true; // API 호출 시작 시 타이핑 상태 활성화
      });

      _closeKeyboard();

      try {
        final botResponse = await _groqService.sendMessage(newMessage.content!);

        final botMessage = MessageLog(
          content: botResponse,
          time: DateFormat('hh:mm a').format(DateTime.now()),
          date: DateFormat('yyyy-MM-dd').format(DateTime.now()),
          isSentByMe: false,
        );

        setState(() {
          messages.add(botMessage);
          isTyping = false; // 응답 후 타이핑 상태 비활성화
        });
      } catch (e) {
        debugPrint("Failed to get bot response: $e");
        setState(() {
          isTyping = false;
        });
      }
      _saveMessages();
    }
  }

  // 메시지 삭제
  void _deleteMessage(int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("삭제 확인"),
          content: const Text("정말 이 메시지를 삭제하시겠습니까?"),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // "아니오"를 눌렀을 때 다이얼로그 닫기
              },
              child: const Text("아니오"),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  messages.removeAt(index);
                });
                _saveMessages();
                Navigator.of(context).pop(); // "예"를 눌렀을 때 다이얼로그 닫고 삭제
              },
              child: const Text("예"),
            ),
          ],
        );
      },
    );
  }

  // 키보드 닫기
  void _closeKeyboard() {
    FocusScope.of(context).unfocus();
  }

  // 날짜 형식화
  String _formatDate(String date) {
    DateTime parsedDate = DateFormat('yyyy-MM-dd').parse(date);
    return DateFormat('yyyy년 MM월 dd일').format(parsedDate);
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isKorean =
        context.watch<LanguageProvider>().currentLanguage == Language.ko;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: AppStyles.primaryColor,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            context.read<NavigationProvider>().updateIndex(0); // HomePage 인덱스
          },
        ),
        title: _buildAppBarTitle(isKorean),
        centerTitle: false,
        actions: const [
          // 나가기 버튼 제거
        ],
      ),
      body: Column(
        children: [
          // 메시지 리스트
          Expanded(child: _buildMessageList()),

          // 메시지 입력 필드
          _buildMessageInput(isKorean),
        ],
      ),
    );
  }

  // 앱바 타이틀 구성
  Widget _buildAppBarTitle(bool isKorean) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Spacer(),
        Image.asset(
          'assets/images/sojang.png',
          height: 40,
        ),
        Text(
          isKorean ? "기억관리소장" : "Memory Curator",
          style: const TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const Spacer(flex: 2),
      ],
    );
  }

  // 메시지 리스트 구성
  Widget _buildMessageList() {
    return ListView.builder(
      reverse: true,
      itemCount: messages.length + (isTyping ? 1 : 0), // 타이핑 메시지 추가
      itemBuilder: (context, index) {
        if (isTyping && index == 0) {
          // 타이핑 애니메이션 표시
          return Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: DefaultTextStyle(
                style: const TextStyle(
                  fontSize: 16.0,
                  color: Colors.grey,
                ),
                child: AnimatedTextKit(
                  repeatForever: true,
                  animatedTexts: [
                    TyperAnimatedText('Typing ...'),
                  ],
                ),
              ),
            ),
          );
        }

        final messageIndex = isTyping ? index - 1 : index;
        final message = messages[messages.length - 1 - messageIndex];
        final bool isMe = message.isSentByMe ?? false;
        bool showDateSeparator = _shouldShowDateSeparator(messageIndex);

        return Column(
          children: [
            if (showDateSeparator)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Text(
                  _formatDate(message.date!),
                  style: TextStyle(color: AppStyles.textColor),
                ),
              ),
            GestureDetector(
              onLongPress: () =>
                  _deleteMessage(messages.length - 1 - messageIndex),
              child: Align(
                alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
                child: _buildMessageBubble(message, isMe),
              ),
            ),
          ],
        );
      },
    );
  }

  // 날짜 구분 여부 판단
  bool _shouldShowDateSeparator(int index) {
    return index == 0 ||
        (index > 0 &&
            _formatDate(messages[messages.length - 1 - index].date!) !=
                _formatDate(messages[messages.length - index].date!));
  }

  // 메시지 버블 구성
  Widget _buildMessageBubble(MessageLog message, bool isMe) {
    return Container(
      constraints: BoxConstraints(
        maxWidth: MediaQuery.of(context).size.width * 0.6,
      ),
      margin: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
      padding: const EdgeInsets.all(10.0),
      decoration: BoxDecoration(
        color: isMe ? AppStyles.maingray : AppStyles.maindeepblue,
        borderRadius: BorderRadius.circular(12.0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 1,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Text(
        message.content ?? "(빈 메시지)",
        style: isMe
            ? const TextStyle(color: Colors.black)
            : const TextStyle(color: Colors.white),
      ),
    );
  }

  // 메시지 입력 필드
  Widget _buildMessageInput(bool isKorean) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _controller,
              focusNode: _focusNode,
              maxLines: null,
              maxLength: 500,
              textInputAction: TextInputAction.newline,
              decoration: InputDecoration(
                hintText: isKorean ? "메세지 보내기" : "Enter your message",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                  borderSide: BorderSide(color: AppStyles.primaryColor),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                  borderSide: BorderSide(color: AppStyles.maindeepblue),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                  borderSide: BorderSide(color: AppStyles.primaryColor),
                ),
              ),
            ),
          ),
          IconButton(
            icon: Image.asset(
              'assets/images/send.png',
              width: 24,
              height: 24,
            ),
            onPressed: _sendMessage,
          ),
        ],
      ),
    );
  }
}
