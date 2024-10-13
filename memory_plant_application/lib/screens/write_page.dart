import 'dart:convert'; // JSON 변환을 위해 import
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

class WritePage extends StatefulWidget {
  final DateTime selected_date;
  const WritePage({super.key, required this.selected_date});

  @override
  State<WritePage> createState() => _WritePageState();
}

class _WritePageState extends State<WritePage> {
  // 제목과 내용을 입력받기 위한 컨트롤러
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();

  Future<String> _getFilePath() async {
    return 'lib/utils/memory.json';
  }

  Future<void> _saveDataToFile(String title, String content) async {
    String path = await _getFilePath();
    File file = File(path);

    // JSON 파일이 존재하지 않으면 초기 데이터 작성
    if (!(await file.exists())) {
      await file.writeAsString(jsonEncode({'entries': []}));
    }

    // 기존 데이터 읽기
    String jsonString = await file.readAsString();
    Map<String, dynamic> jsonData = jsonDecode(jsonString);

    // 새로운 데이터 추가
    jsonData['entries'].add({
      'title': title,
      'date': {
        'year': widget.selected_date.year,
        'month': widget.selected_date.month,
        'day': widget.selected_date.day
      },
      'content': content
    });

    // 업데이트된 데이터를 파일에 저장
    await file.writeAsString(jsonEncode(jsonData));
    print("저장 성공: $path");
  }

  void _saveData() {
    String title = _titleController.text;
    String content = _contentController.text;

    _saveDataToFile(title, content);

    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _titleController, // 제목 컨트롤러 연결
              decoration: const InputDecoration(
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
              controller: _contentController, // 내용 컨트롤러 연결
              maxLines: null,
              minLines: 6,
              decoration: const InputDecoration(
                hintText: '내용을 입력하세요...',
                border: InputBorder.none,
              ),
            ),
          ),
          ElevatedButton(
              onPressed: _saveData, // 저장 함수 호출
              child: const Text("저장"))
        ],
      ),
    );
  }
}
