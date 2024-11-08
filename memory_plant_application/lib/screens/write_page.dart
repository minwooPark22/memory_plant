import 'package:flutter/material.dart';
import 'package:memory_plant_application/screens/start_page.dart';

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

  @override
  Widget build(BuildContext context) {
    final isKorean = StartPage.selectedLanguage == 'ko';

    return Scaffold(
      appBar: AppBar(title: Text(isKorean ? "기억발전소" : "memory plant")),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _titleController, // 제목 컨트롤러 연결
              decoration: InputDecoration(
                hintText: isKorean ? "제목을 입력하세요." : "Please enter a title.", // 라벨 텍스트
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
              decoration: InputDecoration(
                hintText: isKorean ? "일기를 작성해주세요✍🏻" : "Please write a diary✍🏻",
                border: InputBorder.none,
              ),
            ),
          ),
          ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              }, // 저장 함수 호출
              child: const Text("저장"))
        ],
      ),
    );
  }
}
