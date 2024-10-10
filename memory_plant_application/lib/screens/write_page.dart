import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:memory_plant_application/screens/home_page.dart';

class WritePage extends StatefulWidget {
  final DateTime selected_date;
  const WritePage({super.key, required this.selected_date});

  @override
  State<WritePage> createState() => _WritePageState();
}

class _WritePageState extends State<WritePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Title', // 라벨 텍스트
                border: InputBorder.none, // 경계선 없앰
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              '${widget.selected_date.year}-${widget.selected_date.month}-${widget.selected_date.day}',
              style: const TextStyle(fontSize: 24),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: Colors.grey[200], // 연한 배경색
              borderRadius: BorderRadius.circular(12.0),
            ),
            child: TextField(
              maxLines: null,
              minLines: 6,
              decoration: InputDecoration(
                hintText: '내용을 입력하세요...',
                border: InputBorder.none,
              ),
            ),
          ),
          ElevatedButton(
              onPressed: () {
                // 여기에 누르면 json으로 저장하거나 그런식으로 처리해야함
                Navigator.of(context).pop();
                // 홈으로가기가 어렵네 ㅅㅂ
              },
              child: Text("저장"))
        ],
      ),
    );
  }
}
