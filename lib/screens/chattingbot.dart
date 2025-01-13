import 'package:fluentui_icons/fluentui_icons.dart';
import 'package:flutter/material.dart';
import 'package:memory_plant_application/providers/chatbot_provider.dart';
import 'package:memory_plant_application/providers/language_provider.dart';
import 'package:memory_plant_application/providers/navigation_provider.dart';
import 'package:memory_plant_application/styles/app_styles.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../services/message_log.dart';
import 'package:animated_text_kit/animated_text_kit.dart';

class Chatbot extends StatelessWidget {
  const Chatbot({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ChatProvider>(
      builder: (context, chatProvider, child) {
        final isKorean =
            context.watch<LanguageProvider>().currentLanguage == Language.ko;
        return Scaffold(
          appBar: AppBar(
            leading: IconButton(
              icon: const Icon(
                Icons.arrow_back_ios,
              ),
              onPressed: () {
                context
                    .read<NavigationProvider>()
                    .updateIndex(0); // HomePage 인덱스
              },
            ),
            title: _buildAppBarTitle(isKorean),
            centerTitle: true,
            actions: const [],
          ),
          body: Column(
            children: [
              // 메시지 리스트
              Expanded(
                  child: _buildMessageList(chatProvider, context, isKorean)),

              // 메시지 입력 필드
              _buildMessageInput(chatProvider, isKorean, context),
            ],
          ),
        );
      },
    );
  }

  Widget _buildAppBarTitle(bool isKorean) {
    return Text(
      isKorean ? "기억관리소장" : "Memory Curator",
      style: const TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget _buildMessageList(
      ChatProvider chatProvider, BuildContext context, bool isKorean) {
    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            reverse: true,
            itemCount: chatProvider.messageList.length,
            itemBuilder: (context, index) {
              final message = chatProvider.messageList[index];
              final bool isMe = message.isSentByMe ?? false;

              // 날짜 구분선 표시 여부를 판단
              bool showDateSeparator = false;

              if (index == chatProvider.messageList.length - 1) {
                // 가장 오래된 메시지 위에 날짜 구분선 추가
                showDateSeparator = true;
              } else {
                final previousMessageDate =
                    _formatDate(chatProvider.messageList[index + 1].date!);
                final currentMessageDate = _formatDate(message.date!);
                if (previousMessageDate != currentMessageDate) {
                  showDateSeparator = true;
                }
              }

              return Column(
                children: [
                  if (showDateSeparator) _buildDateSeparator(message.date!),
                  GestureDetector(
                    onLongPress: () {
                      if (message.id != null) {
                        // 메시지의 Firestore 문서 ID가 존재할 때만 삭제
                        chatProvider
                            .deleteMessage(message.id!); // Firestore에서 삭제
                      } else {
                        debugPrint("Message ID is null. Cannot delete.");
                      }
                    },
                    child: _buildMessageBubble(message, isMe, context),
                  ),
                ],
              );
            },
          ),
        ),
        if (chatProvider.isTyping) // 상대방 타이핑 상태
          Align(
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
          ),
      ],
    );
  }

  Widget _buildDateSeparator(String date) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Expanded(
            child: Divider(
              color: AppStyles.textColor,
              thickness: 0.7,
              endIndent: 20,
              indent: 20,
            ),
          ),
          Text(
            _formatDate(date),
            style: TextStyle(
              color: AppStyles.textColor,
              fontWeight: FontWeight.w400,
            ),
          ),
          Expanded(
            child: Divider(
              color: AppStyles.textColor,
              thickness: 0.7,
              endIndent: 20,
              indent: 20,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMessageBubble(
      MessageLog message, bool isMe, BuildContext context) {
    return SafeArea(
      child: Row(
        mainAxisAlignment:
            isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (!isMe)
            Padding(
              padding: const EdgeInsets.only(left: 8.0, bottom: 12.0),
              child: CircleAvatar(
                radius: 15.0,
                backgroundColor: const Color(0xFF000000),
                child: Image.asset(
                  'assets/images/app_icon.png',
                  height: 40,
                ),
              ),
            ),
          Container(
            constraints: BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width * 0.7,
            ),
            margin: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 8.0),
            padding: const EdgeInsets.all(10.0),
            decoration: BoxDecoration(
              color: isMe ? AppStyles.maingray : AppStyles.maindeepblue,
              borderRadius: BorderRadius.circular(17.0),
            ),
            child: Text(
              message.content ?? "(빈 메시지)",
              style: isMe
                  ? const TextStyle(
                      color: Colors.black, fontWeight: FontWeight.w400)
                  : const TextStyle(
                      color: Colors.white, fontWeight: FontWeight.w400),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMessageInput(
      ChatProvider chatProvider, bool isKorean, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: chatProvider.controller,
              focusNode: chatProvider.focusNode,
              maxLines: 5,
              minLines: 1,
              maxLength: 500,
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.symmetric(
                    vertical: 10.0, horizontal: 15.0),
                hintText: isKorean ? "메세지 보내기" : "Enter your message",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20.0),
                  borderSide: BorderSide(color: AppStyles.primaryColor),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20.0),
                  borderSide: BorderSide(color: AppStyles.maindeepblue),
                ),
                counterText: "", // 글자수 카운트 제거
              ),
              onSubmitted: (_) => chatProvider.sendMessage(context),
            ),
          ),
          IconButton(
            icon: Transform.rotate(
              angle: -27 * (3.14159 / 180), // 45도를 라디안 값으로 변환 (반시계 방향)
              child: Icon(
                FluentSystemIcons.ic_fluent_send_regular,
                color: AppStyles.maindeepblue,
              ),
            ),
            onPressed: () => chatProvider.sendMessage(context),
          ),
        ],
      ),
    );
  }

  String _formatDate(String date) {
    final DateTime parsedDate = DateFormat('yyyy-MM-ddTHH:mm:ss').parse(date);
    return DateFormat('yyyy-MM-dd').format(parsedDate);
  }
}
