import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert'; // JSON 인코딩 및 디코딩을 위해 필요

class Chatbot extends StatefulWidget {
  const Chatbot({super.key});

  @override
  _ChatbotState createState() => _ChatbotState();
}

class _ChatbotState extends State<Chatbot> {
  final List<Map<String, dynamic>> messages = []; // 채팅 메시지를 저장할 리스트
  final TextEditingController _controller = TextEditingController(); // 입력 필드 컨트롤러
  final FocusNode _focusNode = FocusNode(); // FocusNode 추가

  @override
  void initState() {
    super.initState();
    _loadMessages(); // 저장된 채팅 기록 불러오기
  }

  Future<void> _loadMessages() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? storedMessages = prefs.getString('messages');

    if (storedMessages != null) {
      setState(() {
        messages.addAll(List<Map<String, dynamic>>.from(json.decode(storedMessages)));
      });
    }
  }

  Future<void> _saveMessages() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('messages', json.encode(messages));
  }

  void _sendMessage() {
    if (_controller.text.isNotEmpty) {
      if (_controller.text.trim() == "/c") {
        _clearMessages(); // '/c' 명령어로 채팅 기록 삭제
      } else {
        setState(() {
          messages.add({
            'text': _controller.text,
            'isMe': true, // true이면 사용자가 보낸 메시지
            'time': DateFormat('hh:mm a').format(DateTime.now()), // 현재 시간 추가
          });
          _controller.clear(); // 입력 필드 초기화
        });
        _saveMessages(); // 메시지를 저장
      }

      // 메시지 전송 후 키보드 닫기
      FocusScope.of(context).unfocus();
    }
  }

  Future<void> _clearMessages() async {
    setState(() {
      messages.clear(); // 채팅 기록을 지우고
    });
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('messages'); // 저장된 기록 삭제
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.lightBlueAccent[100], // 연한 하늘색으로 설정
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context); // 이전 화면으로 돌아가기
          },
        ),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center, // 타이틀을 가운데 정렬
          children: [
            const Spacer(), // 왼쪽 여백 추가
            Image.asset(
              'assets/images/sojang.png', // 헤더 이미지 경로
              height: 40, // 이미지 크기 조정
            ),
            const Text(
              '기억관리소장', // 타이틀 텍스트
              style: TextStyle(
                color: Colors.white, // 타이틀 색상 흰색
                fontSize: 20, // 타이틀 폰트 크기
                fontWeight: FontWeight.bold, // 타이틀 굵게
              ),
            ),
            const Spacer(flex: 2), // 오른쪽 여백 추가 (2칸)
          ],
        ),
        centerTitle: false, // 타이틀 중앙 정렬을 비활성화
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              reverse: true, // 새 메시지가 아래에 쌓이도록 설정
              itemCount: messages.length,
              itemBuilder: (context, index) {
                final message = messages[messages.length - 1 - index]; // 역순으로 접근
                bool isMe = message['isMe'];
                return Align(
                  alignment: isMe ? Alignment.centerRight : Alignment.centerLeft, // 메시지 정렬
                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0), // 여백 설정
                    padding: const EdgeInsets.all(10.0),
                    decoration: BoxDecoration(
                      color: isMe ? Colors.white : Colors.lightBlueAccent[100], // 사용자: 흰색, 상대방: 연한 하늘색
                      borderRadius: BorderRadius.circular(12.0), // 모서리 둥글게
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5), // 그림자 색상
                          spreadRadius: 1,
                          blurRadius: 4,
                          offset: const Offset(0, 2), // 그림자 위치
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          message['text'], // 메시지 텍스트
                          style: const TextStyle(color: Colors.black), // 텍스트 색상
                        ),
                        Text(
                          message['time'], // 메시지 전송 시간
                          style: TextStyle(color: Colors.grey[600], fontSize: 10),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    focusNode: _focusNode, // FocusNode 연결
                    onTap: () {
                      FocusScope.of(context).requestFocus(_focusNode); // 입력창 탭하면 포커스
                    },
                    onSubmitted: (_) => _sendMessage(), // Enter 키 눌렀을 때 메시지 전송
                    decoration: const InputDecoration(
                      hintText: 'Enter your message...',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                IconButton(
                  icon: Image.asset('assets/images/send.png'), // 이미지 아이콘
                  onPressed: _sendMessage, // 메시지 전송 버튼
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
